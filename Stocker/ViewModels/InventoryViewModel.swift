import Foundation
import SwiftData

@Observable
class InventoryViewModel {
    var searchText: String = ""
    var selectedCategory: IngredientCategory = .protein

    func ingredients(
        for category: IngredientCategory,
        from allIngredients: [Ingredient]
    ) -> [Ingredient] {
        let filtered = allIngredients.filter { $0.category == category }
        if searchText.isEmpty {
            return filtered.sorted { $0.name.lowercased() < $1.name.lowercased() }
        } else {
            return filtered
                .filter { $0.name.lowercased().contains(searchText.lowercased()) }
                .sorted { $0.name.lowercased() < $1.name.lowercased() }
        }
    }

    func deleteIngredient(
        _ ingredient: Ingredient,
        context: ModelContext
    ) {
        context.delete(ingredient)
        try? context.save()
    }

    func addIngredient(
        name: String,
        quantityAmount: Double,
        quantityUnit: QuantityUnit,
        category: IngredientCategory,
        barcode: String? = nil,
        context: ModelContext
    ) {
        let ingredient = Ingredient(
            name: name,
            quantityAmount: quantityAmount,
            quantityUnit: quantityUnit,
            category: category,
            barcode: barcode
        )
        context.insert(ingredient)
        try? context.save()
    }
}
