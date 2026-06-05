import Foundation
import Observation

@Observable
class BrowseViewModel {
    var selectedCategory: BrowseCategory = .trending
    var browseRecipes: [SpoonacularRecipe] = []
    var isLoading: Bool = false
    var isLoadingMore: Bool = false
    var errorMessage: String? = nil

    // Per-category: how many results have been loaded (= offset for next fetch)
    private var pageOffsets: [BrowseCategory: Int] = [:]
    // Per-category: whether the API has more pages to give
    private var hasMorePerCategory: [BrowseCategory: Bool] = [:]
    // Raw (unmatched) accumulated results per category
    private var sessionCache: [BrowseCategory: [SpoonacularRecipe]] = [:]

    private let pageSize = 20

    /// True when the currently selected category still has pages to load.
    var hasMore: Bool {
        hasMorePerCategory[selectedCategory] ?? true
    }

    // MARK: - Initial Load (page 0)

    func loadRecipes(for category: BrowseCategory, inventory: [Ingredient], force: Bool = false) async {
        // Session cache hit — instant, no network (skip if force refresh)
        if !force, let hit = sessionCache[category] {
            browseRecipes = applyMatching(hit, inventory: inventory)
            return
        }

        // Clear cache for this category on force refresh
        if force {
            sessionCache.removeValue(forKey: category)
            pageOffsets.removeValue(forKey: category)
            hasMorePerCategory[category] = true
        }

        // Disk cache hit — fast, survives restarts (skip if force refresh)
        let cacheKey = "browse_v2_\(category.rawValue)"
        if !force, let diskHit = RecipeDiskCache.load(forKey: cacheKey) {
            sessionCache[category] = diskHit
            pageOffsets[category] = diskHit.count
            // Assume more pages exist unless the disk cache is less than a full page
            hasMorePerCategory[category] = diskHit.count >= pageSize
            browseRecipes = applyMatching(diskHit, inventory: inventory)
            return
        }

        // Real API — first page
        isLoading = true
        errorMessage = nil
        browseRecipes = []

        do {
            let raw = try await SpoonacularService.shared.fetchBrowseRecipes(
                category: category,
                inventoryIngredients: inventory,
                offset: 0
            )
            sessionCache[category] = raw
            pageOffsets[category] = raw.count
            hasMorePerCategory[category] = raw.count >= pageSize
            RecipeDiskCache.save(raw, forKey: cacheKey)
            browseRecipes = applyMatching(raw, inventory: inventory)
        } catch {
            errorMessage = "Couldn't load recipes. Please check your connection."
        }

        isLoading = false
    }

    // MARK: - Load More (next page)

    func loadMore(for category: BrowseCategory, inventory: [Ingredient]) async {
        guard !isLoadingMore, !isLoading, hasMorePerCategory[category] ?? true else { return }

        let offset = pageOffsets[category] ?? 0
        isLoadingMore = true

        do {
            let newRaw = try await SpoonacularService.shared.fetchBrowseRecipes(
                category: category,
                inventoryIngredients: inventory,
                offset: offset
            )

            var existing = sessionCache[category] ?? []
            existing.append(contentsOf: newRaw)
            sessionCache[category] = existing
            pageOffsets[category] = existing.count
            hasMorePerCategory[category] = newRaw.count >= pageSize

            // Keep disk cache current with all loaded pages
            let cacheKey = "browse_v2_\(category.rawValue)"
            RecipeDiskCache.save(existing, forKey: cacheKey)

            browseRecipes = applyMatching(existing, inventory: inventory)
        } catch {
            // Silent fail on pagination — user can scroll up and try again
        }

        isLoadingMore = false
    }

    // MARK: - Re-apply Matching (inventory changed, no network call)

    func refreshMatching(inventory: [Ingredient]) {
        guard let raw = sessionCache[selectedCategory] else { return }
        browseRecipes = applyMatching(raw, inventory: inventory)
    }

    // MARK: - Inventory Matching

    private func applyMatching(
        _ recipes: [SpoonacularRecipe],
        inventory: [Ingredient]
    ) -> [SpoonacularRecipe] {
        return recipes.map { recipe in
            var used: [RecipeIngredient] = []
            var missed: [RecipeIngredient] = []

            for ingredient in recipe.usedIngredients + recipe.missedIngredients {
                let isOwned = IngredientNormalizer.matches(ingredient, against: inventory)
                let isStaple = PantryStaplesManager.isStapleSync(ingredient.name)
                if isOwned || isStaple {
                    used.append(ingredient)
                } else {
                    missed.append(ingredient)
                }
            }

            return SpoonacularRecipe(
                id: recipe.id,
                title: recipe.title,
                image: recipe.image,
                readyInMinutes: recipe.readyInMinutes,
                servings: recipe.servings,
                usedIngredientCount: used.count,
                missedIngredientCount: missed.count,
                missedIngredients: missed,
                usedIngredients: used,
                spoonacularScore: recipe.spoonacularScore
            )
        }
    }
}
