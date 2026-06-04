import SwiftUI
import SwiftData
import Combine

struct BrowseView: View {
    @Binding var showingSettings: Bool
    @Environment(\.modelContext) private var modelContext
    @Query private var allIngredients: [Ingredient]
    @Query private var shoppingItems: [ShoppingItem]
    @State private var viewModel = BrowseViewModel()
    @State private var selectedRecipe: SpoonacularRecipe? = nil
    @State private var showingAddedToast: Bool = false
    @State private var toastMessage: String = ""
    @ObservedObject private var staplesManager = PantryStaplesManager.shared

    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundPrimary")
                    .ignoresSafeArea()

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
                        .padding(.vertical, 12)
                    }

                    // Recipe feed
                    if viewModel.isLoading {
                        Spacer()
                        ProgressView()
                        Spacer()
                    } else if viewModel.browseRecipes.isEmpty {
                        Spacer()
                        VStack(spacing: 16) {
                            Image(systemName: "fork.knife")
                                .font(.system(size: 52))
                                .foregroundStyle(Color("AccentSage").opacity(0.4))
                            Text("No recipes found")
                                .font(.system(.title3, design: .rounded, weight: .semibold))
                                .foregroundStyle(Color("TextSecondary"))
                        }
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(viewModel.browseRecipes) { recipe in
                                    SwipeToAddContainer {
                                        addMissingToShoppingList(recipe: recipe)
                                    } content: {
                                        BrowseFeedCardView(recipe: recipe)
                                            .onTapGesture {
                                                selectedRecipe = recipe
                                            }
                                    }
                                    .padding(.horizontal, 16)
                                }
                            }
                            .padding(.top, 8)
                            .padding(.bottom, 32)
                        }
                    }
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
                .animation(.spring(response: 0.4), value: showingAddedToast)
                .allowsHitTesting(false)
            }
            .navigationTitle("Browse")
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
            }
            .sheet(item: $selectedRecipe) { recipe in
                RecipeDetailView(recipe: recipe)
            }
            .task {
                await viewModel.loadRecipes(for: viewModel.selectedCategory, inventory: Array(allIngredients))
            }
            .onChange(of: allIngredients.count) {
                viewModel.refreshMatching(inventory: Array(allIngredients))
            }
            .onReceive(staplesManager.objectWillChange) { _ in
                viewModel.refreshMatching(inventory: Array(allIngredients))
            }
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
}

// MARK: - Browse Category Pill
struct BrowseCategoryPillView: View {
    let category: BrowseCategory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.system(size: 13, weight: .medium))
                Text(category.rawValue)
                    .font(.system(.subheadline, design: .rounded, weight: .medium))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? Color("AccentSage") : Color("BackgroundSecondary"))
            )
            .foregroundStyle(isSelected ? .white : Color("TextSecondary"))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Browse Feed Card
struct BrowseFeedCardView: View {
    let recipe: SpoonacularRecipe
    var onAddToMenu: (() -> Void)? = nil
    var onAddMissing: (() -> Void)? = nil

    var matchPercentage: Int {
        let total = recipe.usedIngredientCount + recipe.missedIngredientCount
        guard total > 0 else { return 0 }
        return Int((Double(recipe.usedIngredientCount) / Double(total)) * 100)
    }

    var body: some View {
        HStack(spacing: 14) {
            // Recipe image
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
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 8) {
                Text(recipe.title)
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(Color("TextPrimary"))
                    .lineLimit(2)

                HStack(spacing: 8) {
                    if let minutes = recipe.readyInMinutes, minutes > 0 {
                        Label("\(minutes) min", systemImage: "clock")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(Color("TextSecondary"))
                    }
                    if matchPercentage > 0 {
                        Text("\(matchPercentage)% match")
                            .font(.system(.caption, design: .rounded, weight: .semibold))
                            .foregroundStyle(matchPercentage == 100
                                             ? Color("AccentSage")
                                             : Color("DestructiveTerracotta"))
                    }
                }

                if recipe.missedIngredientCount > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "cart.badge.plus")
                            .font(.system(size: 10))
                            .foregroundStyle(Color("DestructiveTerracotta"))
                        Text("Need \(recipe.missedIngredientCount) ingredient\(recipe.missedIngredientCount == 1 ? "" : "s")")
                            .font(.system(.caption2, design: .rounded))
                            .foregroundStyle(Color("TextSecondary"))
                    }
                } else if recipe.usedIngredientCount > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(Color("AccentSage"))
                        Text("You have everything!")
                            .font(.system(.caption2, design: .rounded))
                            .foregroundStyle(Color("AccentSage"))
                    }
                }
            }

            Spacer()

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
