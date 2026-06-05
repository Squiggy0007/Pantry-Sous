import Foundation

// ⚠️ DEVELOPMENT TOGGLE
// true  = mock data, zero API calls, safe for development
// false = real API calls, use when testing on device or publishing
private let useMockData = false

class SpoonacularService {
    static let shared = SpoonacularService()
    private let apiKey: String = {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "SpoonacularAPIKey") as? String,
              !key.isEmpty, !key.hasPrefix("$(") else {
            fatalError("SpoonacularAPIKey missing — run setup_secrets.sh and wire Config.xcconfig in Xcode")
        }
        return key
    }()
    private let baseURL = "https://api.spoonacular.com"

    // MARK: - Fetch Quality Recipes
    func fetchQualityRecipes(
        ingredients: [Ingredient],
        offset: Int = 0
    ) async throws -> [SpoonacularRecipe] {
        if useMockData {
            return mockRecipes.compactMap { recipe in
                var usedIngredients: [RecipeIngredient] = []
                var missedIngredients: [RecipeIngredient] = []

                let allIngredients = recipe.usedIngredients + recipe.missedIngredients

                for ingredient in allIngredients {
                    let isOwned = IngredientNormalizer.matches(ingredient, against: ingredients)
                    let isStaple = PantryStaplesManager.isStapleSync(ingredient.name)
                    if isOwned || isStaple {
                        usedIngredients.append(ingredient)
                    } else {
                        missedIngredients.append(ingredient)
                    }
                }

                guard !usedIngredients.isEmpty else { return nil }

                return SpoonacularRecipe(
                    id: recipe.id,
                    title: recipe.title,
                    image: recipe.image,
                    readyInMinutes: recipe.readyInMinutes,
                    servings: recipe.servings,
                    usedIngredientCount: usedIngredients.count,
                    missedIngredientCount: missedIngredients.count,
                    missedIngredients: missedIngredients,
                    usedIngredients: usedIngredients,
                    spoonacularScore: recipe.spoonacularScore
                )
            }
        }

        // Real API call — no pantry assumptions
        let ingredientNames = ingredients
            .flatMap { IngredientNormalizer.normalizedNames(for: $0.name) }
            .joined(separator: ",+")

        var components = URLComponents(string: "\(baseURL)/recipes/complexSearch")!
        components.queryItems = [
            URLQueryItem(name: "apiKey", value: apiKey),
            URLQueryItem(name: "includeIngredients", value: ingredientNames),
            URLQueryItem(name: "number", value: "20"),
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "instructionsRequired", value: "true"),
            URLQueryItem(name: "fillIngredients", value: "true"),
            URLQueryItem(name: "addRecipeInformation", value: "true"),
            URLQueryItem(name: "minSpoonacularScore", value: "85"),
            URLQueryItem(name: "ignorePantry", value: "false"),
            URLQueryItem(name: "sort", value: "max-used-ingredients"),
            URLQueryItem(name: "sortDirection", value: "desc")
        ]

        guard let url = components.url else {
            throw SpoonacularError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw SpoonacularError.invalidResponse
        }

        do {
            let searchResponse = try JSONDecoder().decode(
                ComplexSearchResponse.self,
                from: data
            )

            return searchResponse.results.map { recipe in
                var used: [RecipeIngredient] = []
                var missed: [RecipeIngredient] = []

                for ingredient in recipe.usedIngredients + recipe.missedIngredients {
                    let isOwned = IngredientNormalizer.matches(ingredient, against: ingredients)
                    let isStaple = PantryStaplesManager.isStapleSync(ingredient.name)
                    if isOwned || isStaple {
                        used.append(ingredient)
                    } else {
                        missed.append(ingredient)
                    }
                }

                return SpoonacularRecipe(
                    id: recipe.id,
                    title: recipe.title,
                    image: recipe.image,
                    readyInMinutes: recipe.readyInMinutes,
                    servings: recipe.servings,
                    usedIngredientCount: used.count,
                    missedIngredientCount: missed.count,
                    missedIngredients: missed,
                    usedIngredients: used,
                    spoonacularScore: recipe.spoonacularScore
                )
            }
        } catch {
            print("DEBUG: Decoding error: \(error)")
            throw SpoonacularError.decodingError
        }
    }

    // MARK: - Fetch Recipe Detail
    func fetchRecipeDetail(id: Int) async throws -> RecipeDetail {
        if useMockData {
            // Check recipes tab details first (full instructions)
            if let detail = mockRecipeDetails[id] {
                return detail
            }

            // Look in browse mock data
            let allBrowseRecipes = mockBrowseRecipes.values.flatMap { $0 }
            if let recipe = allBrowseRecipes.first(where: { $0.id == id }) {

                // Try to find matching recipe in mockRecipeDetails by title
                let matchingDetail = mockRecipeDetails.values.first(where: {
                    $0.title.lowercased() == recipe.title.lowercased()
                })

                let instructions: [AnalyzedInstruction]
                if let matched = matchingDetail {
                    instructions = matched.analyzedInstructions
                } else {
                    instructions = [genericInstructions(for: recipe)]
                }

                return RecipeDetail(
                    id: recipe.id,
                    title: recipe.title,
                    image: recipe.image.replacingOccurrences(of: "312x231", with: "556x370"),
                    readyInMinutes: recipe.readyInMinutes,
                    servings: recipe.servings,
                    extendedIngredients: (recipe.usedIngredients + recipe.missedIngredients).map {
                        ExtendedIngredient(
                            id: $0.id,
                            name: $0.name,
                            original: $0.original,
                            amount: $0.amount,
                            unit: $0.unit
                        )
                    },
                    aggregateLikes: nil,
                    spoonacularScore: recipe.spoonacularScore,
                    analyzedInstructions: instructions,
                    nutrition: matchingDetail?.nutrition ?? genericNutrition(for: recipe)
                )
            }

            throw SpoonacularError.invalidResponse
        }

        // Real API call
        var components = URLComponents(string: "\(baseURL)/recipes/\(id)/information")!
        components.queryItems = [
            URLQueryItem(name: "apiKey", value: apiKey),
            URLQueryItem(name: "includeNutrition", value: "true"),
            URLQueryItem(name: "addRecipeInformation", value: "true")
        ]

        guard let url = components.url else {
            throw SpoonacularError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw SpoonacularError.invalidResponse
        }

        do {
            let detail = try JSONDecoder().decode(RecipeDetail.self, from: data)
            return detail
        } catch {
            print("DEBUG: Decoding error: \(error)")
            throw SpoonacularError.decodingError
        }
    }

    // MARK: - Fetch Browse Recipes
    func fetchBrowseRecipes(
        category: BrowseCategory,
        inventoryIngredients: [Ingredient],
        offset: Int = 0
    ) async throws -> [SpoonacularRecipe] {
        if useMockData {
            let recipes = mockBrowseRecipes[category] ?? []

            return recipes.map { recipe in
                var usedIngredients: [RecipeIngredient] = []
                var missedIngredients: [RecipeIngredient] = []

                let allIngredients = recipe.usedIngredients + recipe.missedIngredients

                for ingredient in allIngredients {
                    let isOwned = IngredientNormalizer.matches(ingredient, against: inventoryIngredients)
                    let isStaple = PantryStaplesManager.isStapleSync(ingredient.name)
                    if isOwned || isStaple {
                        usedIngredients.append(ingredient)
                    } else {
                        missedIngredients.append(ingredient)
                    }
                }

                return SpoonacularRecipe(
                    id: recipe.id,
                    title: recipe.title,
                    image: recipe.image,
                    readyInMinutes: recipe.readyInMinutes,
                    servings: recipe.servings,
                    usedIngredientCount: usedIngredients.count,
                    missedIngredientCount: missedIngredients.count,
                    missedIngredients: missedIngredients,
                    usedIngredients: usedIngredients,
                    spoonacularScore: recipe.spoonacularScore
                )
            }
        }

        // Real API call for browse
        var components = URLComponents(string: "\(baseURL)/recipes/complexSearch")!
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "apiKey",               value: apiKey),
            URLQueryItem(name: "number",               value: "20"),
            URLQueryItem(name: "offset",               value: "\(offset)"),
            URLQueryItem(name: "instructionsRequired", value: "true"),
            URLQueryItem(name: "addRecipeInformation", value: "true"),
            URLQueryItem(name: "fillIngredients",      value: "true"),
            URLQueryItem(name: "minSpoonacularScore",  value: "80"),
            URLQueryItem(name: "sort",                 value: "popularity"),
            URLQueryItem(name: "sortDirection",        value: "desc")
        ]

        // Map browse categories to the correct Spoonacular param.
        // Meal-type categories use `type=`, cuisine-based ones use `cuisine=`.
        // "Trending" has no filter — popularity sort alone is enough.
        switch category {
        case .trending:     break
        case .breakfast:    queryItems.append(URLQueryItem(name: "type",    value: "breakfast"))
        case .lunch:        queryItems.append(URLQueryItem(name: "type",    value: "main course,salad,soup"))
        case .dinner:       queryItems.append(URLQueryItem(name: "type",    value: "main course"))
        case .soup:         queryItems.append(URLQueryItem(name: "type",    value: "soup"))
        case .snacks:       queryItems.append(URLQueryItem(name: "type",    value: "snack,appetizer,fingerfood"))
        case .desserts:     queryItems.append(URLQueryItem(name: "type",    value: "dessert"))
        case .american:     queryItems.append(URLQueryItem(name: "cuisine", value: "american,southern"))
        case .italian:      queryItems.append(URLQueryItem(name: "cuisine", value: "italian"))
        case .mexican:      queryItems.append(URLQueryItem(name: "cuisine", value: "mexican"))
        case .asian:        queryItems.append(URLQueryItem(name: "cuisine", value: "chinese,japanese,korean,thai,vietnamese"))
        case .mediterranean:queryItems.append(URLQueryItem(name: "cuisine", value: "mediterranean,greek,middle eastern"))
        case .indian:       queryItems.append(URLQueryItem(name: "cuisine", value: "indian"))
        }
        components.queryItems = queryItems

        guard let url = components.url else {
            throw SpoonacularError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw SpoonacularError.invalidResponse
        }

        do {
            let searchResponse = try JSONDecoder().decode(
                ComplexSearchResponse.self,
                from: data
            )
            return await hydrateBrowseResults(
                searchResponse.results,
                inventoryIngredients: inventoryIngredients
            )
        } catch {
            print("DEBUG: Decoding error: \(error)")
            throw SpoonacularError.decodingError
        }
    }

    private func hydrateBrowseResults(
        _ recipes: [SpoonacularRecipe],
        inventoryIngredients: [Ingredient]
    ) async -> [SpoonacularRecipe] {
        let ids = recipes.map(\.id)
        guard !ids.isEmpty else { return [] }

        do {
            var components = URLComponents(string: "\(baseURL)/recipes/informationBulk")!
            components.queryItems = [
                URLQueryItem(name: "apiKey", value: apiKey),
                URLQueryItem(name: "ids", value: ids.map(String.init).joined(separator: ",")),
                URLQueryItem(name: "includeNutrition", value: "false")
            ]

            guard let url = components.url else {
                throw SpoonacularError.invalidURL
            }

            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw SpoonacularError.invalidResponse
            }

            let details = try JSONDecoder().decode([BulkRecipeDetail].self, from: data)
            let detailsById = Dictionary(uniqueKeysWithValues: details.map { ($0.id, $0) })

            return recipes.map { recipe in
                guard let detail = detailsById[recipe.id],
                      !detail.extendedIngredients.isEmpty else {
                    return matchedRecipe(
                        recipe,
                        ingredients: recipe.usedIngredients + recipe.missedIngredients,
                        inventoryIngredients: inventoryIngredients
                    )
                }

                let fullIngredients = detail.extendedIngredients.map {
                    RecipeIngredient(
                        id: $0.id,
                        name: $0.name,
                        original: $0.original,
                        amount: $0.amount,
                        unit: $0.unit,
                        image: nil
                    )
                }

                return matchedRecipe(
                    SpoonacularRecipe(
                        id: recipe.id,
                        title: detail.title ?? recipe.title,
                        image: detail.image?.isEmpty == false ? detail.image! : recipe.image,
                        readyInMinutes: detail.readyInMinutes ?? recipe.readyInMinutes,
                        servings: detail.servings ?? recipe.servings,
                        usedIngredientCount: recipe.usedIngredientCount,
                        missedIngredientCount: recipe.missedIngredientCount,
                        missedIngredients: recipe.missedIngredients,
                        usedIngredients: recipe.usedIngredients,
                        spoonacularScore: detail.spoonacularScore ?? recipe.spoonacularScore
                    ),
                    ingredients: fullIngredients,
                    inventoryIngredients: inventoryIngredients
                )
            }
        } catch {
            print("DEBUG: Browse detail hydration failed: \(error)")
            return recipes.map {
                matchedRecipe(
                    $0,
                    ingredients: $0.usedIngredients + $0.missedIngredients,
                    inventoryIngredients: inventoryIngredients
                )
            }
        }
    }

    private struct BulkRecipeDetail: Codable {
        let id: Int
        let title: String?
        let image: String?
        let readyInMinutes: Int?
        let servings: Int?
        let extendedIngredients: [ExtendedIngredient]
        let spoonacularScore: Double?
    }

    private func matchedRecipe(
        _ recipe: SpoonacularRecipe,
        ingredients: [RecipeIngredient],
        inventoryIngredients: [Ingredient]
    ) -> SpoonacularRecipe {
        var used: [RecipeIngredient] = []
        var missed: [RecipeIngredient] = []

        for ingredient in ingredients {
            let isOwned = IngredientNormalizer.matches(ingredient, against: inventoryIngredients)
            let isStaple = PantryStaplesManager.isStapleSync(ingredient.name)
            if isOwned || isStaple {
                used.append(ingredient)
            } else {
                missed.append(ingredient)
            }
        }

        return SpoonacularRecipe(
            id: recipe.id,
            title: recipe.title,
            image: recipe.image,
            readyInMinutes: recipe.readyInMinutes,
            servings: recipe.servings,
            usedIngredientCount: used.count,
            missedIngredientCount: missed.count,
            missedIngredients: missed,
            usedIngredients: used,
            spoonacularScore: recipe.spoonacularScore
        )
    }

    // MARK: - Generic Nutrition
    // Estimates nutrition for browse recipes without a matching mockRecipeDetails entry
    private func genericNutrition(for recipe: SpoonacularRecipe) -> RecipeNutrition {
        let title = recipe.title.lowercased()
        let ingredients = recipe.usedIngredients + recipe.missedIngredients
        let hasProtein = ingredients.contains { i in
            ["chicken", "beef", "pork", "salmon", "shrimp", "fish", "turkey", "lamb", "tuna"]
                .contains { i.name.lowercased().contains($0) }
        }
        let hasPasta = title.contains("pasta") || title.contains("spaghetti") ||
                       title.contains("noodle") || title.contains("lasagna") ||
                       title.contains("gnocchi") || title.contains("risotto")
        let isSoup = title.contains("soup") || title.contains("stew") ||
                     title.contains("chowder") || title.contains("broth")
        let isBreakfast = title.contains("pancake") || title.contains("waffle") ||
                          title.contains("omelette") || title.contains("toast") ||
                          title.contains("french toast") || title.contains("eggs")
        let isDessert = title.contains("cake") || title.contains("cookie") ||
                        title.contains("brownie") || title.contains("pudding") ||
                        title.contains("pie") || title.contains("muffin") ||
                        title.contains("bread") || title.contains("ice cream")
        let isSalad = title.contains("salad")

        let (cal, pro, carb, fat): (Double, Double, Double, Double)
        switch true {
        case isDessert:       (cal, pro, carb, fat) = (360, 4,  52, 14)
        case isSoup:          (cal, pro, carb, fat) = (240, 12, 28,  8)
        case isSalad:         (cal, pro, carb, fat) = (220, 10, 16, 12)
        case isBreakfast:     (cal, pro, carb, fat) = (340, 12, 44, 12)
        case hasPasta:        (cal, pro, carb, fat) = (520, 18, 68, 16)
        case hasProtein:      (cal, pro, carb, fat) = (420, 36, 14, 20)
        default:              (cal, pro, carb, fat) = (380, 14, 48, 12)
        }

        return RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories",      amount: cal,  unit: "kcal"),
            NutrientInfo(name: "Protein",       amount: pro,  unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: carb, unit: "g"),
            NutrientInfo(name: "Fat",           amount: fat,  unit: "g")
        ])
    }

    // MARK: - Generic Instructions
    // Builds realistic category-aware instructions for browse recipes
    // that don't have a matching entry in mockRecipeDetails
    private func genericInstructions(for recipe: SpoonacularRecipe) -> AnalyzedInstruction {
        let title = recipe.title.lowercased()
        let ingredients = recipe.usedIngredients + recipe.missedIngredients
        let ingredientNames = ingredients.compactMap { $0.original ?? $0.name }
        let prepLine = ingredientNames.prefix(4).joined(separator: ", ")

        let mainProtein = ingredients.first(where: { ingredient in
            let name = ingredient.name.lowercased()
            return ["chicken", "beef", "pork", "salmon", "shrimp",
                    "fish", "lamb", "turkey"].contains(where: { name.contains($0) })
        })?.name ?? ""

        // Detect recipe type
        let isSoup = title.contains("soup") || title.contains("chowder") ||
                     title.contains("stew") || title.contains("pozole") ||
                     title.contains("pho") || title.contains("ramen") ||
                     title.contains("minestrone")
        let isPasta = title.contains("pasta") || title.contains("spaghetti") ||
                      title.contains("linguine") || title.contains("penne") ||
                      title.contains("carbonara") || title.contains("bolognese") ||
                      title.contains("lasagna") || title.contains("gnocchi") ||
                      title.contains("risotto") || title.contains("cacio")
        let isStirFry = title.contains("stir fry") || title.contains("stir-fry") ||
                        title.contains("fried rice") || title.contains("pad thai") ||
                        title.contains("bibimbap")
        let isSalad = title.contains("salad") || title.contains("slaw") ||
                      title.contains("tabbouleh") || title.contains("bowl") ||
                      title.contains("caprese")
        let isTaco = title.contains("taco") || title.contains("burrito") ||
                     title.contains("quesadilla") || title.contains("fajita") ||
                     title.contains("enchilada") || title.contains("wrap") ||
                     title.contains("shawarma")
        let isCurry = title.contains("curry") || title.contains("masala") ||
                      title.contains("tikka") || title.contains("korma") ||
                      title.contains("vindaloo") || title.contains("paneer") ||
                      title.contains("dal") || title.contains("chana") ||
                      title.contains("saag") || title.contains("biryani") ||
                      title.contains("aloo") || title.contains("gobi")
        let isGrilled = title.contains("grilled") || title.contains("kebab") ||
                        title.contains("bbq") || title.contains("burger") ||
                        title.contains("wings") || title.contains("ribs") ||
                        title.contains("tandoori")
        let isSmoothie = title.contains("smoothie") || title.contains("shake") ||
                         title.contains("sorbet") || title.contains("acai")
        let isDip = title.contains("dip") || title.contains("hummus") ||
                    title.contains("guacamole") || title.contains("baba") ||
                    title.contains("bruschetta")
        let isBaked = title.contains("baked") || title.contains("roast") ||
                      title.contains("pie") || title.contains("cake") ||
                      title.contains("muffin") || title.contains("bread") ||
                      title.contains("cookie") || title.contains("brownie") ||
                      title.contains("churro") || title.contains("panna") ||
                      title.contains("tiramisu") || title.contains("cheesecake") ||
                      title.contains("lemon bar") || title.contains("cornbread")
        let isSandwich = title.contains("sandwich") || title.contains("toast") ||
                         title.contains("wrap") || title.contains("sub")
        let isBreakfast = title.contains("pancake") || title.contains("waffle") ||
                          title.contains("omelette") || title.contains("oatmeal") ||
                          title.contains("overnight oat") || title.contains("french toast") ||
                          title.contains("benedict") || title.contains("scramble")

        let steps: [InstructionStep]

        if isSmoothie {
            steps = [
                InstructionStep(number: 1, step: "Gather all ingredients: \(prepLine)."),
                InstructionStep(number: 2, step: "If using frozen fruit, let it sit for 2 minutes to slightly soften."),
                InstructionStep(number: 3, step: "Add all ingredients to a high-speed blender, liquid first."),
                InstructionStep(number: 4, step: "Blend on high for 60 seconds until completely smooth."),
                InstructionStep(number: 5, step: "Taste and adjust sweetness or thickness. Add more liquid if too thick."),
                InstructionStep(number: 6, step: "Pour into a glass or bowl and add toppings if desired. Serve immediately.")
            ]
        } else if isDip {
            steps = [
                InstructionStep(number: 1, step: "Prepare all ingredients: \(prepLine)."),
                InstructionStep(number: 2, step: "If any ingredients need to be roasted or cooked first, do so now and allow to cool slightly."),
                InstructionStep(number: 3, step: "Combine all main ingredients in a food processor or large bowl."),
                InstructionStep(number: 4, step: "Blend or mash to your preferred texture — smooth for dips, slightly chunky for salsas."),
                InstructionStep(number: 5, step: "Season with salt, lemon or lime juice, and any spices. Taste and adjust."),
                InstructionStep(number: 6, step: "Transfer to a serving bowl. Drizzle with olive oil and garnish. Serve with pita, chips, or vegetables.")
            ]
        } else if isBreakfast {
            steps = [
                InstructionStep(number: 1, step: "Gather and measure all ingredients: \(prepLine)."),
                InstructionStep(number: 2, step: "If making batter, whisk dry ingredients together in one bowl and wet ingredients in another. Combine gently."),
                InstructionStep(number: 3, step: "Heat your pan, griddle, or skillet over medium heat. Lightly grease with butter or cooking spray."),
                InstructionStep(number: 4, step: "Cook in batches, watching carefully. Most breakfast items cook quickly — 2–4 minutes per side."),
                InstructionStep(number: 5, step: "Look for visual cues: bubbles forming, edges setting, or golden color on the bottom before flipping."),
                InstructionStep(number: 6, step: "Serve warm with your choice of toppings — maple syrup, fresh fruit, powdered sugar, or butter.")
            ]
        } else if isSalad {
            steps = [
                InstructionStep(number: 1, step: "Wash and thoroughly dry all fresh produce: \(prepLine)."),
                InstructionStep(number: 2, step: "Chop, slice, or dice vegetables and greens to your preferred size."),
                InstructionStep(number: 3, step: "If the recipe includes a cooked protein, season and cook it now. Let it rest before slicing."),
                InstructionStep(number: 4, step: "If making a dressing, whisk together the acid (lemon juice or vinegar), oil, and seasonings."),
                InstructionStep(number: 5, step: "Combine all prepared ingredients in a large bowl."),
                InstructionStep(number: 6, step: "Drizzle dressing over just before serving, toss gently, and season to taste with salt and pepper.")
            ]
        } else if isSoup {
            steps = [
                InstructionStep(number: 1, step: "Prep all vegetables and ingredients: \(prepLine). Dice or slice as needed."),
                InstructionStep(number: 2, step: "Heat oil or butter in a large pot over medium heat. Add aromatics (onion, garlic, celery, carrot) and cook 5 minutes until softened."),
                InstructionStep(number: 3, step: !mainProtein.isEmpty
                    ? "Add \(mainProtein) and cook until browned, about 5–8 minutes. If using whole pieces, add them directly to the broth."
                    : "Add any beans, lentils, or main vegetables to the pot."),
                InstructionStep(number: 4, step: "Pour in broth or liquid. Add remaining vegetables, herbs, and seasonings. Bring to a boil."),
                InstructionStep(number: 5, step: "Reduce heat to low, cover, and simmer 20–40 minutes until all ingredients are fully tender."),
                InstructionStep(number: 6, step: "Taste and adjust seasoning generously with salt and pepper. Serve hot with crusty bread.")
            ]
        } else if isPasta {
            steps = [
                InstructionStep(number: 1, step: "Bring a large pot of generously salted water to a rolling boil."),
                InstructionStep(number: 2, step: "Cook pasta according to package directions until al dente. Reserve 1 cup of starchy pasta water before draining."),
                InstructionStep(number: 3, step: "While pasta cooks, prepare the sauce: heat oil in a large pan and cook aromatics (\(prepLine)) over medium heat until fragrant."),
                InstructionStep(number: 4, step: !mainProtein.isEmpty
                    ? "Add \(mainProtein) and cook through. Then add remaining sauce ingredients and simmer 10 minutes."
                    : "Add remaining sauce ingredients and simmer 10–15 minutes until thickened."),
                InstructionStep(number: 5, step: "Add drained pasta directly to the sauce. Toss vigorously, adding reserved pasta water a splash at a time until sauce coats every strand."),
                InstructionStep(number: 6, step: "Remove from heat. Taste and season. Serve immediately topped with cheese and fresh herbs if desired.")
            ]
        } else if isStirFry {
            steps = [
                InstructionStep(number: 1, step: "Prep everything before you start cooking — stir fry is fast. Slice \(prepLine) and set aside in separate bowls."),
                InstructionStep(number: 2, step: "Mix together your sauce (soy sauce, honey, garlic, ginger) in a small bowl. Set aside."),
                InstructionStep(number: 3, step: "Heat oil in a wok or large skillet over the highest heat your stove allows until just smoking."),
                InstructionStep(number: 4, step: !mainProtein.isEmpty
                    ? "Add \(mainProtein) in a single layer. Cook without stirring 2 minutes, then stir-fry until cooked through. Remove and set aside."
                    : "Add tofu or main protein in a single layer. Sear until golden before stirring."),
                InstructionStep(number: 5, step: "Add vegetables to the hot wok. Stir-fry 2–3 minutes — they should be tender-crisp, not soft."),
                InstructionStep(number: 6, step: "Return protein to wok, pour sauce over everything, and toss for 1 minute until glazed. Serve immediately over steamed rice.")
            ]
        } else if isTaco {
            steps = [
                InstructionStep(number: 1, step: "Prepare all fillings: \(prepLine). Season proteins and cook until done. Slice or shred."),
                InstructionStep(number: 2, step: "Prepare any fresh toppings — dice onion, chop cilantro, slice avocado, shred lettuce."),
                InstructionStep(number: 3, step: "Warm tortillas: heat a dry skillet over medium heat and cook 30 seconds per side, or wrap in a damp paper towel and microwave 30 seconds."),
                InstructionStep(number: 4, step: "Set up a taco station with all fillings in separate bowls for easy assembly."),
                InstructionStep(number: 5, step: "Build each taco: start with the protein, add cheese, then toppings."),
                InstructionStep(number: 6, step: "Finish with a squeeze of lime, fresh cilantro, and your favorite hot sauce. Serve immediately.")
            ]
        } else if isCurry {
            steps = [
                InstructionStep(number: 1, step: "Prep all ingredients: \(prepLine). Cut protein into even 1.5-inch pieces for uniform cooking."),
                InstructionStep(number: 2, step: "Heat oil in a large heavy-bottomed pan over medium heat. Add onion and cook 7–8 minutes until deeply golden — don't rush this step."),
                InstructionStep(number: 3, step: "Add garlic and ginger, cook 2 minutes. Add all spices and cook 1 minute, stirring constantly, until fragrant."),
                InstructionStep(number: 4, step: "Add tomatoes or tomato sauce. Simmer 8–10 minutes, stirring occasionally, until oil begins to separate from the sauce."),
                InstructionStep(number: 5, step: !mainProtein.isEmpty
                    ? "Add \(mainProtein) and stir to coat with the sauce. Cook 10–12 minutes until cooked through."
                    : "Add main vegetables or legumes. Stir to coat with sauce and cook until tender."),
                InstructionStep(number: 6, step: "Stir in cream, coconut milk, or yogurt if using. Simmer 5 minutes. Taste, adjust salt. Serve over rice with naan.")
            ]
        } else if isGrilled {
            steps = [
                InstructionStep(number: 1, step: "Remove protein from refrigerator 15–20 minutes before cooking to take the chill off for more even cooking."),
                InstructionStep(number: 2, step: "Pat dry with paper towels — dry surfaces brown better. Season generously: \(prepLine)."),
                InstructionStep(number: 3, step: "Preheat grill or grill pan to high heat. Lightly oil grates or pan surface."),
                InstructionStep(number: 4, step: "Place protein on grill. Do not move it for the first 2–4 minutes — it will release naturally when a good crust forms."),
                InstructionStep(number: 5, step: "Flip and cook the second side. Use a meat thermometer to check doneness: 165°F chicken, 145°F pork/fish, 160°F ground beef."),
                InstructionStep(number: 6, step: "Rest for 5 minutes before slicing — this keeps the juices inside. Serve with any sauces, sides, or garnishes.")
            ]
        } else if isSandwich {
            steps = [
                InstructionStep(number: 1, step: "Prepare all ingredients: \(prepLine). Toast bread if desired."),
                InstructionStep(number: 2, step: "If using any cooked ingredients like bacon or grilled chicken, cook them now and set aside."),
                InstructionStep(number: 3, step: "Spread any condiments or sauces on the bread — mayo, mustard, aioli, or pesto."),
                InstructionStep(number: 4, step: "Layer ingredients strategically: heavier items on the bottom, fresh greens closer to the top to stay crisp."),
                InstructionStep(number: 5, step: "Season lightly with salt and pepper between layers."),
                InstructionStep(number: 6, step: "Press gently together, slice diagonally, and serve immediately.")
            ]
        } else if isBaked {
            let isSweet = title.contains("cake") || title.contains("cookie") ||
                          title.contains("brownie") || title.contains("muffin") ||
                          title.contains("bread") || title.contains("pie") ||
                          title.contains("tiramisu") || title.contains("cheesecake") ||
                          title.contains("churro") || title.contains("panna") ||
                          title.contains("lemon bar") || title.contains("tart")
            if isSweet {
                steps = [
                    InstructionStep(number: 1, step: "Preheat oven as required. Grease and prepare your baking pan — line with parchment if needed."),
                    InstructionStep(number: 2, step: "Measure all ingredients precisely. Baking is science — use a scale if you have one."),
                    InstructionStep(number: 3, step: "Combine dry ingredients in one bowl and wet ingredients in another. Mix each well separately."),
                    InstructionStep(number: 4, step: "Gently fold wet into dry until just combined — overmixing develops gluten and makes baked goods tough."),
                    InstructionStep(number: 5, step: "Pour or spoon into prepared pan. Smooth the top for even baking."),
                    InstructionStep(number: 6, step: "Bake until a toothpick inserted in the center comes out clean or with a few moist crumbs. Cool completely before cutting for clean slices.")
                ]
            } else {
                steps = [
                    InstructionStep(number: 1, step: "Preheat oven to required temperature (usually 375–425°F / 190–220°C)."),
                    InstructionStep(number: 2, step: "Prep all ingredients: \(prepLine). Pat proteins dry and season all sides generously."),
                    InstructionStep(number: 3, step: "If the recipe benefits from searing, brown the protein in a hot oven-safe pan first for 2–3 minutes per side before transferring to the oven."),
                    InstructionStep(number: 4, step: "Arrange everything in a single layer in a baking dish or sheet pan for even cooking. Don't overcrowd."),
                    InstructionStep(number: 5, step: "Roast or bake for the required time. Check halfway through — rotate the pan and baste if needed."),
                    InstructionStep(number: 6, step: "Check internal temperature for proteins. Rest for 5–10 minutes before serving to let juices redistribute.")
                ]
            }
        } else {
            // Default general instructions
            steps = [
                InstructionStep(number: 1, step: "Gather and prepare all ingredients: \(prepLine). Dice, slice, and measure everything before you start cooking."),
                InstructionStep(number: 2, step: "Heat oil or butter in a large pan over medium to medium-high heat until shimmering."),
                InstructionStep(number: 3, step: "Cook aromatics like onion and garlic first, 2–3 minutes until softened and fragrant."),
                InstructionStep(number: 4, step: !mainProtein.isEmpty
                    ? "Add \(mainProtein) and cook until properly browned and cooked through, stirring occasionally."
                    : "Add the main ingredients and cook until tender, stirring as needed."),
                InstructionStep(number: 5, step: "Add remaining ingredients and any sauces or liquids. Stir to combine and cook 5–10 minutes until everything comes together."),
                InstructionStep(number: 6, step: "Taste and season generously with salt and pepper. Adjust any other seasonings to your preference and serve hot.")
            ]
        }

        return AnalyzedInstruction(name: "", steps: steps)
    }

    // MARK: - Analyze Custom Recipe Nutrition
    /// Returns estimated nutrition per serving for a custom recipe.
    /// Mock mode: uses NutritionEstimator (local lookup, no API calls).
    /// Real mode: calls POST /recipes/analyze?includeNutrition=true.
    func analyzeCustomRecipeNutrition(
        title: String,
        ingredients: [String],
        servings: Int
    ) async throws -> NutritionData {
        if useMockData {
            // Local estimation — no API quota used
            return NutritionEstimator.estimate(ingredients: ingredients, servings: servings)
                ?? NutritionData()
        }

        // Real API path
        guard let url = URL(string: "\(baseURL)/recipes/analyze?includeNutrition=true&apiKey=\(apiKey)") else {
            throw SpoonacularError.invalidURL
        }

        let body: [String: Any] = [
            "title": title,
            "servings": servings,
            "ingredients": ingredients,
            "instructions": ""
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        let (responseData, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw SpoonacularError.invalidResponse
        }

        // Parse response — Spoonacular returns nutrition.nutrients array
        guard let json = try? JSONSerialization.jsonObject(with: responseData) as? [String: Any],
              let nutritionObj = json["nutrition"] as? [String: Any],
              let nutrients = nutritionObj["nutrients"] as? [[String: Any]] else {
            // Fall back to local estimator if parsing fails
            return NutritionEstimator.estimate(ingredients: ingredients, servings: servings) ?? NutritionData()
        }

        func nutrientValue(_ name: String) -> Double {
            nutrients.first(where: { ($0["name"] as? String) == name })?["amount"] as? Double ?? 0
        }

        var data = NutritionData()
        data.calories = nutrientValue("Calories")
        data.protein  = nutrientValue("Protein")
        data.carbs    = nutrientValue("Carbohydrates")
        data.fat      = nutrientValue("Fat")
        data.fiber    = nutrientValue("Fiber")
        data.sugar    = nutrientValue("Sugar")
        data.sodium   = nutrientValue("Sodium")
        return data
    }

    // MARK: - Parse Ingredients
    func parseIngredients(_ ingredientLines: [String], servings: Int = 1) async throws -> [SpoonacularParsedIngredient] {
        let cleanedLines = ingredientLines
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        guard !cleanedLines.isEmpty else { return [] }

        if useMockData {
            return cleanedLines.map {
                SpoonacularParsedIngredient(
                    id: nil,
                    name: IngredientNormalizer.normalize(IngredientNormalizer.extractIngredientName($0)),
                    original: $0,
                    originalName: IngredientNormalizer.extractIngredientName($0),
                    amount: nil,
                    unit: nil
                )
            }
        }

        var components = URLComponents(string: "\(baseURL)/recipes/parseIngredients")!
        components.queryItems = [
            URLQueryItem(name: "apiKey", value: apiKey),
            URLQueryItem(name: "language", value: "en")
        ]

        guard let url = components.url else {
            throw SpoonacularError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        var form = URLComponents()
        form.queryItems = [
            URLQueryItem(name: "ingredientList", value: cleanedLines.joined(separator: "\n")),
            URLQueryItem(name: "servings", value: "\(servings)"),
            URLQueryItem(name: "includeNutrition", value: "false")
        ]
        request.httpBody = form.percentEncodedQuery?.data(using: .utf8)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw SpoonacularError.invalidResponse
        }

        do {
            return try JSONDecoder().decode([SpoonacularParsedIngredient].self, from: data)
        } catch {
            throw SpoonacularError.decodingError
        }
    }

    // MARK: - Legacy fetch
    func fetchRecipes(
        ingredients: [Ingredient],
        offset: Int = 0
    ) async throws -> [SpoonacularRecipe] {
        return try await fetchQualityRecipes(ingredients: ingredients, offset: offset)
    }
}

// MARK: - Errors
enum SpoonacularError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
}
