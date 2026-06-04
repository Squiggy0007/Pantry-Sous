import Foundation
import Observation

@Observable
class RecipesViewModel {
    var makeNowRecipes: [SpoonacularRecipe] = []
    var almostThereRecipes: [SpoonacularRecipe] = []
    var isLoading: Bool = false
    var errorMessage: String? = nil
    var hasLoadedOnce: Bool = false
    var cachedAllRecipes: [SpoonacularRecipe] = []
    var offset: Int = 0
    var hasMore: Bool = true
    // Store the stable key string itself (not a Swift hashValue) so it persists across launches
    var lastIngredientKey: String = ""

    // MARK: - Stable Cache Key
    // Swift's hashValue is randomised per process — never use it as a disk cache key.
    // Instead, sort ingredients alphabetically and build a deterministic hex digest.
    private func stableCacheKey(for ingredients: [Ingredient]) -> String {
        let normalizedNames = ingredients
            .flatMap { IngredientNormalizer.normalizedNames(for: $0.name) }
            .map { $0.lowercased() }
            .sorted()
        let raw = "recipes_v4|" + normalizedNames.joined(separator: ",")
        // djb2 hash — deterministic across launches
        let hash = raw.utf8.reduce(UInt64(5381)) { (($0 << 5) &+ $0) &+ UInt64($1) }
        return String(hash, radix: 16)
    }

    // MARK: - Load Recipes
    func loadRecipes(ingredients: [Ingredient], force: Bool = false) async {
        guard !ingredients.isEmpty else {
            errorMessage = "Add some ingredients to your inventory first!"
            return
        }

        let currentKey = stableCacheKey(for: ingredients)

        // Skip if nothing changed and we're not forcing a reload
        if hasLoadedOnce && !force && currentKey == lastIngredientKey {
            return
        }

        // Reset session cache if ingredients changed
        if currentKey != lastIngredientKey {
            cachedAllRecipes = []
            offset = 0
            hasMore = true
        }

        // ── 1. Disk cache (skip on Load More — we want fresh page data) ──
        if offset == 0 && !force {
            let cacheKey = "recipes_\(currentKey)"
            if let diskHit = RecipeDiskCache.load(forKey: cacheKey) {
                cachedAllRecipes = diskHit
                categorizeRecipes()
                hasLoadedOnce = true
                lastIngredientKey = currentKey
                return  // served from disk — no API call needed
            }
        }

        // ── 2. Real API call ──
        isLoading = true
        errorMessage = nil

        do {
            let recipes = try await SpoonacularService.shared.fetchQualityRecipes(
                ingredients: ingredients,
                offset: offset
            )

            let newRecipes = recipes.filter { newRecipe in
                !cachedAllRecipes.contains(where: { $0.id == newRecipe.id })
            }

            cachedAllRecipes.append(contentsOf: newRecipes)
            hasMore = recipes.count == 20
            categorizeRecipes()
            hasLoadedOnce = true
            lastIngredientKey = currentKey

            // Persist page 1 results to disk
            if offset == 0 {
                RecipeDiskCache.save(cachedAllRecipes, forKey: "recipes_\(currentKey)")
            }

        } catch {
            errorMessage = "Couldn't load recipes. Please check your connection."
        }

        isLoading = false
    }

    // MARK: - Load More
    func loadMore(ingredients: [Ingredient]) async {
        offset += 20
        await loadRecipes(ingredients: ingredients, force: true)
    }

    // MARK: - Categorize
    private func categorizeRecipes() {
        makeNowRecipes = cachedAllRecipes.filter { recipe in
            recipe.missedIngredientCount == 0
        }

        // Show every useful partial match. Browse is for exploring broadly;
        // Recipes should surface anything connected to the user's inventory.
        almostThereRecipes = cachedAllRecipes
            .filter { recipe in
                let total = recipe.usedIngredientCount + recipe.missedIngredientCount
                guard total > 0 else { return false }
                return recipe.usedIngredientCount > 0 && recipe.missedIngredientCount > 0
            }
            .sorted { a, b in
                let totalA = a.usedIngredientCount + a.missedIngredientCount
                let totalB = b.usedIngredientCount + b.missedIngredientCount
                let pctA = totalA > 0 ? Double(a.usedIngredientCount) / Double(totalA) : 0
                let pctB = totalB > 0 ? Double(b.usedIngredientCount) / Double(totalB) : 0
                // Secondary sort: fewer missing ingredients first when percentages tie
                if abs(pctA - pctB) < 0.001 {
                    return a.missedIngredientCount < b.missedIngredientCount
                }
                return pctA > pctB
            }
    }

    // MARK: - Reset
    func reset() {
        makeNowRecipes = []
        almostThereRecipes = []
        cachedAllRecipes = []
        offset = 0
        hasMore = true
        hasLoadedOnce = false
        errorMessage = nil
        lastIngredientKey = ""
    }
}
