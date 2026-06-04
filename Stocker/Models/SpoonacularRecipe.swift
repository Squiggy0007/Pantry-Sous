import Foundation

// MARK: - Search Response
struct ComplexSearchResponse: Codable {
    let results: [SpoonacularRecipe]
    let totalResults: Int
}

// MARK: - Recipe (from search)
struct SpoonacularRecipe: Codable, Identifiable {
    let id: Int
    let title: String
    let image: String
    let readyInMinutes: Int?
    let servings: Int?
    let usedIngredientCount: Int
    let missedIngredientCount: Int
    let missedIngredients: [RecipeIngredient]
    let usedIngredients: [RecipeIngredient]
    let spoonacularScore: Double?

    init(
        id: Int,
        title: String,
        image: String,
        readyInMinutes: Int? = nil,
        servings: Int? = nil,
        usedIngredientCount: Int,
        missedIngredientCount: Int,
        missedIngredients: [RecipeIngredient],
        usedIngredients: [RecipeIngredient],
        spoonacularScore: Double? = nil
    ) {
        self.id = id
        self.title = title
        self.image = image
        self.readyInMinutes = readyInMinutes
        self.servings = servings
        self.usedIngredientCount = usedIngredientCount
        self.missedIngredientCount = missedIngredientCount
        self.missedIngredients = missedIngredients
        self.usedIngredients = usedIngredients
        self.spoonacularScore = spoonacularScore
    }
}

// MARK: - Recipe Ingredient
struct RecipeIngredient: Codable, Identifiable {
    let id: Int
    let name: String
    let original: String?
    let amount: Double?
    let unit: String?
    let image: String?
}

// MARK: - Recipe Detail
struct RecipeDetail: Codable, Identifiable {
    let id: Int
    let title: String
    let image: String
    let readyInMinutes: Int?
    let servings: Int?
    let extendedIngredients: [ExtendedIngredient]
    let aggregateLikes: Int?
    let spoonacularScore: Double?
    let analyzedInstructions: [AnalyzedInstruction]
    let nutrition: RecipeNutrition?

    init(
        id: Int,
        title: String,
        image: String,
        readyInMinutes: Int? = nil,
        servings: Int? = nil,
        extendedIngredients: [ExtendedIngredient],
        aggregateLikes: Int? = nil,
        spoonacularScore: Double? = nil,
        analyzedInstructions: [AnalyzedInstruction],
        nutrition: RecipeNutrition? = nil
    ) {
        self.id = id
        self.title = title
        self.image = image
        self.readyInMinutes = readyInMinutes
        self.servings = servings
        self.extendedIngredients = extendedIngredients
        self.aggregateLikes = aggregateLikes
        self.spoonacularScore = spoonacularScore
        self.analyzedInstructions = analyzedInstructions
        self.nutrition = nutrition
    }
}

// MARK: - Nutrition
struct RecipeNutrition: Codable {
    let nutrients: [NutrientInfo]

    var calories: Double? { nutrients.first(where: { $0.name == "Calories" })?.amount }
    var protein: Double? { nutrients.first(where: { $0.name == "Protein" })?.amount }
    var carbs: Double? { nutrients.first(where: { $0.name == "Carbohydrates" })?.amount }
    var fat: Double? { nutrients.first(where: { $0.name == "Fat" })?.amount }
}

struct NutrientInfo: Codable {
    let name: String
    let amount: Double
    let unit: String
}

// MARK: - Extended Ingredient
struct ExtendedIngredient: Codable, Identifiable {
    let id: Int
    let name: String
    let original: String?
    let amount: Double?
    let unit: String?
}

// MARK: - Instructions
struct AnalyzedInstruction: Codable {
    let name: String
    let steps: [InstructionStep]
}

struct InstructionStep: Codable {
    let number: Int
    let step: String
}
