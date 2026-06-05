import SwiftUI
import SwiftData
import CodeScanner

struct ShoppingListView: View {
    @Binding var showingSettings: Bool
    @Environment(\.modelContext) private var modelContext
    @Query private var shoppingItems: [ShoppingItem]
    @Query private var barcodeMemories: [BarcodeMemory]
    @State private var showingFinishShopping: Bool = false
    @State private var showingAddItem: Bool = false
    @State private var showingShareSheet: Bool = false
    @State private var shareText: String = ""
    @State private var showingClearCheckedAlert: Bool = false
    @State private var showingClearAllAlert: Bool = false

    // Barcode scan during shopping
    @State private var showingShopScanner = false
    @State private var isLookingUpScan = false
    @State private var showingScanConfirm = false
    @State private var scanNotFound = false
    @State private var scanBarcode = ""
    @State private var scanName = ""
    @State private var scanAmount = 1.0
    @State private var scanUnit: QuantityUnit = .item
    @State private var scanCategory: IngredientCategory = .other
    @State private var scanContainerSize = 0.0
    @State private var scanContainerSizeUnit: QuantityUnit = .oz
    // Nutrition fields captured during shop scan
    @State private var scanServingSize: String = ""
    @State private var scanCalories: Double = 0
    @State private var scanProtein: Double = 0
    @State private var scanCarbs: Double = 0
    @State private var scanFat: Double = 0
    @State private var scanSaturatedFat: Double = 0
    @State private var scanTransFat: Double = 0
    @State private var scanFiber: Double = 0
    @State private var scanSugar: Double = 0
    @State private var scanSodium: Double = 0
    @State private var scanCholesterol: Double = 0
    @State private var scanAllergens: [String] = []
    @State private var scanIngredientsList: String = ""

    var unpurchasedItems: [ShoppingItem] {
        shoppingItems.filter { !$0.isPurchased }
            .sorted { $0.dateAdded < $1.dateAdded }
    }

    var purchasedItems: [ShoppingItem] {
        shoppingItems.filter { $0.isPurchased }
            .sorted { $0.dateAdded < $1.dateAdded }
    }

    // Group unpurchased by category using orderedCases
    var groupedUnpurchased: [(IngredientCategory, [ShoppingItem])] {
        let grouped = Dictionary(grouping: unpurchasedItems) { $0.category }
        return IngredientCategory.orderedCases
            .compactMap { category in
                guard let items = grouped[category], !items.isEmpty else { return nil }
                return (category, items)
            }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundPrimary")
                    .ignoresSafeArea()

                if shoppingItems.isEmpty {
                    EmptyShoppingListView()
                } else {
                    shoppingContent
                }
            }
            .navigationTitle("Shopping List")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(spacing: 12) {
                        if !purchasedItems.isEmpty {
                            Button {
                                HapticFeedback.medium()
                                showingFinishShopping = true
                            } label: {
                                Text("Finish")
                                    .font(.system(.body, design: .rounded, weight: .semibold))
                                    .foregroundStyle(Color("AccentSage"))
                            }
                        } else {
                            Button {
                                HapticFeedback.light()
                                showingSettings = true
                            } label: {
                                Image(systemName: "gearshape.fill")
                                    .font(.system(size: 16))
                                    .foregroundStyle(Color("TextSecondary"))
                            }
                        }
                        // Clear all button — only when list has items
                        if !shoppingItems.isEmpty {
                            Button {
                                HapticFeedback.warning()
                                showingClearAllAlert = true
                            } label: {
                                Image(systemName: "trash")
                                    .font(.system(size: 16))
                                    .foregroundStyle(Color("DestructiveTerracotta"))
                            }
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 4) {
                        if !purchasedItems.isEmpty {
                            Button {
                                HapticFeedback.light()
                                showingSettings = true
                            } label: {
                                Image(systemName: "gearshape.fill")
                                    .font(.system(size: 16))
                                    .foregroundStyle(Color("TextSecondary"))
                            }
                        }
                        if !shoppingItems.isEmpty {
                            Button {
                                prepareShare()
                            } label: {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(Color("AccentSage"))
                            }
                        }
                        // Scan barcode while shopping
                        Button {
                            HapticFeedback.light()
                            showingShopScanner = true
                        } label: {
                            if isLookingUpScan {
                                ProgressView()
                                    .tint(Color("AccentSage"))
                                    .scaleEffect(0.85)
                                    .frame(width: 22, height: 22)
                            } else {
                                Image(systemName: "barcode.viewfinder")
                                    .font(.system(size: 20))
                                    .foregroundStyle(Color("AccentSage"))
                            }
                        }
                        .disabled(isLookingUpScan)
                        Button {
                            showingAddItem = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 22))
                                .foregroundStyle(Color("AccentSage"))
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddItem) {
                AddShoppingItemView()
            }
            .sheet(isPresented: $showingShareSheet) {
                ShareSheet(text: shareText)
            }
            .sheet(isPresented: $showingFinishShopping) {
                FinishShoppingView(purchasedItems: purchasedItems) {
                    clearPurchased()
                }
            }
            .sheet(isPresented: $showingShopScanner) {
                BarcodeScannerView(
                    onScan: handleShopScan,
                    onDismiss: { showingShopScanner = false }
                )
            }
            .sheet(isPresented: $showingScanConfirm) {
                ShopScanConfirmSheet(
                    name: $scanName,
                    amount: $scanAmount,
                    unit: $scanUnit,
                    category: $scanCategory,
                    containerSize: $scanContainerSize,
                    containerSizeUnit: $scanContainerSizeUnit,
                    notFound: scanNotFound,
                    onConfirm: { confirmShopScan() }
                )
            }
            .alert("Clear Checked Items?", isPresented: $showingClearCheckedAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Clear", role: .destructive) {
                    clearPurchased()
                }
            } message: {
                Text("\(purchasedItems.count) checked item\(purchasedItems.count == 1 ? "" : "s") will be removed from your list.")
            }
            .alert("Clear Entire List?", isPresented: $showingClearAllAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Clear All", role: .destructive) {
                    clearAll()
                }
            } message: {
                Text("This will remove all \(shoppingItems.count) item\(shoppingItems.count == 1 ? "" : "s") from your shopping list.")
            }
        }
    }

    private var shoppingContent: some View {
        ScrollView {
            LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {

                // Finish Shopping banner
                if !purchasedItems.isEmpty {
                    Button {
                        showingFinishShopping = true
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "cart.fill.badge.plus")
                                .font(.system(size: 16))
                            Text("\(purchasedItems.count) item\(purchasedItems.count == 1 ? "" : "s") checked — Finish Shopping")
                                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color("AccentSage"))
                        )
                        .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 8)
                }

                // Grouped unpurchased items by category
                ForEach(groupedUnpurchased, id: \.0) { category, items in
                    Section {
                        ForEach(items) { item in
                            ShoppingItemRowView(item: item, onTap: {
                                togglePurchased(item)
                            }, onDelete: {
                                deleteItem(item)
                            })
                        }
                    } header: {
                        HStack(spacing: 6) {
                            Text(category.emoji)
                                .font(.system(size: 14))
                            Text(category.rawValue)
                                .font(.system(.subheadline, design: .rounded, weight: .bold))
                                .foregroundStyle(Color("TextSecondary"))
                            Text("(\(items.count))")
                                .font(.system(.subheadline, design: .rounded, weight: .regular))
                                .foregroundStyle(Color("TextSecondary").opacity(0.6))
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 6)
                        .background(Color("BackgroundPrimary"))
                    }
                }

                // Purchased items
                if !purchasedItems.isEmpty {
                    Section {
                        ForEach(purchasedItems) { item in
                            ShoppingItemRowView(item: item, onTap: {
                                togglePurchased(item)
                            }, onDelete: {
                                deleteItem(item)
                            })
                        }
                    } header: {
                        HStack {
                            Text("✅ Checked Off")
                                .font(.system(.subheadline, design: .rounded, weight: .bold))
                                .foregroundStyle(Color("TextSecondary"))
                            Spacer()
                            Button {
                                HapticFeedback.warning()
                                showingClearCheckedAlert = true
                            } label: {
                                Text("Clear")
                                    .font(.system(.caption, design: .rounded, weight: .semibold))
                                    .foregroundStyle(Color("DestructiveTerracotta"))
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 6)
                        .background(Color("BackgroundPrimary"))
                    }
                }
            }
            .padding(.bottom, 32)
        }
    }

    // MARK: - Shop Scan Handlers

    private func handleShopScan(result: Result<ScanResult, ScanError>) {
        showingShopScanner = false
        switch result {
        case .success(let scan):
            scanBarcode = scan.string
            lookupShopBarcode(scan.string)
        case .failure:
            break // Scanner dismissed; user can add manually
        }
    }

    private func lookupShopBarcode(_ barcode: String) {
        scanNotFound = false
        isLookingUpScan = true

        Task { @MainActor in
            // Reset scan fields
            scanName = ""
            scanAmount = 1.0
            scanUnit = .item
            scanCategory = .other
            scanContainerSize = 0.0
            scanContainerSizeUnit = .oz
            scanServingSize = ""
            scanCalories = 0; scanProtein = 0; scanCarbs = 0
            scanFat = 0; scanSaturatedFat = 0; scanTransFat = 0
            scanFiber = 0; scanSugar = 0; scanSodium = 0; scanCholesterol = 0
            scanAllergens = []; scanIngredientsList = ""

            // Check BarcodeMemory for cached data first
            if let memory = barcodeMemories.first(where: { $0.barcode == barcode }) {
                // Stale-cache check: entry has macros but no carbs → saved before the Int/Double
                // JSON fix was in place. Purge and re-fetch for the complete label.
                if (memory.fat > 0 || memory.protein > 0) && memory.carbs == 0 {
                    modelContext.delete(memory)
                    try? modelContext.save()
                    // fall through to API fetch below
                } else {
                    scanName           = memory.productName
                    scanUnit           = .item
                    scanCategory       = memory.category
                    scanContainerSize  = memory.containerSize
                    scanContainerSizeUnit = QuantityUnit(rawValue: memory.containerSizeUnitRaw) ?? .oz
                    if memory.unitRaw != QuantityUnit.item.rawValue {
                        memory.unitRaw = QuantityUnit.item.rawValue
                        try? modelContext.save()
                    }
                    scanServingSize    = memory.servingSize
                    scanCalories       = memory.calories
                    scanProtein        = memory.protein
                    scanCarbs          = memory.carbs
                    scanFat            = memory.fat
                    scanSaturatedFat   = memory.saturatedFat
                    scanTransFat       = memory.transFat
                    scanFiber          = memory.fiber
                    scanSugar          = memory.sugar
                    scanSodium         = memory.sodium
                    scanCholesterol    = memory.cholesterol
                    scanAllergens      = memory.allergensList
                    scanIngredientsList = memory.ingredientsList
                    isLookingUpScan = false
                    try? await Task.sleep(nanoseconds: 400_000_000)
                    showingScanConfirm = true
                    return
                }
            }

            // ── Step 1: Open Food Facts — barcode → name/packaging/category ──
            isLookingUpScan = false
            let ofxURL = URL(string: "https://world.openfoodfacts.org/api/v0/product/\(barcode).json")
            if let ofxURL,
               let (ofxData, _) = try? await URLSession.shared.data(from: ofxURL),
               let ofxJSON = try? JSONSerialization.jsonObject(with: ofxData) as? [String: Any],
               let product = ofxJSON["product"] as? [String: Any] {

                // Product name
                let rawName  = product["product_name"] as? String ?? ""
                let brandRaw = product["brands"] as? String ?? ""
                let brand    = brandRaw.components(separatedBy: ",").first?
                    .trimmingCharacters(in: .whitespaces) ?? ""
                let fullName: String
                if !brand.isEmpty && !rawName.isEmpty {
                    fullName = rawName.lowercased().hasPrefix(brand.lowercased()) ? rawName : "\(brand) \(rawName)"
                } else if !rawName.isEmpty { fullName = rawName }
                else                       { fullName = "" }
                scanName = fullName.titleCased()

                // Scanned package counts are intentionally shown as item/items.
                scanUnit = .item

                // Quantity → container size
                if let quantityRaw = product["quantity"] as? String, !quantityRaw.isEmpty {
                    let parsed = parseShopQuantity(quantityRaw)
                    if parsed.size > 0 {
                        scanContainerSize     = parsed.size
                        scanContainerSizeUnit = parsed.sizeUnit
                    }
                }

                // Category
                let tags = product["categories_tags"] as? [String] ?? []
                scanCategory = detectShopCategory(from: tags, name: scanName)

                // ── Step 2: USDA — accurate nutrition by product name ──
                let usdaNutr = await USDANutritionService.lookupNutrition(forProduct: scanName)

                if let nutr = usdaNutr, nutr.hasData {
                    scanServingSize     = nutr.servingSize
                    scanCalories        = nutr.calories
                    scanProtein         = nutr.protein
                    scanCarbs           = nutr.carbs
                    scanFat             = nutr.fat
                    scanSaturatedFat    = nutr.saturatedFat
                    scanTransFat        = nutr.transFat
                    scanFiber           = nutr.fiber
                    scanSugar           = nutr.sugar
                    scanSodium          = nutr.sodium
                    scanCholesterol     = nutr.cholesterol
                    scanAllergens       = nutr.allergensList
                    scanIngredientsList = nutr.ingredientsList
                } else {
                    // Fallback: OFX nutrition
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
                        scanCalories     = n("energy-kcal")
                        if scanCalories == 0 { scanCalories = (n("energy") / 4.184 * 10).rounded() / 10 }
                        scanFat          = n("fat")
                        scanSaturatedFat = n("saturated-fat")
                        scanTransFat     = n("trans-fat")
                        scanCholesterol  = (n("cholesterol") * 1000).rounded()
                        scanCarbs        = n("carbohydrates")
                        scanFiber        = n("fiber")
                        scanSugar        = n("sugars")
                        scanProtein      = n("proteins")
                        scanSodium       = (n("sodium") * 1000).rounded()
                    }
                    if let s = product["serving_size"] as? String, !s.isEmpty { scanServingSize = s }
                    scanAllergens = (product["allergens_tags"] as? [String] ?? [])
                        .compactMap { $0.components(separatedBy: ":").last?.capitalized }
                        .filter { !$0.isEmpty }
                    if let ing = product["ingredients_text_en"] as? String, !ing.isEmpty {
                        scanIngredientsList = ing
                    }
                }

                // Save to BarcodeMemory so the next scan is instant
                if !scanName.isEmpty {
                    let memory = BarcodeMemory(
                        barcode: barcode,
                        productName: scanName,
                        category: scanCategory,
                        unitRaw: scanUnit.rawValue,
                        containerSize: scanContainerSize,
                        containerSizeUnitRaw: scanContainerSize > 0 ? scanContainerSizeUnit.rawValue : "",
                        servingSize: scanServingSize,
                        calories: scanCalories,
                        protein: scanProtein,
                        carbs: scanCarbs,
                        fat: scanFat,
                        fiber: scanFiber,
                        sugar: scanSugar,
                        sodium: scanSodium,
                        cholesterol: scanCholesterol,
                        saturatedFat: scanSaturatedFat,
                        transFat: scanTransFat,
                        allergensList: scanAllergens,
                        ingredientsList: scanIngredientsList
                    )
                    modelContext.insert(memory)
                    try? modelContext.save()
                }
            } else {
                scanNotFound = true
                scanName = ""
            }

            // Delay slightly so the scanner sheet finishes its dismiss animation
            // before the confirm sheet is presented — prevents the sheet conflict freeze.
            try? await Task.sleep(nanoseconds: 400_000_000)
            showingScanConfirm = true
        }
    }

    private func confirmShopScan() {
        let finalName = scanName.titleCased()

        // If item already on the list (unpurchased, normalized name match), check it off
        // and update it with the actual scanned product details so FinishShoppingView
        // shows the real product name and barcode-filled quantity.
        if let existing = unpurchasedItems.first(where: {
            IngredientNormalizer.matches(finalName, against: [$0.name])
        }) {
            HapticFeedback.success()
            existing.name = finalName                                     // e.g. "Hunts Tomato Sauce"
            existing.quantityAmount = scanAmount
            existing.quantityUnit = scanUnit.rawValue
            existing.category = scanCategory
            existing.containerSize = scanContainerSize
            existing.containerSizeUnit = scanContainerSize > 0 ? scanContainerSizeUnit.rawValue : ""
            existing.isPurchased = true
            existing.isScanned = true
        } else {
            // Not on the list — add as a new purchased (checked-off) scanned item
            HapticFeedback.success()
            let item = ShoppingItem(
                name: finalName,
                quantityAmount: scanAmount,
                quantityUnit: scanUnit,
                category: scanCategory,
                isScanned: true,
                containerSize: scanContainerSize,
                containerSizeUnit: scanContainerSize > 0 ? scanContainerSizeUnit.rawValue : ""
            )
            item.isPurchased = true
            modelContext.insert(item)
        }
        try? modelContext.save()
    }

    // MARK: - Barcode Parsing Helpers

    private func parseShopQuantity(_ raw: String) -> (size: Double, sizeUnit: QuantityUnit) {
        let trimmed = raw.trimmingCharacters(in: .whitespaces)
        var numStr = ""
        var rest = ""
        var foundDecimal = false
        for (i, ch) in trimmed.enumerated() {
            if ch.isNumber { numStr.append(ch) }
            else if ch == "." && !foundDecimal { numStr.append(ch); foundDecimal = true }
            else { rest = String(trimmed.dropFirst(i)).trimmingCharacters(in: .whitespaces).lowercased(); break }
        }
        guard let size = Double(numStr), size > 0 else { return (0, .oz) }
        if rest.hasPrefix("fl oz") || rest.hasPrefix("fl. oz") { return (size, .flOz) }
        if rest.hasPrefix("oz")  { return (size, .oz) }
        if rest.hasPrefix("lbs") || rest.hasPrefix("lb") { return (size, .lbs) }
        if rest.hasPrefix("kg")  { return (size, .kg) }
        if rest.hasPrefix("ml")  { return (((size / 29.5735) * 10).rounded() / 10, .flOz) }
        if rest.hasPrefix("cl")  { return (((size * 10 / 29.5735) * 10).rounded() / 10, .flOz) }
        if rest.hasPrefix("l")   { return (((size / 0.2366) * 10).rounded() / 10, .cup) }
        if rest.hasPrefix("g")   { return (size, .g) }
        if rest.hasPrefix("cup") { return (size, .cup) }
        return (size, .oz)
    }

    private func detectShopCategory(from tags: [String], name: String) -> IngredientCategory {
        let t = tags.joined(separator: " ").lowercased()
        let nameSuggestion = IngredientCategory.suggested(for: name)
        if nameSuggestion == .pantry || nameSuggestion == .herbsAndSpices {
            return nameSuggestion
        }
        if t.contains("dairies") || t.contains("dairy") || t.contains("milks") || t.contains("cheeses") || t.contains("yogurts") || t.contains("butter") { return .dairy }
        if t.contains("meats") || t.contains("poultry") || t.contains("seafood") || t.contains("fish") || t.contains("beef") || t.contains("chicken") || t.contains("pork") { return .protein }
        if t.contains("canned") || t.contains("preserved") || t.contains("condiments") || t.contains("sauces") || t.contains("soups") || t.contains("broths") { return .pantry }
        if t.contains("vegetables") || t.contains("produce") || t.contains("fruits") { return nameSuggestion == .other ? .produce : nameSuggestion }
        if t.contains("cereals") || t.contains("pasta") || t.contains("breads") || t.contains("flour") || t.contains("rice") || t.contains("crackers") || t.contains("snack") { return .pantry }
        if t.contains("spices") || t.contains("herbs") || t.contains("seasonings") { return .herbsAndSpices }
        return nameSuggestion
    }

    // MARK: - Existing Helpers

    private func togglePurchased(_ item: ShoppingItem) {
        HapticFeedback.medium()
        withAnimation(.spring(response: 0.3)) {
            item.isPurchased.toggle()
            try? modelContext.save()
        }
    }

    private func deleteItem(_ item: ShoppingItem) {
        HapticFeedback.light()
        modelContext.delete(item)
        try? modelContext.save()
    }

    private func clearPurchased() {
        for item in purchasedItems {
            modelContext.delete(item)
        }
        try? modelContext.save()
    }

    private func clearAll() {
        HapticFeedback.warning()
        for item in shoppingItems {
            modelContext.delete(item)
        }
        try? modelContext.save()
    }

    private func prepareShare() {
        var text = "🛒 Shopping List\n\n"
        for (category, items) in groupedUnpurchased {
            text += "\(category.emoji) \(category.rawValue)\n"
            for item in items {
                text += "  • \(item.name) — \(item.displayQuantity)\n"
            }
            text += "\n"
        }
        if !purchasedItems.isEmpty {
            text += "✅ Checked Off\n"
            for item in purchasedItems {
                text += "  • \(item.name) — \(item.displayQuantity)\n"
            }
            text += "\n"
        }
        text += "Shared from Pantry Sous 🛒"
        shareText = text
        showingShareSheet = true
    }
}

// MARK: - Shop Scan Confirm Sheet

struct ShopScanConfirmSheet: View {
    @Binding var name: String
    @Binding var amount: Double
    @Binding var unit: QuantityUnit
    @Binding var category: IngredientCategory
    @Binding var containerSize: Double
    @Binding var containerSizeUnit: QuantityUnit
    var notFound: Bool = false
    let onConfirm: () -> Void

    @Environment(\.dismiss) private var dismiss
    @FocusState private var nameFocused: Bool

    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundPrimary").ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {

                        // Scan badge
                        HStack(spacing: 8) {
                            Image(systemName: notFound ? "exclamationmark.triangle" : "barcode.viewfinder")
                                .font(.system(size: 13))
                            Text(notFound
                                 ? "Item not found — enter the name manually"
                                 : "Scanned product — confirm details below")
                                .font(.system(.caption, design: .rounded, weight: .medium))
                        }
                        .foregroundStyle(notFound ? Color("DestructiveTerracotta") : Color("AccentSage"))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(notFound
                                      ? Color("DestructiveTerracotta").opacity(0.1)
                                      : Color("AccentSage").opacity(0.1))
                        )
                        .padding(.horizontal, 16)
                        .padding(.top, 8)

                        // Name
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Item Name")
                                .font(.system(.caption, design: .rounded, weight: .medium))
                                .foregroundStyle(Color("TextSecondary"))
                                .padding(.horizontal, 4)
                            TextField("Product name", text: $name)
                                .font(.system(.body, design: .rounded))
                                .padding(14)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color("CardBackground")))
                                .focused($nameFocused)
                                .onChange(of: nameFocused) { _, focused in
                                    if !focused && !name.isEmpty { name = name.titleCased() }
                                }
                        }
                        .padding(.horizontal, 16)

                        // Quantity
                        VStack(alignment: .leading, spacing: 6) {
                            Text("How Many?")
                                .font(.system(.caption, design: .rounded, weight: .medium))
                                .foregroundStyle(Color("TextSecondary"))
                                .padding(.horizontal, 4)
                            QuantityPickerView(
                                amount: $amount,
                                unit: $unit,
                                ingredientName: name,
                                containerSize: $containerSize,
                                containerSizeUnit: $containerSizeUnit,
                                isBarcodeScanned: true,
                                ingredientCategory: category
                            )
                            .padding(14)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color("CardBackground")))
                        }
                        .padding(.horizontal, 16)

                        // Category
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Category")
                                .font(.system(.caption, design: .rounded, weight: .medium))
                                .foregroundStyle(Color("TextSecondary"))
                                .padding(.horizontal, 4)
                            CategoryGridPicker(selectedCategory: $category)
                        }
                        .padding(.horizontal, 16)

                        // Add to Cart button
                        Button {
                            onConfirm()
                            dismiss()
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "cart.fill.badge.plus")
                                Text("Add to Cart")
                                    .font(.system(.body, design: .rounded, weight: .semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(name.isEmpty ? Color("BackgroundSecondary") : Color("AccentSage"))
                            )
                            .foregroundStyle(name.isEmpty ? Color("TextSecondary") : .white)
                        }
                        .disabled(name.isEmpty)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 32)
                    }
                }
            }
            .navigationTitle("Scanned Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(Color("AccentSage"))
                }
            }
        }
    }
}

// MARK: - Shopping Item Row

struct ShoppingItemRowView: View {
    let item: ShoppingItem
    let onTap: () -> Void
    var onDelete: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 0) {
            // Main tap area (toggle checked)
            Button(action: onTap) {
                HStack(spacing: 14) {
                    Image(systemName: item.isPurchased ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 24))
                        .foregroundStyle(item.isPurchased
                                         ? Color("AccentSage")
                                         : Color("TextSecondary").opacity(0.4))

                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 6) {
                            Text(item.name)
                                .font(.system(.body, design: .rounded, weight: .medium))
                                .foregroundStyle(item.isPurchased ? Color("TextSecondary") : Color("TextPrimary"))
                                .strikethrough(item.isPurchased)
                            if item.isScanned {
                                Image(systemName: "barcode.viewfinder")
                                    .font(.system(size: 11))
                                    .foregroundStyle(Color("AccentSage").opacity(0.7))
                            }
                        }
                        Text(item.displayQuantity)
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundStyle(Color("TextSecondary"))
                    }

                    Spacer()

                    Text(item.category.emoji)
                        .font(.system(size: 20))
                }
                .padding(.leading, 16)
                .padding(.trailing, onDelete != nil ? 8 : 16)
                .padding(.vertical, 12)
            }
            .buttonStyle(.plain)

            // Trash button
            if let onDelete = onDelete {
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color("DestructiveTerracotta").opacity(0.7))
                        .frame(width: 40, height: 44)
                }
                .buttonStyle(.plain)
                .padding(.trailing, 8)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("CardBackground"))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
        .opacity(item.isPurchased ? 0.6 : 1.0)
    }
}

// MARK: - Empty State

struct EmptyShoppingListView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "cart")
                .font(.system(size: 52))
                .foregroundStyle(Color("AccentSage").opacity(0.4))
            Text("Your list is empty")
                .font(.system(.title3, design: .rounded, weight: .semibold))
                .foregroundStyle(Color("TextSecondary"))
            Text("Add items manually or tap 'Add Missing' on any recipe")
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(Color("TextSecondary").opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}
