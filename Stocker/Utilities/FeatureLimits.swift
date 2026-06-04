import Foundation

enum FeatureLimits {
    static let freeFavoriteLimit = 20
    static let freeCustomRecipeLimit = 5

    static var isPlusUnlocked: Bool {
        isTestingBuild || UserDefaults.standard.bool(forKey: "pantrySousPlusUnlocked")
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

    private static var isTestingBuild: Bool {
        #if DEBUG
        return true
        #else
        return Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
        #endif
    }
}
