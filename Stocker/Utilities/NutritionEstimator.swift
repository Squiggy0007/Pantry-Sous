import Foundation

// MARK: - Nutrition Estimator
// Estimates recipe nutrition from ingredient strings using a built-in per-100g database.
// Used in mock mode; real API (Spoonacular analyze) is used when useMockData = false.

struct NutritionEstimator {

    // MARK: - Per-100g Nutrition Entry
    struct Entry {
        let cal: Double   // kcal
        let pro: Double   // g protein
        let carb: Double  // g carbohydrates
        let fat: Double   // g fat
        let fiber: Double // g fiber
        /// Grams per 1 cup (used for volume→weight conversion).
        /// nil means treat as liquid (240g/cup).
        let gramsPerCup: Double?
        /// Grams for 1 count (used when unit is "item" / piece / egg / etc.)
        let gramsPerItem: Double?
    }

    // MARK: - Database (per 100g)

    static let db: [String: Entry] = [
        // ── Baking & Dry Goods ──
        "flour":            Entry(cal: 364, pro: 10,  carb: 76,  fat: 1,   fiber: 3,  gramsPerCup: 125, gramsPerItem: nil),
        "all-purpose flour":Entry(cal: 364, pro: 10,  carb: 76,  fat: 1,   fiber: 3,  gramsPerCup: 125, gramsPerItem: nil),
        "bread flour":      Entry(cal: 361, pro: 12,  carb: 73,  fat: 2,   fiber: 3,  gramsPerCup: 125, gramsPerItem: nil),
        "whole wheat flour":Entry(cal: 340, pro: 13,  carb: 72,  fat: 2,   fiber: 11, gramsPerCup: 120, gramsPerItem: nil),
        "cornmeal":         Entry(cal: 362, pro: 8,   carb: 77,  fat: 4,   fiber: 7,  gramsPerCup: 156, gramsPerItem: nil),
        "cornstarch":       Entry(cal: 381, pro: 0,   carb: 91,  fat: 0,   fiber: 1,  gramsPerCup: 128, gramsPerItem: nil),
        "oats":             Entry(cal: 389, pro: 17,  carb: 66,  fat: 7,   fiber: 11, gramsPerCup: 90,  gramsPerItem: nil),
        "rolled oats":      Entry(cal: 389, pro: 17,  carb: 66,  fat: 7,   fiber: 11, gramsPerCup: 90,  gramsPerItem: nil),
        "rice":             Entry(cal: 365, pro: 7,   carb: 80,  fat: 1,   fiber: 1,  gramsPerCup: 185, gramsPerItem: nil),
        "brown rice":       Entry(cal: 370, pro: 8,   carb: 77,  fat: 3,   fiber: 4,  gramsPerCup: 185, gramsPerItem: nil),
        "pasta":            Entry(cal: 371, pro: 13,  carb: 74,  fat: 2,   fiber: 3,  gramsPerCup: 85,  gramsPerItem: nil),
        "breadcrumbs":      Entry(cal: 395, pro: 13,  carb: 73,  fat: 5,   fiber: 4,  gramsPerCup: 108, gramsPerItem: nil),

        // ── Sweeteners ──
        "sugar":            Entry(cal: 387, pro: 0,   carb: 100, fat: 0,   fiber: 0,  gramsPerCup: 200, gramsPerItem: nil),
        "brown sugar":      Entry(cal: 380, pro: 0,   carb: 98,  fat: 0,   fiber: 0,  gramsPerCup: 220, gramsPerItem: nil),
        "powdered sugar":   Entry(cal: 389, pro: 0,   carb: 100, fat: 0,   fiber: 0,  gramsPerCup: 120, gramsPerItem: nil),
        "honey":            Entry(cal: 304, pro: 0,   carb: 82,  fat: 0,   fiber: 0,  gramsPerCup: 340, gramsPerItem: nil),
        "maple syrup":      Entry(cal: 260, pro: 0,   carb: 67,  fat: 0,   fiber: 0,  gramsPerCup: 320, gramsPerItem: nil),

        // ── Fats & Oils ──
        "butter":           Entry(cal: 717, pro: 1,   carb: 1,   fat: 81,  fiber: 0,  gramsPerCup: 227, gramsPerItem: nil),
        "oil":              Entry(cal: 884, pro: 0,   carb: 0,   fat: 100, fiber: 0,  gramsPerCup: 218, gramsPerItem: nil),
        "olive oil":        Entry(cal: 884, pro: 0,   carb: 0,   fat: 100, fiber: 0,  gramsPerCup: 218, gramsPerItem: nil),
        "vegetable oil":    Entry(cal: 884, pro: 0,   carb: 0,   fat: 100, fiber: 0,  gramsPerCup: 218, gramsPerItem: nil),
        "coconut oil":      Entry(cal: 862, pro: 0,   carb: 0,   fat: 100, fiber: 0,  gramsPerCup: 218, gramsPerItem: nil),

        // ── Dairy ──
        "milk":             Entry(cal: 61,  pro: 3,   carb: 5,   fat: 3,   fiber: 0,  gramsPerCup: 244, gramsPerItem: nil),
        "whole milk":       Entry(cal: 61,  pro: 3,   carb: 5,   fat: 3,   fiber: 0,  gramsPerCup: 244, gramsPerItem: nil),
        "skim milk":        Entry(cal: 35,  pro: 3,   carb: 5,   fat: 0,   fiber: 0,  gramsPerCup: 244, gramsPerItem: nil),
        "heavy cream":      Entry(cal: 340, pro: 2,   carb: 3,   fat: 36,  fiber: 0,  gramsPerCup: 232, gramsPerItem: nil),
        "heavy whipping cream": Entry(cal: 340, pro: 2, carb: 3, fat: 36, fiber: 0,  gramsPerCup: 232, gramsPerItem: nil),
        "sour cream":       Entry(cal: 193, pro: 3,   carb: 5,   fat: 19,  fiber: 0,  gramsPerCup: 230, gramsPerItem: nil),
        "cream cheese":     Entry(cal: 342, pro: 6,   carb: 4,   fat: 34,  fiber: 0,  gramsPerCup: 232, gramsPerItem: nil),
        "yogurt":           Entry(cal: 59,  pro: 10,  carb: 4,   fat: 0,   fiber: 0,  gramsPerCup: 245, gramsPerItem: nil),
        "greek yogurt":     Entry(cal: 59,  pro: 10,  carb: 4,   fat: 0,   fiber: 0,  gramsPerCup: 245, gramsPerItem: nil),
        "cheese":           Entry(cal: 403, pro: 25,  carb: 1,   fat: 33,  fiber: 0,  gramsPerCup: 113, gramsPerItem: nil),
        "cheddar":          Entry(cal: 403, pro: 25,  carb: 1,   fat: 33,  fiber: 0,  gramsPerCup: 113, gramsPerItem: nil),
        "mozzarella":       Entry(cal: 280, pro: 22,  carb: 2,   fat: 17,  fiber: 0,  gramsPerCup: 113, gramsPerItem: nil),
        "parmesan":         Entry(cal: 431, pro: 38,  carb: 4,   fat: 29,  fiber: 0,  gramsPerCup: 100, gramsPerItem: nil),
        "feta":             Entry(cal: 264, pro: 14,  carb: 4,   fat: 21,  fiber: 0,  gramsPerCup: 150, gramsPerItem: nil),
        "ricotta":          Entry(cal: 174, pro: 11,  carb: 3,   fat: 13,  fiber: 0,  gramsPerCup: 246, gramsPerItem: nil),

        // ── Eggs ──
        "egg":              Entry(cal: 147, pro: 13,  carb: 1,   fat: 10,  fiber: 0,  gramsPerCup: nil, gramsPerItem: 50),
        "eggs":             Entry(cal: 147, pro: 13,  carb: 1,   fat: 10,  fiber: 0,  gramsPerCup: nil, gramsPerItem: 50),
        "egg white":        Entry(cal: 52,  pro: 11,  carb: 1,   fat: 0,   fiber: 0,  gramsPerCup: nil, gramsPerItem: 33),
        "egg yolk":         Entry(cal: 317, pro: 16,  carb: 4,   fat: 27,  fiber: 0,  gramsPerCup: nil, gramsPerItem: 17),

        // ── Proteins ──
        "chicken":          Entry(cal: 165, pro: 31,  carb: 0,   fat: 4,   fiber: 0,  gramsPerCup: 140, gramsPerItem: 200),
        "ground beef":      Entry(cal: 254, pro: 17,  carb: 0,   fat: 20,  fiber: 0,  gramsPerCup: 230, gramsPerItem: nil),
        "beef":             Entry(cal: 250, pro: 26,  carb: 0,   fat: 17,  fiber: 0,  gramsPerCup: 230, gramsPerItem: nil),
        "pork":             Entry(cal: 242, pro: 27,  carb: 0,   fat: 14,  fiber: 0,  gramsPerCup: 230, gramsPerItem: nil),
        "bacon":            Entry(cal: 541, pro: 37,  carb: 1,   fat: 42,  fiber: 0,  gramsPerCup: 100, gramsPerItem: 15),
        "sausage":          Entry(cal: 301, pro: 12,  carb: 2,   fat: 27,  fiber: 0,  gramsPerCup: 230, gramsPerItem: 85),
        "salmon":           Entry(cal: 208, pro: 20,  carb: 0,   fat: 13,  fiber: 0,  gramsPerCup: nil, gramsPerItem: 150),
        "tuna":             Entry(cal: 128, pro: 29,  carb: 0,   fat: 1,   fiber: 0,  gramsPerCup: 154, gramsPerItem: nil),
        "shrimp":           Entry(cal: 99,  pro: 24,  carb: 0,   fat: 1,   fiber: 0,  gramsPerCup: 135, gramsPerItem: 15),
        "tofu":             Entry(cal: 76,  pro: 8,   carb: 2,   fat: 5,   fiber: 0,  gramsPerCup: 252, gramsPerItem: nil),
        "turkey":           Entry(cal: 189, pro: 29,  carb: 0,   fat: 7,   fiber: 0,  gramsPerCup: 140, gramsPerItem: nil),
        "ham":              Entry(cal: 163, pro: 21,  carb: 2,   fat: 8,   fiber: 0,  gramsPerCup: 135, gramsPerItem: nil),

        // ── Vegetables ──
        "onion":            Entry(cal: 40,  pro: 1,   carb: 9,   fat: 0,   fiber: 2,  gramsPerCup: 160, gramsPerItem: 150),
        "garlic":           Entry(cal: 149, pro: 6,   carb: 33,  fat: 1,   fiber: 2,  gramsPerCup: 136, gramsPerItem: 4),
        "tomato":           Entry(cal: 18,  pro: 1,   carb: 4,   fat: 0,   fiber: 1,  gramsPerCup: 180, gramsPerItem: 120),
        "potato":           Entry(cal: 77,  pro: 2,   carb: 17,  fat: 0,   fiber: 2,  gramsPerCup: 150, gramsPerItem: 150),
        "sweet potato":     Entry(cal: 86,  pro: 2,   carb: 20,  fat: 0,   fiber: 3,  gramsPerCup: 133, gramsPerItem: 150),
        "carrot":           Entry(cal: 41,  pro: 1,   carb: 10,  fat: 0,   fiber: 3,  gramsPerCup: 128, gramsPerItem: 61),
        "broccoli":         Entry(cal: 34,  pro: 3,   carb: 7,   fat: 0,   fiber: 3,  gramsPerCup: 91,  gramsPerItem: nil),
        "spinach":          Entry(cal: 23,  pro: 3,   carb: 4,   fat: 0,   fiber: 2,  gramsPerCup: 30,  gramsPerItem: nil),
        "kale":             Entry(cal: 49,  pro: 4,   carb: 9,   fat: 1,   fiber: 4,  gramsPerCup: 67,  gramsPerItem: nil),
        "lettuce":          Entry(cal: 15,  pro: 1,   carb: 3,   fat: 0,   fiber: 1,  gramsPerCup: 47,  gramsPerItem: nil),
        "bell pepper":      Entry(cal: 31,  pro: 1,   carb: 6,   fat: 0,   fiber: 2,  gramsPerCup: 149, gramsPerItem: 120),
        "mushroom":         Entry(cal: 22,  pro: 3,   carb: 3,   fat: 0,   fiber: 1,  gramsPerCup: 70,  gramsPerItem: 18),
        "zucchini":         Entry(cal: 17,  pro: 1,   carb: 3,   fat: 0,   fiber: 1,  gramsPerCup: 124, gramsPerItem: 200),
        "celery":           Entry(cal: 16,  pro: 1,   carb: 3,   fat: 0,   fiber: 2,  gramsPerCup: 101, gramsPerItem: 40),
        "corn":             Entry(cal: 86,  pro: 3,   carb: 19,  fat: 1,   fiber: 2,  gramsPerCup: 154, gramsPerItem: nil),
        "peas":             Entry(cal: 81,  pro: 5,   carb: 14,  fat: 0,   fiber: 5,  gramsPerCup: 145, gramsPerItem: nil),
        "cucumber":         Entry(cal: 15,  pro: 1,   carb: 4,   fat: 0,   fiber: 1,  gramsPerCup: 119, gramsPerItem: 200),
        "avocado":          Entry(cal: 160, pro: 2,   carb: 9,   fat: 15,  fiber: 7,  gramsPerCup: 150, gramsPerItem: 140),
        "jalapeño":         Entry(cal: 29,  pro: 1,   carb: 7,   fat: 0,   fiber: 3,  gramsPerCup: 90,  gramsPerItem: 14),
        "green onion":      Entry(cal: 32,  pro: 2,   carb: 7,   fat: 0,   fiber: 3,  gramsPerCup: 100, gramsPerItem: 12),
        "cabbage":          Entry(cal: 25,  pro: 1,   carb: 6,   fat: 0,   fiber: 3,  gramsPerCup: 89,  gramsPerItem: nil),

        // ── Fruit ──
        "apple":            Entry(cal: 52,  pro: 0,   carb: 14,  fat: 0,   fiber: 2,  gramsPerCup: 125, gramsPerItem: 150),
        "banana":           Entry(cal: 89,  pro: 1,   carb: 23,  fat: 0,   fiber: 3,  gramsPerCup: 225, gramsPerItem: 100),
        "strawberry":       Entry(cal: 32,  pro: 1,   carb: 8,   fat: 0,   fiber: 2,  gramsPerCup: 152, gramsPerItem: 18),
        "blueberry":        Entry(cal: 57,  pro: 1,   carb: 14,  fat: 0,   fiber: 2,  gramsPerCup: 148, gramsPerItem: nil),
        "lemon":            Entry(cal: 22,  pro: 1,   carb: 7,   fat: 0,   fiber: 3,  gramsPerCup: 240, gramsPerItem: 30), // juice
        "lime":             Entry(cal: 25,  pro: 1,   carb: 8,   fat: 0,   fiber: 3,  gramsPerCup: 240, gramsPerItem: 20), // juice
        "mango":            Entry(cal: 60,  pro: 1,   carb: 15,  fat: 0,   fiber: 2,  gramsPerCup: 165, gramsPerItem: 200),
        "pineapple":        Entry(cal: 50,  pro: 1,   carb: 13,  fat: 0,   fiber: 1,  gramsPerCup: 165, gramsPerItem: nil),

        // ── Legumes & Beans ──
        "beans":            Entry(cal: 127, pro: 9,   carb: 23,  fat: 1,   fiber: 9,  gramsPerCup: 172, gramsPerItem: nil),
        "black beans":      Entry(cal: 132, pro: 9,   carb: 24,  fat: 1,   fiber: 9,  gramsPerCup: 172, gramsPerItem: nil),
        "kidney beans":     Entry(cal: 127, pro: 9,   carb: 23,  fat: 1,   fiber: 7,  gramsPerCup: 177, gramsPerItem: nil),
        "chickpeas":        Entry(cal: 164, pro: 9,   carb: 27,  fat: 3,   fiber: 8,  gramsPerCup: 164, gramsPerItem: nil),
        "lentils":          Entry(cal: 116, pro: 9,   carb: 20,  fat: 0,   fiber: 8,  gramsPerCup: 192, gramsPerItem: nil),
        "peanut butter":    Entry(cal: 588, pro: 25,  carb: 20,  fat: 50,  fiber: 6,  gramsPerCup: 258, gramsPerItem: nil),

        // ── Nuts & Seeds ──
        "almonds":          Entry(cal: 579, pro: 21,  carb: 22,  fat: 50,  fiber: 13, gramsPerCup: 143, gramsPerItem: 1),
        "walnuts":          Entry(cal: 654, pro: 15,  carb: 14,  fat: 65,  fiber: 7,  gramsPerCup: 117, gramsPerItem: 4),

        // ── Condiments & Liquids ──
        "chicken broth":    Entry(cal: 15,  pro: 1,   carb: 1,   fat: 0,   fiber: 0,  gramsPerCup: 240, gramsPerItem: nil),
        "beef broth":       Entry(cal: 17,  pro: 3,   carb: 0,   fat: 1,   fiber: 0,  gramsPerCup: 240, gramsPerItem: nil),
        "vegetable broth":  Entry(cal: 10,  pro: 0,   carb: 2,   fat: 0,   fiber: 0,  gramsPerCup: 240, gramsPerItem: nil),
        "tomato sauce":     Entry(cal: 29,  pro: 1,   carb: 7,   fat: 0,   fiber: 1,  gramsPerCup: 245, gramsPerItem: nil),
        "tomato paste":     Entry(cal: 82,  pro: 4,   carb: 19,  fat: 0,   fiber: 4,  gramsPerCup: 262, gramsPerItem: nil),
        "coconut milk":     Entry(cal: 230, pro: 2,   carb: 6,   fat: 24,  fiber: 0,  gramsPerCup: 240, gramsPerItem: nil),
        "soy sauce":        Entry(cal: 60,  pro: 10,  carb: 6,   fat: 0,   fiber: 0,  gramsPerCup: 255, gramsPerItem: nil),
        "worcestershire":   Entry(cal: 78,  pro: 0,   carb: 20,  fat: 0,   fiber: 0,  gramsPerCup: 272, gramsPerItem: nil),
        "hot sauce":        Entry(cal: 11,  pro: 1,   carb: 2,   fat: 0,   fiber: 0,  gramsPerCup: 240, gramsPerItem: nil),
        "ketchup":          Entry(cal: 101, pro: 1,   carb: 25,  fat: 0,   fiber: 0,  gramsPerCup: 240, gramsPerItem: nil),
        "mayonnaise":       Entry(cal: 680, pro: 1,   carb: 1,   fat: 75,  fiber: 0,  gramsPerCup: 220, gramsPerItem: nil),
        "mustard":          Entry(cal: 66,  pro: 4,   carb: 6,   fat: 4,   fiber: 4,  gramsPerCup: 240, gramsPerItem: nil),
        "vinegar":          Entry(cal: 21,  pro: 0,   carb: 1,   fat: 0,   fiber: 0,  gramsPerCup: 240, gramsPerItem: nil),
        "lemon juice":      Entry(cal: 22,  pro: 0,   carb: 7,   fat: 0,   fiber: 0,  gramsPerCup: 244, gramsPerItem: nil),
        "lime juice":       Entry(cal: 25,  pro: 0,   carb: 8,   fat: 0,   fiber: 0,  gramsPerCup: 246, gramsPerItem: nil),

        // ── Chocolate & Baking ──
        "chocolate chips":  Entry(cal: 488, pro: 5,   carb: 63,  fat: 27,  fiber: 5,  gramsPerCup: 170, gramsPerItem: nil),
        "cocoa powder":     Entry(cal: 228, pro: 20,  carb: 58,  fat: 14,  fiber: 33, gramsPerCup: 86,  gramsPerItem: nil),
        "vanilla extract":  Entry(cal: 288, pro: 0,   carb: 13,  fat: 0,   fiber: 0,  gramsPerCup: 208, gramsPerItem: nil),
        "baking powder":    Entry(cal: 53,  pro: 0,   carb: 28,  fat: 0,   fiber: 0,  gramsPerCup: 230, gramsPerItem: nil),
        "baking soda":      Entry(cal: 0,   pro: 0,   carb: 0,   fat: 0,   fiber: 0,  gramsPerCup: 230, gramsPerItem: nil),

        // ── Spices (negligible amounts, but tracked) ──
        "salt":             Entry(cal: 0,   pro: 0,   carb: 0,   fat: 0,   fiber: 0,  gramsPerCup: 288, gramsPerItem: nil),
        "black pepper":     Entry(cal: 251, pro: 10,  carb: 64,  fat: 3,   fiber: 26, gramsPerCup: 144, gramsPerItem: nil),
        "cumin":            Entry(cal: 375, pro: 18,  carb: 44,  fat: 22,  fiber: 11, gramsPerCup: 117, gramsPerItem: nil),
        "paprika":          Entry(cal: 282, pro: 14,  carb: 54,  fat: 13,  fiber: 35, gramsPerCup: 108, gramsPerItem: nil),
        "cinnamon":         Entry(cal: 247, pro: 4,   carb: 81,  fat: 1,   fiber: 53, gramsPerCup: 120, gramsPerItem: nil),
        "oregano":          Entry(cal: 265, pro: 9,   carb: 69,  fat: 4,   fiber: 43, gramsPerCup: 48,  gramsPerItem: nil),
        "thyme":            Entry(cal: 101, pro: 6,   carb: 24,  fat: 2,   fiber: 14, gramsPerCup: 48,  gramsPerItem: nil),
        "basil":            Entry(cal: 23,  pro: 3,   carb: 3,   fat: 1,   fiber: 2,  gramsPerCup: 24,  gramsPerItem: nil),
        "chili powder":     Entry(cal: 282, pro: 13,  carb: 50,  fat: 14,  fiber: 27, gramsPerCup: 125, gramsPerItem: nil),
        "garlic powder":    Entry(cal: 331, pro: 16,  carb: 73,  fat: 1,   fiber: 9,  gramsPerCup: 136, gramsPerItem: nil),
        "onion powder":     Entry(cal: 341, pro: 10,  carb: 79,  fat: 1,   fiber: 9,  gramsPerCup: 152, gramsPerItem: nil),
        "cayenne":          Entry(cal: 318, pro: 12,  carb: 57,  fat: 17,  fiber: 27, gramsPerCup: 108, gramsPerItem: nil),
        "turmeric":         Entry(cal: 312, pro: 10,  carb: 67,  fat: 3,   fiber: 21, gramsPerCup: 120, gramsPerItem: nil),
        "ginger":           Entry(cal: 80,  pro: 2,   carb: 18,  fat: 1,   fiber: 2,  gramsPerCup: 96,  gramsPerItem: nil),
        "red pepper flakes":Entry(cal: 314, pro: 12,  carb: 56,  fat: 13,  fiber: 27, gramsPerCup: 90,  gramsPerItem: nil),
    ]

    // MARK: - Unit → Grams Conversion

    /// Returns the weight in grams for a given amount + unit + ingredient name.
    static func toGrams(amount: Double, unit: String, ingredientName: String) -> Double {
        let u = unit.lowercased().trimmingCharacters(in: .whitespaces)
        let normalized = IngredientNormalizer.normalize(ingredientName)
        let entry = db[normalized] ?? db[ingredientName.lowercased()]

        switch u {
        case "g", "gram", "grams":
            return amount
        case "kg", "kilogram", "kilograms":
            return amount * 1000
        case "oz", "ounce", "ounces":
            return amount * 28.35
        case "lb", "lbs", "pound", "pounds":
            return amount * 453.6
        case "cup", "cups":
            let gpc = entry?.gramsPerCup ?? 240 // default to water density
            return amount * gpc
        case "tbsp", "tablespoon", "tablespoons":
            let gpc = entry?.gramsPerCup ?? 240
            return amount * (gpc / 16) // 16 tbsp per cup
        case "tsp", "teaspoon", "teaspoons":
            let gpc = entry?.gramsPerCup ?? 240
            return amount * (gpc / 48) // 48 tsp per cup
        case "fl oz", "fluid ounce", "fluid ounces", "floz":
            return amount * 29.57 // ml ≈ grams for water
        case "ml", "milliliter", "milliliters":
            return amount
        case "l", "liter", "liters":
            return amount * 1000
        case "pint", "pints":
            return amount * 473
        case "quart", "quarts":
            return amount * 946
        case "gallon", "gallons":
            return amount * 3785
        case "item", "items", "piece", "pieces", "whole",
             "can", "cans", "jar", "jars", "bottle", "bottles",
             "bag", "bags", "box", "boxes", "package", "packages", "packet", "packets":
            // For containers, use ingredient weight as a rough estimate
            // (a standard can ≈ 400g, bag varies)
            if u.contains("can") { return amount * 400 }
            return entry?.gramsPerItem.map { amount * $0 } ?? amount * 100
        default:
            // Treat as item
            return entry?.gramsPerItem.map { amount * $0 } ?? amount * 100
        }
    }

    // MARK: - Public API

    /// Estimates nutrition for a list of ingredient strings, divided by servings.
    /// Returns nil if no recognizable ingredients were found.
    static func estimate(ingredients: [String], servings: Int) -> NutritionData? {
        var totalCal  = 0.0
        var totalPro  = 0.0
        var totalCarb = 0.0
        var totalFat  = 0.0
        var totalFiber = 0.0
        var matchedCount = 0

        for line in ingredients {
            guard !line.trimmingCharacters(in: .whitespaces).isEmpty else { continue }

            let rawName = IngredientNormalizer.extractIngredientName(line)
            guard !rawName.isEmpty else { continue }

            let normalizedName = IngredientNormalizer.normalize(rawName)

            // Find entry: try exact normalized name first, then partial match
            guard let entry = db[normalizedName] ?? findPartialMatch(for: normalizedName) else { continue }

            let (amount, unit) = parseAmountUnit(from: line)
            let grams = toGrams(amount: amount, unit: unit, ingredientName: rawName)

            // Scale from per-100g to actual grams
            let scale = grams / 100.0
            totalCal   += entry.cal   * scale
            totalPro   += entry.pro   * scale
            totalCarb  += entry.carb  * scale
            totalFat   += entry.fat   * scale
            totalFiber += entry.fiber * scale
            matchedCount += 1
        }

        guard matchedCount > 0 else { return nil }

        let s = max(1, Double(servings))
        var data = NutritionData()
        data.calories = (totalCal  / s).rounded()
        data.protein  = roundToOne(totalPro  / s)
        data.carbs    = roundToOne(totalCarb / s)
        data.fat      = roundToOne(totalFat  / s)
        data.fiber    = roundToOne(totalFiber / s)
        return data
    }

    // MARK: - Helpers

    private static func findPartialMatch(for name: String) -> Entry? {
        // Check if any DB key is contained within the ingredient name or vice versa
        for (key, entry) in db {
            if name.contains(key) || key.contains(name) {
                return entry
            }
        }
        return nil
    }

    private static func roundToOne(_ value: Double) -> Double {
        (value * 10).rounded() / 10
    }

    private static func parseAmountUnit(from line: String) -> (Double, String) {
        let words = line.trimmingCharacters(in: .whitespaces)
            .components(separatedBy: " ").filter { !$0.isEmpty }
        guard !words.isEmpty else { return (1, "item") }

        var idx = 0
        var amount = 1.0

        // First token: number or fraction
        if let d = Double(words[idx]) {
            amount = d; idx += 1
        } else if words[idx].contains("/"), let f = fraction(words[idx]) {
            amount = f; idx += 1
        }

        // Mixed number (e.g. "1 1/2")
        if idx < words.count, words[idx].contains("/"), let f = fraction(words[idx]) {
            amount += f; idx += 1
        }

        // Next word: unit?
        let unitWords: Set<String> = [
            "cup","cups","tsp","tbsp","oz","lbs","lb","g","kg",
            "pint","pints","quart","quarts","gallon","gallons",
            "can","cans","jar","jars","bag","bags","box","boxes",
            "bottle","bottles","package","packages","packet","packets",
            "ml","l","cloves","clove","item","items","piece","pieces",
            "whole","large","medium","small","fl","floz","fl oz"
        ]
        var unit = "item"
        if idx < words.count && unitWords.contains(words[idx].lowercased()) {
            unit = words[idx].lowercased()
            // Handle "fl oz" two-word unit
            if unit == "fl" && idx + 1 < words.count && words[idx + 1].lowercased() == "oz" {
                unit = "fl oz"
            }
        }

        return (amount, unit)
    }

    private static func fraction(_ s: String) -> Double? {
        let parts = s.split(separator: "/")
        guard parts.count == 2,
              let n = Double(parts[0]),
              let d = Double(parts[1]), d != 0 else { return nil }
        return n / d
    }
}
