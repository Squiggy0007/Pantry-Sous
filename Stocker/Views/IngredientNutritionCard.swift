import SwiftUI
import SwiftData

// MARK: - Ingredient Info Sheet

/// Full-screen sheet opened by tapping the ⓘ button on an IngredientCardView.
/// Shows nutritional facts, allergens, and ingredient list for barcode-scanned products.
struct IngredientInfoSheet: View {
    let ingredient: Ingredient
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var barcodeMemories: [BarcodeMemory]
    /// True when the saved ingredient has macros but no carbs — stored before the
    /// Int/Double JSON fix. We patch it silently from BarcodeMemory on appear.
    private var isStaleNutrition: Bool {
        (ingredient.fat > 0 || ingredient.protein > 0) && ingredient.carbs == 0
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundPrimary").ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {

                        // Ingredient hero row
                        HStack(spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(Color("AccentSage").opacity(0.15))
                                    .frame(width: 56, height: 56)
                                Text(ingredient.category.emoji)
                                    .font(.system(size: 26))
                            }
                            VStack(alignment: .leading, spacing: 4) {
                                Text(ingredient.name)
                                    .font(.system(.title3, design: .rounded, weight: .bold))
                                    .foregroundStyle(Color("TextPrimary"))
                                Text(ingredient.displayQuantity)
                                    .font(.system(.subheadline, design: .rounded))
                                    .foregroundStyle(Color("TextSecondary"))
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)


                        // Nutrition card or empty state
                        if ingredient.hasNutritionData {
                            IngredientNutritionCard(
                                servingSize:    ingredient.servingSize,
                                calories:       ingredient.calories,
                                protein:        ingredient.protein,
                                carbs:          ingredient.carbs,
                                fat:            ingredient.fat,
                                saturatedFat:   ingredient.saturatedFat,
                                transFat:       ingredient.transFat,
                                fiber:          ingredient.fiber,
                                sugar:          ingredient.sugar,
                                sodium:         ingredient.sodium,
                                cholesterol:    ingredient.cholesterol,
                                allergens:      ingredient.allergensList,
                                ingredientsList: ingredient.ingredientsList
                            )
                            .padding(.horizontal, 16)
                        } else {
                            VStack(spacing: 12) {
                                Image(systemName: "chart.bar.doc.horizontal")
                                    .font(.system(size: 36))
                                    .foregroundStyle(Color("AccentSage").opacity(0.4))
                                Text("No nutrition info available")
                                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                                    .foregroundStyle(Color("TextSecondary"))
                                Text("Scan the product barcode in the Ingredients tab to load nutrition facts.")
                                    .font(.system(.caption, design: .rounded))
                                    .foregroundStyle(Color("TextSecondary").opacity(0.7))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 24)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 40)
                        }
                    }
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("Ingredient Info")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.system(.body, design: .rounded, weight: .semibold))
                        .foregroundStyle(Color("AccentSage"))
                }
            }
            // Silently patch stale/incomplete ingredient nutrition from BarcodeMemory + keyword scan.
            .onAppear {
                let barcode = ingredient.barcode ?? ""
                let memory = barcodeMemories.first(where: { $0.barcode == barcode && !barcode.isEmpty })
                    ?? barcodeMemories.first(where: { $0.productName.lowercased() == ingredient.name.lowercased() })

                // Backfill full nutrition from cache when macros were saved without carbs
                if isStaleNutrition, let m = memory, m.carbs > 0 {
                    ingredient.servingSize     = m.servingSize
                    ingredient.calories        = m.calories
                    ingredient.protein         = m.protein
                    ingredient.carbs           = m.carbs
                    ingredient.fat             = m.fat
                    ingredient.saturatedFat    = m.saturatedFat
                    ingredient.transFat        = m.transFat
                    ingredient.fiber           = m.fiber
                    ingredient.sugar           = m.sugar
                    ingredient.sodium          = m.sodium
                    ingredient.cholesterol     = m.cholesterol
                    ingredient.allergensList   = m.allergensList
                    ingredient.ingredientsList = m.ingredientsList
                    try? modelContext.save()
                    return
                }

                // Re-derive allergens from ingredients text when the saved list is empty
                // but we have ingredient text (handles products scanned before allergen scan was added)
                if ingredient.allergensList.isEmpty && !ingredient.ingredientsList.isEmpty {
                    let derived = USDANutritionService.extractAllergens(from: ingredient.ingredientsList)
                    if !derived.isEmpty {
                        ingredient.allergensList = derived
                        try? modelContext.save()
                    }
                }
            }
        }
    }
}

// MARK: - Edit Nutrition Sheet

/// Lets users manually fill in or correct nutrition values from the physical product box.
struct EditNutritionSheet: View {
    let ingredient: Ingredient
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    // Local editable state — pre-filled from current ingredient values
    @State private var servingSize: String = ""
    @State private var calories: String = ""
    @State private var totalFat: String = ""
    @State private var saturatedFat: String = ""
    @State private var transFat: String = ""
    @State private var cholesterol: String = ""
    @State private var sodium: String = ""
    @State private var totalCarbs: String = ""
    @State private var fiber: String = ""
    @State private var sugar: String = ""
    @State private var protein: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundPrimary").ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 0) {

                        // Header hint
                        HStack(spacing: 8) {
                            Image(systemName: "info.circle")
                                .font(.system(size: 13))
                            Text("Enter values from the Nutrition Facts label on the product box.")
                                .font(.system(.caption, design: .rounded))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .foregroundStyle(Color("AccentSage"))
                        .padding(14)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color("AccentSage").opacity(0.08)))
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                        .padding(.bottom, 20)

                        // Serving size
                        sectionHeader("Serving")
                        nutritionRow(label: "Serving Size", placeholder: "e.g. 26 crackers (30g)", value: $servingSize, isText: true)
                        divider()
                        nutritionRow(label: "Calories", placeholder: "0", value: $calories, unit: "")
                        sectionDivider()

                        // Fats
                        sectionHeader("Fats")
                        nutritionRow(label: "Total Fat", placeholder: "0", value: $totalFat, unit: "g")
                        divider()
                        nutritionRow(label: "Saturated Fat", placeholder: "0", value: $saturatedFat, unit: "g", indented: true)
                        divider()
                        nutritionRow(label: "Trans Fat", placeholder: "0", value: $transFat, unit: "g", indented: true)
                        sectionDivider()

                        // Other minerals
                        sectionHeader("Other")
                        nutritionRow(label: "Cholesterol", placeholder: "0", value: $cholesterol, unit: "mg")
                        divider()
                        nutritionRow(label: "Sodium", placeholder: "0", value: $sodium, unit: "mg")
                        sectionDivider()

                        // Carbs
                        sectionHeader("Carbohydrates")
                        nutritionRow(label: "Total Carbohydrate", placeholder: "0", value: $totalCarbs, unit: "g")
                        divider()
                        nutritionRow(label: "Dietary Fiber", placeholder: "0", value: $fiber, unit: "g", indented: true)
                        divider()
                        nutritionRow(label: "Total Sugars", placeholder: "0", value: $sugar, unit: "g", indented: true)
                        sectionDivider()

                        // Protein
                        sectionHeader("Protein")
                        nutritionRow(label: "Protein", placeholder: "0", value: $protein, unit: "g")

                        Color.clear.frame(height: 40)
                    }
                }
            }
            .navigationTitle("Edit Nutrition")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(Color("AccentSage"))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveChanges()
                        dismiss()
                    }
                    .font(.system(.body, design: .rounded, weight: .semibold))
                    .foregroundStyle(Color("AccentSage"))
                }
            }
            .onAppear { populateFields() }
        }
    }

    // MARK: - Row builders

    @ViewBuilder
    private func sectionHeader(_ title: String) -> some View {
        Text(title.uppercased())
            .font(.system(.caption2, design: .rounded, weight: .semibold))
            .foregroundStyle(Color("TextSecondary"))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 14)
            .padding(.bottom, 4)
    }

    @ViewBuilder
    private func nutritionRow(label: String, placeholder: String, value: Binding<String>, unit: String = "", isText: Bool = false, indented: Bool = false) -> some View {
        HStack {
            Text(label)
                .font(.system(.subheadline, design: .rounded, weight: indented ? .regular : .medium))
                .foregroundStyle(Color("TextPrimary"))
                .padding(.leading, indented ? 28 : 0)
            Spacer()
            HStack(spacing: 4) {
                TextField(placeholder, text: value)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(Color("TextPrimary"))
                    .keyboardType(isText ? .default : .decimalPad)
                    .multilineTextAlignment(.trailing)
                    .frame(width: isText ? 180 : 60)
                if !unit.isEmpty {
                    Text(unit)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(Color("TextSecondary"))
                        .frame(width: 24, alignment: .leading)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 13)
        .background(Color("CardBackground"))
    }

    @ViewBuilder
    private func divider() -> some View {
        Divider().padding(.leading, 20)
    }

    @ViewBuilder
    private func sectionDivider() -> some View {
        Color.clear.frame(height: 8)
    }

    // MARK: - Logic

    private func populateFields() {
        servingSize  = ingredient.servingSize
        calories     = ingredient.calories    > 0 ? format(ingredient.calories)    : ""
        totalFat     = ingredient.fat         > 0 ? format(ingredient.fat)         : ""
        saturatedFat = ingredient.saturatedFat > 0 ? format(ingredient.saturatedFat) : ""
        transFat     = ingredient.transFat    > 0 ? format(ingredient.transFat)    : ""
        cholesterol  = ingredient.cholesterol > 0 ? format(ingredient.cholesterol) : ""
        sodium       = ingredient.sodium      > 0 ? format(ingredient.sodium)      : ""
        totalCarbs   = ingredient.carbs       > 0 ? format(ingredient.carbs)       : ""
        fiber        = ingredient.fiber       > 0 ? format(ingredient.fiber)       : ""
        sugar        = ingredient.sugar       > 0 ? format(ingredient.sugar)       : ""
        protein      = ingredient.protein     > 0 ? format(ingredient.protein)     : ""
    }

    private func format(_ v: Double) -> String {
        v.truncatingRemainder(dividingBy: 1) == 0 ? "\(Int(v))" : String(format: "%.1f", v)
    }

    private func saveChanges() {
        HapticFeedback.success()
        ingredient.servingSize    = servingSize
        ingredient.calories       = Double(calories)     ?? ingredient.calories
        ingredient.fat            = Double(totalFat)     ?? ingredient.fat
        ingredient.saturatedFat   = Double(saturatedFat) ?? ingredient.saturatedFat
        ingredient.transFat       = Double(transFat)     ?? ingredient.transFat
        ingredient.cholesterol    = Double(cholesterol)  ?? ingredient.cholesterol
        ingredient.sodium         = Double(sodium)       ?? ingredient.sodium
        ingredient.carbs          = Double(totalCarbs)   ?? ingredient.carbs
        ingredient.fiber          = Double(fiber)        ?? ingredient.fiber
        ingredient.sugar          = Double(sugar)        ?? ingredient.sugar
        ingredient.protein        = Double(protein)      ?? ingredient.protein
        try? modelContext.save()
    }
}

// MARK: - Nutrition Data Transfer Object
// Used to pass nutrition data around before it's saved to an Ingredient model.
struct NutritionData {
    var servingSize: String = ""
    var calories: Double = 0
    var protein: Double = 0
    var carbs: Double = 0
    var fat: Double = 0
    var saturatedFat: Double = 0
    var transFat: Double = 0
    var fiber: Double = 0
    var sugar: Double = 0
    var sodium: Double = 0
    var cholesterol: Double = 0
    var allergensList: [String] = []
    var ingredientsList: String = ""

    var hasData: Bool {
        calories > 0 || protein > 0 || carbs > 0 || fat > 0
    }
}

// MARK: - Ingredient Nutrition Card

struct IngredientNutritionCard: View {
    let servingSize: String
    let calories: Double
    let protein: Double
    let carbs: Double
    let fat: Double
    let saturatedFat: Double
    let transFat: Double
    let fiber: Double
    let sugar: Double
    let sodium: Double
    let cholesterol: Double
    let allergens: [String]
    let ingredientsList: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // ── "Nutrition Facts" header ──────────────────────────────
            VStack(alignment: .leading, spacing: 2) {
                Text("Nutrition Facts")
                    .font(.system(size: 26, weight: .black, design: .default))
                    .foregroundStyle(Color("TextPrimary"))
                if !servingSize.isEmpty {
                    Text("Serving size  \(servingSize)")
                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                        .foregroundStyle(Color("TextPrimary"))
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, 8)

            // Thick top rule
            Rectangle()
                .fill(Color("TextPrimary"))
                .frame(height: 8)
                .padding(.horizontal, 16)

            // ── Amount per serving + Calories ─────────────────────────
            if calories > 0 {
                Text("Amount per serving")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(Color("TextSecondary"))
                    .padding(.horizontal, 16)
                    .padding(.top, 4)

                HStack(alignment: .firstTextBaseline) {
                    Text("Calories")
                        .font(.system(size: 22, weight: .black, design: .default))
                        .foregroundStyle(Color("TextPrimary"))
                    Spacer()
                    Text("\(Int(calories.rounded()))")
                        .font(.system(size: 42, weight: .black, design: .default))
                        .foregroundStyle(Color("TextPrimary"))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 4)

                // Thick rule after calories
                Rectangle()
                    .fill(Color("TextPrimary"))
                    .frame(height: 5)
                    .padding(.horizontal, 16)

                // % Daily Value* label
                Text("% Daily Value*")
                    .font(.system(.caption2, design: .rounded, weight: .semibold))
                    .foregroundStyle(Color("TextSecondary"))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal, 16)
                    .padding(.top, 4)

                thinDivider()
            }

            // ── Macros — FDA label order ──────────────────────────────
            // FDA requires Trans Fat, Cholesterol, and Total Sugars to always
            // appear on the label — even when the value is 0g / 0mg.

            if fat > 0 {
                labelRow(bold: "Total Fat", regular: nil, value: fat, unit: "g")
                if saturatedFat > 0 {
                    indentRow(label: "Saturated Fat", value: saturatedFat, unit: "g")
                    thinDivider()
                }
                // Trans Fat: always show (FDA required, often 0g)
                indentRow(label: "Trans Fat", value: transFat, unit: "g")
                thinDivider()
            }
            // Cholesterol: always show when we have macro data
            if fat > 0 || carbs > 0 || protein > 0 {
                labelRow(bold: "Cholesterol", regular: nil, value: cholesterol, unit: "mg")
                thinDivider()
            }
            if sodium > 0 {
                labelRow(bold: "Sodium", regular: nil, value: sodium, unit: "mg")
                thinDivider()
            }
            if carbs > 0 {
                labelRow(bold: "Total Carbohydrate", regular: nil, value: carbs, unit: "g")
                if fiber > 0 {
                    indentRow(label: "Dietary Fiber", value: fiber, unit: "g")
                    thinDivider()
                }
                // Total Sugars: always show (FDA required, often 0g for crackers)
                indentRow(label: "Total Sugars", value: sugar, unit: "g")
                thinDivider()
            }
            if protein > 0 {
                labelRow(bold: "Protein", regular: nil, value: protein, unit: "g")
                thinDivider()
            }

            // ── Allergens ─────────────────────────────────────────────
            if !allergens.isEmpty {
                Rectangle()
                    .fill(Color("TextPrimary"))
                    .frame(height: 5)
                    .padding(.horizontal, 16)

                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 5) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 11))
                            .foregroundStyle(Color("DestructiveTerracotta"))
                        Text("Contains")
                            .font(.system(.caption, design: .rounded, weight: .semibold))
                            .foregroundStyle(Color("DestructiveTerracotta"))
                    }
                    FlowLayout(spacing: 6) {
                        ForEach(allergens, id: \.self) { allergen in
                            Text(allergen)
                                .font(.system(.caption2, design: .rounded, weight: .semibold))
                                .foregroundStyle(Color("DestructiveTerracotta"))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(Color("DestructiveTerracotta").opacity(0.12))
                                )
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
            }

            // ── Ingredients list (always shown) ───────────────────────
            if !ingredientsList.isEmpty {
                Rectangle()
                    .fill(Color("TextPrimary"))
                    .frame(height: 3)
                    .padding(.horizontal, 16)

                HStack(spacing: 6) {
                    Image(systemName: "list.bullet")
                        .font(.system(size: 12))
                    Text("Ingredients")
                        .font(.system(.caption, design: .rounded, weight: .semibold))
                }
                .foregroundStyle(Color("AccentSage"))
                .padding(.horizontal, 16)
                .padding(.top, 10)
                .padding(.bottom, 4)

                Text(ingredientsList)
                    .font(.system(.caption2, design: .rounded))
                    .foregroundStyle(Color("TextSecondary"))
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
            }

            Color.clear.frame(height: 8)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("CardBackground"))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }

    // MARK: - Row builders

    private func labelRow(bold: String, regular: String?, value: Double, unit: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            HStack(spacing: 0) {
                Text(bold)
                    .font(.system(.subheadline, design: .rounded, weight: .bold))
                    .foregroundStyle(Color("TextPrimary"))
                if let reg = regular {
                    Text(" \(reg)")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(Color("TextPrimary"))
                }
            }
            Spacer()
            Text(formatValue(value, unit: unit))
                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                .foregroundStyle(Color("TextPrimary"))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
    }

    private func indentRow(label: String, value: Double, unit: String) -> some View {
        HStack {
            Text(label)
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(Color("TextSecondary"))
                .padding(.leading, 20)
            Spacer()
            Text(formatValue(value, unit: unit))
                .font(.system(.caption, design: .rounded, weight: .medium))
                .foregroundStyle(Color("TextPrimary"))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 5)
    }

    private func thinDivider() -> some View {
        Divider()
            .padding(.horizontal, 16)
    }

    private func formatValue(_ value: Double, unit: String) -> String {
        let n = unit == "mg"
            ? "\(Int(value.rounded()))"
            : (value.truncatingRemainder(dividingBy: 1) == 0
               ? "\(Int(value))"
               : String(format: "%.1f", value))
        return "\(n)\(unit)"
    }
}

// MARK: - Flow Layout (wrapping HStack for allergen chips)

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var x: CGFloat = 0
        var y: CGFloat = 0
        var lineHeight: CGFloat = 0
        var totalHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth && x > 0 {
                y += lineHeight + spacing
                x = 0
                lineHeight = 0
            }
            x += size.width + spacing
            lineHeight = max(lineHeight, size.height)
            totalHeight = y + lineHeight
        }
        return CGSize(width: maxWidth, height: totalHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) {
        var x = bounds.minX
        var y = bounds.minY
        var lineHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX && x > bounds.minX {
                y += lineHeight + spacing
                x = bounds.minX
                lineHeight = 0
            }
            subview.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            lineHeight = max(lineHeight, size.height)
        }
    }
}
