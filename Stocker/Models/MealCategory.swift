import Foundation

enum MealCategory: String, CaseIterable, Codable {
    case breakfast  = "Breakfast"
    case lunch      = "Lunch"
    case dinner     = "Dinner"
    case soup       = "Soup"
    case snacks     = "Snacks"
    case desserts   = "Desserts"
    case uncategorized = "Uncategorized"

    var emoji: String {
        switch self {
        case .breakfast:     return "🌅"
        case .lunch:         return "☀️"
        case .dinner:        return "🌙"
        case .soup:          return "🍲"
        case .snacks:        return "🍃"
        case .desserts:      return "🎂"
        case .uncategorized: return "📌"
        }
    }

    /// Attempt to guess the meal category from a recipe title.
    static func suggested(for title: String) -> MealCategory {
        let t = title.lowercased()

        // Soup
        if ["soup", "stew", "chowder", "bisque", "broth", "ramen",
            "pho", "gumbo", "minestrone", "chili"].contains(where: { t.contains($0) }) {
            return .soup
        }

        // Desserts
        if ["cake", "cookie", "brownie", "pie", "tart", "mousse",
            "pudding", "custard", "ice cream", "gelato", "dessert",
            "cheesecake", "tiramisu", "fudge", "truffle", "muffin",
            "donut", "doughnut", "cupcake", "macaron", "churro",
            "cobbler", "crumble", "éclair", "crepe"].contains(where: { t.contains($0) }) {
            return .desserts
        }

        // Breakfast
        if ["pancake", "waffle", "omelette", "omelet", "scrambled",
            "frittata", "quiche", "breakfast", "brunch", "eggs benedict",
            "french toast", "granola", "oatmeal", "porridge",
            "hash", "benedict"].contains(where: { t.contains($0) }) {
            return .breakfast
        }

        // Snacks
        if ["snack", "dip", "hummus", "guacamole", "chips", "salsa",
            "bruschetta", "crostini", "nachos", "spring roll",
            "popcorn", "trail mix", "energy ball"].contains(where: { t.contains($0) }) {
            return .snacks
        }

        // Lunch
        if ["sandwich", "wrap", "salad", "lunch", "panini",
            "flatbread", "sub", "hoagie", "blt"].contains(where: { t.contains($0) }) {
            return .lunch
        }

        // Dinner keywords — most recipes are dinner so this is broad
        if ["roast", "steak", "pasta", "chicken", "beef", "pork",
            "salmon", "shrimp", "lasagna", "casserole", "bake",
            "dinner", "grill", "sauté", "curry", "stir fry",
            "fried rice", "risotto", "tacos", "burrito", "enchilada",
            "schnitzel", "meatball", "burger", "chops"].contains(where: { t.contains($0) }) {
            return .dinner
        }

        return .uncategorized
    }

    /// Display order for sections
    static var orderedCases: [MealCategory] {
        [.breakfast, .lunch, .dinner, .soup, .snacks, .desserts, .uncategorized]
    }
}
