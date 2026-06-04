import SwiftUI
import SwiftData

enum IngredientSortOrder: String, CaseIterable {
    case alphabetical  = "A–Z"
    case recentlyAdded = "Recently Added"
    case mostQuantity  = "Most Quantity"

    var icon: String {
        switch self {
        case .alphabetical:  return "textformat.abc"
        case .recentlyAdded: return "clock.arrow.circlepath"
        case .mostQuantity:  return "arrow.down.circle"
        }
    }
}

struct InventoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var allIngredients: [Ingredient]
    @Query private var shoppingItems: [ShoppingItem]
    @State private var viewModel = InventoryViewModel()
    @State private var sortOrder: IngredientSortOrder = .alphabetical
    @State private var showingAddIngredient = false
    @State private var editingIngredient: Ingredient? = nil
    @State private var ingredientToDelete: Ingredient? = nil
    @State private var showingDeleteConfirmation = false
    @State private var showAddedToast: Bool = false
    @State private var addedToastMessage: String = ""
    @State private var usingIngredient: Ingredient? = nil
    @State private var addingToIngredient: Ingredient? = nil
    @State private var viewingNutritionFor: Ingredient? = nil
    @Binding var showingSettings: Bool

    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundPrimary")
                    .ignoresSafeArea()

                // Toast overlay
                VStack {
                    Spacer()
                    if showAddedToast {
                        HStack(spacing: 10) {
                            Image(systemName: "cart.fill.badge.plus")
                                .font(.system(size: 14))
                                .foregroundStyle(.white)
                            Text(addedToastMessage)
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
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: showAddedToast)
                .zIndex(1)

                VStack(spacing: 0) {
                    // Category picker
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(IngredientCategory.orderedCases, id: \.self) { category in
                                CategoryPillView(
                                    category: category,
                                    isSelected: viewModel.selectedCategory == category
                                ) {
                                    HapticFeedback.light()
                                    withAnimation(.spring(response: 0.3)) {
                                        viewModel.selectedCategory = category
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }

                    let baseIngredients = viewModel.ingredients(
                        for: viewModel.selectedCategory,
                        from: allIngredients
                    )
                    let ingredients: [Ingredient] = {
                        switch sortOrder {
                        case .alphabetical:
                            return baseIngredients  // ViewModel already sorts A-Z
                        case .recentlyAdded:
                            return baseIngredients.sorted { $0.dateAdded > $1.dateAdded }
                        case .mostQuantity:
                            return baseIngredients.sorted { $0.quantityAmount > $1.quantityAmount }
                        }
                    }()

                    if ingredients.isEmpty {
                        EmptyInventoryView(category: viewModel.selectedCategory)
                    } else {
                        List {
                            ForEach(ingredients) { ingredient in
                                IngredientCardView(
                                    ingredient: ingredient,
                                    onEdit: { editingIngredient = ingredient },
                                    onAddToList: { addIngredientToShoppingList(ingredient) },
                                    onUse: { usingIngredient = ingredient },
                                    onAdd: { addingToIngredient = ingredient },
                                    onInfo: { viewingNutritionFor = ingredient }
                                )
                                .listRowInsets(EdgeInsets())
                                .listRowBackground(Color("BackgroundPrimary"))
                                .listRowSeparator(.hidden)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        ingredientToDelete = ingredient
                                        showingDeleteConfirmation = true
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                    Button {
                                        editingIngredient = ingredient
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    .tint(Color("AccentSage"))
                                }
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        .background(Color("BackgroundPrimary"))
                        .padding(.bottom, 32)
                    }
                }
            }
            .navigationTitle("Ingredients")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $viewModel.searchText, prompt: "Search ingredients...")
            .onAppear {
                // Migrate any legacy .other ingredients to .pantry (one-time, safe)
                let legacyItems = allIngredients.filter { $0.category == .other }
                if !legacyItems.isEmpty {
                    for item in legacyItems { item.category = .pantry }
                    try? modelContext.save()
                }
            }
            .toolbar {
                // Settings gear — top left, persists on all tabs via MainTabView
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        HapticFeedback.light()
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(Color("TextSecondary"))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 12) {
                        Menu {
                            ForEach(IngredientSortOrder.allCases, id: \.self) { order in
                                Button {
                                    HapticFeedback.light()
                                    sortOrder = order
                                } label: {
                                    Label(order.rawValue, systemImage: order.icon)
                                    if sortOrder == order {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        } label: {
                            Image(systemName: "arrow.up.arrow.down")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundStyle(sortOrder == .alphabetical
                                                 ? Color("TextSecondary")
                                                 : Color("AccentSage"))
                        }
                        Button {
                            HapticFeedback.medium()
                            showingAddIngredient = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 22))
                                .foregroundStyle(Color("AccentSage"))
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddIngredient) {
                AddIngredientView()
            }
            .sheet(item: $editingIngredient) { ingredient in
                EditIngredientView(ingredient: ingredient)
            }
            .sheet(item: $usingIngredient) { ingredient in
                UseIngredientSheet(ingredient: ingredient, isAddMode: false)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.hidden)
            }
            .sheet(item: $addingToIngredient) { ingredient in
                UseIngredientSheet(ingredient: ingredient, isAddMode: true)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.hidden)
            }
            .sheet(item: $viewingNutritionFor) { ingredient in
                IngredientInfoSheet(ingredient: ingredient)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
            .confirmationDialog(
                "Delete \(ingredientToDelete?.name ?? "this ingredient")?",
                isPresented: $showingDeleteConfirmation,
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) {
                    HapticFeedback.warning()
                    if let ingredient = ingredientToDelete {
                        viewModel.deleteIngredient(ingredient, context: modelContext)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This cannot be undone.")
            }
        }
    }

    // MARK: - Add to Shopping List
    private func addIngredientToShoppingList(_ ingredient: Ingredient) {
        // Check if already on list — just note it, don't duplicate
        if shoppingItems.contains(where: {
            $0.name.lowercased() == ingredient.name.lowercased()
        }) {
            addedToastMessage = "\(ingredient.name) is already on your list"
            HapticFeedback.light()
        } else {
            let item = ShoppingItem(
                name: ingredient.name,
                quantityAmount: 1,
                quantityUnit: .item,
                category: ingredient.category
            )
            modelContext.insert(item)
            try? modelContext.save()
            addedToastMessage = "\(ingredient.name) added to shopping list"
            HapticFeedback.success()
        }

        showToast($showAddedToast)
    }
}

// MARK: - Category Pill
struct CategoryPillView: View {
    let category: IngredientCategory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(category.emoji)
                    .font(.system(size: 14))
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

// MARK: - Empty State
struct EmptyInventoryView: View {
    let category: IngredientCategory

    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Text(category.emoji)
                .font(.system(size: 52))
            Text("No items in \(category.rawValue)")
                .font(.system(.title3, design: .rounded, weight: .semibold))
                .foregroundStyle(Color("TextSecondary"))
            Text("Tap + to add your first ingredient")
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(Color("TextSecondary").opacity(0.7))
            Spacer()
        }
    }
}
