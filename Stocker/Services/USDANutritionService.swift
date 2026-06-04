import Foundation

// MARK: - USDA FoodData Central Service

enum USDANutritionService {

    // Key loaded from Info.plist → Config.xcconfig → ~/secrets.xcconfig
    static let apiKey: String = {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "USDAAPIKey") as? String,
              !key.isEmpty, !key.hasPrefix("$(") else {
            fatalError("USDAAPIKey missing — run setup_secrets.sh and wire Config.xcconfig in Xcode")
        }
        return key
    }()

    // USDA nutrient IDs for Branded foods (values are per 100 g in the API response)
    private enum NID {
        static let calories      = 1008
        static let fat           = 1004
        static let saturatedFat  = 1258
        static let transFat      = 1257
        static let cholesterol   = 1253   // mg/100 g
        static let sodium        = 1093   // mg/100 g
        static let carbs         = 1005
        static let fiber         = 1079
        static let sugars        = 2000   // Total Sugars
        static let sugarsAlt     = 1063   // Added Sugars — fallback
        static let protein       = 1003
    }

    // MARK: - Public API

    /// Search USDA by product name (e.g. "Cheez-It Original Crackers") and return
    /// the best-matching nutrition data. Call this AFTER getting the product name
    /// from a barcode database (Open Food Facts, etc.), since USDA's text search
    /// works much better with product names than with raw UPC/EAN barcode numbers.
    ///
    /// Returns nil if the product isn't found or the network call fails.
    /// All nutrient values in the returned NutritionData are scaled to one serving.
    static func lookupNutrition(forProduct productName: String) async -> NutritionData? {
        // Strip brand prefix attempts that add noise, but keep the full name for a
        // first try.  USDA text search is pretty robust — just pass the full name.
        let encoded = productName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? productName
        let urlStr  = "https://api.nal.usda.gov/fdc/v1/foods/search?query=\(encoded)&dataType=Branded&pageSize=3&api_key=\(apiKey)"
        guard let url = URL(string: urlStr),
              let (data, _) = try? await URLSession.shared.data(from: url),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let foods = json["foods"] as? [[String: Any]],
              let food  = foods.first else { return nil }

        return parseNutrition(from: food)
    }

    // MARK: - Private helpers

    /// Extracts a NutritionData from a single USDA food search result dictionary.
    static func parseNutrition(from food: [String: Any]) -> NutritionData {
        let servingGrams = (food["servingSize"] as? NSNumber)?.doubleValue ?? 0
        let household    = (food["householdServingFullText"] as? String ?? "").uppercased()

        // Serving size text for the nutrition label
        var servingSizeText = ""
        if servingGrams > 0 {
            let gStr = servingGrams == servingGrams.rounded()
                ? "\(Int(servingGrams))g"
                : String(format: "%.1fg", servingGrams)
            servingSizeText = household.isEmpty ? gStr : "\(household.capitalized) (\(gStr))"
        } else if !household.isEmpty {
            servingSizeText = household.capitalized
        }

        // Nutrients — USDA values are per 100 g; scale to one serving
        let scale = servingGrams > 0 ? servingGrams / 100.0 : 1.0
        var nmap: [Int: Double] = [:]
        for n in food["foodNutrients"] as? [[String: Any]] ?? [] {
            if let nid = (n["nutrientId"] as? NSNumber)?.intValue,
               let val = (n["value"]      as? NSNumber)?.doubleValue {
                nmap[nid] = val
            }
        }

        func g(_ id: Int) -> Double {
            guard let v = nmap[id], v > 0 else { return 0 }
            return (v * scale * 10).rounded() / 10
        }

        var nutr          = NutritionData()
        nutr.servingSize  = servingSizeText
        nutr.calories     = g(NID.calories)
        nutr.fat          = g(NID.fat)
        nutr.saturatedFat = g(NID.saturatedFat)
        nutr.transFat     = g(NID.transFat)
        nutr.cholesterol  = g(NID.cholesterol)   // USDA stores mg/100 g → scaled gives mg/serving
        nutr.sodium       = g(NID.sodium)         // same — already in milligrams
        nutr.carbs        = g(NID.carbs)
        nutr.fiber        = g(NID.fiber)
        nutr.sugar        = g(NID.sugars) > 0 ? g(NID.sugars) : g(NID.sugarsAlt)
        nutr.protein      = g(NID.protein)

        // Ingredients text & allergens
        let ingredientsText  = food["ingredients"] as? String ?? ""
        nutr.ingredientsList = ingredientsText
        nutr.allergensList   = extractAllergens(from: ingredientsText)

        return nutr
    }

    // MARK: - Private helpers

    /// Extracts allergens from an ingredients string using two strategies:
    /// 1. Explicit "CONTAINS: WHEAT, MILK, SOY." clause (most reliable)
    /// 2. Keyword scan for the 9 major FDA allergens when no CONTAINS clause exists
    static func extractAllergens(from text: String) -> [String] {
        let upper = text.uppercased()

        // ── Strategy 1: explicit CONTAINS clause ──────────────────────────
        if let range = upper.range(of: "CONTAINS:") {
            let after = String(upper[range.upperBound...])
                .components(separatedBy: ".").first
                ?? String(upper[range.upperBound...])
            let found = after
                .components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).capitalized }
                .filter { !$0.isEmpty }
            if !found.isEmpty { return found }
        }

        // ── Strategy 2: keyword scan for FDA major allergens ──────────────
        // Ordered so "Tree Nuts" check comes before individual nut names.
        struct AllergenRule {
            let label: String
            let keywords: [String]
        }
        let rules: [AllergenRule] = [
            .init(label: "Wheat",      keywords: ["WHEAT", "FLOUR", "GLUTEN", "SPELT", "SEMOLINA", "DURUM", "TRITICALE", "BULGUR"]),
            .init(label: "Milk",       keywords: ["MILK", "CREAM", "BUTTER", "CHEESE", "WHEY", "CASEIN", "LACTOSE", "LACTALBUMIN", "DAIRY"]),
            .init(label: "Eggs",       keywords: ["EGG", "ALBUMIN", "GLOBULIN", "LYSOZYME"]),
            .init(label: "Soy",        keywords: ["SOY", "SOYA", "TOFU", "TEMPEH", "EDAMAME", "MISO", "NATTO"]),
            .init(label: "Peanuts",    keywords: ["PEANUT", "GROUNDNUT", "ARACHIS"]),
            .init(label: "Tree Nuts",  keywords: ["ALMOND", "CASHEW", "WALNUT", "PECAN", "PISTACHIO", "HAZELNUT", "MACADAMIA", "PINE NUT", "BRAZIL NUT", "COCONUT"]),
            .init(label: "Fish",       keywords: ["ANCHOVY", "ANCHOVIES", "SALMON", "TUNA", "TILAPIA", "COD", "BASS", "FLOUNDER", "HALIBUT", "HERRING", "MAHI", "POLLOCK", "TROUT"]),
            .init(label: "Shellfish",  keywords: ["SHRIMP", "CRAB", "LOBSTER", "CLAM", "OYSTER", "SCALLOP", "MUSSEL", "CRAYFISH", "PRAWN"]),
            .init(label: "Sesame",     keywords: ["SESAME", "TAHINI", "TIL "]),
        ]

        var found: [String] = []
        for rule in rules {
            if rule.keywords.contains(where: { upper.contains($0) }) {
                found.append(rule.label)
            }
        }
        return found
    }

    /// Parses a USDA packageWeight string like "13.7 OZ", "355 ML", "1 LB" into (size, unit).
    /// Liquid volumes are converted to fl oz for consistency with the app's unit picker.
    private static func parseWeightString(_ raw: String) -> (size: Double, unit: QuantityUnit) {
        let upper = raw.uppercased().trimmingCharacters(in: .whitespaces)

        // Extract leading number (handles "13.7", "355", "1")
        var numStr = ""
        var rest   = ""
        var seenDot = false
        for (i, ch) in upper.enumerated() {
            if ch.isNumber { numStr.append(ch) }
            else if ch == "." && !seenDot { numStr.append(ch); seenDot = true }
            else {
                rest = String(upper.dropFirst(i)).trimmingCharacters(in: .whitespaces)
                break
            }
        }
        guard let size = Double(numStr), size > 0 else { return (0, .oz) }

        if rest.hasPrefix("FL OZ") || rest.hasPrefix("FL.OZ") {
            return (size, .flOz)
        }
        if rest.hasPrefix("OZ")  { return (size, .oz) }
        if rest.hasPrefix("LBS") || rest.hasPrefix("LB") { return (size, .lbs) }
        if rest.hasPrefix("ML") {
            // ml → fl oz (1 fl oz = 29.5735 ml)
            let flOz = (size / 29.5735 * 10).rounded() / 10
            return (flOz, .flOz)
        }
        if rest.hasPrefix("L") && (rest.count == 1 || rest.dropFirst().hasPrefix(" ")) {
            // Litres → fl oz (1 L = 33.814 fl oz)
            let flOz = (size * 33.814 * 10).rounded() / 10
            return (flOz, .flOz)
        }
        if rest.hasPrefix("KG") {
            // kg → g
            return (size * 1000, .g)
        }
        if rest.hasPrefix("G") { return (size, .g) }

        return (size, .oz)   // default fallback
    }
}
