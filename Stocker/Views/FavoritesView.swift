import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Binding var showingSettings: Bool
    @Environment(\.modelContext) private var modelContext
    @Query private var savedRecipes: [SavedRecipe]
    @Query private var customRecipes: [CustomRecipe]
    @State private var selectedRecipe: SavedRecipe? = nil
    @State private var selectedCustomRecipe: CustomRecipe? = nil
    @State private var showingCreateRecipe = false
    @State private var selectedSegment: Int = 0   // 0 = Saved, 1 = My Recipes

    // Group saved recipes by meal category, preserving display order
    var groupedSaved: [(MealCategory, [SavedRecipe])] {
        let groups = Dictionary(grouping: savedRecipes) { $0.mealCategory }
        return MealCategory.orderedCases.compactMap { category in
            guard let recipes = groups[category], !recipes.isEmpty else { return nil }
            return (category, recipes.sorted { $0.dateSaved > $1.dateSaved })
        }
    }

    var groupedCustom: [(MealCategory, [CustomRecipe])] {
        let groups = Dictionary(grouping: customRecipes) { $0.mealCategory }
        return MealCategory.orderedCases.compactMap { category in
            guard let recipes = groups[category], !recipes.isEmpty else { return nil }
            return (category, recipes.sorted { $0.dateCreated > $1.dateCreated })
        }
    }

    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundPrimary")
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Segment picker
                    Picker("", selection: $selectedSegment) {
                        Text("Saved").tag(0)
                        Text("My Recipes").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)

                    // Content
                    if selectedSegment == 0 {
                        savedRecipesContent
                    } else {
                        myRecipesContent
                    }
                }
            }
            .navigationTitle("Favorites")
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
                if selectedSegment == 1 {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            HapticFeedback.medium()
                            showingCreateRecipe = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 20))
                                .foregroundStyle(Color("AccentSage"))
                        }
                    }
                }
            }
            .sheet(item: $selectedRecipe) { recipe in
                SavedRecipeDetailView(recipe: recipe)
            }
            .sheet(item: $selectedCustomRecipe) { recipe in
                CustomRecipeDetailView(recipe: recipe)
            }
            .sheet(isPresented: $showingCreateRecipe) {
                CreateRecipeView()
            }
        }
    }

    // MARK: - Saved Recipes Tab
    @ViewBuilder
    private var savedRecipesContent: some View {
        if savedRecipes.isEmpty {
            EmptyFavoritesView()
        } else {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    ForEach(groupedSaved, id: \.0) { category, recipes in
                        categorySection(category: category) {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(recipes) { recipe in
                                    FavoriteCardView(recipe: recipe)
                                        .onTapGesture { selectedRecipe = recipe }
                                        .contextMenu {
                                            Menu {
                                                ForEach(MealCategory.allCases.filter { $0 != recipe.mealCategory }, id: \.self) { cat in
                                                    Button {
                                                        recipe.mealCategory = cat
                                                        try? modelContext.save()
                                                    } label: {
                                                        Label("\(cat.emoji) \(cat.rawValue)", systemImage: "")
                                                    }
                                                }
                                            } label: {
                                                Label("Move to…", systemImage: "folder")
                                            }
                                            Divider()
                                            Button(role: .destructive) {
                                                deleteRecipe(recipe)
                                            } label: {
                                                Label("Remove from Favorites", systemImage: "heart.slash")
                                            }
                                        }
                                }
                            }
                        }
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
        }
    }

    // MARK: - My Recipes Tab
    @ViewBuilder
    private var myRecipesContent: some View {
        if customRecipes.isEmpty {
            EmptyCustomRecipesView {
                showingCreateRecipe = true
            }
        } else {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    ForEach(groupedCustom, id: \.0) { category, recipes in
                        categorySection(category: category) {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(recipes) { recipe in
                                    CustomRecipeCardView(recipe: recipe)
                                        .onTapGesture { selectedCustomRecipe = recipe }
                                        .contextMenu {
                                            Button(role: .destructive) {
                                                modelContext.delete(recipe)
                                                try? modelContext.save()
                                            } label: {
                                                Label("Delete Recipe", systemImage: "trash")
                                            }
                                        }
                                }
                            }
                        }
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
        }
    }

    // MARK: - Shared Section Header Builder
    @ViewBuilder
    private func categorySection<Content: View>(
        category: MealCategory,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Text(category.emoji).font(.system(size: 18))
                Text(category.rawValue)
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundStyle(Color("TextPrimary"))
                Spacer()
            }
            .padding(.horizontal, 16)
            content().padding(.horizontal, 16)
        }
    }

    private func deleteRecipe(_ recipe: SavedRecipe) {
        modelContext.delete(recipe)
        try? modelContext.save()
    }
}

// MARK: - Favorite Card
struct FavoriteCardView: View {
    let recipe: SavedRecipe

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CachedAsyncImage(url: URL(string: recipe.imageURL)) { phase in
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
                                .font(.system(size: 24))
                                .foregroundStyle(Color("TextSecondary"))
                        )
                case .empty:
                    Rectangle()
                        .fill(Color("BackgroundSecondary"))
                        .overlay(ProgressView())
                }
            }
            .frame(height: 120)
            .clipped()

            VStack(alignment: .leading, spacing: 6) {
                Text(recipe.title)
                    .font(.system(.caption, design: .rounded, weight: .semibold))
                    .foregroundStyle(Color("TextPrimary"))
                    .lineLimit(2)

                HStack(spacing: 6) {
                    Image(systemName: "clock")
                        .font(.system(size: 10))
                    Text("\(recipe.readyInMinutes) min")
                        .font(.system(.caption2, design: .rounded))
                }
                .foregroundStyle(Color("TextSecondary"))
            }
            .padding(10)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("CardBackground"))
                .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Custom Recipe Card
struct CustomRecipeCardView: View {
    let recipe: CustomRecipe

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Show user photo if available, otherwise emoji placeholder
            if let imageData = recipe.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 120)
                    .clipped()
            } else {
                ZStack {
                    Rectangle()
                        .fill(Color("BackgroundSecondary"))
                    Text(recipe.mealCategory.emoji)
                        .font(.system(size: 40))
                }
                .frame(height: 120)
                .clipped()
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(recipe.title)
                    .font(.system(.caption, design: .rounded, weight: .semibold))
                    .foregroundStyle(Color("TextPrimary"))
                    .lineLimit(2)

                HStack(spacing: 6) {
                    Image(systemName: "clock")
                        .font(.system(size: 10))
                    Text("\(recipe.readyInMinutes) min")
                        .font(.system(.caption2, design: .rounded))
                    if recipe.isPrivate {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 9))
                    }
                }
                .foregroundStyle(Color("TextSecondary"))
            }
            .padding(10)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("CardBackground"))
                .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Empty Custom Recipes
struct EmptyCustomRecipesView: View {
    let onCreate: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "pencil.and.list.clipboard")
                .font(.system(size: 52))
                .foregroundStyle(Color("AccentSage").opacity(0.4))
            Text("No custom recipes yet")
                .font(.system(.title3, design: .rounded, weight: .semibold))
                .foregroundStyle(Color("TextSecondary"))
            Text("Create your own recipes and cross-reference them with your pantry")
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(Color("TextSecondary").opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Button { onCreate() } label: {
                HStack(spacing: 6) {
                    Image(systemName: "plus.circle.fill")
                    Text("Create Recipe")
                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Capsule().fill(Color("AccentSage")))
                .foregroundStyle(.white)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Empty Favorites
struct EmptyFavoritesView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.slash")
                .font(.system(size: 52))
                .foregroundStyle(Color("AccentSage").opacity(0.4))
            Text("No saved recipes yet")
                .font(.system(.title3, design: .rounded, weight: .semibold))
                .foregroundStyle(Color("TextSecondary"))
            Text("Tap the heart on any recipe to save it here")
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(Color("TextSecondary").opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
