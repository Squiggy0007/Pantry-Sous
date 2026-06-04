import SwiftUI
import SwiftData

struct RecipeDetailView: View {
    let recipe: SpoonacularRecipe
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var savedRecipes: [SavedRecipe]
    @Query private var shoppingItems: [ShoppingItem]
    @Query private var allIngredients: [Ingredient]
    @State private var recipeDetail: RecipeDetail? = nil
    @State private var isLoading: Bool = true
    @State private var errorMessage: String? = nil
    @State private var showingShareSheet: Bool = false
    @State private var shareText: String = ""
    @State private var showingAddedToast: Bool = false
    @State private var toastMessage: String = ""
    @State private var showingMadeDishSheet: Bool = false
    @State private var showingFavoriteLimitAlert: Bool = false
    @State private var servingScale: Double = 1.0
    @ObservedObject private var staplesManager = PantryStaplesManager.shared

    var isSaved: Bool {
        savedRecipes.contains(where: { $0.id == recipe.id })
    }

    var parsedSteps: [InstructionStep] {
        recipeDetail?.analyzedInstructions.first?.steps ?? []
    }

    var inventoryNames: [String] {
        allIngredients.map { $0.name }
    }

    // Split ingredients into staples vs regular
    var nonStapleIngredients: [ExtendedIngredient] {
        recipeDetail?.extendedIngredients.filter { !staplesManager.isActiveStaple($0.name) } ?? []
    }

    var stapleIngredients: [ExtendedIngredient] {
        recipeDetail?.extendedIngredients.filter { staplesManager.isActiveStaple($0.name) } ?? []
    }

    var ingredientProgress: (owned: Int, total: Int) {
        let total = nonStapleIngredients.count
        let owned = nonStapleIngredients.filter {
            IngredientNormalizer.matches($0.name, against: inventoryNames)
        }.count
        return (owned, total)
    }

    var missingDetailIngredientCount: Int {
        nonStapleIngredients.filter {
            !IngredientNormalizer.matches($0.name, against: inventoryNames)
        }.count
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundPrimary")
                    .ignoresSafeArea()

                if isLoading {
                    LoadingRecipesView()
                } else if let error = errorMessage {
                    ErrorRecipesView(message: error) {
                        Task { await loadDetail() }
                    }
                } else if let detail = recipeDetail {
                    recipeContent(detail: detail)
                }

                // Toast notification
                VStack {
                    Spacer()
                    if showingAddedToast {
                        HStack(spacing: 10) {
                            Image(systemName: "cart.fill.badge.plus")
                                .font(.system(size: 16))
                                .foregroundStyle(.white)
                            Text(toastMessage)
                                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .background(
                            Capsule()
                                .fill(Color("AccentSage"))
                                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                        )
                        .padding(.bottom, 32)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: showingAddedToast)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
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
                        Button { toggleSave() } label: {
                            Image(systemName: isSaved ? "heart.fill" : "heart")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(isSaved
                                                 ? Color("DestructiveTerracotta")
                                                 : Color("AccentSage"))
                        }
                    }
                }
            }
            .task { await loadDetail() }
            .sheet(isPresented: $showingShareSheet) {
                ShareSheet(text: shareText)
            }
            .sheet(isPresented: $showingMadeDishSheet) {
                if let detail = recipeDetail {
                    MadeDishSheet(
                        detail: detail,
                        allIngredients: allIngredients,
                        onConfirm: { deductions in
                            applyMadeDish(deductions: deductions)
                        }
                    )
                }
            }
            .alert("Favorite Limit Reached", isPresented: $showingFavoriteLimitAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(FeatureLimits.favoriteLimitMessage)
            }
        }
    }

    // MARK: - Recipe Content
    private func recipeContent(detail: RecipeDetail) -> some View {
        GeometryReader { proxy in
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 0) {

                // Hero image
                CachedAsyncImage(url: URL(string: detail.image)) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().aspectRatio(contentMode: .fill)
                    case .failure(_):
                        Rectangle()
                            .fill(Color("BackgroundSecondary"))
                            .overlay(
                                Image(systemName: "fork.knife")
                                    .font(.system(size: 40))
                                    .foregroundStyle(Color("TextSecondary"))
                            )
                    case .empty:
                        Rectangle()
                            .fill(Color("BackgroundSecondary"))
                            .overlay(ProgressView())
                    }
                }
                .frame(width: proxy.size.width, height: 260)
                .clipped()

                VStack(alignment: .leading, spacing: 20) {

                    // Title and stats
                    VStack(alignment: .leading, spacing: 12) {
                        Text(detail.title)
                            .font(.system(.title2, design: .rounded, weight: .bold))
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(Color("TextPrimary"))

                        HStack(spacing: 12) {
                            if let minutes = detail.readyInMinutes, minutes > 0 {
                                StatPillView(icon: "clock", value: "\(minutes) min")
                            }
                            if let servings = detail.servings, servings > 0 {
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
                            }
                            if let score = detail.spoonacularScore, score > 0 {
                                HStack(spacing: 4) {
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 11))
                                        .foregroundStyle(Color("AccentSage"))
                                    Text("\(Int(score))/100")
                                        .font(.system(.caption, design: .rounded, weight: .semibold))
                                        .foregroundStyle(Color("AccentSage"))
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color("AccentSage").opacity(0.12))
                                )
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                    // Ingredient progress pill
                    if ingredientProgress.total > 0 {
                        let prog = ingredientProgress
                        let allOwned = prog.owned == prog.total
                        HStack(spacing: 8) {
                            Image(systemName: allOwned ? "checkmark.circle.fill" : "circle.bottomhalf.filled")
                                .font(.system(size: 14))
                                .foregroundStyle(allOwned ? Color("AccentSage") : Color("DestructiveTerracotta"))
                            Text("\(prog.owned) of \(prog.total) ingredients on hand")
                                .font(.system(.subheadline, design: .rounded, weight: .medium))
                                .foregroundStyle(allOwned ? Color("AccentSage") : Color("TextSecondary"))
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(allOwned
                                      ? Color("AccentSage").opacity(0.10)
                                      : Color("BackgroundSecondary"))
                        )
                    }

                    // Nutrition summary (shown when API returns data)
                    if let nutrition = detail.nutrition,
                       let cal = nutrition.calories {
                        HStack(spacing: 0) {
                            NutrientPillView(label: "Calories", value: "\(Int(cal))", unit: "")
                            Divider().frame(height: 32)
                            if let p = nutrition.protein {
                                NutrientPillView(label: "Protein", value: String(format: "%.0f", p), unit: "g")
                                Divider().frame(height: 32)
                            }
                            if let c = nutrition.carbs {
                                NutrientPillView(label: "Carbs", value: String(format: "%.0f", c), unit: "g")
                                Divider().frame(height: 32)
                            }
                            if let f = nutrition.fat {
                                NutrientPillView(label: "Fat", value: String(format: "%.0f", f), unit: "g")
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color("BackgroundSecondary"))
                        )
                    }

                    Divider()

                    // Ingredients
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Ingredients")
                            .font(.system(.title3, design: .rounded, weight: .bold))
                            .foregroundStyle(Color("TextPrimary"))

                        // Regular ingredients — check vs missing
                        ForEach(nonStapleIngredients) { ingredient in
                            let isOwned = IngredientNormalizer.matches(
                                ingredient.name,
                                against: inventoryNames
                            )

                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: isOwned
                                      ? "checkmark.circle.fill"
                                      : "circle")
                                    .font(.system(size: 18))
                                    .foregroundStyle(isOwned
                                                     ? Color("AccentSage")
                                                     : Color("DestructiveTerracotta"))
                                    .padding(.top, 2)

                                Text(scaledIngredientText(ingredient))
                                    .font(.system(.body, design: .rounded))
                                    .foregroundStyle(isOwned
                                                     ? Color("TextPrimary")
                                                     : Color("TextSecondary"))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(.vertical, 4)
                        }

                        // Pantry staples section — no checkbox, neutral styling
                        if !stapleIngredients.isEmpty {
                            Divider()
                                .padding(.vertical, 4)

                            HStack(spacing: 6) {
                                Image(systemName: "cabinet.fill")
                                    .font(.system(size: 12))
                                    .foregroundStyle(Color("TextSecondary"))
                                Text("Pantry Staples")
                                    .font(.system(.caption, design: .rounded, weight: .semibold))
                                    .foregroundStyle(Color("TextSecondary"))
                            }

                            ForEach(stapleIngredients) { ingredient in
                                HStack(alignment: .top, spacing: 12) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 18))
                                        .foregroundStyle(Color("AccentSage").opacity(0.5))
                                        .padding(.top, 2)

                                    Text(scaledIngredientText(ingredient))
                                        .font(.system(.body, design: .rounded))
                                        .foregroundStyle(Color("TextPrimary").opacity(0.6))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }

                    // Action buttons
                    VStack(spacing: 10) {
                        // Made Dish button
                        Button { showingMadeDishSheet = true } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.seal.fill")
                                Text("Made This Dish")
                                    .font(.system(.body, design: .rounded, weight: .semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color("AccentSage"))
                            )
                            .foregroundStyle(.white)
                        }

                        // Add missing button
                        if missingDetailIngredientCount > 0 {
                            Button { addMissingToShoppingList() } label: {
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
                    }

                    Divider()

                    // Instructions
                    if !parsedSteps.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Instructions")
                                .font(.system(.title3, design: .rounded, weight: .bold))
                                .foregroundStyle(Color("TextPrimary"))

                            ForEach(parsedSteps, id: \.number) { step in
                                InstructionStepView(
                                    number: step.number,
                                    text: step.step
                                )
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
                .padding(.bottom, 40)
            }
            .frame(width: proxy.size.width, alignment: .leading)
            .clipped()
        }
        }
    }   // ScrollView
    }   // recipeContent

    // MARK: - Load Detail
    private func loadDetail() async {
        isLoading = true
        errorMessage = nil
        do {
            recipeDetail = try await SpoonacularService.shared.fetchRecipeDetail(id: recipe.id)
        } catch {
            errorMessage = "Couldn't load recipe details. Please try again."
        }
        isLoading = false
    }

    // MARK: - Save / Unsave
    private func toggleSave() {
        HapticFeedback.medium()
        if isSaved {
            if let existing = savedRecipes.first(where: { $0.id == recipe.id }) {
                modelContext.delete(existing)
                try? modelContext.save()
            }
        } else {
            guard let detail = recipeDetail else { return }
            guard FeatureLimits.canSaveFavorite(currentCount: savedRecipes.count) else {
                HapticFeedback.warning()
                showingFavoriteLimitAlert = true
                return
            }
            let ingredientsList = detail.extendedIngredients
                .map { $0.original ?? $0.name }
                .joined(separator: "|")
            let steps = detail.analyzedInstructions.first?.steps ?? []
            let parsedSteps = steps
                .map { "\($0.number)|\($0.step)" }
                .joined(separator: "||")
            let saved = SavedRecipe(
                id: detail.id,
                title: detail.title,
                imageURL: detail.image,
                readyInMinutes: detail.readyInMinutes ?? 0,
                servings: detail.servings ?? 1,
                ingredientsList: ingredientsList,
                parsedSteps: parsedSteps,
                mealCategory: MealCategory.suggested(for: detail.title)
            )
            modelContext.insert(saved)
            try? modelContext.save()
        }
    }

    // MARK: - Add Missing to Shopping List
    private func addMissingToShoppingList() {
        guard let detail = recipeDetail else { return }

        var addedCount = 0

        for ingredient in detail.extendedIngredients {
            // Skip staples
            if staplesManager.isActiveStaple(ingredient.name) { continue }

            let isOwned = IngredientNormalizer.matches(
                ingredient.name,
                against: inventoryNames
            )
            if isOwned { continue }

            let recipeAmount = (ingredient.amount ?? 1) * servingScale
            let recipeUnit = ingredient.unit ?? ""

            let (finalAmount, finalUnit) = UnitConversionHelper.resolveShoppingQuantity(
                ingredientName: ingredient.name,
                amount: recipeAmount,
                unitString: recipeUnit
            )

            // If item already exists in shopping list, stack quantities if units match
            if let existing = shoppingItems.first(where: {
                IngredientNormalizer.matches(ingredient.name, against: [$0.name])
            }) {
                if existing.quantityUnit == finalUnit.rawValue {
                    existing.quantityAmount += finalAmount
                    addedCount += 1
                }
                continue
            }

            let category = IngredientCategory.suggested(for: ingredient.name)

            let item = ShoppingItem(
                name: ingredient.name.titleCased(),
                quantityAmount: finalAmount,
                quantityUnit: finalUnit,
                category: category
            )
            modelContext.insert(item)
            addedCount += 1
        }

        try? modelContext.save()

        if addedCount > 0 {
            toastMessage = "\(addedCount) item\(addedCount == 1 ? "" : "s") added to shopping list"
            HapticFeedback.success()
        } else {
            toastMessage = "All items already on your list"
            HapticFeedback.light()
        }

        showToast($showingAddedToast)
    }

    // MARK: - Made Dish — Apply Deductions
    private func applyMadeDish(deductions: [IngredientDeduction]) {
        // Prefer opened/partial containers (smallest containerSize) first
        let sortedIngredients = allIngredients.sorted {
            let a = $0.containerSize > 0 ? $0.containerSize : Double.infinity
            let b = $1.containerSize > 0 ? $1.containerSize : Double.infinity
            return a < b
        }
        for deduction in deductions {
            guard let inventoryItem = sortedIngredients.first(where: {
                IngredientNormalizer.matches(deduction.ingredientName, against: [$0.name])
            }) else { continue }

            let converted = UnitConversionHelper.convertBetweenUnits(
                amount: deduction.recipeAmount,
                from: deduction.recipeUnit,
                to: QuantityUnit(rawValue: inventoryItem.quantityUnit) ?? .item,
                ingredientHint: deduction.ingredientName
            )

            let remaining = inventoryItem.quantityAmount - converted
            if remaining <= 0 {
                modelContext.delete(inventoryItem)
            } else {
                inventoryItem.quantityAmount = remaining
            }
        }
        try? modelContext.save()

        HapticFeedback.success()
        toastMessage = "Inventory updated!"
        showToast($showingAddedToast)
    }

    // MARK: - Scaled Ingredient Text
    /// Returns the ingredient display string scaled by servingScale.
    /// At 1× returns `ingredient.original` verbatim to preserve Spoonacular's formatting.
    /// At other scales:
    ///   - Uses vulgar fraction characters (½, ¼, ¾…) via `toFractionString()`.
    ///   - If a measured unit is present, rebuilds cleanly as "N unit(s) name".
    ///   - If no unit and `original` contains more than just a bare "N name" (e.g.
    ///     "zest and juice of 1 lemon"), replaces the number inline to preserve context.
    private func scaledIngredientText(_ ingredient: ExtendedIngredient) -> String {
        guard servingScale != 1.0, let amount = ingredient.amount else {
            return ingredient.original ?? ingredient.name
        }

        let scaled = amount * servingScale
        let formatted = scaled.toFractionString()
        let unit = ingredient.unit.flatMap { $0.isEmpty ? nil : $0 } ?? ""

        // "whole" is Spoonacular's unit for count items — treat it like no unit so we
        // can preserve descriptive originals like "zest and juice of 1 lemon".
        let isMeasuredUnit = !unit.isEmpty && unit.lowercased() != "whole"

        // When there's a real measurement unit, rebuild cleanly with pluralized unit.
        if isMeasuredUnit {
            let pluralUnit = Self.pluralizedUnit(unit, count: scaled)
            return "\(formatted) \(pluralUnit) \(ingredient.name)"
        }

        // No unit (or "whole") — try to replace the number inside original to preserve
        // descriptions like "zest and juice of 1 lemon" → "zest and juice of 2 lemons".
        if let original = ingredient.original {
            // Use the plain integer / decimal string to search `original`
            // (Spoonacular stores amounts as numbers in original text, not fractions)
            let amountStr = amount.truncatingRemainder(dividingBy: 1) == 0
                ? String(Int(amount))
                : String(format: "%.2g", amount)

            // Only do inline replacement when original has more context than "N name".
            let bareForm = "\(amountStr) \(ingredient.name)"
            if original.lowercased().trimmingCharacters(in: .whitespaces) != bareForm.lowercased(),
               let numRange = original.range(of: amountStr) {
                var result = original.replacingCharacters(in: numRange, with: formatted)
                // Pluralize the ingredient name when the original had exactly 1 item
                if amount == 1 && scaled > 1 {
                    let plural = ingredient.name.pluralized(count: scaled)
                    if plural != ingredient.name,
                       let nameRange = result.range(of: ingredient.name, options: .caseInsensitive) {
                        result.replaceSubrange(nameRange, with: plural)
                    }
                }
                return result
            }
        }

        // Simple fallback: "N name" or "N names"
        let plural = ingredient.name.pluralized(count: scaled)
        return "\(formatted) \(plural)"
    }

    // MARK: - Unit Pluralization
    /// Pluralizes spelled-out unit names for recipe scaling.
    /// Abbreviations (oz, tbsp, tsp, g, kg, ml) are left unchanged.
    private static func pluralizedUnit(_ unit: String, count: Double) -> String {
        guard count != 1.0 else { return unit }
        switch unit.lowercased() {
        case "tablespoon":  return "tablespoons"
        case "teaspoon":    return "teaspoons"
        case "cup":         return "cups"
        case "ounce":       return "ounces"
        case "pound":       return "pounds"
        case "gram":        return "grams"
        case "kilogram":    return "kilograms"
        case "clove":       return "cloves"
        case "slice":       return "slices"
        case "piece":       return "pieces"
        case "sprig":       return "sprigs"
        case "stalk":       return "stalks"
        case "bunch":       return "bunches"
        case "head":        return "heads"
        case "can":         return "cans"
        case "jar":         return "jars"
        case "bag":         return "bags"
        case "bottle":      return "bottles"
        case "package":     return "packages"
        case "packet":      return "packets"
        case "strip":       return "strips"
        case "leaf":        return "leaves"
        case "ear":         return "ears"
        case "inch":        return "inches"
        default:            return unit   // leave abbreviations unchanged
        }
    }

    // MARK: - Share
    private func prepareShare() {
        guard let detail = recipeDetail else { return }
        var text = "🍽️ \(detail.title)\n"
        if let minutes = detail.readyInMinutes, minutes > 0 {
            text += "⏱️ \(minutes) minutes"
        }
        if let servings = detail.servings, servings > 0 {
            text += " | 👤 \(servings) servings"
        }
        text += "\n\n📝 INGREDIENTS\n"
        for ingredient in detail.extendedIngredients {
            text += "• \(ingredient.original ?? ingredient.name)\n"
        }
        if !parsedSteps.isEmpty {
            text += "\n👨‍🍳 INSTRUCTIONS\n"
            for step in parsedSteps {
                text += "\(step.number). \(step.step)\n"
            }
        }
        text += "\n\nShared from Pantry Sous 🛒"
        shareText = text
        showingShareSheet = true
    }
}

// MARK: - Ingredient Deduction Model
struct IngredientDeduction: Identifiable {
    let id = UUID()
    let ingredientName: String
    let recipeAmount: Double
    let recipeUnit: QuantityUnit
    let inventoryAmount: Double
    let inventoryUnit: QuantityUnit
    let resultAmount: Double   // what will remain
    let canDeduct: Bool        // false if units are incompatible
}

// MARK: - Made Dish Sheet
struct MadeDishSheet: View {
    let detail: RecipeDetail
    let allIngredients: [Ingredient]
    let onConfirm: ([IngredientDeduction]) -> Void

    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var staplesManager = PantryStaplesManager.shared

    var deductions: [IngredientDeduction] {
        // Prefer opened/partial containers (smallest containerSize) first
        let sortedIngredients = allIngredients.sorted {
            let a = $0.containerSize > 0 ? $0.containerSize : Double.infinity
            let b = $1.containerSize > 0 ? $1.containerSize : Double.infinity
            return a < b
        }
        return detail.extendedIngredients.compactMap { ingredient in
            guard !staplesManager.isActiveStaple(ingredient.name) else { return nil }

            guard let inventoryItem = sortedIngredients.first(where: {
                IngredientNormalizer.matches(ingredient.name, against: [$0.name])
            }) else { return nil }

            let recipeAmount = ingredient.amount ?? 1
            let recipeUnit = UnitConversionHelper.mapToQuantityUnit(ingredient.unit ?? "")
            let invUnit = QuantityUnit(rawValue: inventoryItem.quantityUnit) ?? .item

            let deductAmount = UnitConversionHelper.convertBetweenUnits(
                amount: recipeAmount,
                from: recipeUnit,
                to: invUnit,
                ingredientHint: ingredient.name
            )
            let canDeduct = deductAmount > 0
            let resultAmount = max(0, inventoryItem.quantityAmount - deductAmount)

            return IngredientDeduction(
                ingredientName: ingredient.name,
                recipeAmount: recipeAmount,
                recipeUnit: recipeUnit,
                inventoryAmount: inventoryItem.quantityAmount,
                inventoryUnit: invUnit,
                resultAmount: resultAmount,
                canDeduct: canDeduct
            )
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundPrimary").ignoresSafeArea()

                if deductions.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.seal")
                            .font(.system(size: 52))
                            .foregroundStyle(Color("AccentSage").opacity(0.4))
                        Text("No tracked ingredients to deduct")
                            .font(.system(.title3, design: .rounded, weight: .semibold))
                            .foregroundStyle(Color("TextSecondary"))
                        Text("Add ingredients to your inventory first, or check that the recipe ingredients are in your pantry.")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundStyle(Color("TextSecondary").opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("The following ingredients will be deducted from your inventory:")
                                .font(.system(.subheadline, design: .rounded))
                                .foregroundStyle(Color("TextSecondary"))
                                .padding(.horizontal, 20)
                                .padding(.top, 4)

                            ForEach(deductions) { deduction in
                                DeductionRowView(deduction: deduction)
                            }

                            Text("Items that reach 0 will be removed from your inventory.")
                                .font(.system(.caption, design: .rounded))
                                .foregroundStyle(Color("TextSecondary").opacity(0.7))
                                .padding(.horizontal, 20)
                                .padding(.top, 4)
                        }
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationTitle("Made This Dish")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(Color("TextSecondary"))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        onConfirm(deductions.filter { $0.canDeduct })
                        dismiss()
                    } label: {
                        Text("Confirm")
                            .font(.system(.body, design: .rounded, weight: .semibold))
                            .foregroundStyle(Color("AccentSage"))
                    }
                    .disabled(deductions.isEmpty)
                }
            }
        }
    }

}

// MARK: - Deduction Row
struct DeductionRowView: View {
    let deduction: IngredientDeduction

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: deduction.canDeduct ? "minus.circle.fill" : "exclamationmark.circle.fill")
                .font(.system(size: 20))
                .foregroundStyle(deduction.canDeduct ? Color("AccentSage") : Color("TextSecondary"))

            VStack(alignment: .leading, spacing: 3) {
                Text(deduction.ingredientName.titleCased())
                    .font(.system(.body, design: .rounded, weight: .semibold))
                    .foregroundStyle(Color("TextPrimary"))

                if deduction.canDeduct {
                    let invLabel = IngredientQuantity(amount: deduction.inventoryAmount, unit: deduction.inventoryUnit).displayString
                    let resultLabel = IngredientQuantity(amount: deduction.resultAmount, unit: deduction.inventoryUnit).displayString
                    Text("\(invLabel) → \(deduction.resultAmount <= 0 ? "removed" : resultLabel)")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(deduction.resultAmount <= 0
                                         ? Color("DestructiveTerracotta")
                                         : Color("TextSecondary"))
                } else {
                    Text("Unit mismatch — skipped")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(Color("TextSecondary").opacity(0.7))
                }
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(Color("CardBackground"))
        .overlay(
            Divider()
                .frame(maxWidth: .infinity, maxHeight: 0.5)
                .background(Color("BackgroundSecondary")),
            alignment: .bottom
        )
    }
}

// MARK: - Instruction Step View
struct InstructionStepView: View {
    let number: Int
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color("AccentSage"))
                    .frame(width: 28, height: 28)
                Text("\(number)")
                    .font(.system(.caption, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
            }
            .padding(.top, 2)

            Text(text)
                .font(.system(.body, design: .rounded))
                .foregroundStyle(Color("TextPrimary"))
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color("CardBackground"))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color("AccentSage").opacity(0.2), lineWidth: 1)
                )
        )
    }
}

// MARK: - Nutrient Pill
struct NutrientPillView: View {
    let label: String
    let value: String
    let unit: String

    var body: some View {
        VStack(spacing: 2) {
            Text("\(value)\(unit)")
                .font(.system(.subheadline, design: .rounded, weight: .bold))
                .foregroundStyle(Color("TextPrimary"))
            Text(label)
                .font(.system(.caption2, design: .rounded))
                .foregroundStyle(Color("TextSecondary"))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
    }
}

// MARK: - Stat Pill
struct StatPillView: View {
    let icon: String
    let value: String

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 13))
            Text(value)
                .font(.system(.subheadline, design: .rounded, weight: .medium))
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("BackgroundSecondary"))
        )
        .foregroundStyle(Color("TextSecondary"))
    }
}

// MARK: - Share Sheet
struct ShareSheet: UIViewControllerRepresentable {
    let text: String

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: [text], applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
