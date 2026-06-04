import Foundation
import SwiftData

// MARK: - Week Day

enum WeekDay: Int, CaseIterable, Codable, Identifiable {
    var id: Int { rawValue }
    case monday    = 0
    case tuesday   = 1
    case wednesday = 2
    case thursday  = 3
    case friday    = 4
    case saturday  = 5
    case sunday    = 6

    var displayName: String {
        switch self {
        case .monday:    return "Monday"
        case .tuesday:   return "Tuesday"
        case .wednesday: return "Wednesday"
        case .thursday:  return "Thursday"
        case .friday:    return "Friday"
        case .saturday:  return "Saturday"
        case .sunday:    return "Sunday"
        }
    }

    var shortName: String { String(displayName.prefix(3)) }

    var emoji: String {
        switch self {
        case .monday:    return "🌙"
        case .tuesday:   return "🌙"
        case .wednesday: return "🌙"
        case .thursday:  return "🌙"
        case .friday:    return "🎉"
        case .saturday:  return "☀️"
        case .sunday:    return "🌿"
        }
    }
}

// MARK: - Menu Entry

@Model
class MenuEntry {
    var id: UUID
    var recipeId: Int
    var recipeTitle: String
    var recipeImage: String
    var dayOfWeek: Int          // WeekDay.rawValue
    var readyInMinutes: Int?
    var servings: Int?
    var dateAdded: Date

    /// All ingredient names for this recipe, stored at add-time so the menu
    /// can compute missing ingredients live against current inventory.
    var ingredientNames: [String] = []

    init(recipe: SpoonacularRecipe, day: WeekDay) {
        self.id = UUID()
        self.recipeId = recipe.id
        self.recipeTitle = recipe.title
        self.recipeImage = recipe.image
        self.dayOfWeek = day.rawValue
        self.readyInMinutes = recipe.readyInMinutes
        self.servings = recipe.servings
        self.dateAdded = Date()
        // Capture the full ingredient list (mock mode stores everything in usedIngredients;
        // real API splits into used + missed — union covers both cases)
        self.ingredientNames = (recipe.usedIngredients + recipe.missedIngredients)
            .map { $0.name }
            .filter { !$0.isEmpty }
    }
}
