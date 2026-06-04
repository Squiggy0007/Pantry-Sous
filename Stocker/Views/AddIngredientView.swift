import SwiftUI
import SwiftData
import CodeScanner
import AVFoundation

struct AddIngredientView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var barcodeMemories: [BarcodeMemory]
    @Query private var allIngredients: [Ingredient]

    @State private var name: String = ""
    @State private var amount: Double = 1
    @State private var unit: QuantityUnit = .item
    @State private var containerSize: Double = 0.0
    @State private var containerSizeUnit: QuantityUnit = .oz
    @State private var selectedCategory: IngredientCategory = .other
    @State private var categoryWasAutoSet: Bool = false
    @State private var showingScanner = false
    @State private var scannedBarcode: String = ""
    @State private var isLoadingBarcode = false
    @State private var barcodeFilledHint: String? = nil
    @State private var isBarcodeScanned: Bool = false
    @State private var errorMessage: String? = nil
    @State private var nutrition = NutritionData()
    @FocusState private var nameFieldFocused: Bool

    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundPrimary")
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {

                        // Scan barcode button
                        Button {
                            showingScanner = true
                        } label: {
                            HStack(spacing: 12) {
                                if isLoadingBarcode {
                                    ProgressView()
                                        .tint(.white)
                                        .scaleEffect(0.9)
                                } else {
                                    Image(systemName: "barcode.viewfinder")
                                        .font(.system(size: 22))
                                }
                                Text(isLoadingBarcode ? "Looking up barcode…" : "Scan Barcode")
                                    .font(.system(.body, design: .rounded, weight: .semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(isLoadingBarcode
                                          ? Color("AccentSage").opacity(0.6)
                                          : Color("AccentSage"))
                            )
                            .foregroundStyle(.white)
                        }
                        .disabled(isLoadingBarcode)
                        .padding(.horizontal, 16)
                        .padding(.top, 8)

                        // Divider
                        HStack {
                            Rectangle()
                                .fill(Color("TextSecondary").opacity(0.2))
                                .frame(height: 1)
                            Text("OR")
                                .font(.system(.caption, design: .rounded, weight: .medium))
                                .foregroundStyle(Color("TextSecondary"))
                            Rectangle()
                                .fill(Color("TextSecondary").opacity(0.2))
                                .frame(height: 1)
                        }
                        .padding(.horizontal, 16)

                        // Name field
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Ingredient Name")
                                .font(.system(.caption, design: .rounded, weight: .medium))
                                .foregroundStyle(Color("TextSecondary"))
                                .padding(.horizontal, 4)

                            TextField("e.g. Chicken Breast", text: $name)
                                .font(.system(.body, design: .rounded))
                                .padding(14)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color("CardBackground"))
                                )
                                .focused($nameFieldFocused)
                                .onChange(of: nameFieldFocused) { _, isFocused in
                                    if !isFocused && !name.isEmpty {
                                        name = name.titleCased()
                                        // Only auto-categorize if not already set by barcode
                                        if barcodeFilledHint == nil {
                                            let suggested = IngredientCategory.suggested(for: name)
                                            selectedCategory = suggested
                                            categoryWasAutoSet = true
                                        }
                                        if IngredientNormalizer.isEggIngredient(name) {
                                            unit = .egg
                                            amount = 1
                                        }
                                    }
                                }

                            // Barcode fill hint
                            if let hint = barcodeFilledHint {
                                HStack(spacing: 4) {
                                    Image(systemName: "barcode.viewfinder")
                                        .font(.system(size: 11))
                                    Text(hint)
                                        .font(.system(.caption2, design: .rounded))
                                }
                                .foregroundStyle(Color("AccentSage"))
                                .padding(.horizontal, 4)
                            } else if categoryWasAutoSet && selectedCategory != .other {
                                HStack(spacing: 4) {
                                    Image(systemName: "sparkles")
                                        .font(.system(size: 11))
                                    Text("Auto-sorted to \(selectedCategory.rawValue)")
                                        .font(.system(.caption2, design: .rounded))
                                }
                                .foregroundStyle(Color("AccentSage"))
                                .padding(.horizontal, 4)
                            }
                        }
                        .padding(.horizontal, 16)

                        // Quantity picker
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Quantity")
                                .font(.system(.caption, design: .rounded, weight: .medium))
                                .foregroundStyle(Color("TextSecondary"))
                                .padding(.horizontal, 4)

                            QuantityPickerView(
                                amount: $amount,
                                unit: $unit,
                                ingredientName: name,
                                containerSize: $containerSize,
                                containerSizeUnit: $containerSizeUnit,
                                isBarcodeScanned: isBarcodeScanned,
                                ingredientCategory: selectedCategory
                            )
                            .padding(14)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color("CardBackground"))
                            )
                        }
                        .padding(.horizontal, 16)

                        // Category picker
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Category")
                                .font(.system(.caption, design: .rounded, weight: .medium))
                                .foregroundStyle(Color("TextSecondary"))
                                .padding(.horizontal, 4)

                            CategoryGridPicker(selectedCategory: $selectedCategory)
                        }
                        .padding(.horizontal, 16)

                        // Nutrition card — shown after barcode scan
                        if nutrition.hasData {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Product Info")
                                    .font(.system(.caption, design: .rounded, weight: .medium))
                                    .foregroundStyle(Color("TextSecondary"))
                                    .padding(.horizontal, 4)

                                IngredientNutritionCard(
                                    servingSize: nutrition.servingSize,
                                    calories: nutrition.calories,
                                    protein: nutrition.protein,
                                    carbs: nutrition.carbs,
                                    fat: nutrition.fat,
                                    saturatedFat: nutrition.saturatedFat,
                                    transFat: nutrition.transFat,
                                    fiber: nutrition.fiber,
                                    sugar: nutrition.sugar,
                                    sodium: nutrition.sodium,
                                    cholesterol: nutrition.cholesterol,
                                    allergens: nutrition.allergensList,
                                    ingredientsList: nutrition.ingredientsList
                                )
                            }
                            .padding(.horizontal, 16)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }

                        if let error = errorMessage {
                            Text(error)
                                .font(.system(.caption, design: .rounded))
                                .foregroundStyle(Color("DestructiveTerracotta"))
                                .padding(.horizontal, 16)
                        }

                        Button {
                            saveIngredient()
                        } label: {
                            Text("Add to Ingredients")
                                .font(.system(.body, design: .rounded, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(name.isEmpty
                                              ? Color("BackgroundSecondary")
                                              : Color("AccentSage"))
                                )
                                .foregroundStyle(name.isEmpty ? Color("TextSecondary") : .white)
                        }
                        .disabled(name.isEmpty)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 32)
                    }
                }
            }
            .navigationTitle("Add Ingredient")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(Color("AccentSage"))
                }
            }
            .sheet(isPresented: $showingScanner) {
                BarcodeScannerView(
                    onScan: handleScan,
                    onDismiss: { showingScanner = false }
                )
            }
        }
    }

    // MARK: - Barcode Handling

    private func handleScan(result: Result<ScanResult, ScanError>) {
        showingScanner = false
        switch result {
        case .success(let scan):
            let barcode = scan.string
            scannedBarcode = barcode
            if let memory = barcodeMemories.first(where: { $0.barcode == barcode }) {
                // Stale-cache check: entry has macros but no carbs → saved before the Int/Double
                // JSON fix was in place. Purge and re-fetch for complete data.
                if (memory.fat > 0 || memory.protein > 0) && memory.carbs == 0 {
                    modelContext.delete(memory)
                    try? modelContext.save()
                    lookupBarcode(barcode)
                    return
                }
                // Restore all fields from memory
                name = memory.productName
                selectedCategory = memory.category
                unit = QuantityUnit(rawValue: memory.unitRaw) ?? .item
                containerSize = memory.containerSize
                containerSizeUnit = QuantityUnit(rawValue: memory.containerSizeUnitRaw) ?? .oz
                nutrition = NutritionData(
                    servingSize: memory.servingSize,
                    calories: memory.calories,
                    protein: memory.protein,
                    carbs: memory.carbs,
                    fat: memory.fat,
                    saturatedFat: memory.saturatedFat,
                    transFat: memory.transFat,
                    fiber: memory.fiber,
                    sugar: memory.sugar,
                    sodium: memory.sodium,
                    cholesterol: memory.cholesterol,
                    allergensList: memory.allergensList,
                    ingredientsList: memory.ingredientsList
                )
                barcodeFilledHint = "Details filled from previous scan"
                isBarcodeScanned = true
            } else {
                lookupBarcode(barcode)
            }
        case .failure:
            errorMessage = "Scan failed. Please try again or enter manually."
        }
    }

    private func lookupBarcode(_ barcode: String) {
        isLoadingBarcode = true
        Task { @MainActor in
            defer { isLoadingBarcode = false }

            // ── Step 1: Open Food Facts — reliable barcode → name/packaging/category ──
            guard let url = URL(string: "https://world.openfoodfacts.org/api/v0/product/\(barcode).json"),
                  let (data, _) = try? await URLSession.shared.data(from: url),
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let product = json["product"] as? [String: Any] else {
                errorMessage = "Item not found. Try entering it manually."
                return
            }

            // --- Product name ---
            let rawName = (product["product_name_en"] as? String).nonEmpty()
                ?? (product["product_name"] as? String).nonEmpty()
                ?? (product["generic_name_en"] as? String).nonEmpty()
                ?? (product["generic_name"] as? String).nonEmpty()
                ?? ""
            let brandRaw = product["brands"] as? String ?? ""
            let brand = brandRaw.components(separatedBy: ",").first?
                .trimmingCharacters(in: .whitespaces) ?? ""
            let fullName: String
            if !brand.isEmpty && !rawName.isEmpty {
                fullName = rawName.lowercased().hasPrefix(brand.lowercased()) ? rawName : "\(brand) \(rawName)"
            } else if !rawName.isEmpty { fullName = rawName }
            else if !brand.isEmpty     { fullName = brand   }
            else {
                errorMessage = "Item not found. Try entering it manually."
                return
            }
            name = fullName.titleCased()

            var hintParts: [String] = []

            // --- Packaging → container unit ---
            let packagingStr   = product["packaging"] as? String ?? ""
            let packagingTags  = (product["packaging_tags"] as? [String] ?? []).joined(separator: " ")
            let packagingLower = (packagingStr + " " + packagingTags).lowercased()
            if      packagingLower.contains("can") || packagingLower.contains("tin") { unit = .can;     hintParts.append("can")       }
            else if packagingLower.contains("bottle")                                { unit = .bottle;  hintParts.append("bottle")    }
            else if packagingLower.contains("jar")                                   { unit = .jar;     hintParts.append("jar")       }
            else if packagingLower.contains("bag") || packagingLower.contains("pouch") { unit = .bag;  hintParts.append("bag")       }
            else if packagingLower.contains("box") || packagingLower.contains("carton") { unit = .box; hintParts.append("box")       }
            else if packagingLower.contains("packet")                                { unit = .packet;  hintParts.append("packet")   }
            else if packagingLower.contains("tub") || packagingLower.contains("container") { unit = .package; hintParts.append("container") }
            else if packagingLower.contains("pack")                                  { unit = .package; hintParts.append("package")  }

            // --- Quantity string → container size ---
            let quantityRaw = product["quantity"] as? String ?? ""
            if !quantityRaw.isEmpty {
                let parsed = parseQuantityString(quantityRaw)
                if parsed.size > 0 {
                    containerSize     = parsed.size
                    containerSizeUnit = parsed.sizeUnit
                    hintParts.append("\(formatSize(parsed.size)) \(parsed.sizeUnit.rawValue)")
                }
            }

            // --- Category ---
            let categoryTags = product["categories_tags"] as? [String] ?? []
            selectedCategory = detectCategory(from: categoryTags, productName: name)
            hintParts.append(selectedCategory.rawValue)

            // Hard override: canned/jarred unit can't be fresh produce
            if selectedCategory == .produce {
                let nameLower = name.lowercased()
                let isCannedByUnit = (unit == .can || unit == .jar)
                let isCannedByName = nameLower.contains("canned") || nameLower.contains("tinned")
                let isCannedByTag  = categoryTags.joined(separator: " ").lowercased().contains("canned") ||
                                     categoryTags.joined(separator: " ").lowercased().contains("preserved")
                if isCannedByUnit || isCannedByName || isCannedByTag {
                    selectedCategory = .pantry
                    if !hintParts.isEmpty { hintParts[hintParts.count - 1] = selectedCategory.rawValue }
                }
            }

            // Infer container type from category when packaging fields were empty
            if unit == .item && containerSize > 0 {
                switch selectedCategory {
                case .pantry:
                    let n = name.lowercased()
                    let isDry = n.contains("pasta") || n.contains("noodle") || n.contains("cereal") ||
                                n.contains("cracker") || n.contains("rice") || n.contains("oat") ||
                                n.contains("flour") || n.contains("sugar") || n.contains("chip") ||
                                n.contains("cookie") || n.contains("pretzel")
                    unit = isDry ? .box : .can
                    hintParts.insert(isDry ? "box" : "can", at: 0)
                case .dairy:
                    unit = .bottle; hintParts.insert("bottle", at: 0)
                case .produce:
                    break
                default:
                    if containerSizeUnit == .oz || containerSizeUnit == .g {
                        unit = .bag; hintParts.insert("bag", at: 0)
                    }
                }
            }

            // ── Step 2: USDA — accurate nutrition data by product name ──
            // USDA text search works much better with names than raw barcode numbers.
            let usdaNutr = await USDANutritionService.lookupNutrition(forProduct: name)

            if let nutr = usdaNutr, nutr.hasData {
                // USDA found accurate label-sourced nutrition
                nutrition = nutr
            } else {
                // Fallback: parse OFX nutrition (less accurate but better than nothing)
                var nutr = NutritionData()
                nutr.servingSize = product["serving_size"] as? String ?? ""
                if let nutriments = product["nutriments"] as? [String: Any] {
                    let sg = (nutriments["serving_quantity"] as? NSNumber)?.doubleValue
                          ?? (product["serving_quantity"] as? NSNumber)?.doubleValue ?? 0
                    func n(_ key: String) -> Double {
                        func v(_ k: String) -> Double? { (nutriments[k] as? NSNumber)?.doubleValue }
                        if let x = v("\(key)_serving") ?? v("\(key)_value"), x > 0 { return x }
                        if let p = v("\(key)_100g") ?? v(key), p > 0 {
                            guard sg > 0 else { return p }
                            return (p * sg / 100 * 10).rounded() / 10
                        }
                        return 0
                    }
                    nutr.calories     = n("energy-kcal")
                    if nutr.calories == 0 { nutr.calories = (n("energy") / 4.184 * 10).rounded() / 10 }
                    nutr.fat          = n("fat")
                    nutr.saturatedFat = n("saturated-fat")
                    nutr.transFat     = n("trans-fat")
                    nutr.cholesterol  = (n("cholesterol") * 1000).rounded()
                    nutr.carbs        = n("carbohydrates")
                    nutr.fiber        = n("fiber")
                    nutr.sugar        = n("sugars")
                    nutr.protein      = n("proteins")
                    nutr.sodium       = (n("sodium") * 1000).rounded()
                }
                let allergenTags = product["allergens_tags"] as? [String] ?? []
                nutr.allergensList = allergenTags
                    .compactMap { $0.components(separatedBy: ":").last?.capitalized }
                    .filter { !$0.isEmpty }
                nutr.ingredientsList = (product["ingredients_text_en"] as? String).nonEmpty()
                    ?? (product["ingredients_text"] as? String).nonEmpty() ?? ""
                nutrition = nutr
            }

            barcodeFilledHint = hintParts.isEmpty
                ? "Details filled from barcode"
                : "Filled from barcode: \(hintParts.joined(separator: ", "))"
            isBarcodeScanned = true
        }
    }

    // MARK: - Barcode Parsing Helpers

    /// Parses a quantity string like "12.5 oz", "400 g", "355 ml", "1.5 qt", "8.5 oz (241 g)",
    /// "3 x 500 g" (multipack — takes per-unit size), leading non-numeric chars ignored.
    private func parseQuantityString(_ raw: String) -> (size: Double, sizeUnit: QuantityUnit) {
        // Strip secondary measurements in parens and everything after '/'
        let simplified = raw
            .components(separatedBy: CharacterSet(charactersIn: "/(")).first?
            .trimmingCharacters(in: .whitespaces) ?? raw

        var trimmed = simplified.trimmingCharacters(in: .whitespaces)

        // Handle "X x Y unit" multipack format — take Y (per-unit size, not total)
        // e.g. "3 x 500 g" → use "500 g"
        let xPattern = trimmed.lowercased()
        if let xRange = xPattern.range(of: #"\d+\s*x\s*"#, options: .regularExpression) {
            trimmed = String(trimmed[xRange.upperBound...]).trimmingCharacters(in: .whitespaces)
        }

        // Skip any leading non-numeric characters (handles OFX quirks like "e 500 g", "~12 oz")
        if let firstDigit = trimmed.firstIndex(where: { $0.isNumber }) {
            trimmed = String(trimmed[firstDigit...])
        } else {
            return (0, .oz)
        }

        // Extract leading number (handles "12.5", "355", "1")
        var numStr = ""
        var rest = ""
        var foundDecimal = false
        for (i, ch) in trimmed.enumerated() {
            if ch.isNumber {
                numStr.append(ch)
            } else if ch == "." && !foundDecimal {
                numStr.append(ch)
                foundDecimal = true
            } else {
                rest = String(trimmed.dropFirst(i)).trimmingCharacters(in: .whitespaces).lowercased()
                break
            }
        }
        guard let size = Double(numStr), size > 0 else { return (0, .oz) }

        if rest.hasPrefix("fl oz") || rest.hasPrefix("fl. oz") || rest.hasPrefix("fl.oz") {
            return (size, .flOz)
        } else if rest.hasPrefix("oz") {
            return (size, .oz)
        } else if rest.hasPrefix("lbs") || rest.hasPrefix("lb") {
            return (size, .lbs)
        } else if rest.hasPrefix("kg") {
            return (size, .kg)
        } else if rest.hasPrefix("qt") {
            // Convert quarts → fl oz (1 qt = 32 fl oz)
            let flOz = (size * 32 * 10).rounded() / 10
            return (flOz, .flOz)
        } else if rest.hasPrefix("pt") {
            // Convert pints → fl oz (1 pt = 16 fl oz)
            let flOz = (size * 16 * 10).rounded() / 10
            return (flOz, .flOz)
        } else if rest.hasPrefix("ml") {
            // Convert ml → fl oz (1 fl oz = 29.5735 ml), round to 1 decimal
            let flOz = (size / 29.5735 * 10).rounded() / 10
            return (flOz, .flOz)
        } else if rest.hasPrefix("cl") {
            let flOz = (size * 10 / 29.5735 * 10).rounded() / 10
            return (flOz, .flOz)
        } else if rest.hasPrefix("l") {
            // Convert L → fl oz (1 L = 33.814 fl oz)
            let flOz = (size * 33.814 * 10).rounded() / 10
            return (flOz, .flOz)
        } else if rest.hasPrefix("g") {
            return (size, .g)
        } else if rest.hasPrefix("cup") {
            return (size, .cup)
        }
        // No unit found but we have a number — return it as oz (common fallback for weight)
        return (size, .oz)
    }

    private func formatSize(_ size: Double) -> String {
        size.truncatingRemainder(dividingBy: 1) == 0
            ? String(Int(size))
            : String(format: "%.1f", size)
    }

    /// Maps Open Food Facts category tags to IngredientCategory.
    /// IMPORTANT: canned/sauces/preserved checked BEFORE produce because OFX tags
    /// tomato-based products with both "en:vegetables-based-foods" AND "en:sauces".
    private func detectCategory(from tags: [String], productName: String) -> IngredientCategory {
        let allTags = tags.joined(separator: " ").lowercased()
        let nameSuggestion = IngredientCategory.suggested(for: productName)

        if nameSuggestion == .pantry || nameSuggestion == .herbsAndSpices {
            return nameSuggestion
        }

        // 1. Dairy first (before protein — avoids "dairy-free" false positives)
        if allTags.contains("dairies") || allTags.contains("dairy") ||
           allTags.contains(":milks") || allTags.contains("cheeses") ||
           allTags.contains("yogurts") || allTags.contains(":butters") ||
           allTags.contains("creams") || allTags.contains("ice-cream") ||
           allTags.contains("frozen-desserts") {
            return .dairy
        }
        // 2. Protein
        if allTags.contains("meats") || allTags.contains("poultry") ||
           allTags.contains("seafoods") || allTags.contains(":fish") ||
           allTags.contains(":beef") || allTags.contains(":chicken") ||
           allTags.contains(":pork") || allTags.contains(":turkey") ||
           allTags.contains(":eggs") {
            return .protein
        }
        // 3. Pantry — canned, sauces, preserved, condiments (BEFORE produce to catch tomato sauce)
        if allTags.contains("canned") || allTags.contains("preserved") ||
           allTags.contains("condiments") || allTags.contains(":sauces") ||
           allTags.contains("soups") || allTags.contains("broths") ||
           allTags.contains("pickles") || allTags.contains("jarred") ||
           allTags.contains("tomato-sauce") || allTags.contains("pasta-sauce") ||
           allTags.contains("canned-tomato") || allTags.contains("tomatoes-and-tomato") ||
           allTags.contains("dressings") || allTags.contains("spreads") {
            return .pantry
        }
        // 3b. Product name override — "Canned" in the name always means pantry
        if productName.lowercased().contains("canned") || productName.lowercased().contains("tinned") {
            return .pantry
        }
        // 4. Pantry — dry goods, snacks
        if allTags.contains("cereals") || allTags.contains(":pasta") ||
           allTags.contains("breads") || allTags.contains(":flour") ||
           allTags.contains(":rice") || allTags.contains("grains") ||
           allTags.contains("crackers") || allTags.contains("cookies") ||
           allTags.contains("biscuits") || allTags.contains(":chips") ||
           allTags.contains("snacks") || allTags.contains("potato-chips") {
            return .pantry
        }
        // 5. Produce (after pantry so processed tomato/vegetable products don't land here)
        if allTags.contains(":vegetables") || allTags.contains(":fruits") ||
           allTags.contains("fresh-produce") {
            return nameSuggestion == .other ? .produce : nameSuggestion
        }
        // 6. Herbs & Spices
        if allTags.contains("spices") || allTags.contains(":herbs") ||
           allTags.contains("seasonings") || allTags.contains(":salt") {
            return .herbsAndSpices
        }

        // Fall back to name-based detection
        return nameSuggestion
    }

    // MARK: - Save

    private func saveIngredient() {
        guard !name.isEmpty else {
            errorMessage = "Please enter an ingredient name"
            return
        }

        let finalName = name.titleCased()

        // Persist barcode memory for future scans of the same product
        if !scannedBarcode.isEmpty,
           barcodeMemories.first(where: { $0.barcode == scannedBarcode }) == nil {
            let memory = BarcodeMemory(
                barcode: scannedBarcode,
                productName: finalName,
                category: selectedCategory,
                unitRaw: unit.rawValue,
                containerSize: containerSize,
                containerSizeUnitRaw: containerSize > 0 ? containerSizeUnit.rawValue : "",
                servingSize: nutrition.servingSize,
                calories: nutrition.calories,
                protein: nutrition.protein,
                carbs: nutrition.carbs,
                fat: nutrition.fat,
                fiber: nutrition.fiber,
                sugar: nutrition.sugar,
                sodium: nutrition.sodium,
                cholesterol: nutrition.cholesterol,
                saturatedFat: nutrition.saturatedFat,
                transFat: nutrition.transFat,
                allergensList: nutrition.allergensList,
                ingredientsList: nutrition.ingredientsList
            )
            modelContext.insert(memory)
        }

        // Merge only when name + unit + container size all match exactly.
        // Different container sizes (e.g. 12.5 oz can vs 6 oz can) stay as separate entries.
        let containerSizeUnitRaw = containerSize > 0 ? containerSizeUnit.rawValue : ""
        if let existing = allIngredients.first(where: {
            $0.name.lowercased() == finalName.lowercased() &&
            $0.quantityUnit == unit.rawValue &&
            $0.containerSize == containerSize &&
            $0.containerSizeUnit == containerSizeUnitRaw
        }) {
            existing.quantityAmount += amount
            // Update nutrition data if this is a fresh scan with richer data
            if nutrition.hasData {
                existing.servingSize   = nutrition.servingSize
                existing.calories      = nutrition.calories
                existing.protein       = nutrition.protein
                existing.carbs         = nutrition.carbs
                existing.fat           = nutrition.fat
                existing.saturatedFat  = nutrition.saturatedFat
                existing.transFat      = nutrition.transFat
                existing.fiber         = nutrition.fiber
                existing.sugar         = nutrition.sugar
                existing.sodium        = nutrition.sodium
                existing.cholesterol   = nutrition.cholesterol
                existing.allergensList = nutrition.allergensList
                existing.ingredientsList = nutrition.ingredientsList
            }
        } else {
            let ingredient = Ingredient(
                name: finalName,
                quantityAmount: amount,
                quantityUnit: unit,
                category: selectedCategory,
                barcode: scannedBarcode.isEmpty ? nil : scannedBarcode,
                containerSize: containerSize,
                containerSizeUnit: containerSize > 0 ? containerSizeUnit : nil,
                servingSize:    nutrition.servingSize,
                calories:       nutrition.calories,
                protein:        nutrition.protein,
                carbs:          nutrition.carbs,
                fat:            nutrition.fat,
                fiber:          nutrition.fiber,
                sugar:          nutrition.sugar,
                sodium:         nutrition.sodium,
                cholesterol:    nutrition.cholesterol,
                saturatedFat:   nutrition.saturatedFat,
                transFat:       nutrition.transFat,
                allergensList:  nutrition.allergensList,
                ingredientsList: nutrition.ingredientsList
            )
            modelContext.insert(ingredient)
        }
        try? modelContext.save()
        dismiss()
    }
}
