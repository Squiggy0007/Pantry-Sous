import SwiftUI
import SwiftData

struct FinishShoppingView: View {
    let purchasedItems: [ShoppingItem]
    let onFinish: () -> Void

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var allIngredients: [Ingredient]
    @Query private var barcodeMemories: [BarcodeMemory]

    // Override amounts/units/categories for non-scanned items only
    @State private var itemAmounts: [UUID: Double] = [:]
    @State private var itemUnits: [UUID: QuantityUnit] = [:]
    @State private var itemCategories: [UUID: IngredientCategory] = [:]

    // Non-scanned items sorted: produce first, then others
    var manualItems: [ShoppingItem] {
        purchasedItems
            .filter { !$0.isScanned }
            .sorted { a, b in
                let aIsProduce = (a.category == .produce)
                let bIsProduce = (b.category == .produce)
                if aIsProduce != bIsProduce { return aIsProduce }
                return a.dateAdded < b.dateAdded
            }
    }

    // Scanned items (barcode was used during shopping — quantities already set)
    var scannedItems: [ShoppingItem] {
        purchasedItems.filter { $0.isScanned }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundPrimary")
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {

                        // Header card
                        VStack(spacing: 8) {
                            Image(systemName: "cart.fill.badge.plus")
                                .font(.system(size: 36))
                                .foregroundStyle(Color("AccentSage"))
                            Text("Add to Ingredients?")
                                .font(.system(.title3, design: .rounded, weight: .bold))
                                .foregroundStyle(Color("TextPrimary"))
                            Text("Review what you picked up, then add it all to your pantry.")
                                .font(.system(.subheadline, design: .rounded))
                                .foregroundStyle(Color("TextSecondary"))
                                .multilineTextAlignment(.center)
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color("CardBackground"))
                        )
                        .padding(.horizontal, 16)
                        .padding(.top, 8)

                        // --- Section 1: Fresh produce + manually-added items ---
                        if !manualItems.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                // Section header
                                HStack(spacing: 6) {
                                    Text("🥦")
                                        .font(.system(size: 16))
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Fresh & Manual Items")
                                            .font(.system(.subheadline, design: .rounded, weight: .bold))
                                            .foregroundStyle(Color("TextPrimary"))
                                        Text("Input how much you actually got")
                                            .font(.system(.caption, design: .rounded))
                                            .foregroundStyle(Color("TextSecondary"))
                                    }
                                }
                                .padding(.horizontal, 16)

                                ForEach(manualItems) { item in
                                    FinishShoppingItemRow(
                                        item: item,
                                        amount: Binding(
                                            get: { itemAmounts[item.id] ?? item.quantityAmount },
                                            set: { itemAmounts[item.id] = $0 }
                                        ),
                                        unit: Binding(
                                            get: { itemUnits[item.id] ?? (QuantityUnit(rawValue: item.quantityUnit) ?? .item) },
                                            set: { itemUnits[item.id] = $0 }
                                        ),
                                        category: Binding(
                                            get: { itemCategories[item.id] ?? item.category },
                                            set: { itemCategories[item.id] = $0 }
                                        )
                                    )
                                }
                            }
                            .padding(.horizontal, 16)
                        }

                        // --- Section 2: Scanned items ---
                        if !scannedItems.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                // Section header
                                HStack(spacing: 6) {
                                    Text("📱")
                                        .font(.system(size: 16))
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Scanned Items")
                                            .font(.system(.subheadline, design: .rounded, weight: .bold))
                                            .foregroundStyle(Color("TextPrimary"))
                                        Text("Quantities filled from barcode — ready to go")
                                            .font(.system(.caption, design: .rounded))
                                            .foregroundStyle(Color("TextSecondary"))
                                    }
                                }
                                .padding(.horizontal, 16)

                                VStack(spacing: 10) {
                                    ForEach(scannedItems) { item in
                                        ScannedItemConfirmRow(item: item)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }

                        // --- Action buttons ---
                        VStack(spacing: 12) {
                            Button {
                                addAllToIngredients()
                            } label: {
                                HStack(spacing: 8) {
                                    if !scannedItems.isEmpty && manualItems.isEmpty {
                                        Image(systemName: "checkmark.seal.fill")
                                    }
                                    Text(scannedItems.isEmpty
                                         ? "Add All to Ingredients & Finish"
                                         : (manualItems.isEmpty
                                            ? "Looks Good — Add to Ingredients"
                                            : "Add All to Ingredients & Finish"))
                                        .font(.system(.body, design: .rounded, weight: .semibold))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color("AccentSage"))
                                )
                                .foregroundStyle(.white)
                            }

                            Button {
                                onFinish()
                                dismiss()
                            } label: {
                                Text("Clear List Without Adding")
                                    .font(.system(.body, design: .rounded, weight: .medium))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color("BackgroundSecondary"))
                                    )
                                    .foregroundStyle(Color("TextSecondary"))
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 32)
                    }
                }
            }
            .navigationTitle("Finish Shopping")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(Color("AccentSage"))
                }
            }
        }
    }

    // MARK: - Add to Ingredients

    private func addAllToIngredients() {
        // Non-scanned items: use overridden amounts + merge on name + unit + containerSize == 0
        for item in manualItems {
            let amount = itemAmounts[item.id] ?? item.quantityAmount
            let unit = itemUnits[item.id] ?? (QuantityUnit(rawValue: item.quantityUnit) ?? .item)
            let category = itemCategories[item.id] ?? item.category
            let itemName = item.name.titleCased()

            if let existing = allIngredients.first(where: {
                $0.name.lowercased() == itemName.lowercased() &&
                $0.quantityUnit == unit.rawValue &&
                $0.containerSize == 0
            }) {
                existing.quantityAmount += amount
            } else {
                let ingredient = Ingredient(
                    name: itemName,
                    quantityAmount: amount,
                    quantityUnit: unit,
                    category: category
                )
                modelContext.insert(ingredient)
            }
        }

        // Scanned items: use item data directly (container size known from barcode)
        for item in scannedItems {
            let itemName = item.name.titleCased()
            let unit = QuantityUnit(rawValue: item.quantityUnit) ?? .item
            let containerSizeUnitRaw = item.containerSize > 0 ? item.containerSizeUnit : ""

            // Look up BarcodeMemory by name to carry over any nutrition data
            let memory = barcodeMemories.first(where: {
                $0.productName.lowercased() == itemName.lowercased()
            })

            if let existing = allIngredients.first(where: {
                $0.name.lowercased() == itemName.lowercased() &&
                $0.quantityUnit == unit.rawValue &&
                $0.containerSize == item.containerSize &&
                $0.containerSizeUnit == containerSizeUnitRaw
            }) {
                existing.quantityAmount += item.quantityAmount
                // Backfill nutrition if this entry doesn't have it yet
                if !existing.hasNutritionData, let m = memory, m.calories > 0 {
                    existing.servingSize    = m.servingSize
                    existing.calories       = m.calories
                    existing.protein        = m.protein
                    existing.carbs          = m.carbs
                    existing.fat            = m.fat
                    existing.saturatedFat   = m.saturatedFat
                    existing.transFat       = m.transFat
                    existing.fiber          = m.fiber
                    existing.sugar          = m.sugar
                    existing.sodium         = m.sodium
                    existing.cholesterol    = m.cholesterol
                    existing.allergensList  = m.allergensList
                    existing.ingredientsList = m.ingredientsList
                }
            } else {
                let ingredient = Ingredient(
                    name: itemName,
                    quantityAmount: item.quantityAmount,
                    quantityUnit: unit,
                    category: item.category,
                    containerSize: item.containerSize,
                    containerSizeUnit: item.containerSize > 0
                        ? QuantityUnit(rawValue: item.containerSizeUnit)
                        : nil,
                    servingSize:    memory?.servingSize    ?? "",
                    calories:       memory?.calories       ?? 0,
                    protein:        memory?.protein        ?? 0,
                    carbs:          memory?.carbs          ?? 0,
                    fat:            memory?.fat            ?? 0,
                    fiber:          memory?.fiber          ?? 0,
                    sugar:          memory?.sugar          ?? 0,
                    sodium:         memory?.sodium         ?? 0,
                    cholesterol:    memory?.cholesterol    ?? 0,
                    saturatedFat:   memory?.saturatedFat   ?? 0,
                    transFat:       memory?.transFat       ?? 0,
                    allergensList:  memory?.allergensList  ?? [],
                    ingredientsList: memory?.ingredientsList ?? ""
                )
                modelContext.insert(ingredient)
            }
        }

        try? modelContext.save()
        onFinish()
        dismiss()
    }
}

// MARK: - Manual Item Row (produce + other non-scanned)

struct FinishShoppingItemRow: View {
    let item: ShoppingItem
    @Binding var amount: Double
    @Binding var unit: QuantityUnit
    @Binding var category: IngredientCategory

    var isProduce: Bool {
        item.category == .produce
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                if isProduce {
                    Text(item.category.emoji)
                        .font(.system(size: 18))
                }
                Text(item.name)
                    .font(.system(.body, design: .rounded, weight: .semibold))
                    .foregroundStyle(Color("TextPrimary"))
            }

            QuantityPickerView(
                amount: $amount,
                unit: $unit,
                ingredientName: item.name
            )

            VStack(alignment: .leading, spacing: 4) {
                Text("Add to")
                    .font(.system(.caption, design: .rounded, weight: .medium))
                    .foregroundStyle(Color("TextSecondary"))
                CategoryGridPicker(selectedCategory: $category)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("CardBackground"))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}

// MARK: - Scanned Item Row (read-only, quantities from barcode)

struct ScannedItemConfirmRow: View {
    let item: ShoppingItem

    var body: some View {
        HStack(spacing: 14) {
            // Barcode icon
            Image(systemName: "barcode.viewfinder")
                .font(.system(size: 18))
                .foregroundStyle(Color("AccentSage"))
                .frame(width: 32, alignment: .center)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(Color("TextPrimary"))
                Text(item.displayQuantity)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(Color("TextSecondary"))
            }

            Spacer()

            Text(item.category.emoji)
                .font(.system(size: 20))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color("CardBackground"))
                .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
        )
    }
}
