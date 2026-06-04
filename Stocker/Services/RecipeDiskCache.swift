import Foundation

// MARK: - RecipeDiskCache
// Persists Spoonacular API responses to the system caches directory.
// Entries expire after `ttl` seconds (default 6 hours).
// Keyed strings are sanitized, so any alphanumeric key is safe.

struct RecipeDiskCache {

    static let ttl: TimeInterval = 6 * 60 * 60   // 6 hours

    // MARK: - Public API

    static func save(_ recipes: [SpoonacularRecipe], forKey key: String) {
        guard !recipes.isEmpty else { return }
        let wrapper = Wrapper(timestamp: Date(), recipes: recipes)
        if let data = try? JSONEncoder().encode(wrapper) {
            try? data.write(to: cacheURL(key), options: .atomic)
        }
    }

    /// Returns cached recipes if they exist and are within the TTL, otherwise nil.
    static func load(forKey key: String) -> [SpoonacularRecipe]? {
        guard let data = try? Data(contentsOf: cacheURL(key)),
              let wrapper = try? JSONDecoder().decode(Wrapper.self, from: data),
              !wrapper.recipes.isEmpty,
              Date().timeIntervalSince(wrapper.timestamp) < ttl
        else { return nil }
        return wrapper.recipes
    }

    /// Delete all cached recipe files (e.g. after a significant ingredient change).
    static func clearAll() {
        let dir = cacheDirectory
        guard let files = try? FileManager.default.contentsOfDirectory(
            at: dir, includingPropertiesForKeys: nil
        ) else { return }
        for file in files where file.lastPathComponent.hasPrefix("sr_") {
            try? FileManager.default.removeItem(at: file)
        }
    }

    // MARK: - Private

    private static var cacheDirectory: URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }

    private static func cacheURL(_ key: String) -> URL {
        let safe = key
            .lowercased()
            .components(separatedBy: .alphanumerics.inverted)
            .joined(separator: "_")
        return cacheDirectory.appendingPathComponent("sr_\(safe).json")
    }

    private struct Wrapper: Codable {
        let timestamp: Date
        let recipes: [SpoonacularRecipe]
    }
}
