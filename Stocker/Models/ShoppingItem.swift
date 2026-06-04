import Foundation
import SwiftData

@Model
class ShoppingItem {
    var id: UUID
    var name: String
    var quantityAmount: Double
    var quantityUnit: String
    var category: IngredientCategory
    var isPurchased: Bool
    var isScanned: Bool = false
    var containerSize: Double = 0.0
    var containerSizeUnit: String = ""
    var dateAdded: Date

    init(
        name: String,
        quantityAmount: Double = 1,
        quantityUnit: QuantityUnit = .item,
        category: IngredientCategory,
        isScanned: Bool = false,
        containerSize: Double = 0.0,
        containerSizeUnit: String = ""
    ) {
        self.id = UUID()
        self.name = name.titleCased()
        self.quantityAmount = quantityAmount
        self.quantityUnit = quantityUnit.rawValue
        self.category = category
        self.isPurchased = false
        self.isScanned = isScanned
        self.containerSize = containerSize
        self.containerSizeUnit = containerSizeUnit
        self.dateAdded = Date()
    }

    var displayQuantity: String {
        let unit = QuantityUnit(rawValue: quantityUnit) ?? .item
        let quantity = IngredientQuantity(amount: quantityAmount, unit: unit)
        var base = quantity.displayString
        if containerSize > 0, !containerSizeUnit.isEmpty,
           let sizeUnit = QuantityUnit(rawValue: containerSizeUnit) {
            let sizeFormatted = containerSize.truncatingRemainder(dividingBy: 1) == 0
                ? String(Int(containerSize)) : String(format: "%.1f", containerSize)
            base = "\(base) · \(sizeFormatted) \(sizeUnit.rawValue)"
        }
        return base
    }
}
