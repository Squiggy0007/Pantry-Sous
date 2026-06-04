import Foundation
import SwiftData

@Model
class SavedRecipe {
    var id: Int
    var title: String
    var imageURL: String
    var readyInMinutes: Int
    var servings: Int
    var ingredientsList: String
    var parsedSteps: String
    var dateSaved: Date
    var mealCategoryRaw: String   // stores MealCategory.rawValue

    var mealCategory: MealCategory {
        get { MealCategory(rawValue: mealCategoryRaw) ?? .uncategorized }
        set { mealCategoryRaw = newValue.rawValue }
    }

    init(
        id: Int,
        title: String,
        imageURL: String,
        readyInMinutes: Int,
        servings: Int,
        ingredientsList: String,
        parsedSteps: String,
        mealCategory: MealCategory? = nil
    ) {
        self.id = id
        self.title = title
        self.imageURL = imageURL
        self.readyInMinutes = readyInMinutes
        self.servings = servings
        self.ingredientsList = ingredientsList
        self.parsedSteps = parsedSteps
        self.dateSaved = Date()
        // Auto-detect meal category from title if not provided
        self.mealCategoryRaw = (mealCategory ?? MealCategory.suggested(for: title)).rawValue
    }
}
