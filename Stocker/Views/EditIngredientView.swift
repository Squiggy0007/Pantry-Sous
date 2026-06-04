import SwiftUI
import SwiftData

struct EditIngredientView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let ingredient: Ingredient
    @Query private var allIngredients: [Ingredient]

    @State private var name: String
    @State private var amount: Double
    @State private var unit: QuantityUnit
    @State private var containerSize: Double
    @State private var containerSizeUnit: QuantityUnit
    @State private var selectedCategory: IngredientCategory
    @State private var errorMessage: String? = nil
    @State private var showingDeleteConfirmation = false
    @FocusState private var nameFieldFocused: Bool

    init(ingredient: Ingredient) {
        self.ingredient = ingredient
        _name = State(initialValue: ingredient.name)
        _amount = State(initialValue: ingredient.quantityAmount)
        _unit = State(initialValue: QuantityUnit(rawValue: ingredient.quantityUnit) ?? .item)
        _containerSize = State(initialValue: ingredient.containerSize)
        _containerSizeUnit = State(initialValue: QuantityUnit(rawValue: ingredient.containerSizeUnit) ?? .oz)
        _selectedCategory = State(initialValue: ingredient.category)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundPrimary")
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {

                        // Name field
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Ingredient Name")
                                .font(.system(.caption, design: .rounded, weight: .medium))
                                .foregroundStyle(Color("TextSecondary"))
                                .padding(.horizontal, 4)

                            TextField("e.g. Chicken Breast", text: $name)
                                .font(.system(.body, design: .rounded))
                                .padding(14)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color("CardBackground"))
                                )
                                .focused($nameFieldFocused)
                                .onChange(of: nameFieldFocused) { _, isFocused in
                                    if !isFocused {
                                        name = name.titleCased()
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
                                containerSize: $containerSize,
                                containerSizeUnit: $containerSizeUnit,
                                ingredientCategory: selectedCategory
                            )
                            .padding(14)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color("CardBackground"))
                            )
                        }
                        .padding(.horizontal, 16)

                        // Category picker — extracted to avoid type-checker timeout
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Category")
                                .font(.system(.caption, design: .rounded, weight: .medium))
                                .foregroundStyle(Color("TextSecondary"))
                                .padding(.horizontal, 4)

                            CategoryGridPicker(selectedCategory: $selectedCategory)
                        }
                        .padding(.horizontal, 16)

                        // Nutrition card — shown when ingredient was scanned from a barcode
                        if ingredient.hasNutritionData {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Product Info")
                                    .font(.system(.caption, design: .rounded, weight: .medium))
                                    .foregroundStyle(Color("TextSecondary"))
                                    .padding(.horizontal, 4)

                                IngredientNutritionCard(
                                    servingSize: ingredient.servingSize,
                                    calories: ingredient.calories,
                                    protein: ingredient.protein,
                                    carbs: ingredient.carbs,
                                    fat: ingredient.fat,
                                    saturatedFat: ingredient.saturatedFat,
                                    transFat: ingredient.transFat,
                                    fiber: ingredient.fiber,
                                    sugar: ingredient.sugar,
                                    sodium: ingredient.sodium,
                                    cholesterol: ingredient.cholesterol,
                                    allergens: ingredient.allergensList,
                                    ingredientsList: ingredient.ingredientsList
                                )
                            }
                            .padding(.horizontal, 16)
                        }

                        if let error = errorMessage {
                            Text(error)
                                .font(.system(.caption, design: .rounded))
                                .foregroundStyle(Color("DestructiveTerracotta"))
                                .padding(.horizontal, 16)
                        }

                        // Save button
                        Button {
                            saveChanges()
                        } label: {
                            Text("Save Changes")
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

                        // Delete button
                        Button {
                            showingDeleteConfirmation = true
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "trash")
                                Text("Delete Ingredient")
                                    .font(.system(.body, design: .rounded, weight: .semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color("DestructiveTerracotta").opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color("DestructiveTerracotta"), lineWidth: 1.5)
                                    )
                            )
                            .foregroundStyle(Color("DestructiveTerracotta"))
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 32)
                    }
                    .padding(.top, 16)
                }
            }
            .navigationTitle("Edit Ingredient")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(Color("AccentSage"))
                }
            }
            .confirmationDialog(
                "Delete \(name)?",
                isPresented: $showingDeleteConfirmation,
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) {
                    modelContext.delete(ingredient)
                    try? modelContext.save()
                    dismiss()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This cannot be undone.")
            }
        }
    }

    private func saveChanges() {
        guard !name.isEmpty else {
            errorMessage = "Please enter an ingredient name"
            return
        }

        let newName = name.titleCased()

        // Merge only when name + unit + container size all match exactly (excluding self).
        // Different container sizes (e.g. 12.5 oz can vs 6 oz can) stay as separate entries.
        let containerSizeUnitRaw = containerSize > 0 ? containerSizeUnit.rawValue : ""
        if let existing = allIngredients.first(where: {
            $0.id != ingredient.id &&
            $0.name.lowercased() == newName.lowercased() &&
            $0.quantityUnit == unit.rawValue &&
            $0.containerSize == containerSize &&
            $0.containerSizeUnit == containerSizeUnitRaw
        }) {
            // Merge: add this ingredient's amount into the existing one, then delete this one
            existing.quantityAmount += amount
            modelContext.delete(ingredient)
        } else {
            // No conflict — just update in place
            ingredient.name = newName
            ingredient.quantityAmount = amount
            ingredient.quantityUnit = unit.rawValue
            ingredient.category = selectedCategory
            ingredient.containerSize = containerSize
            ingredient.containerSizeUnit = containerSize > 0 ? containerSizeUnit.rawValue : ""
        }

        try? modelContext.save()
        dismiss()
    }
}

// MARK: - Category Grid Picker
// Extracted into its own view to prevent Swift type-checker timeout
struct CategoryGridPicker: View {
    @Binding var selectedCategory: IngredientCategory

    let columns = Array(repeating: GridItem(.flexible()), count: 3)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(IngredientCategory.orderedCases, id: \.self) { category in
                categoryButton(for: category)
            }
        }
    }

    private func categoryButton(for category: IngredientCategory) -> some View {
        Button {
            selectedCategory = category
        } label: {
            VStack(spacing: 6) {
                Text(category.emoji)
                    .font(.system(size: 24))
                Text(category.rawValue)
                    .font(.system(.caption2, design: .rounded, weight: .medium))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(selectedCategory == category
                          ? Color("AccentSage")
                          : Color("CardBackground"))
            )
            .foregroundStyle(selectedCategory == category
                             ? .white
                             : Color("TextSecondary"))
        }
        .buttonStyle(.plain)
    }
}
