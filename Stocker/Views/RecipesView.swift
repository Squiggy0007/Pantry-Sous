import SwiftUI
import SwiftData
import Combine

struct RecipesView: View {
    @Binding var showingSettings: Bool
    @Environment(\.modelContext) private var modelContext
    @Query private var allIngredients: [Ingredient]
    @Query private var shoppingItems: [ShoppingItem]
    @Query private var customRecipes: [CustomRecipe]
    @State private var viewModel = RecipesViewModel()
    @State private var browseViewModel = BrowseViewModel()
    @State private var selectedRecipe: SpoonacularRecipe? = nil
    @State private var selectedCustomRecipe: CustomRecipe? = nil
    @State private var menuPickerRecipe: SpoonacularRecipe? = nil
    @State private var showingAddedToast: Bool = false
    @State private var toastMessage: String = ""
    @State private var searchText: String = ""
    @State private var selectedSegment: Int = 0   // 0 = Recipes, 1 = Browse
    @ObservedObject private var staplesManager = PantryStaplesManager.shared

    var filteredMakeNow: [SpoonacularRecipe] {
        searchText.isEmpty ? viewModel.makeNowRecipes
            : viewModel.makeNowRecipes.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }

    var filteredAlmostThere: [SpoonacularRecipe] {
        searchText.isEmpty ? viewModel.almostThereRecipes
            : viewModel.almostThereRecipes.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }

    /// Custom recipes where every non-staple ingredient is in the user's inventory.
    var readyCustomRecipes: [CustomRecipe] {
        let inventoryNames = allIngredients.map { $0.name }
        return customRecipes.filter { recipe in
            let nonStaples = recipe.ingredients.filter { line in
                !staplesManager.isActiveStaple(IngredientNormalizer.extractIngredientName(line))
            }
            guard !nonStaples.isEmpty else { return true }
            return nonStaples.allSatisfy { line in
                let name = IngredientNormalizer.extractIngredientName(line)
                return !name.isEmpty && IngredientNormalizer.matches(name, against: inventoryNames)
            }
        }.filter {
            searchText.isEmpty || $0.title.localizedCaseInsensitiveContains(searchText)
        }
    }

    var currentBrowseRecipes: [SpoonacularRecipe] {
        let all = browseViewModel.browseRecipes
        guard !searchText.isEmpty else { return all }
        return all.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            // VStack directly inside NavigationStack → NavigationStack constrains the height
            // → header takes its natural height → ScrollView fills the rest → scrolling works.
            VStack(spacing: 0) {
                pinnedHeader

                Group {
                    if selectedSegment == 0 {
                        recipesContent
                    } else {
                        browseContent
                    }
                }
                .overlay {
                    if selectedSegment == 0 {
                        if allIngredients.isEmpty {
                            EmptyIngredientsView()
                        } else if viewModel.isLoading && !viewModel.hasLoadedOnce {
                            LoadingRecipesView()
                        } else if let error = viewModel.errorMessage {
                            ErrorRecipesView(message: error) {
                                Task { await viewModel.loadRecipes(ingredients: allIngredients, force: true) }
                            }
                        }
                    }
                }
            }
            .background(Color("BackgroundPrimary"))
            .overlay(alignment: .bottom) {
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
                    .allowsHitTesting(false)
                }
            }
            .animation(.spring(response: 0.4), value: showingAddedToast)
            .navigationTitle("Recipes")
            .navigationBarTitleDisplayMode(.inline)
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
                        HapticFeedback.medium()
                        if selectedSegment == 0 {
                            Task {
                                await viewModel.loadRecipes(ingredients: allIngredients, force: true)
                            }
                        } else {
                            // Clear browse cache for current category and reload fresh
                            Task {
                                await browseViewModel.loadRecipes(
                                    for: browseViewModel.selectedCategory,
                                    inventory: allIngredients,
                                    force: true
                                )
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Color("AccentSage"))
                    }
                }
            }
            .task {
                await viewModel.loadRecipes(ingredients: allIngredients)
                await browseViewModel.loadRecipes(for: browseViewModel.selectedCategory, inventory: allIngredients)
            }
            .onChange(of: allIngredients.count) { _, _ in
                Task { await viewModel.loadRecipes(ingredients: allIngredients) }
                browseViewModel.refreshMatching(inventory: allIngredients)
            }
            .onChange(of: allIngredients.map { $0.name }.joined()) { _, _ in
                Task { await viewModel.loadRecipes(ingredients: allIngredients) }
                browseViewModel.refreshMatching(inventory: allIngredients)
            }
            .onChange(of: browseViewModel.selectedCategory) { _, category in
                Task { await browseViewModel.loadRecipes(for: category, inventory: allIngredients) }
            }
            .onReceive(staplesManager.objectWillChange) { _ in
                Task { await viewModel.loadRecipes(ingredients: allIngredients, force: true) }
                browseViewModel.refreshMatching(inventory: allIngredients)
            }
            .sheet(item: $selectedRecipe) { recipe in RecipeDetailView(recipe: recipe) }
            .sheet(item: $selectedCustomRecipe) { recipe in CustomRecipeDetailView(recipe: recipe) }
            .sheet(item: $menuPickerRecipe) { recipe in AddToMenuSheet(recipe: recipe) }
        }
    }

    // MARK: - Add Missing to Shopping List
    private func addMissingToShoppingList(recipe: SpoonacularRecipe) {
        var addedCount = 0

        for ingredient in recipe.missedIngredients {
            if staplesManager.isActiveStaple(ingredient.name) { continue }

            let (finalAmount, finalUnit) = UnitConversionHelper.resolveShoppingQuantity(
                ingredientName: ingredient.name,
                amount: ingredient.amount ?? 1,
                unitString: ingredient.unit ?? ""
            )

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

    // MARK: - Pinned Header (always visible, never scrolls away)
    private var pinnedHeader: some View {
        VStack(spacing: 0) {
            // Segment picker
            Picker("", selection: $selectedSegment) {
                Text("Recipes").tag(0)
                Text("Browse").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 6)

            // Search bar
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 15))
                    .foregroundStyle(Color("TextSecondary"))
                TextField("Search recipes", text: $searchText)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(Color("TextPrimary"))
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 15))
                            .foregroundStyle(Color("TextSecondary"))
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 9)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color("BackgroundSecondary"))
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 8)

            // Browse category pills — only shown in Browse segment
            if selectedSegment == 1 {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(BrowseCategory.allCases, id: \.self) { category in
                            BrowseCategoryPillView(
                                category: category,
                                isSelected: browseViewModel.selectedCategory == category
                            ) {
                                HapticFeedback.light()
                                withAnimation(.spring(response: 0.3)) {
                                    browseViewModel.selectedCategory = category
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                }
            }

            Divider()
        }
        .background(Color("BackgroundPrimary"))
    }

    // MARK: - Recipes Content
    private var recipesContent: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 24) {

                // My Recipes — Ready to Make
                if !readyCustomRecipes.isEmpty {
                    SectionHeaderView(
                        title: "Your Recipes",
                        subtitle: "Custom recipes you can make right now",
                        icon: "person.crop.circle.badge.checkmark",
                        color: Color("AccentSage"),
                        count: readyCustomRecipes.count
                    )

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(readyCustomRecipes) { recipe in
                                CustomRecipeReadyCardView(recipe: recipe)
                                    .frame(width: 240)
                                    .onTapGesture { selectedCustomRecipe = recipe }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }

                // Ready to Make Section
                if !filteredMakeNow.isEmpty {
                    SectionHeaderView(
                        title: "Ready to Make",
                        subtitle: "You have all the ingredients",
                        icon: "checkmark.circle.fill",
                        color: Color("AccentSage"),
                        count: filteredMakeNow.count
                    )

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(filteredMakeNow) { recipe in
                                RecipeCardView(
                                    recipe: recipe,
                                    totalIngredients: recipe.usedIngredientCount + recipe.missedIngredientCount,
                                    onAddToMenu: { menuPickerRecipe = recipe }
                                )
                                .frame(width: 280)
                                .onTapGesture {
                                    selectedRecipe = recipe
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }

                // Almost There Section
                if !filteredAlmostThere.isEmpty {
                    SectionHeaderView(
                        title: "Almost There",
                        subtitle: filteredAlmostThere.count == 1
                            ? "1 recipe needs a few more ingredients"
                            : "\(filteredAlmostThere.count) recipes need a few more ingredients",
                        icon: "cart.badge.plus",
                        color: Color("DestructiveTerracotta"),
                        count: filteredAlmostThere.count
                    )

                    LazyVStack(spacing: 16) {
                        ForEach(filteredAlmostThere) { recipe in
                            RecipeFeedCardView(
                                recipe: recipe,
                                totalIngredients: recipe.usedIngredientCount + recipe.missedIngredientCount,
                                onAddToMenu: { menuPickerRecipe = recipe },
                                onAddMissing: recipe.missedIngredientCount > 0
                                    ? { addMissingToShoppingList(recipe: recipe) }
                                    : nil
                            )
                            .onTapGesture { selectedRecipe = recipe }
                            .padding(.horizontal, 16)
                        }
                    }
                }

                // No recipes found
                let hasResults = !filteredMakeNow.isEmpty || !filteredAlmostThere.isEmpty
                if !hasResults && viewModel.hasLoadedOnce {
                    if !searchText.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 40))
                                .foregroundStyle(Color("TextSecondary").opacity(0.4))
                            Text("No recipes match \"\(searchText)\"")
                                .font(.system(.subheadline, design: .rounded))
                                .foregroundStyle(Color("TextSecondary"))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 60)
                    } else {
                        NoRecipesView()
                    }
                }

                // Load More button
                if viewModel.hasMore && viewModel.hasLoadedOnce {
                    Button {
                        Task {
                            await viewModel.loadMore(ingredients: allIngredients)
                        }
                    } label: {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Load More Recipes")
                                    .font(.system(.body, design: .rounded, weight: .semibold))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color("AccentSage"))
                        )
                        .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 32)
                }
            }
            .padding(.top, 8)
            .frame(maxWidth: .infinity)
        }
        .refreshable {
            await viewModel.loadRecipes(ingredients: allIngredients, force: true)
        }
    }

    // MARK: - Browse Content
    private var browseContent: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if browseViewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 60)
                } else if currentBrowseRecipes.isEmpty && !searchText.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 40))
                            .foregroundStyle(Color("TextSecondary").opacity(0.4))
                        Text("No recipes match \"\(searchText)\"")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundStyle(Color("TextSecondary"))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 60)
                } else {
                    ForEach(Array(currentBrowseRecipes.enumerated()), id: \.element.id) { index, recipe in
                        BrowseFeedCardView(
                            recipe: recipe,
                            onAddToMenu: { menuPickerRecipe = recipe },
                            onAddMissing: recipe.missedIngredientCount > 0
                                ? { addMissingToShoppingList(recipe: recipe) }
                                : nil
                        )
                        .onTapGesture { selectedRecipe = recipe }
                        .padding(.horizontal, 16)
                        // Trigger next page when the second-to-last card appears
                        .onAppear {
                            if index == currentBrowseRecipes.count - 2 {
                                Task {
                                    await browseViewModel.loadMore(
                                        for: browseViewModel.selectedCategory,
                                        inventory: allIngredients
                                    )
                                }
                            }
                        }
                    }

                    // Load-more footer
                    if browseViewModel.isLoadingMore {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                    } else if !browseViewModel.hasMore && !currentBrowseRecipes.isEmpty {
                        Text("You've seen it all!")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(Color("TextSecondary"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                    }
                }
            }
            .id(browseViewModel.selectedCategory)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Feed Card
struct RecipeFeedCardView: View {
    let recipe: SpoonacularRecipe
    let totalIngredients: Int
    var onAddToMenu: (() -> Void)? = nil
    var onAddMissing: (() -> Void)? = nil

    var matchPercentage: Int {
        let total = recipe.usedIngredientCount + recipe.missedIngredientCount
        guard total > 0 else { return 0 }
        return Int((Double(recipe.usedIngredientCount) / Double(total)) * 100)
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            CachedAsyncImage(url: URL(string: recipe.image)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure(_):
                    Rectangle()
                        .fill(Color("BackgroundSecondary"))
                        .overlay(
                            Image(systemName: "fork.knife")
                                .font(.system(size: 20))
                                .foregroundStyle(Color("TextSecondary"))
                        )
                case .empty:
                    Rectangle()
                        .fill(Color("BackgroundSecondary"))
                        .overlay(ProgressView())
                }
            }
            .frame(width: 88, height: 88)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 7) {
                Text(recipe.title)
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(Color("TextPrimary"))
                    .lineLimit(2)

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        if let minutes = recipe.readyInMinutes, minutes > 0 {
                            Label("\(minutes) min", systemImage: "clock")
                                .font(.system(.caption, design: .rounded))
                                .foregroundStyle(Color("TextSecondary"))
                                .lineLimit(1)
                                .fixedSize(horizontal: true, vertical: false)
                        }

                        if let score = recipe.spoonacularScore, score > 0 {
                            HStack(spacing: 3) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 9))
                                Text("\(Int(score))")
                                    .font(.system(.caption2, design: .rounded, weight: .bold))
                            }
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color("AccentSage").opacity(0.15))
                            )
                            .foregroundStyle(Color("AccentSage"))
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                        }
                    }

                    Text("\(matchPercentage)% match")
                        .font(.system(.caption, design: .rounded, weight: .semibold))
                        .foregroundStyle(Color("DestructiveTerracotta"))
                        .lineLimit(1)
                }

                if recipe.missedIngredientCount > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "cart.badge.plus")
                            .font(.system(size: 10))
                            .foregroundStyle(Color("DestructiveTerracotta"))
                        Text("Missing: \(recipe.missedIngredients.map { $0.name }.joined(separator: ", "))")
                            .font(.system(.caption2, design: .rounded))
                            .foregroundStyle(Color("TextSecondary"))
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }

            Spacer(minLength: 0)

            VStack(spacing: 8) {
                if let onAddMissing {
                    Button {
                        HapticFeedback.success()
                        onAddMissing()
                    } label: {
                        Image(systemName: "cart.badge.plus")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Color("DestructiveTerracotta"))
                            .padding(6)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color("DestructiveTerracotta").opacity(0.12))
                            )
                    }
                    .buttonStyle(.plain)
                }

                if let onAddToMenu {
                    Button {
                        HapticFeedback.light()
                        onAddToMenu()
                    } label: {
                        Image(systemName: "calendar.badge.plus")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Color("AccentSage"))
                            .padding(6)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color("AccentSage").opacity(0.12))
                            )
                    }
                    .buttonStyle(.plain)
                }

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color("TextSecondary").opacity(0.5))
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color("CardBackground"))
                .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
        )
    }
}

// MARK: - Section Header
struct SectionHeaderView: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    var count: Int? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(color)
                Text(title)
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundStyle(Color("TextPrimary"))
                if let count {
                    Text("\(count)")
                        .font(.system(.caption, design: .rounded, weight: .bold))
                        .foregroundStyle(color)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(color.opacity(0.12)))
                }
            }
            Text(subtitle)
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(Color("TextSecondary"))
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Empty States
struct EmptyIngredientsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("🥦")
                .font(.system(size: 52))
            Text("Your ingredients are empty")
                .font(.system(.title3, design: .rounded, weight: .semibold))
                .foregroundStyle(Color("TextSecondary"))
            Text("Add ingredients in the Ingredients tab to discover recipes")
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(Color("TextSecondary").opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}

struct LoadingRecipesView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(Color("AccentSage"))
            Text("Finding recipes...")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(Color("TextSecondary"))
        }
    }
}

struct ErrorRecipesView: View {
    let message: String
    let retry: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 52))
                .foregroundStyle(Color("DestructiveTerracotta").opacity(0.6))
            Text(message)
                .font(.system(.body, design: .rounded))
                .foregroundStyle(Color("TextSecondary"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Button(action: retry) {
                Text("Try Again")
                    .font(.system(.body, design: .rounded, weight: .semibold))
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color("AccentSage"))
                    )
                    .foregroundStyle(.white)
            }
        }
    }
}

struct NoRecipesView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "fork.knife")
                .font(.system(size: 52))
                .foregroundStyle(Color("AccentSage").opacity(0.4))
            Text("No recipes found")
                .font(.system(.title3, design: .rounded, weight: .semibold))
                .foregroundStyle(Color("TextSecondary"))
            Text("Try adding more ingredients or tap refresh")
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(Color("TextSecondary").opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

// MARK: - Custom Recipe Ready Card
struct CustomRecipeReadyCardView: View {
    let recipe: CustomRecipe

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Photo or placeholder
            if let data = recipe.imageData, let img = UIImage(data: data) {
                Image(uiImage: img)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 130)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color("BackgroundSecondary"))
                    .frame(height: 130)
                    .overlay(
                        Image(systemName: "fork.knife")
                            .font(.system(size: 28))
                            .foregroundStyle(Color("TextSecondary").opacity(0.4))
                    )
            }

            VStack(alignment: .leading, spacing: 6) {
                // "My Recipe" badge
                HStack(spacing: 4) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 10))
                    Text("My Recipe")
                        .font(.system(.caption2, design: .rounded, weight: .bold))
                }
                .foregroundStyle(Color("AccentSage"))
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(Capsule().fill(Color("AccentSage").opacity(0.12)))

                Text(recipe.title)
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(Color("TextPrimary"))
                    .lineLimit(2)

                if recipe.readyInMinutes > 0 {
                    Label("\(recipe.readyInMinutes) min", systemImage: "clock")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(Color("TextSecondary"))
                }
            }
            .padding(12)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("CardBackground"))
                .shadow(color: .black.opacity(0.07), radius: 6, x: 0, y: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
