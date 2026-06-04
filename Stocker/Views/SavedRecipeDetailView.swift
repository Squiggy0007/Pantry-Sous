import SwiftUI
import SwiftData

struct SavedRecipeDetailView: View {
    let recipe: SavedRecipe
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Query private var allIngredients: [Ingredient]
    @Query private var shoppingItems: [ShoppingItem]
    @ObservedObject private var staplesManager = PantryStaplesManager.shared

    @State private var showingShareSheet: Bool = false
    @State private var shareText: String = ""
    @State private var showingMadeDishSheet: Bool = false
    @State private var toastVisible: Bool = false
    @State private var toastMessage: String = ""

    var ingredients: [String] {
        recipe.ingredientsList.components(separatedBy: "|").filter { !$0.isEmpty }
    }

    var steps: [(number: Int, text: String)] {
        recipe.parsedSteps
            .components(separatedBy: "||")
            .compactMap { entry in
                let parts = entry.components(separatedBy: "|")
                guard parts.count == 2,
                      let number = Int(parts[0]) else { return nil }
                return (number: number, text: parts[1])
            }
    }

    // MARK: - Inventory Matching

    private func isOwned(_ ingredientLine: String) -> Bool {
        let name = IngredientNormalizer.extractIngredientName(ingredientLine)
        guard !name.isEmpty else { return false }
        return IngredientNormalizer.matches(name, against: allIngredients.map { $0.name })
    }

    private func isStaple(_ ingredientLine: String) -> Bool {
        let name = IngredientNormalizer.extractIngredientName(ingredientLine)
        return staplesManager.isActiveStaple(name)
    }

    private var missingNonStapleLines: [String] {
        ingredients.filter { line in
            let name = IngredientNormalizer.extractIngredientName(line)
            guard !name.isEmpty else { return false }
            guard !staplesManager.isActiveStaple(name) else { return false }
            return !IngredientNormalizer.matches(name, against: allIngredients.map { $0.name })
        }
    }

    // MARK: - RecipeDetail for MadeDishSheet

    private var recipeDetailForMadeDish: RecipeDetail {
        let extended: [ExtendedIngredient] = ingredients.enumerated().map { idx, line in
            let name = IngredientNormalizer.extractIngredientName(line)
            let (amount, unit) = parseAmountAndUnit(from: line)
            return ExtendedIngredient(id: idx, name: name, original: line, amount: amount, unit: unit)
        }
        return RecipeDetail(
            id: recipe.id,
            title: recipe.title,
            image: recipe.imageURL,
            readyInMinutes: recipe.readyInMinutes,
            servings: recipe.servings,
            extendedIngredients: extended,
            aggregateLikes: nil,
            spoonacularScore: nil,
            analyzedInstructions: []
        )
    }

    // MARK: - View

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color("BackgroundPrimary")
                    .ignoresSafeArea()

                ScrollView(.vertical) {
                    VStack(alignment: .leading, spacing: 0) {

                        // Hero image
                        Group {
                            if recipe.imageURL.isEmpty {
                                Rectangle()
                                    .fill(Color("BackgroundSecondary"))
                                    .overlay(
                                        Image(systemName: "heart.fill")
                                            .font(.system(size: 40))
                                            .foregroundStyle(Color("AccentSage"))
                                    )
                            } else {
                                CachedAsyncImage(url: URL(string: recipe.imageURL)) { phase in
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
                            }
                        }
                        .frame(maxWidth: .infinity, minHeight: 260, maxHeight: 260)
                        .clipped()

                        VStack(alignment: .leading, spacing: 20) {

                            // Title and stats
                            VStack(alignment: .leading, spacing: 12) {
                                Text(recipe.title)
                                    .font(.system(.title2, design: .rounded, weight: .bold))
                                    .foregroundStyle(Color("TextPrimary"))
                                    .fixedSize(horizontal: false, vertical: true)

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 10) {
                                        if recipe.readyInMinutes > 0 {
                                            StatPillView(icon: "clock", value: "\(recipe.readyInMinutes) min")
                                        }
                                        if recipe.servings > 0 {
                                            StatPillView(icon: "person.2", value: "\(recipe.servings) servings")
                                        }
                                        StatPillView(
                                            icon: "calendar",
                                            value: "Saved \(recipe.dateSaved.formatted(.dateTime.month(.abbreviated).day()))"
                                        )
                                    }
                                }
                            }

                            Divider()

                            // Ingredients
                            VStack(alignment: .leading, spacing: 14) {
                                Text("Ingredients")
                                    .font(.system(.title3, design: .rounded, weight: .bold))
                                    .foregroundStyle(Color("TextPrimary"))

                                ForEach(ingredients, id: \.self) { line in
                                    ingredientRow(line)
                                }
                            }

                            // Action buttons
                            actionButtons

                            Divider()

                            // Instructions
                            if !steps.isEmpty {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Instructions")
                                        .font(.system(.title3, design: .rounded, weight: .bold))
                                        .foregroundStyle(Color("TextPrimary"))

                                    ForEach(steps, id: \.number) { step in
                                        InstructionStepView(number: step.number, text: step.text)
                                    }
                                }
                            }

                            // Remove from favorites
                            Button {
                                modelContext.delete(recipe)
                                try? modelContext.save()
                                dismiss()
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: "heart.slash")
                                    Text("Remove from Favorites")
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
                        .padding(20)
                        .padding(.bottom, 40)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                // Toast
                if toastVisible {
                    toastView
                }
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
                    Button {
                        prepareShare()
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Color("AccentSage"))
                    }
                }
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
        }
    }

    // MARK: - Ingredient Row

    @ViewBuilder
    private func ingredientRow(_ line: String) -> some View {
        let owned = isOwned(line)
        let staple = isStaple(line)

        HStack(alignment: .top, spacing: 12) {
            if owned {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(Color("AccentSage"))
            } else if staple {
                Image(systemName: "circle.dotted")
                    .font(.system(size: 18))
                    .foregroundStyle(Color("TextSecondary"))
            } else {
                Image(systemName: "circle")
                    .font(.system(size: 18))
                    .foregroundStyle(Color("DestructiveTerracotta"))
            }

            Text(line)
                .font(.system(.body, design: .rounded))
                .foregroundStyle(owned ? Color("TextPrimary") : (staple ? Color("TextSecondary") : Color("TextPrimary")))
                .fixedSize(horizontal: false, vertical: true)

            Spacer()
        }
        .padding(.vertical, 2)
    }

    // MARK: - Action Buttons

    private var actionButtons: some View {
        VStack(spacing: 12) {
            // Add Missing to Shopping List
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

            // Made This Dish
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
    }

    // MARK: - Toast

    private var toastView: some View {
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

    // MARK: - Add Missing to Shopping List

    private func addMissingToShoppingList() {
        let inventoryNames = allIngredients.map { $0.name }
        var addedCount = 0

        for line in ingredients {
            let name = IngredientNormalizer.extractIngredientName(line)
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
                let category = IngredientCategory.suggested(for: name)
                let item = ShoppingItem(
                    name: name.titleCased(),
                    quantityAmount: resolvedAmount,
                    quantityUnit: resolvedUnit,
                    category: category
                )
                modelContext.insert(item)
                addedCount += 1
            }
        }

        try? modelContext.save()

        if addedCount > 0 {
            displayToast(addedCount == 1 ? "1 item added to shopping list" : "\(addedCount) items added to shopping list")
        } else {
            displayToast("All items already on your list")
        }
    }

    private func displayToast(_ message: String) {
        toastMessage = message
        withAnimation(.spring(response: 0.3)) { toastVisible = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.spring(response: 0.3)) { toastVisible = false }
        }
    }

    // MARK: - Made This Dish

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

    // MARK: - Ingredient Parsing Helpers

    private func parseAmountAndUnit(from line: String) -> (Double?, String?) {
        let words = line.trimmingCharacters(in: .whitespaces)
            .components(separatedBy: " ").filter { !$0.isEmpty }
        guard !words.isEmpty else { return (nil, nil) }

        var idx = 0
        var amount: Double? = nil

        let first = words[idx]
        if let d = Double(first) {
            amount = d
            idx += 1
        } else if first.contains("/"), let frac = parseFraction(first) {
            amount = frac
            idx += 1
        }

        // Mixed number: e.g. "1 1/2"
        if amount != nil, idx < words.count {
            let second = words[idx]
            if second.contains("/"), let frac = parseFraction(second) {
                amount = (amount ?? 0) + frac
                idx += 1
            }
        }

        let unitWords: Set<String> = [
            "cup","cups","tsp","tbsp","oz","lbs","lb","g","kg",
            "pint","pints","quart","quarts","gallon","gallons",
            "can","cans","jar","jars","bag","bags","box","boxes",
            "bottle","bottles","package","packages","packet","packets",
            "ml","l","cloves","clove","slices","slice","pieces","piece",
            "sprigs","sprig","whole","large","medium","small"
        ]
        var unit: String? = nil
        if idx < words.count && unitWords.contains(words[idx].lowercased()) {
            unit = words[idx]
        }

        return (amount, unit)
    }

    private func parseFraction(_ s: String) -> Double? {
        let parts = s.split(separator: "/")
        guard parts.count == 2,
              let n = Double(parts[0]),
              let d = Double(parts[1]),
              d != 0 else { return nil }
        return n / d
    }

    // MARK: - Share

    private func prepareShare() {
        var text = "🍽️ \(recipe.title)\n"
        if recipe.readyInMinutes > 0 { text += "⏱️ \(recipe.readyInMinutes) minutes" }
        if recipe.servings > 0 { text += " | 👤 \(recipe.servings) servings" }
        text += "\n\n📝 INGREDIENTS\n"
        for ingredient in ingredients { text += "• \(ingredient)\n" }
        if !steps.isEmpty {
            text += "\n👨‍🍳 INSTRUCTIONS\n"
            for step in steps { text += "\(step.number). \(step.text)\n" }
        }
        text += "\n\nShared from Pantry Sous 🛒"
        shareText = text
        showingShareSheet = true
    }
}
