import Foundation
import SwiftData

// MARK: - Custom Recipe
// User-created recipes stored locally in SwiftData.
// When isPrivate = false, the app can offer to upload to Spoonacular.

@Model
class CustomRecipe {
    var id: UUID
    var title: String
    var imageData: Data?           // optional photo stored locally
    var readyInMinutes: Int
    var servings: Int
    var ingredientsList: String    // "|" delimited raw ingredient strings
    var instructionsList: String   // "||" delimited steps
    var mealCategoryRaw: String
    var isPrivate: Bool
    var dateCreated: Date
    var notes: String

    var mealCategory: MealCategory {
        get { MealCategory(rawValue: mealCategoryRaw) ?? .uncategorized }
        set { mealCategoryRaw = newValue.rawValue }
    }

    /// Parsed ingredient strings
    var ingredients: [String] {
        ingredientsList.isEmpty ? [] : ingredientsList.components(separatedBy: "|")
    }

    /// Parsed instruction steps
    var steps: [String] {
        instructionsList.isEmpty ? [] : instructionsList.components(separatedBy: "||")
    }

    init(
        title: String,
        readyInMinutes: Int = 30,
        servings: Int = 4,
        ingredients: [String] = [],
        steps: [String] = [],
        mealCategory: MealCategory = .dinner,
        isPrivate: Bool = true,
        notes: String = "",
        imageData: Data? = nil
    ) {
        self.id = UUID()
        self.title = title
        self.readyInMinutes = readyInMinutes
        self.servings = servings
        self.ingredientsList = ingredients.joined(separator: "|")
        self.instructionsList = steps.joined(separator: "||")
        self.mealCategoryRaw = mealCategory.rawValue
        self.isPrivate = isPrivate
        self.dateCreated = Date()
        self.notes = notes
        self.imageData = imageData
    }
}
