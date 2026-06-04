import Foundation
import SwiftData

@Model
class BarcodeMemory {
    var barcode: String
    var productName: String
    var category: IngredientCategory
    var unitRaw: String = "item"
    var containerSize: Double = 0.0
    var containerSizeUnitRaw: String = ""

    // Nutrition & label data
    var servingSize: String = ""
    var calories: Double = 0
    var protein: Double = 0
    var carbs: Double = 0
    var fat: Double = 0
    var fiber: Double = 0
    var sugar: Double = 0
    var sodium: Double = 0
    var cholesterol: Double = 0
    var saturatedFat: Double = 0
    var transFat: Double = 0
    var allergensList: [String] = []
    var ingredientsList: String = ""

    init(barcode: String,
         productName: String,
         category: IngredientCategory,
         unitRaw: String = "item",
         containerSize: Double = 0.0,
         containerSizeUnitRaw: String = "",
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
         ingredientsList: String = "") {
        self.barcode = barcode
        self.productName = productName
        self.category = category
        self.unitRaw = unitRaw
        self.containerSize = containerSize
        self.containerSizeUnitRaw = containerSizeUnitRaw
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
}
