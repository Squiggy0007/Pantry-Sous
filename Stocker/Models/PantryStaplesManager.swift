import Foundation
import SwiftUI
import Combine

// MARK: - Pantry Staples Manager
// @MainActor required for ObservableObject conformance in Swift 6.
// Two tiers:
//   1. Spoonacular Core Staples — one master toggle (water, salt, pepper, oil, flour, sugar)
//   2. Common Household Staples — individual toggles for things most (but not all) families keep
//
// NOTE: isStapleSync is nonisolated and uses only inline local constants — no references to
// any external type — so Swift 6 cannot infer @MainActor isolation on anything it touches.

@MainActor
class PantryStaplesManager: ObservableObject {
    static let shared = PantryStaplesManager()

    // ── Tier 1: Spoonacular Core Staples (single group toggle) ────────────
    @AppStorage("staples.spoonacularEnabled") var spoonacularStaplesEnabled: Bool = true

    // ── Tier 2: Common Household Staples (individual toggles) ─────────────
    @AppStorage("staples.butter")          var butterEnabled: Bool = true
    @AppStorage("staples.garlic")          var garlicEnabled: Bool = true
    @AppStorage("staples.oliveOil")        var oliveOilEnabled: Bool = false
    @AppStorage("staples.brownSugar")      var brownSugarEnabled: Bool = false
    @AppStorage("staples.bakingSoda")      var bakingSodaEnabled: Bool = false
    @AppStorage("staples.bakingPowder")    var bakingPowderEnabled: Bool = false
    @AppStorage("staples.cornstarch")      var cornstarchEnabled: Bool = false
    @AppStorage("staples.vanillaExtract")  var vanillaExtractEnabled: Bool = false
    @AppStorage("staples.chickenBroth")    var chickenBrothEnabled: Bool = false
    @AppStorage("staples.vegetableBroth")  var vegetableBrothEnabled: Bool = false

    // ── Sync Check (nonisolated — safe to call from any actor context) ────
    /// All name lists are inlined as local constants so Swift 6 has nothing
    /// external to infer @MainActor isolation from.
    nonisolated static func isStapleSync(_ ingredientName: String) -> Bool {
        let lower = ingredientName.lowercased().trimmingCharacters(in: .whitespaces)

        // Tier 1 — Spoonacular core (default ON if key not yet written)
        if UserDefaults.standard.object(forKey: "staples.spoonacularEnabled") as? Bool ?? true {
            let core: [String] = [
                "water",
                "salt", "sea salt", "kosher salt", "table salt",
                "black pepper", "pepper", "ground pepper",
                "oil", "vegetable oil", "canola oil", "cooking oil",
                "flour", "all purpose flour", "all-purpose flour",
                "sugar", "white sugar", "granulated sugar"
            ]
            if core.contains(lower) { return true }
        }

        // Tier 2 — common household staples
        let tier2: [(key: String, names: [String])] = [
            ("staples.butter",         ["butter", "unsalted butter", "salted butter"]),
            ("staples.garlic",         ["garlic", "garlic cloves", "garlic clove", "fresh garlic"]),
            ("staples.oliveOil",       ["olive oil", "extra virgin olive oil", "evoo"]),
            ("staples.brownSugar",     ["brown sugar", "light brown sugar", "dark brown sugar"]),
            ("staples.bakingSoda",     ["baking soda", "bicarbonate of soda", "bicarb"]),
            ("staples.bakingPowder",   ["baking powder"]),
            ("staples.cornstarch",     ["cornstarch", "corn starch", "cornflour"]),
            ("staples.vanillaExtract", ["vanilla extract", "pure vanilla extract", "vanilla"]),
            ("staples.chickenBroth",   ["chicken broth", "chicken stock"]),
            ("staples.vegetableBroth", ["vegetable broth", "vegetable stock", "veggie broth"]),
        ]
        for entry in tier2 {
            if UserDefaults.standard.bool(forKey: entry.key) {
                if entry.names.contains(lower) { return true }
            }
        }

        // Compound ingredient check — e.g. "Salt and Pepper", "salt, pepper, and oil"
        // If the line contains " and " or "," AND every individual component is a staple,
        // the whole line is treated as a staple and won't be added to the shopping list.
        if lower.contains(" and ") || lower.contains(",") {
            let parts = lower
                .components(separatedBy: " and ")
                .flatMap { $0.components(separatedBy: ",") }
                .map { $0.trimmingCharacters(in: .whitespaces) }
                // Only recurse on simple tokens (no further " and "/" , ") to prevent deep recursion
                .filter { !$0.isEmpty && !$0.contains(" and ") && !$0.contains(",") }
            if !parts.isEmpty && parts.allSatisfy({ isStapleSync($0) }) {
                return true
            }
        }

        return false
    }

    // ── Main Check ────────────────────────────────────────────────────────
    /// Called from @MainActor UI code. Delegates to isStapleSync so the
    /// name lists live in exactly one place.
    @MainActor func isActiveStaple(_ ingredientName: String) -> Bool {
        return Self.isStapleSync(ingredientName)
    }
}
