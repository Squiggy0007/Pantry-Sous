import Foundation
import SwiftData

@Model
class Ingredient {
    var id: UUID
    var name: String
    var quantityAmount: Double
    var quantityUnit: String
    var category: IngredientCategory
    var barcode: String?
    var dateAdded: Date
    /// Optional per-container size (e.g. 12.5 for "3 cans · 12.5 oz").
    /// 0 means not set. Only meaningful when quantityUnit is a container unit.
    var containerSize: Double = 0.0
    /// Unit for containerSize (rawValue of QuantityUnit). Empty string means not set.
    var containerSizeUnit: String = ""
    /// Cached Spoonacular canonical ingredient id from /recipes/parseIngredients.
    /// 0 means unknown/unparsed.
    var spoonacularIngredientId: Int = 0
    /// Cached Spoonacular canonical ingredient name from /recipes/parseIngredients.
    var spoonacularIngredientName: String = ""

    // MARK: - Nutrition & Label Data (populated from barcode scan)
    var servingSize: String = ""
    var calories: Double = 0
    var protein: Double = 0      // grams
    var carbs: Double = 0        // grams
    var fat: Double = 0          // grams
    var fiber: Double = 0        // grams
    var sugar: Double = 0        // grams
    var sodium: Double = 0          // milligrams
    var cholesterol: Double = 0     // milligrams
    var saturatedFat: Double = 0    // grams
    var transFat: Double = 0        // grams
    var allergensList: [String] = []
    var ingredientsList: String = ""

    /// True if any nutrition data was populated from a barcode scan.
    var hasNutritionData: Bool {
        calories > 0 || protein > 0 || carbs > 0 || fat > 0
    }

    init(
        name: String,
        quantityAmount: Double = 1,
        quantityUnit: QuantityUnit = .item,
        category: IngredientCategory,
        barcode: String? = nil,
        containerSize: Double = 0.0,
        containerSizeUnit: QuantityUnit? = nil,
        spoonacularIngredientId: Int = 0,
        spoonacularIngredientName: String = "",
        servingSize: String = "",
        calories: Double = 0,
        protein: Double = 0,
        carbs: Double = 0,
        fat: Double = 0,
        fiber: Double = 0,
        sugar: Double = 0,
        sodium: Double = 0,
        cholesterol: Double = 0,
        saturatedFat: Double = 0,
        transFat: Double = 0,
        allergensList: [String] = [],
        ingredientsList: String = ""
    ) {
        self.id = UUID()
        self.name = name.titleCased()
        self.quantityAmount = quantityAmount
        self.quantityUnit = quantityUnit.rawValue
        self.category = category
        self.barcode = barcode
        self.dateAdded = Date()
        self.containerSize = containerSize
        self.containerSizeUnit = containerSizeUnit?.rawValue ?? ""
        self.spoonacularIngredientId = spoonacularIngredientId
        self.spoonacularIngredientName = spoonacularIngredientName
        self.servingSize = servingSize
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
        self.fiber = fiber
        self.sugar = sugar
        self.sodium = sodium
        self.cholesterol = cholesterol
        self.saturatedFat = saturatedFat
        self.transFat = transFat
        self.allergensList = allergensList
        self.ingredientsList = ingredientsList
    }

    var quantity: IngredientQuantity {
        get {
            let unit = QuantityUnit(rawValue: quantityUnit) ?? .item
            return IngredientQuantity(amount: quantityAmount, unit: unit)
        }
        set {
            quantityAmount = newValue.amount
            quantityUnit = newValue.unit.rawValue
        }
    }

    var displayQuantity: String {
        // If a per-container size is set, append it: "3 cans · 12.5 oz"
        if containerSize > 0, !containerSizeUnit.isEmpty,
           let sizeUnit = QuantityUnit(rawValue: containerSizeUnit) {
            let base = IngredientQuantity(amount: quantityAmount, unit: .item).displayString
            let sizeFormatted = containerSize.truncatingRemainder(dividingBy: 1) == 0
                ? String(Int(containerSize))
                : String(format: "%.2f", containerSize)
            return "\(base) · \(sizeFormatted) \(sizeUnit.rawValue)"
        }
        return quantity.displayString
    }


}
