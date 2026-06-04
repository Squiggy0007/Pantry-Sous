import Foundation
import UIKit
import SwiftUI

extension String {

    // Moved to background thread to avoid blocking UI
    func removingHTMLTags() -> String {
        // Fast path — if no HTML tags detected skip the expensive NSAttributedString
        guard self.contains("<") else { return self }
        guard let data = self.data(using: .utf8) else { return self }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        if let attributed = try? NSAttributedString(
            data: data,
            options: options,
            documentAttributes: nil
        ) {
            return attributed.string
        }
        return self
    }

    func extractHTMLListItems() -> [String]? {
        guard self.contains("<li>") || self.contains("<ol>") else { return nil }
        var items: [String] = []
        var remaining = self
        while let start = remaining.range(of: "<li>"),
              let end = remaining.range(of: "</li>") {
            let item = String(remaining[start.upperBound..<end.lowerBound])
                .removingHTMLTags()
                .trimmingCharacters(in: .whitespacesAndNewlines)
            if !item.isEmpty { items.append(item) }
            remaining = String(remaining[end.upperBound...])
        }
        return items.isEmpty ? nil : items
    }

    /// Returns the plural form of a word using English rules suited to food/ingredient names.
    /// Pass `count` so that 1.0 returns the singular unchanged.
    func pluralized(count: Double = 2) -> String {
        guard count != 1.0 else { return self }
        let lower = self.lowercased()

        // Uncountable ingredients — never pluralize
        let uncountable: Set<String> = [
            "flour", "sugar", "salt", "pepper", "rice", "pasta", "oil", "olive oil",
            "butter", "milk", "cream", "water", "broth", "stock", "sauce", "cheese",
            "bacon", "beef", "pork", "fish", "salmon", "tuna", "shrimp", "chicken",
            "turkey", "lamb", "bread", "dough", "batter", "spinach", "kale", "lettuce",
            "cabbage", "broccoli", "cauliflower", "parsley", "cilantro", "basil",
            "thyme", "rosemary", "oregano", "cumin", "paprika", "cinnamon", "nutmeg",
            "ginger", "turmeric", "honey", "vinegar", "soy sauce", "mayonnaise",
            "mustard", "ketchup", "sriracha", "tahini", "hummus", "garlic", "corn",
            "oatmeal", "quinoa", "couscous", "polenta", "lard", "shortening", "yeast",
            "baking soda", "baking powder", "cocoa", "vanilla", "coffee", "tea"
        ]
        if uncountable.contains(lower) { return self }

        // Irregular plurals common in cooking
        let irregulars: [String: String] = [
            "leaf":   "leaves",   "loaf":   "loaves",   "half":    "halves",
            "knife":  "knives",   "shelf":  "shelves",  "wolf":    "wolves",
            "tomato": "tomatoes", "potato": "potatoes", "hero":    "heroes",
            "mango":  "mangoes",  "echo":   "echoes",   "torpedo": "torpedoes",
        ]
        if let irregular = irregulars[lower] {
            return self.first?.isUppercase == true
                ? irregular.prefix(1).uppercased() + irregular.dropFirst()
                : irregular
        }

        // "fe" ending → "ves"  (knife→knives, already in irregulars, but handles others)
        if lower.hasSuffix("fe") {
            return String(self.dropLast(2)) + "ves"
        }

        // Single "f" (not "ff") → "ves"  (leaf→leaves, loaf→loaves — covered above,
        //                                  but catches any others like dwarf→dwarves)
        if lower.hasSuffix("f") && !lower.hasSuffix("ff") && lower.count > 1 {
            return String(self.dropLast(1)) + "ves"
        }

        // "sh", "ch", "ss", "x", "z" → "es"  (peach→peaches, dish→dishes)
        let esEndings = ["sh", "ch", "ss", "x", "z"]
        if esEndings.contains(where: { lower.hasSuffix($0) }) {
            return self + "es"
        }

        // Consonant + "y" → "ies"  (berry→berries, cherry→cherries)
        let consonants: Set<Character> = ["b","c","d","f","g","h","j","k","l","m",
                                          "n","p","q","r","s","t","v","w","x","y","z"]
        if lower.hasSuffix("y"), lower.count >= 2 {
            let penultimate = lower[lower.index(lower.endIndex, offsetBy: -2)]
            if consonants.contains(penultimate) {
                return String(self.dropLast(1)) + "ies"
            }
        }

        // Consonant + "o" → "es"  (tomato/potato covered above, catches others)
        // Exceptions: avocado, burrito, risotto, pesto, prosciutto stay with just "s"
        let oExceptions: Set<String> = ["avocado", "burrito", "risotto", "pesto",
                                        "prosciutto", "espresso", "photo", "piano"]
        if lower.hasSuffix("o"), !oExceptions.contains(lower), lower.count >= 2 {
            let penultimate = lower[lower.index(lower.endIndex, offsetBy: -2)]
            if consonants.contains(penultimate) {
                return self + "es"
            }
        }

        // Default: add "s"
        return self + "s"
    }

    // Applied on focus loss only, not every keystroke
    func titleCased() -> String {
        return self
            .lowercased()
            .split(separator: " ", omittingEmptySubsequences: false)
            .map { word -> String in
                guard let first = word.first else { return String(word) }
                return first.uppercased() + word.dropFirst()
            }
            .joined(separator: " ")
    }
}

// MARK: - Double Fraction Display
extension Double {
    /// Returns a human-readable fraction string using vulgar fraction characters.
    /// Examples: 0.5 → "½", 1.5 → "1½", 2.0 → "2", 0.25 → "¼", 2.75 → "2¾".
    func toFractionString() -> String {
        if self <= 0 { return "0" }
        let whole = Int(self)
        let decimal = self - Double(whole)
        let fractions: [(Double, String)] = [
            (1.0/8, "⅛"), (1.0/4, "¼"), (1.0/3, "⅓"), (3.0/8, "⅜"),
            (1.0/2, "½"), (5.0/8, "⅝"), (2.0/3, "⅔"), (3.0/4, "¾"), (7.0/8, "⅞")
        ]
        let tolerance = 0.05
        if decimal < tolerance {
            return whole == 0 ? "0" : "\(whole)"
        }
        if decimal > 1.0 - tolerance {
            return "\(whole + 1)"
        }
        for (value, symbol) in fractions {
            if abs(decimal - value) < tolerance {
                return whole == 0 ? symbol : "\(whole)\(symbol)"
            }
        }
        // Fallback for unrecognized decimals
        return String(format: "%.2g", self)
    }
}

// MARK: - Optional String Helper
extension Optional where Wrapped == String {
    /// Returns the string if non-nil and non-empty, otherwise nil.
    func nonEmpty() -> String? {
        guard let s = self, !s.trimmingCharacters(in: .whitespaces).isEmpty else { return nil }
        return s
    }
}

// MARK: - Toast Helper
/// Shows `binding` for `duration` seconds, then hides it with animation.
/// Use instead of the repeated withAnimation / DispatchQueue.main.asyncAfter pattern.
func showToast(_ binding: Binding<Bool>, duration: Double = 2.5) {
    withAnimation { binding.wrappedValue = true }
    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
        withAnimation { binding.wrappedValue = false }
    }
}
