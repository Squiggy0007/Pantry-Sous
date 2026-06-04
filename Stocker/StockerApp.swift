import SwiftUI
import SwiftData

@main
struct StockerApp: App {
    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(
                for:
                    Ingredient.self,
                    BarcodeMemory.self,
                    SavedRecipe.self,
                    ShoppingItem.self,
                    CustomRecipe.self,
                    MenuEntry.self
            )
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .modelContainer(container)
        }
    }
}
