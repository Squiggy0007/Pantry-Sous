import Foundation
import StoreKit

enum FeatureLimits {
    static let freeFavoriteLimit = 20
    static let freeCustomRecipeLimit = 5

    static var isPlusUnlocked: Bool {
        isDebugBuild ||
        UserDefaults.standard.bool(forKey: testingEnvironmentKey) ||
        UserDefaults.standard.bool(forKey: plusUnlockedKey)
    }

    static func canSaveFavorite(currentCount: Int) -> Bool {
        isPlusUnlocked || currentCount < freeFavoriteLimit
    }

    static func canCreateCustomRecipe(currentCount: Int) -> Bool {
        isPlusUnlocked || currentCount < freeCustomRecipeLimit
    }

    static var favoriteLimitMessage: String {
        "Free accounts can save up to \(freeFavoriteLimit) favorite recipes. Pantry Sous Plus will unlock unlimited favorites."
    }

    static var customRecipeLimitMessage: String {
        "Free accounts can create up to \(freeCustomRecipeLimit) custom recipes. Pantry Sous Plus will unlock unlimited custom recipes."
    }

    @MainActor
    static func refreshTestingEnvironment() async {
        #if DEBUG
        UserDefaults.standard.set(true, forKey: testingEnvironmentKey)
        #else
        do {
            let result = try await AppTransaction.shared

            switch result {
            case .verified(let appTransaction):
                UserDefaults.standard.set(appTransaction.environment != .production, forKey: testingEnvironmentKey)
            case .unverified:
                UserDefaults.standard.set(false, forKey: testingEnvironmentKey)
            }
        } catch {
            UserDefaults.standard.set(false, forKey: testingEnvironmentKey)
        }
        #endif
    }

    private static let testingEnvironmentKey = "pantrySousTestingEnvironment"
    private static let plusUnlockedKey = "pantrySousPlusUnlocked"

    private static var isDebugBuild: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
}
