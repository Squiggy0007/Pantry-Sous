import SwiftUI
import SwiftData
import PhotosUI

struct CustomRecipeDetailView: View {
    let recipe: CustomRecipe
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var allIngredients: [Ingredient]

    @Query private var shoppingItems: [ShoppingItem]
    @ObservedObject private var staplesManager = PantryStaplesManager.shared
    @State private var showingEditSheet = false
    @State private var showingDeleteConfirm = false
    @State private var showingShareSheet = false
    @State private var showingMadeDishSheet = false
    @State private var shareText = ""
    @State private var toastVisible = false
    @State private var toastMessage = ""
    @State private var servingScale: Double = 1.0
    @State private var calculatedNutrition: NutritionData? = nil
    @State private var isCalculatingNutrition = false
    @State private var nutritionError: String? = nil

    var inventoryNames: [String] { allIngredients.map { $0.name } }

    var nonStapleIngredients: [String] {
        recipe.ingredients.filter { line in
            !staplesManager.isActiveStaple(extractName(line))
        }
    }

    var stapleIngredients: [String] {
        recipe.ingredients.filter { line in
            staplesManager.isActiveStaple(extractName(line))
        }
    }

    var matchedCount: Int {
        nonStapleIngredients.filter { line in
            let name = extractName(line)
            return !name.isEmpty && IngredientNormalizer.matches(name, against: inventoryNames)
        }.count
    }

    var matchPercent: Int {
        guard !nonStapleIngredients.isEmpty else { return 100 }
        return Int(Double(matchedCount) / Double(nonStapleIngredients.count) * 100)
    }

    var missingNonStapleLines: [String] {
        nonStapleIngredients.filter { line in
            let name = extractName(line)
            return !name.isEmpty && !IngredientNormalizer.matches(name, against: inventoryNames)
        }
    }

    private var recipeDetailForMadeDish: RecipeDetail {
        let extended: [ExtendedIngredient] = recipe.ingredients.enumerated().map { idx, line in
            let name = extractName(line)
            let (amount, unit) = parseAmountAndUnit(from: line)
            return ExtendedIngredient(id: idx, name: name, original: line, amount: amount, unit: unit)
        }
        return RecipeDetail(
            id: recipe.id.hashValue,
            title: recipe.title,
            image: "",
            readyInMinutes: recipe.readyInMinutes,
            servings: recipe.servings,
            extendedIngredients: extended,
            aggregateLikes: nil,
            spoonacularScore: nil,
            analyzedInstructions: []
        )
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color("BackgroundPrimary").ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {

                        // Hero photo (if available)
                        if let imageData = recipe.imageData, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 220)
                                .clipped()
                        }

                        // Header card
                        VStack(alignment: .leading, spacing: 14) {
                            HStack(spacing: 10) {
                                Text(recipe.mealCategory.emoji)
                                    .font(.system(size: 28))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(recipe.title)
                                        .font(.system(.title2, design: .rounded, weight: .bold))
                                        .foregroundStyle(Color("TextPrimary"))
                                    Text(recipe.mealCategory.rawValue)
                                        .font(.system(.caption, design: .rounded))
                                        .foregroundStyle(Color("TextSecondary"))
                                }
                                Spacer()
                            }

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    StatPillView(icon: "clock", value: "\(recipe.readyInMinutes) min")

                                    // Interactive servings stepper
                                    HStack(spacing: 0) {
                                        Button {
                                            HapticFeedback.light()
                                            if servingScale > 1 {
                                                servingScale -= 1
                                            } else if servingScale == 1.0 {
                                                servingScale = 0.5
                                            }
                                        } label: {
                                            Image(systemName: "minus")
                                                .font(.system(size: 11, weight: .semibold))
                                                .frame(width: 28, height: 30)
                                        }
                                        .disabled(servingScale <= 0.5)
                                        Text(servingScale == 0.5 ? "½×" : "\(Int(servingScale))×")
                                            .font(.system(.subheadline, design: .rounded, weight: .medium))
                                            .lineLimit(1)
                                            .fixedSize(horizontal: true, vertical: false)
                                            .frame(minWidth: 32)
                                        Button {
                                            HapticFeedback.light()
                                            if servingScale < 1 {
                                                servingScale = 1.0
                                            } else if servingScale < 4 {
                                                servingScale += 1
                                            }
                                        } label: {
                                            Image(systemName: "plus")
                                                .font(.system(size: 11, weight: .semibold))
                                                .frame(width: 28, height: 30)
                                        }
                                        .disabled(servingScale >= 4)
                                    }
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color("BackgroundSecondary"))
                                    )
                                    .foregroundStyle(Color("TextSecondary"))

                                    HStack(spacing: 4) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 11))
                                            .foregroundStyle(Color("AccentSage"))
                                        Text("\(matchPercent)% match")
                                            .font(.system(.caption, design: .rounded, weight: .semibold))
                                            .foregroundStyle(Color("AccentSage"))
                                            .lineLimit(1)
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color("AccentSage").opacity(0.12))
                                    )

                                    if recipe.isPrivate {
                                        HStack(spacing: 4) {
                                            Image(systemName: "lock.fill")
                                                .font(.system(size: 11))
                                            Text("Private")
                                                .font(.system(.caption, design: .rounded, weight: .semibold))
                                                .lineLimit(1)
                                        }
                                        .foregroundStyle(Color("TextSecondary"))
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color("BackgroundSecondary"))
                                        )
                                    }
                                }
                            }
                        }
                        .padding(20)
                        .background(Color("CardBackground"))

                        VStack(alignment: .leading, spacing: 20) {

                            Divider()

                            // Ingredients
                            VStack(alignment: .leading, spacing: 14) {
                                Text("Ingredients")
                                    .font(.system(.title3, design: .rounded, weight: .bold))
                                    .foregroundStyle(Color("TextPrimary"))

                                ForEach(nonStapleIngredients, id: \.self) { line in
                                    let name = extractName(line)
                                    let isOwned = !name.isEmpty && IngredientNormalizer.matches(name, against: inventoryNames)

                                    HStack(spacing: 12) {
                                        Image(systemName: isOwned ? "checkmark.circle.fill" : "circle")
                                            .font(.system(size: 18))
                                            .foregroundStyle(isOwned ? Color("AccentSage") : Color("DestructiveTerracotta"))
                                        Text(scaledLine(line))
                                            .font(.system(.body, design: .rounded))
                                            .foregroundStyle(isOwned ? Color("TextPrimary") : Color("TextSecondary"))
                                        Spacer()
                                    }
                                    .padding(.vertical, 4)
                                }

                                // Staples
                                if !stapleIngredients.isEmpty {
                                    Divider().padding(.vertical, 4)
                                    HStack(spacing: 6) {
                                        Image(systemName: "cabinet.fill")
                                            .font(.system(size: 12))
                                        Text("Pantry Staples")
                                            .font(.system(.caption, design: .rounded, weight: .semibold))
                                    }
                                    .foregroundStyle(Color("TextSecondary"))

                                    ForEach(stapleIngredients, id: \.self) { line in
                                        HStack(spacing: 12) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .font(.system(size: 18))
                                                .foregroundStyle(Color("AccentSage").opacity(0.5))
                                            Text(line)
                                                .font(.system(.body, design: .rounded))
                                                .foregroundStyle(Color("TextPrimary").opacity(0.6))
                                            Spacer()
                                        }
                                        .padding(.vertical, 4)
                                    }
                                }
                            }

                            // Action buttons
                            VStack(spacing: 12) {
                                if !missingNonStapleLines.isEmpty {
                                    Button {
                                        HapticFeedback.success()
                                        addMissingToShoppingList()
                                    } label: {
                                        HStack(spacing: 8) {
                                            Image(systemName: "cart.badge.plus")
                                            Text("Add Missing to Shopping List")
                                                .font(.system(.body, design: .rounded, weight: .semibold))
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 14)
                                        .background(
                                            RoundedRectangle(cornerRadius: 14)
                                                .fill(Color("DestructiveTerracotta").opacity(0.1))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 14)
                                                        .stroke(Color("DestructiveTerracotta"), lineWidth: 1.5)
                                                )
                                        )
                                        .foregroundStyle(Color("DestructiveTerracotta"))
                                    }
                                }

                                Button {
                                    HapticFeedback.medium()
                                    showingMadeDishSheet = true
                                } label: {
                                    HStack(spacing: 8) {
                                        Image(systemName: "checkmark.seal")
                                        Text("Made This Dish")
                                            .font(.system(.body, design: .rounded, weight: .semibold))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(Color("BackgroundSecondary"))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 14)
                                                    .stroke(Color("AccentSage"), lineWidth: 1.5)
                                            )
                                    )
                                    .foregroundStyle(Color("AccentSage"))
                                }
                            }

                            Divider()

                            // Instructions
                            if !recipe.steps.isEmpty {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Instructions")
                                        .font(.system(.title3, design: .rounded, weight: .bold))
                                        .foregroundStyle(Color("TextPrimary"))

                                    ForEach(recipe.steps.indices, id: \.self) { idx in
                                        InstructionStepView(
                                            number: idx + 1,
                                            text: recipe.steps[idx]
                                        )
                                    }
                                }
                            }

                            // Notes
                            if !recipe.notes.isEmpty {
                                Divider()
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "note.text")
                                            .font(.system(size: 14))
                                        Text("Notes")
                                            .font(.system(.headline, design: .rounded, weight: .bold))
                                    }
                                    .foregroundStyle(Color("TextPrimary"))
                                    Text(recipe.notes)
                                        .font(.system(.body, design: .rounded))
                                        .foregroundStyle(Color("TextSecondary"))
                                }
                            }

                            // Nutrition section
                            Divider()
                            nutritionSection
                        }
                        .padding(20)
                        .padding(.bottom, 40)
                    }
                }
                // Toast
                if toastVisible {
                    Text(toastMessage)
                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(
                            Capsule()
                                .fill(Color("AccentSage"))
                                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                        )
                        .padding(.bottom, 20)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear { calculateNutrition() }
            .onChange(of: showingEditSheet) { _, isShowing in
                if !isShowing { calculateNutrition() }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(Color("TextSecondary"))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 12) {
                        Button { prepareShare() } label: {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(Color("AccentSage"))
                        }
                        Button { showingEditSheet = true } label: {
                            Image(systemName: "pencil.circle.fill")
                                .font(.system(size: 20))
                                .foregroundStyle(Color("AccentSage"))
                        }
                        Button { showingDeleteConfirm = true } label: {
                            Image(systemName: "trash.circle.fill")
                                .font(.system(size: 20))
                                .foregroundStyle(Color("DestructiveTerracotta"))
                        }
                    }
                }
            }
            .sheet(isPresented: $showingEditSheet) {
                EditCustomRecipeView(recipe: recipe)
            }
            .sheet(isPresented: $showingShareSheet) {
                ShareSheet(text: shareText)
            }
            .sheet(isPresented: $showingMadeDishSheet) {
                MadeDishSheet(
                    detail: recipeDetailForMadeDish,
                    allIngredients: allIngredients,
                    onConfirm: { deductions in
                        applyMadeDish(deductions: deductions)
                    }
                )
            }
            .confirmationDialog("Delete Recipe", isPresented: $showingDeleteConfirm, titleVisibility: .visible) {
                Button("Delete", role: .destructive) {
                    modelContext.delete(recipe)
                    try? modelContext.save()
                    dismiss()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will permanently delete \"\(recipe.title)\".")
            }
        }
    }

    // MARK: - Nutrition Section

    @ViewBuilder
    private var nutritionSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Text("Nutrition")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundStyle(Color("TextPrimary"))
                Spacer()
                if isCalculatingNutrition {
                    ProgressView().scaleEffect(0.75)
                }
            }

            if let nutrition = calculatedNutrition, nutrition.hasData {
                Text("Per serving · \(recipe.servings) servings")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(Color("TextSecondary"))

                HStack(spacing: 0) {
                    NutrientPillView(label: "Calories", value: "\(Int(nutrition.calories))", unit: "")
                    Divider().frame(height: 32)
                    NutrientPillView(label: "Protein", value: String(format: "%.0f", nutrition.protein), unit: "g")
                    Divider().frame(height: 32)
                    NutrientPillView(label: "Carbs", value: String(format: "%.0f", nutrition.carbs), unit: "g")
                    Divider().frame(height: 32)
                    NutrientPillView(label: "Fat", value: String(format: "%.0f", nutrition.fat), unit: "g")
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color("BackgroundSecondary"))
                )

            } else if let error = nutritionError {
                Text(error)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(Color("DestructiveTerracotta"))

            } else if !isCalculatingNutrition {
                Text("Add ingredients to see nutrition estimates.")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(Color("TextSecondary"))
            }
        }
    }

    private func calculateNutrition() {
        guard !isCalculatingNutrition else { return }
        guard !recipe.ingredients.isEmpty else { return }
        isCalculatingNutrition = true
        nutritionError = nil
        calculatedNutrition = nil

        Task {
            do {
                let result = try await SpoonacularService.shared.analyzeCustomRecipeNutrition(
                    title: recipe.title,
                    ingredients: recipe.ingredients,
                    servings: max(1, recipe.servings)
                )
                await MainActor.run {
                    if result.hasData {
                        calculatedNutrition = result
                    } else {
                        nutritionError = "Couldn't estimate nutrition — try adding more ingredient details."
                    }
                    isCalculatingNutrition = false
                }
            } catch {
                await MainActor.run {
                    nutritionError = "Couldn't fetch nutrition. Check your connection and try again."
                    isCalculatingNutrition = false
                }
            }
        }
    }

    private func addMissingToShoppingList() {
        var addedCount = 0
        for line in recipe.ingredients {
            let name = extractName(line)
            guard !name.isEmpty else { continue }
            guard !staplesManager.isActiveStaple(name) else { continue }
            guard !IngredientNormalizer.matches(name, against: inventoryNames) else { continue }

            let (amount, unitString) = parseAmountAndUnit(from: line)
            let (resolvedAmount, resolvedUnit) = UnitConversionHelper.resolveShoppingQuantity(
                ingredientName: name,
                amount: amount ?? 1,
                unitString: unitString ?? ""
            )

            if let existing = shoppingItems.first(where: {
                $0.name.lowercased() == name.lowercased() && !$0.isPurchased
            }) {
                existing.quantityAmount += resolvedAmount
            } else {
                let item = ShoppingItem(
                    name: name.titleCased(),
                    quantityAmount: resolvedAmount,
                    quantityUnit: resolvedUnit,
                    category: IngredientCategory.suggested(for: name)
                )
                modelContext.insert(item)
                addedCount += 1
            }
        }
        try? modelContext.save()
        displayToast(addedCount > 0
            ? "\(addedCount) item\(addedCount == 1 ? "" : "s") added to shopping list"
            : "All items already on your list")
    }

    private func applyMadeDish(deductions: [IngredientDeduction]) {
        // Match opened/partial containers first (same order MadeDishSheet used)
        let sortedIngredients = allIngredients.sorted {
            let a = $0.containerSize > 0 ? $0.containerSize : Double.infinity
            let b = $1.containerSize > 0 ? $1.containerSize : Double.infinity
            return a < b
        }
        for deduction in deductions where deduction.canDeduct {
            if let item = sortedIngredients.first(where: {
                IngredientNormalizer.matches(deduction.ingredientName, against: [$0.name])
            }) {
                item.quantityAmount = deduction.resultAmount
            }
        }
        try? modelContext.save()
        HapticFeedback.success()
    }

    private func displayToast(_ message: String) {
        toastMessage = message
        withAnimation(.spring(response: 0.3)) { toastVisible = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.spring(response: 0.3)) { toastVisible = false }
        }
    }

    private func parseAmountAndUnit(from line: String) -> (Double?, String?) {
        let words = line.trimmingCharacters(in: .whitespaces)
            .components(separatedBy: " ").filter { !$0.isEmpty }
        guard !words.isEmpty else { return (nil, nil) }
        var idx = 0
        var amount: Double? = nil
        let first = words[idx]
        if let d = Double(first) { amount = d; idx += 1 }
        else if first.contains("/"), let frac = parseFraction(first) { amount = frac; idx += 1 }
        if amount != nil, idx < words.count {
            let second = words[idx]
            if second.contains("/"), let frac = parseFraction(second) { amount = (amount ?? 0) + frac; idx += 1 }
        }
        let unitWords: Set<String> = [
            "cup","cups","tsp","tbsp","oz","lbs","lb","g","kg",
            "pint","pints","quart","quarts","gallon","gallons",
            "can","cans","jar","jars","bag","bags","box","boxes",
            "bottle","bottles","package","packages","packet","packets",
            "ml","l","cloves","clove","slices","slice","pieces","piece",
            "sprigs","sprig","whole","large","medium","small"
        ]
        let unit: String? = idx < words.count && unitWords.contains(words[idx].lowercased()) ? words[idx] : nil
        return (amount, unit)
    }

    private func parseFraction(_ s: String) -> Double? {
        let parts = s.split(separator: "/")
        guard parts.count == 2, let n = Double(parts[0]), let d = Double(parts[1]), d != 0 else { return nil }
        return n / d
    }

    private func prepareShare() {
        var text = "🍽️ \(recipe.title)\n"
        text += "⏱️ \(recipe.readyInMinutes) min | 👤 \(recipe.servings) servings\n\n"
        text += "📝 INGREDIENTS\n"
        for line in recipe.ingredients { text += "• \(line)\n" }
        if !recipe.steps.isEmpty {
            text += "\n👨‍🍳 INSTRUCTIONS\n"
            for (i, step) in recipe.steps.enumerated() { text += "\(i+1). \(step)\n" }
        }
        if !recipe.notes.isEmpty { text += "\n📌 NOTES\n\(recipe.notes)\n" }
        text += "\nShared from Pantry Sous 🛒"
        shareText = text
        showingShareSheet = true
    }

    private func extractName(_ line: String) -> String {
        IngredientNormalizer.extractIngredientName(line)
    }

    // MARK: - Scaling Helpers

    /// Returns the ingredient line with the leading amount scaled by `servingScale`.
    private func scaledLine(_ line: String) -> String {
        guard servingScale != 1.0 else { return line }
        let words = line.trimmingCharacters(in: .whitespaces)
            .components(separatedBy: " ").filter { !$0.isEmpty }
        guard !words.isEmpty else { return line }

        var idx = 0
        var amount: Double? = nil

        let first = words[idx]
        if let d = Double(first) {
            amount = d; idx += 1
        } else if first.contains("/"), let frac = parseFraction(first) {
            amount = frac; idx += 1
        }
        // Mixed number e.g. "1 1/2"
        if let a = amount, idx < words.count {
            let second = words[idx]
            if second.contains("/"), let frac = parseFraction(second) {
                amount = a + frac; idx += 1
            }
        }

        guard let baseAmount = amount else { return line }
        let scaled = baseAmount * servingScale
        let rest = words[idx...].joined(separator: " ")
        let formattedAmount = scaled.toFractionString()
        return rest.isEmpty ? formattedAmount : "\(formattedAmount) \(rest)"
    }
}

// MARK: - Edit Custom Recipe (thin wrapper reusing CreateRecipeView logic)
struct EditCustomRecipeView: View {
    let recipe: CustomRecipe
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var title: String
    @State private var readyInMinutes: String
    @State private var servings: String
    @State private var selectedMealCategory: MealCategory
    @State private var isPrivate: Bool
    @State private var notes: String
    @State private var ingredientLines: [String]
    @State private var steps: [String]
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data?

    init(recipe: CustomRecipe) {
        self.recipe = recipe
        _title = State(initialValue: recipe.title)
        _readyInMinutes = State(initialValue: "\(recipe.readyInMinutes)")
        _servings = State(initialValue: "\(recipe.servings)")
        _selectedMealCategory = State(initialValue: recipe.mealCategory)
        _isPrivate = State(initialValue: recipe.isPrivate)
        _notes = State(initialValue: recipe.notes)
        _ingredientLines = State(initialValue: recipe.ingredients.isEmpty ? [""] : recipe.ingredients)
        _steps = State(initialValue: recipe.steps.isEmpty ? [""] : recipe.steps)
        _selectedImageData = State(initialValue: recipe.imageData)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundPrimary").ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 16) {
                        Group {
                            FloatingLabelField(label: "Recipe Name", text: $title)
                            FloatingLabelField(label: "Cook Time (min)", text: $readyInMinutes)
                            FloatingLabelField(label: "Servings", text: $servings)
                        }
                        .padding(.horizontal, 16)

                        // Photo picker
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Photo (optional)")
                                .font(.system(.caption, design: .rounded, weight: .medium))
                                .foregroundStyle(Color("TextSecondary"))
                                .padding(.horizontal, 16)

                            PhotosPicker(
                                selection: $selectedPhotoItem,
                                matching: .images,
                                photoLibrary: .shared()
                            ) {
                                if let imageData = selectedImageData,
                                   let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 140)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color("AccentSage").opacity(0.3), lineWidth: 1)
                                        )
                                        .padding(.horizontal, 16)
                                } else {
                                    HStack(spacing: 10) {
                                        Image(systemName: "photo.badge.plus")
                                            .font(.system(size: 20))
                                        Text("Add Photo")
                                            .font(.system(.body, design: .rounded, weight: .semibold))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color("BackgroundSecondary"))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [6]))
                                                    .foregroundStyle(Color("TextSecondary").opacity(0.3))
                                            )
                                    )
                                    .foregroundStyle(Color("TextSecondary"))
                                    .padding(.horizontal, 16)
                                }
                            }
                            .onChange(of: selectedPhotoItem) { _, newItem in
                                Task {
                                    selectedImageData = try? await newItem?.loadTransferable(type: Data.self)
                                }
                            }

                            if selectedImageData != nil {
                                Button {
                                    selectedImageData = nil
                                    selectedPhotoItem = nil
                                } label: {
                                    HStack(spacing: 4) {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.system(size: 12))
                                        Text("Remove photo")
                                            .font(.system(.caption, design: .rounded))
                                    }
                                    .foregroundStyle(Color("DestructiveTerracotta"))
                                }
                                .padding(.horizontal, 16)
                            }
                        }

                        // Meal category
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(MealCategory.allCases.filter { $0 != .uncategorized }, id: \.self) { cat in
                                    Button { selectedMealCategory = cat } label: {
                                        HStack(spacing: 4) {
                                            Text(cat.emoji).font(.system(size: 14))
                                            Text(cat.rawValue).font(.system(.caption, design: .rounded, weight: .semibold))
                                        }
                                        .padding(.horizontal, 12).padding(.vertical, 8)
                                        .background(RoundedRectangle(cornerRadius: 10)
                                            .fill(selectedMealCategory == cat ? Color("AccentSage") : Color("BackgroundSecondary")))
                                        .foregroundStyle(selectedMealCategory == cat ? .white : Color("TextSecondary"))
                                    }.buttonStyle(.plain)
                                }
                            }.padding(.horizontal, 16)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Ingredients").font(.system(.headline, design: .rounded, weight: .bold)).padding(.horizontal, 16)
                            ForEach(ingredientLines.indices, id: \.self) { idx in
                                HStack(spacing: 8) {
                                    TextField("Ingredient", text: $ingredientLines[idx])
                                        .font(.system(.body, design: .rounded))
                                        .padding(12)
                                        .background(RoundedRectangle(cornerRadius: 10).fill(Color("BackgroundSecondary")))
                                    if ingredientLines.count > 1 {
                                        Button { ingredientLines.remove(at: idx) } label: {
                                            Image(systemName: "minus.circle.fill").foregroundStyle(Color("TextSecondary").opacity(0.5))
                                        }
                                    }
                                }.padding(.horizontal, 16)
                            }
                            Button { ingredientLines.append("") } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Add Ingredient").font(.system(.subheadline, design: .rounded, weight: .semibold))
                                }.foregroundStyle(Color("AccentSage"))
                            }.padding(.horizontal, 16)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Instructions").font(.system(.headline, design: .rounded, weight: .bold)).padding(.horizontal, 16)
                            ForEach(steps.indices, id: \.self) { idx in
                                HStack(alignment: .top, spacing: 8) {
                                    TextField("Step \(idx+1)", text: $steps[idx], axis: .vertical)
                                        .font(.system(.body, design: .rounded))
                                        .lineLimit(2...)
                                        .padding(12)
                                        .background(RoundedRectangle(cornerRadius: 10).fill(Color("BackgroundSecondary")))
                                    if steps.count > 1 {
                                        Button { steps.remove(at: idx) } label: {
                                            Image(systemName: "minus.circle.fill").foregroundStyle(Color("TextSecondary").opacity(0.5))
                                        }.padding(.top, 8)
                                    }
                                }.padding(.horizontal, 16)
                            }
                            Button { steps.append("") } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Add Step").font(.system(.subheadline, design: .rounded, weight: .semibold))
                                }.foregroundStyle(Color("AccentSage"))
                            }.padding(.horizontal, 16)
                        }

                        Toggle(isOn: $isPrivate) {
                            Text("Private Recipe").font(.system(.body, design: .rounded))
                        }.tint(Color("AccentSage")).padding(.horizontal, 16)
                    }
                    .padding(.vertical, 16)
                }
            }
            .navigationTitle("Edit Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }.foregroundStyle(Color("TextSecondary"))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        recipe.title = title.trimmingCharacters(in: .whitespaces)
                        recipe.readyInMinutes = Int(readyInMinutes) ?? 30
                        recipe.servings = Int(servings) ?? 4
                        recipe.mealCategory = selectedMealCategory
                        recipe.isPrivate = isPrivate
                        recipe.notes = notes
                        recipe.imageData = selectedImageData
                        recipe.ingredientsList = ingredientLines
                            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
                            .joined(separator: "|")
                        recipe.instructionsList = steps
                            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
                            .joined(separator: "||")
                        try? modelContext.save()
                        dismiss()
                    }
                    .font(.system(.body, design: .rounded, weight: .semibold))
                    .foregroundStyle(Color("AccentSage"))
                }
            }
        }
    }
}
