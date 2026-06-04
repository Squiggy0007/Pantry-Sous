import SwiftUI
import SwiftData

struct AddShoppingItemView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var shoppingItems: [ShoppingItem]

    @State private var name: String = ""
    @State private var amount: Double = 1
    @State private var unit: QuantityUnit = .item
    @State private var selectedCategory: IngredientCategory = .other
    @State private var errorMessage: String? = nil
    @FocusState private var nameFieldFocused: Bool

    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundPrimary")
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {

                        // Name field
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Item Name")
                                .font(.system(.caption, design: .rounded, weight: .medium))
                                .foregroundStyle(Color("TextSecondary"))
                                .padding(.horizontal, 4)

                            TextField("e.g. Milk", text: $name)
                                .font(.system(.body, design: .rounded))
                                .padding(14)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color("CardBackground"))
                                )
                                .focused($nameFieldFocused)
                                .onChange(of: nameFieldFocused) { _, isFocused in
                                    if !isFocused && !name.isEmpty {
                                        name = name.titleCased()
                                        selectedCategory = IngredientCategory.suggested(for: name)
                                        if isEggIngredient(name) {
                                            unit = .egg
                                            amount = 1
                                        }
                                    }
                                }
                        }
                        .padding(.horizontal, 16)

                        // Quantity picker
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Quantity")
                                .font(.system(.caption, design: .rounded, weight: .medium))
                                .foregroundStyle(Color("TextSecondary"))
                                .padding(.horizontal, 4)

                            QuantityPickerView(
                                amount: $amount,
                                unit: $unit,
                                ingredientName: name,
                                ingredientCategory: selectedCategory
                            )
                            .padding(14)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color("CardBackground"))
                            )
                        }
                        .padding(.horizontal, 16)

                        // Category picker
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Category")
                                .font(.system(.caption, design: .rounded, weight: .medium))
                                .foregroundStyle(Color("TextSecondary"))
                                .padding(.horizontal, 4)

                            CategoryGridPicker(selectedCategory: $selectedCategory)
                        }
                        .padding(.horizontal, 16)

                        if let error = errorMessage {
                            Text(error)
                                .font(.system(.caption, design: .rounded))
                                .foregroundStyle(Color("DestructiveTerracotta"))
                                .padding(.horizontal, 16)
                        }

                        Button {
                            saveItem()
                        } label: {
                            Text("Add to List")
                                .font(.system(.body, design: .rounded, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(name.isEmpty
                                              ? Color("BackgroundSecondary")
                                              : Color("AccentSage"))
                                )
                                .foregroundStyle(name.isEmpty ? Color("TextSecondary") : .white)
                        }
                        .disabled(name.isEmpty)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 32)
                    }
                    .padding(.top, 16)
                }
            }
            .navigationTitle("Add Item")
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

    private func saveItem() {
        guard !name.isEmpty else {
            errorMessage = "Please enter an item name"
            return
        }

        // Merge if item already exists on list
        if let existing = shoppingItems.first(where: {
            $0.name.lowercased() == name.lowercased()
        }) {
            if existing.quantityUnit == unit.rawValue {
                existing.quantityAmount += amount
            } else {
                // Different unit — just bump the amount in existing unit
                existing.quantityAmount += amount
            }
            try? modelContext.save()
        } else {
            let item = ShoppingItem(
                name: name,
                quantityAmount: amount,
                quantityUnit: unit,
                category: selectedCategory
            )
            modelContext.insert(item)
            try? modelContext.save()
        }

        HapticFeedback.success()
        dismiss()
    }
}
