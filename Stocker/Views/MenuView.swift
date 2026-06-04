import SwiftUI
import SwiftData

struct MenuView: View {
    @Binding var showingSettings: Bool
    @Environment(\.modelContext) private var modelContext
    @Query private var menuEntries: [MenuEntry]
    @Query private var allIngredients: [Ingredient]
    @Query private var shoppingItems: [ShoppingItem]
    @State private var selectedRecipe: SpoonacularRecipe? = nil
    @State private var showingClearWeekAlert: Bool = false
    @State private var mealPickerDay: WeekDay? = nil

    // Toast
    @State private var toastMessage: String = ""
    @State private var showingToast: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundPrimary")
                    .ignoresSafeArea()

                ScrollView {
                    LazyVStack(spacing: 16) {

                        // Weekly summary strip
                        if !menuEntries.isEmpty {
                            weeklySummaryStrip
                                .padding(.horizontal, 16)
                                .padding(.top, 4)
                        }

                        ForEach(WeekDay.allCases, id: \.rawValue) { day in
                            DayMenuCardView(
                                day: day,
                                entries: entriesFor(day),
                                allIngredients: allIngredients,
                                onRemove: { removeEntry($0) },
                                onTap: { openRecipe($0) },
                                onClear: { clearDay(day) },
                                onAddMeal: { mealPickerDay = day },
                                onAddMissing: { addMissingToShopping($0) }
                            )
                            .padding(.horizontal, 16)
                        }
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 32)
                }

                // Toast overlay
                if showingToast {
                    VStack {
                        Spacer()
                        Text(toastMessage)
                            .font(.system(.subheadline, design: .rounded, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(
                                Capsule()
                                    .fill(Color.black.opacity(0.78))
                            )
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .padding(.bottom, 24)
                    }
                }
            }
            .navigationTitle("This Week")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        HapticFeedback.light()
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(Color("TextSecondary"))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        HapticFeedback.warning()
                        showingClearWeekAlert = true
                    } label: {
                        Image(systemName: "trash")
                            .font(.system(size: 16))
                            .foregroundStyle(Color("TextSecondary").opacity(
                                menuEntries.isEmpty ? 0.3 : 0.8
                            ))
                    }
                    .disabled(menuEntries.isEmpty)
                }
            }
            .sheet(item: $selectedRecipe) { recipe in
                RecipeDetailView(recipe: recipe)
            }
            .sheet(item: $mealPickerDay) { day in
                MealPickerSheet(day: day)
            }
            .onAppear { backfillIngredientNames() }
            .alert("Clear Entire Week?", isPresented: $showingClearWeekAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Clear", role: .destructive) {
                    for entry in menuEntries {
                        modelContext.delete(entry)
                    }
                    try? modelContext.save()
                }
            } message: {
                Text("All planned meals will be removed.")
            }
        }
    }

    // MARK: - Helpers

    /// Backfills ingredientNames for MenuEntry objects that were added before
    /// the field existed (they have empty arrays). Looks up in mock recipe data.
    private func backfillIngredientNames() {
        let staleEntries = menuEntries.filter { $0.ingredientNames.isEmpty }
        guard !staleEntries.isEmpty else { return }

        // Build a flat lookup: recipeId → [String] from both mock sources
        var lookup: [Int: [String]] = [:]

        for recipe in mockRecipes {
            let names = (recipe.usedIngredients + recipe.missedIngredients)
                .map { $0.name }
                .filter { !$0.isEmpty }
            if !names.isEmpty { lookup[recipe.id] = names }
        }
        for recipes in mockBrowseRecipes.values {
            for recipe in recipes {
                guard lookup[recipe.id] == nil else { continue }
                let names = (recipe.usedIngredients + recipe.missedIngredients)
                    .map { $0.name }
                    .filter { !$0.isEmpty }
                if !names.isEmpty { lookup[recipe.id] = names }
            }
        }

        var didChange = false
        for entry in staleEntries {
            if let names = lookup[entry.recipeId] {
                entry.ingredientNames = names
                didChange = true
            }
        }
        if didChange { try? modelContext.save() }
    }

    private func entriesFor(_ day: WeekDay) -> [MenuEntry] {
        menuEntries.filter { $0.dayOfWeek == day.rawValue }
    }

    private func removeEntry(_ entry: MenuEntry) {
        modelContext.delete(entry)
        try? modelContext.save()
    }

    private func openRecipe(_ entry: MenuEntry) {
        selectedRecipe = SpoonacularRecipe(
            id: entry.recipeId,
            title: entry.recipeTitle,
            image: entry.recipeImage,
            readyInMinutes: entry.readyInMinutes,
            servings: entry.servings,
            usedIngredientCount: 0,
            missedIngredientCount: 0,
            missedIngredients: [],
            usedIngredients: []
        )
    }

    private func clearDay(_ day: WeekDay) {
        for entry in entriesFor(day) { modelContext.delete(entry) }
        try? modelContext.save()
    }

    // MARK: - Add Missing to Shopping List

    private func addMissingToShopping(_ ingredientNames: [String]) {
        var added = 0
        for name in ingredientNames {
            let titleName = name.titleCased()
            let normalized = IngredientNormalizer.normalize(name)
            // Skip if already on list (unpurchased)
            let alreadyOnList = shoppingItems.contains {
                !$0.isPurchased &&
                IngredientNormalizer.normalize($0.name) == normalized
            }
            guard !alreadyOnList else { continue }

            let item = ShoppingItem(
                name: titleName,
                quantityAmount: 1,
                quantityUnit: .item,
                category: IngredientCategory.suggested(for: titleName)
            )
            modelContext.insert(item)
            added += 1
        }
        try? modelContext.save()

        let message = added == 0
            ? "Already on your shopping list"
            : "\(added) item\(added == 1 ? "" : "s") added to shopping list"
        showToastMessage(message)
        HapticFeedback.success()
    }

    private func showToastMessage(_ message: String) {
        toastMessage = message
        withAnimation(.spring(response: 0.4)) {
            showingToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeOut(duration: 0.3)) {
                showingToast = false
            }
        }
    }

    // MARK: - Weekly Summary Strip
    private var weeklySummaryStrip: some View {
        HStack(spacing: 6) {
            Image(systemName: "calendar")
                .font(.system(size: 13, weight: .medium))
            Text("\(menuEntries.count) meal\(menuEntries.count == 1 ? "" : "s") planned this week")
                .font(.system(.subheadline, design: .rounded, weight: .medium))
            Spacer()
        }
        .foregroundStyle(Color("AccentSage"))
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color("CardBackground"))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}

// MARK: - Meal Picker Sheet

struct MealPickerSheet: View {
    let day: WeekDay
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var menuEntries: [MenuEntry]
    @Query private var allIngredients: [Ingredient]
    @State private var viewModel = BrowseViewModel()
    @State private var searchText = ""

    var alreadyAddedIds: Set<Int> {
        Set(menuEntries.filter { $0.dayOfWeek == day.rawValue }.map { $0.recipeId })
    }

    var filteredRecipes: [SpoonacularRecipe] {
        guard !searchText.isEmpty else { return viewModel.browseRecipes }
        return viewModel.browseRecipes.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Category pills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(BrowseCategory.allCases, id: \.self) { category in
                            BrowseCategoryPillView(
                                category: category,
                                isSelected: viewModel.selectedCategory == category
                            ) {
                                HapticFeedback.light()
                                withAnimation(.spring(response: 0.3)) {
                                    viewModel.selectedCategory = category
                                }
                                Task {
                                    await viewModel.loadRecipes(for: category, inventory: Array(allIngredients))
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                }
                Divider()
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)
                }
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredRecipes) { recipe in
                            let added = alreadyAddedIds.contains(recipe.id)
                            BrowseFeedCardView(recipe: recipe)
                                .overlay(alignment: .topTrailing) {
                                    Image(systemName: added ? "checkmark.circle.fill" : "plus.circle.fill")
                                        .font(.system(size: 22))
                                        .foregroundStyle(added ? Color("AccentSage") : Color("AccentSage").opacity(0.6))
                                        .padding(10)
                                }
                                .onTapGesture { toggleRecipe(recipe) }
                                .padding(.horizontal, 16)
                        }
                    }
                    .id(viewModel.selectedCategory)
                    .padding(.vertical, 16)
                }
            }
            .background(Color("BackgroundPrimary"))
            .navigationTitle("Add to \(day.displayName)")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search recipes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.system(.body, design: .rounded, weight: .semibold))
                        .foregroundStyle(Color("AccentSage"))
                }
            }
            .task {
                await viewModel.loadRecipes(for: viewModel.selectedCategory, inventory: Array(allIngredients))
            }
        }
    }

    private func toggleRecipe(_ recipe: SpoonacularRecipe) {
        if let existing = menuEntries.first(where: {
            $0.recipeId == recipe.id && $0.dayOfWeek == day.rawValue
        }) {
            HapticFeedback.light()
            modelContext.delete(existing)
        } else {
            HapticFeedback.success()
            let entry = MenuEntry(recipe: recipe, day: day)
            modelContext.insert(entry)
        }
        try? modelContext.save()
    }
}

// MARK: - Day Card

struct DayMenuCardView: View {
    let day: WeekDay
    let entries: [MenuEntry]
    let allIngredients: [Ingredient]
    let onRemove: (MenuEntry) -> Void
    let onTap: (MenuEntry) -> Void
    var onClear: (() -> Void)? = nil
    var onAddMeal: (() -> Void)? = nil
    var onAddMissing: (([String]) -> Void)? = nil

    @State private var showingClearDayAlert = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Day header
            HStack(spacing: 8) {
                Text(day.displayName)
                    .font(.system(.headline, design: .rounded, weight: .bold))
                    .foregroundStyle(Color("TextPrimary"))
                Spacer()
                if !entries.isEmpty {
                    Text("\(entries.count) meal\(entries.count == 1 ? "" : "s")")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(Color("TextSecondary"))
                    // Add more meals button
                    Button {
                        HapticFeedback.light()
                        onAddMeal?()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(Color("AccentSage"))
                    }
                    .buttonStyle(.plain)
                    // Clear day button
                    Button {
                        showingClearDayAlert = true
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(Color("TextSecondary").opacity(0.5))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color("BackgroundSecondary"))
            .alert("Clear \(day.displayName)?", isPresented: $showingClearDayAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Clear", role: .destructive) {
                    onClear?()
                }
            } message: {
                Text("All meals planned for \(day.displayName) will be removed.")
            }

            // Meal rows
            if entries.isEmpty {
                HStack {
                    Image(systemName: "fork.knife")
                        .font(.system(size: 14))
                        .foregroundStyle(Color("TextSecondary").opacity(0.4))
                    Text("Nothing planned")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(Color("TextSecondary").opacity(0.5))
                    Spacer()
                    if onAddMeal != nil {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 16))
                            .foregroundStyle(Color("AccentSage").opacity(0.7))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.vertical, 18)
                .contentShape(Rectangle())
                .onTapGesture { onAddMeal?() }
            } else {
                ForEach(entries) { entry in
                    let missing = missingIngredients(for: entry)
                    HStack(spacing: 0) {
                        MenuMealRowView(
                            entry: entry,
                            missingIngredients: missing,
                            onAddMissing: missing.isEmpty ? nil : {
                                onAddMissing?(missing)
                            }
                        )
                        .contentShape(Rectangle())
                        .onTapGesture { onTap(entry) }

                        // Per-meal remove button
                        Button {
                            HapticFeedback.light()
                            onRemove(entry)
                        } label: {
                            Image(systemName: "trash")
                                .font(.system(size: 14))
                                .foregroundStyle(Color("DestructiveTerracotta").opacity(0.7))
                                .frame(width: 44, height: 44)
                        }
                        .buttonStyle(.plain)
                        .padding(.trailing, 8)
                    }
                    .overlay(
                        Divider()
                            .frame(maxWidth: .infinity, maxHeight: 0.5)
                            .background(Color("BackgroundSecondary")),
                        alignment: .bottom
                    )
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color("CardBackground"))
                .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    // MARK: - Missing ingredient computation

    private func missingIngredients(for entry: MenuEntry) -> [String] {
        guard !entry.ingredientNames.isEmpty else { return [] }

        let normalizedInventory = Set(
            allIngredients.map { IngredientNormalizer.normalize($0.name) }
        )

        return entry.ingredientNames.filter { name in
            // Skip pantry staples — they are never "missing" from a planning POV
            guard !PantryStaplesManager.isStapleSync(name) else { return false }
            let normalized = IngredientNormalizer.normalize(name)
            return !normalizedInventory.contains(normalized)
        }
    }
}

// MARK: - Meal Row

struct MenuMealRowView: View {
    let entry: MenuEntry
    var missingIngredients: [String] = []
    var onAddMissing: (() -> Void)? = nil

    // Whether we have ingredient data for this entry at all
    private var hasIngredientData: Bool { !entry.ingredientNames.isEmpty }
    private var isReadyToMake: Bool { hasIngredientData && missingIngredients.isEmpty }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Main meal info row
            HStack(spacing: 12) {
                CachedAsyncImage(url: URL(string: entry.recipeImage)) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().aspectRatio(contentMode: .fill)
                    case .failure, .empty:
                        Rectangle()
                            .fill(Color("BackgroundSecondary"))
                            .overlay(
                                Image(systemName: "fork.knife")
                                    .font(.system(size: 14))
                                    .foregroundStyle(Color("TextSecondary"))
                            )
                    }
                }
                .frame(width: 56, height: 56)
                .clipShape(RoundedRectangle(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.recipeTitle)
                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                        .foregroundStyle(Color("TextPrimary"))
                        .lineLimit(2)

                    if let minutes = entry.readyInMinutes, minutes > 0 {
                        Label("\(minutes) min", systemImage: "clock")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(Color("TextSecondary"))
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color("TextSecondary").opacity(0.4))
            }
            .padding(.leading, 16)
            .padding(.trailing, 4)
            .padding(.top, 12)
            .padding(.bottom, hasIngredientData ? 8 : 12)

            // Ingredient status bar
            if isReadyToMake {
                readyToMakePill
                    .padding(.leading, 16)
                    .padding(.trailing, 4)
                    .padding(.bottom, 12)
            } else if !missingIngredients.isEmpty {
                missingIngredientsRow
                    .padding(.leading, 16)
                    .padding(.trailing, 4)
                    .padding(.bottom, 12)
            }
        }
        .background(Color("CardBackground"))
    }

    // MARK: - Ready to Make Pill

    private var readyToMakePill: some View {
        HStack(spacing: 5) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 12))
            Text("Ready to make")
                .font(.system(.caption, design: .rounded, weight: .semibold))
        }
        .foregroundStyle(Color("AccentSage"))
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            Capsule()
                .fill(Color("AccentSage").opacity(0.12))
        )
    }

    // MARK: - Missing Ingredients Row

    private var missingIngredientsRow: some View {
        HStack(spacing: 8) {
            // Badge count
            Text("\(missingIngredients.count)")
                .font(.system(.caption2, design: .rounded, weight: .bold))
                .foregroundStyle(.white)
                .frame(minWidth: 18, minHeight: 18)
                .background(Circle().fill(Color("DestructiveTerracotta")))

            Text("missing")
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(Color("DestructiveTerracotta"))

            Spacer()

            // Add to list button
            Button {
                HapticFeedback.medium()
                onAddMissing?()
            } label: {
                HStack(spacing: 5) {
                    Image(systemName: "cart.badge.plus")
                        .font(.system(size: 11, weight: .semibold))
                    Text("Add to List")
                        .font(.system(.caption, design: .rounded, weight: .semibold))
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    Capsule()
                        .fill(Color("AccentSage"))
                )
            }
            .buttonStyle(.plain)
        }
    }
}
