# StockIt — iOS App Project README

## Overview
**StockIt** (formerly Stocker) is a personal iOS app for managing household food inventory and discovering recipes based on what you actually have. Built for a family managing grocery budgets, the app helps reduce food waste and simplify meal planning. The core philosophy: **no assumptions — if it's not in your ingredients list, it's missing.**

---

## Development Environment
- **Device:** iPhone 15 Pro Max
- **Xcode:** Version 26.5 (24943)
- **macOS:** 26.3.1
- **Language:** Swift
- **UI Framework:** SwiftUI
- **Storage:** SwiftData
- **Minimum Target:** iOS 17
- **Apple Developer Account:** Free (apps expire after 7 days, reinstall via Cmd+R)
- **Bundle ID:** com.yourname.Stocker

---

## API
- **Recipe API:** Spoonacular (https://spoonacular.com/food-api)
- **Free Tier Limit:** 50 requests/day
- **Key placeholder in code:** `YOUR_API_KEY_HERE` in `SpoonacularService.swift`
- **Mock data toggle:** `private let useMockData = true` in `SpoonacularService.swift`
- **ignorePantry:** `false` — no pantry assumptions ever

---

## Monetization Plan (Future)
- **Model:** Freemium
- **Free tier:** Ingredients, recipe matching, shopping list, 5 saved favorites, banner + native ads
- **Paid tier ($2.99/mo or $14.99/yr):** Barcode scanner, unlimited favorites, Browse tab, ad-free
- **Ads:** Google AdMob — banner ads + native ads in recipe feed (free tier only)
- **Apple Developer paid account:** $99/year required before App Store submission
- **Spoonacular paid plan:** Upgrade to Cook ($29/mo) before publishing

---

## App Icon
- **Light mode:** Sage green background (#7D9E7D), white teardrop leaf, sage veins, white stem
- **Dark mode:** Deep charcoal background (#2A2A2C), sage green (#8FB08F) leaf, dark veins, sage stem
- Both icons are 1024x1024 PNG added to Assets → AppIcon

---

## Design Language
- Clean, minimal, rounded corners (16–20pt radius)
- SF Pro Rounded typography throughout
- SF Symbols for UI actions, emoji for category icons
- Smooth spring animations

### Color Palette
| Asset Name | Light Mode | Dark Mode | Usage |
|---|---|---|---|
| AccentSage | `#7D9E7D` | `#8FB08F` | Primary accent, buttons, icons |
| BackgroundPrimary | `#FAF7F2` | `#1C1C1E` | Main screen background |
| BackgroundSecondary | `#F0EBE3` | `#2C2C2E` | Secondary backgrounds, pills |
| CardBackground | `#FFFFFF` | `#3A3A3C` | Cards and list items |
| TextPrimary | `#1A1A1A` | `#F5F5F5` | Main text |
| TextSecondary | `#6B6B6B` | `#ABABAB` | Subtitles, captions |
| DestructiveTerracotta | `#C17A5E` | `#D4896A` | Missing ingredients, delete actions |

---

## App Structure

### Tab Bar (5 Tabs)
| # | Tab | Icon | Purpose |
|---|---|---|---|
| 0 | Ingredients | cabinet | Manage inventory by category |
| 1 | Recipes | fork.knife | Recipes matched to inventory + Browse section at bottom |
| 2 | Menu | calendar.badge.plus | Weekly dinner planner — Mon–Sun day cards |
| 3 | Favorites | heart.fill | Saved recipes (offline) |
| 4 | Shopping | cart.fill | Shopping list + finish shopping flow |

---

## Features

### Ingredients Tab
- **8 categories with emoji icons:**
  - 🥩 Protein, 🥦 Vegetables, 🍎 Fruit, 🌿 Herbs & Spices
  - 🥫 Canned & Jarred, 🌾 Dry Goods, 🧀 Dairy, 📦 Other
- Structured quantity picker: Count, Eggs (egg/half dozen/dozen/18-pack), Weight, Volume, Container
- Container units are dynamic: "1 packet" vs "2 packets", "1 can" vs "2 cans", etc.
- Decimal quantities supported
- **Smart auto-categorization** — ingredient name suggests category on focus loss
  - Checks canned/jarred FIRST to prevent "chicken broth" being labeled protein
  - "Kosher Salt" → Herbs & Spices, "Chicken Breast" → Protein, "Chicken Broth" → Canned & Jarred
  - Shows "Auto-sorted to [Category]" hint when auto-assigned
- **Contextual egg units** — typing "Eggs" shows egg-specific quantity options
- Auto title-case on ingredient names (applied on focus loss — fixes space input bug)
- **Add two ways:** Barcode scanner (with targeting box UI + camera permission) or manual entry
- Barcode scanner remembers products per barcode (BarcodeMemory model)
- **Edit ingredients** — tap pencil icon or swipe left
- **Delete ingredients** — swipe right OR delete button in edit screen (with confirmation dialog)
- Search bar to filter ingredients
- List-based swipe actions for reliable behavior on real device

### Recipes Tab
- Powered by Spoonacular API (mock toggle in SpoonacularService)
- **ignorePantry: false** — zero assumptions, 100% accurate matching
- Ingredient normalization — "Kosher Salt" matches "salt", "Jasmine Rice" matches "rice", etc.
- **"pepper" alone normalizes to "black pepper"**
- Broth types are kept specific — chicken broth ≠ beef broth ≠ vegetable broth
- Two sections:
  - **Ready to Make** — 100% ingredient match (horizontal scrolling cards)
  - **Almost There** — 50%+ ingredient match (vertical feed cards)
- Spoonacular quality score badge (★ 92) shown on recipe cards
- Auto-refreshes when ingredients change (watches count + name changes)
- Manual refresh button in toolbar
- Load More with session caching
- 60+ mock recipes across all major categories with full ingredients AND instructions

### Recipe Detail View
- Hero image, cook time, servings, quality score
- Ingredient checklist — green checkmark = owned, terracotta circle = missing
- Both sides of comparison normalized (inventory + recipe ingredients)
- Numbered instruction steps with sage green circles
- Save to Favorites, Share, Add Missing to Shopping List buttons
- **Toast notification** when items are added to shopping list ("3 items added to shopping list")
- Toast also shows "All items already on your list" if nothing new was added
- Smart quantity resolution — recipe amounts map to proper units
- Eggs auto-resolve to half dozen/dozen based on quantity needed
- Whole items (lemons, limes, onions) always round up to nearest whole number
- Share exports full recipe as formatted text

### Browse Tab
- **13 category pills** — horizontal scroll at top
  - Trending 🔥, Breakfast 🌅, Lunch ☀️, Dinner 🌙, Soup 💧, Snacks 🍃
  - Desserts 🎂, American 🚩, Italian 🍴, Mexican 🔥, Asian 🌬️, Mediterranean 🌊, Indian ✨
- **Vertical feed** of recipe cards for selected category
- Shows match % and quality score based on actual inventory
- 130+ mock recipes across all 13 categories (10 per category)
- Taps open same RecipeDetailView with ingredient matching
- Browse recipes show full ingredient checklist and instructions
- Recipes that match Recipes tab entries reuse full instructions
- Recipes without exact matches get smart category-aware generic instructions

### Favorites
- Offline SwiftData storage
- Grid layout, long press to remove
- Full recipe detail view with same styling

### Shopping List
- Add missing ingredients from recipes in one tap
- Uses exact recipe quantities (e.g. "4 cups" chicken broth, not "1 item")
- Manual add with structured quantity picker
- Smart auto-categorization when adding items
- Items grouped by category with emoji headers
- Check off items while shopping
- **Finish Shopping flow** — add purchased items to ingredients with category selection

---

## Ingredient Matching Logic

### Core Principle
**No pantry assumptions.** Salt, oil, broth, water, spices — none are assumed. If it's not in your ingredients list, it's missing.

### Normalization Map (IngredientNormalizer.swift)
- Rice varieties → "rice" (jasmine, basmati, brown, etc.)
- Oil varieties → "oil" (olive, vegetable, canola, etc.)
- Chicken cuts → "chicken" (breast, thighs, wings, etc.)
- Salt varieties → "salt" (kosher, sea, himalayan, etc.)
- **"pepper" alone → "black pepper"**
- Broth types → **specific** (chicken broth ≠ beef broth — users must have the exact type)
- 150+ ingredient families covered

### Matching Rules
- **Strict exact normalized matching only** — no partial string contains
- Uses `Set.isDisjoint` logic — "chicken" does NOT match "chicken broth"
- Both sides normalized: inventory ingredients AND recipe ingredients
- Match % = usedIngredientCount / (usedIngredientCount + missedIngredientCount)

---

## Mock Data System

### Toggle
```swift
// SpoonacularService.swift
private let useMockData = true  // true = mock, false = real API
```

### How It Works
- Mock data stores all recipe ingredients in `usedIngredients` array
- `SpoonacularService.fetchQualityRecipes` dynamically calculates used vs missed based on actual inventory
- Match percentages are always accurate and reflect real inventory
- No hardcoded match counts — all calculated at runtime
- Browse recipes build detail views dynamically from mock data
- Recipes with matching titles in `mockRecipeDetails` reuse full instructions
- All other browse recipes get category-aware generic instructions

### Mock Recipe Coverage
**MockRecipeService.swift** — 60 recipes for the Recipes tab:
- Full ingredients AND step-by-step instructions for every recipe
- Spoonacular quality scores for all recipes
- Chicken (10), Beef (8), Eggs (5), Pasta (5), Rice (2), Seafood (4), Pork (3), Soups (5), Vegetarian (6), Breakfast (2), Mexican (2), Asian (2), Indian (3), Desserts (3)

**MockBrowseData.swift** — 130 recipes for the Browse tab:
- 10 recipes per category across all 13 categories
- Full ingredient lists with accurate amounts
- Trending, Breakfast, Lunch, Dinner, Soup, Snacks, Desserts, American, Italian, Mexican, Asian, Mediterranean, Indian

---

## Auto-Categorization Logic (IngredientCategory.swift)

Order of checks (important — broth/soup checked BEFORE protein):
1. Canned & Jarred — broth, stock, soup, sauce, paste, beans, condiments (FIRST)
2. Protein — specific chicken cuts, beef, pork, fish, eggs (not "chicken" alone)
3. Dairy — milk, cheese, butter, cream, yogurt
4. Vegetables — carrots, broccoli, onions, peppers, etc.
5. Fruit — apples, bananas, lemons, berries, etc.
6. Herbs & Spices — salt, pepper, cumin, paprika, dried/ground seasonings
7. Canned & Jarred (second pass) — oils
8. Dry Goods — pasta, rice, flour, sugar, bread, baking ingredients
9. Other — fallback for anything unrecognized

---

## Project File Structure
```
Stocker
  └── Stocker
        ├── Models
        │     ├── IngredientCategory.swift    (8 categories + emoji icons + auto-suggest)
        │     ├── IngredientQuantity.swift    (QuantityUnit + QuantityCategory + egg units)
        │     ├── Ingredient.swift
        │     ├── BarcodeMemory.swift
        │     ├── SavedRecipe.swift
        │     ├── ShoppingItem.swift
        │     ├── SpoonacularRecipe.swift     (includes spoonacularScore field)
        │     ├── PantryStapleNames.swift     (actor-free enum with all staple name arrays)
        │     ├── PantryStaplesManager.swift  (@MainActor ObservableObject, isStapleSync, isActiveStaple)
        │     └── MenuEntry.swift             (@Model MenuEntry + WeekDay enum (Mon–Sun, emoji, displayName))
        ├── Services
        │     ├── SpoonacularService.swift    (mock toggle, browse fetch, generic instructions)
        │     ├── MockRecipeService.swift     (60 recipes with full instructions + scores)
        │     └── MockBrowseData.swift        (130 browse recipes + BrowseCategory enum)
        ├── Utilities
        │     ├── StringExtensions.swift      (titleCased, removingHTMLTags, showToast helper)
        │     ├── HapticFeedback.swift        (light/medium/success/warning — replaces inline generators)
        │     ├── UnitConversionHelper.swift  (mapToQuantityUnit, resolveShoppingQuantity, convertBetweenUnits)
        │     └── IngredientNormalizer.swift  (150+ families, strict matching, pepper fix, isEggIngredient)
        ├── ViewModels
        │     ├── InventoryViewModel.swift
        │     ├── RecipesViewModel.swift
        │     └── BrowseViewModel.swift
        ├── Views
        │     ├── CachedAsyncImage.swift      (NSCache-backed image view, replaces AsyncImage)
        │     ├── MainTabView.swift           (5 tabs)
        │     ├── InventoryView.swift         (List swipe actions, emoji category pills)
        │     ├── IngredientCardView.swift    (emoji icons)
        │     ├── QuantityPickerView.swift    (egg context, dynamic labels)
        │     ├── AddIngredientView.swift     (auto-categorization hint, grid picker)
        │     ├── EditIngredientView.swift    (grid category picker)
        │     ├── BarcodeScannerView.swift
        │     ├── RecipesView.swift           (Ready to Make, Almost There, Browse section, search, swipe-to-add)
        │     ├── RecipeCardView.swift        (score badge, Add to Menu button)
        │     ├── RecipeDetailView.swift      (toast notification, smart quantities, serving scale 1–8×)
        │     ├── SwipeToAddContainer.swift   (generic DragGesture swipe reveal; used in Recipes + Browse)
        │     ├── BrowseView.swift            (helper structs: BrowseFeedCardView, BrowseCategoryPillView — no longer a tab)
        │     ├── MenuView.swift              (Mon–Sun day cards with planned meals, swipe-to-delete)
        │     ├── AddToMenuSheet.swift        (day picker half-sheet, prevents duplicate day adds)
        │     ├── FavoritesView.swift
        │     ├── SavedRecipeDetailView.swift
        │     ├── ShoppingListView.swift      (grouped by category, emoji headers)
        │     ├── AddShoppingItemView.swift   (auto-categorization)
        │     └── FinishShoppingView.swift    (horizontal category scroll)
        ├── Assets                            (7 color sets + leaf app icon)
        └── StockerApp.swift
```

---

## Data Models

### Ingredient
```swift
@Model class Ingredient {
    var id: UUID
    var name: String           // title-cased, applied on focus loss
    var quantityAmount: Double
    var quantityUnit: String   // QuantityUnit.rawValue
    var category: IngredientCategory
    var barcode: String?
    var dateAdded: Date
}
```

### ShoppingItem
```swift
@Model class ShoppingItem {
    var id: UUID
    var name: String
    var quantityAmount: Double
    var quantityUnit: String
    var category: IngredientCategory
    var isPurchased: Bool
    var dateAdded: Date
}
```

### IngredientCategory
`.protein` | `.vegetables` | `.fruit` | `.herbsAndSpices` | `.cannedAndJarred` | `.dryGoods` | `.dairy` | `.other`

### QuantityUnit
- Count: `.item`
- Eggs: `.egg` `.halfDozen` `.dozen` `.eighteenPack`
- Weight: `.oz` `.lbs` `.g` `.kg`
- Volume: `.tsp` `.tbsp` `.cup` `.flOz` `.pint` `.quart` `.gallon`
- Container: `.can` `.bag` `.box` `.bottle` `.jar` `.package` `.packet`

---

## Third Party Packages
| Package | URL | Purpose |
|---|---|---|
| CodeScanner | https://github.com/twostraws/CodeScanner | Barcode scanning |

---

## Info.plist Requirements
- `Privacy - Camera Usage Description` = "Stocker needs camera access to scan barcodes"

---

## Known Issues / Notes
- SwiftData model changes require app deletion + reinstall on device and simulator
- Browse recipe instructions use category-aware generic steps when no exact match exists in mockRecipeDetails
- Toast notification appears for 2.5 seconds after adding items to shopping list
- `PantryStaplesManager` is `@MainActor` (required for `ObservableObject` in Swift 6). Static stored properties in a `@MainActor` class inherit actor isolation in Swift 6, so all name arrays live in a separate plain `enum PantryStapleNames` (no actor annotation) in the same file. Services like `SpoonacularService` that aren't `@MainActor` must use `PantryStaplesManager.isStapleSync()` — a `nonisolated static` method that reads `UserDefaults.standard` directly and references `PantryStapleNames.*` instead of actor-isolated properties. NOTE: Swift 6 / Xcode 26.5 may still infer `@MainActor` on `PantryStapleNames` if any `@MainActor` method references it — the final working solution is to inline all name arrays as local constants inside `isStapleSync` so the method has zero external type references. `isActiveStaple` simply delegates to `isStapleSync`.

---

## Device Installation
1. Connect iPhone via USB → Trust Computer
2. Select device in Xcode top bar
3. Press **Cmd+R** to build and install
4. Go to Settings → General → VPN & Device Management → Trust your Apple ID
5. App expires after **7 days** — reinstall via Cmd+R
6. **Wireless:** Window → Devices and Simulators → Connect via Network

### After SwiftData Model Changes
- Delete app from iPhone
- Simulator: Device menu → Erase All Content and Settings
- Then Cmd+R to reinstall

---

## Development Progress

### ✅ Completed (Session 18 — USDA Nutrition, Allergen Detection & Scan Speed)
- [x] **USDANutritionService.swift** — new service that queries USDA FoodData Central (`/fdc/v1/foods/search?dataType=Branded`) by product name and returns `NutritionData`; values are per 100g in the API, scaled to one serving using `servingSize / 100`; API key stored as `static let apiKey` in the file
- [x] **Hybrid OFX + USDA barcode lookup** — USDA can't do barcode lookup (text-search engine only); solution: Open Food Facts handles barcode → name/packaging/category, then USDA handles nutrition via product name search; fixes "Scanned Item" bug from pure USDA approach; both `AddIngredientView.lookupBarcode` and `ShoppingListView.lookupShopBarcode` use this pattern
- [x] **OFX nutrition fallback** — if USDA returns nil or `hasData == false`, inline OFX `nutriments` parsing serves as fallback; ensures nutrition is shown even for products not in USDA Branded database
- [x] **FDA-required nutrition rows always shown** — `IngredientNutritionCard` changed from `if value > 0` guards to always showing Trans Fat (indented under Total Fat), Cholesterol, and Total Sugars (indented under Total Carbohydrate) even at 0g/0mg; matches FDA Nutrition Facts label requirements
- [x] **Two-strategy allergen detection** — `USDANutritionService.extractAllergens(from:)` checks for explicit "CONTAINS: WHEAT, MILK, SOY." clause first; falls back to keyword scan for all 9 FDA major allergens (Wheat, Milk, Eggs, Soy, Peanuts, Tree Nuts, Fish, Shellfish, Sesame) in the ingredients body text
- [x] **Auto-patch cached allergens** — `IngredientInfoSheet.onAppear` re-derives allergens from `ingredientsList` if `allergensList.isEmpty && !ingredientsList.isEmpty`; patches products that were scanned before allergen detection was added
- [x] **Faster barcode recognition** — `CodeScannerView` gains `scanInterval: 0.1` in `BarcodeScannerView.swift`; reduces the delay between scan attempts from the ~2s default to 100ms, making the camera recognize a barcode almost instantly once it's in frame

### ✅ Completed (Session 17 — Quick-Use Ingredient Splitting + Opened-First Ordering)
- [x] **UseIngredientSheet** — new `Views/UseIngredientSheet.swift`; long press an ingredient card → "How much did you use?" bottom sheet with ingredient name, emoji, in-stock display, big number input, unit label, and "Log Use" button
- [x] **Split algorithm** — container-tracked items (containerSize > 0): calculates `fullContainersUsed = Int(used/containerSize)` and `remainder`; if remainder > 0.001 → removes `fullContainersUsed+1` from quantity AND inserts a new partial-open entry with `containerSize = containerSize - remainder`; bulk items (containerSize == 0): subtracts directly; deletes ingredient if quantity reaches 0
- [x] **Long press wired** — `IngredientCardView` gains `onUse: (() -> Void)? = nil` + `.onLongPressGesture(minimumDuration: 0.4)`; `InventoryView` adds `@State private var usingIngredient: Ingredient?` and `.sheet(item: $usingIngredient)` presenting `UseIngredientSheet` with `.presentationDetents([.medium])`
- [x] **Made This Dish — opened-first ordering** — all three applyMadeDish implementations (`RecipeDetailView`, `SavedRecipeDetailView`, `CustomRecipeDetailView`) now sort candidate inventory items by `containerSize` ascending before taking first match; ensures opened/partial containers (smallest size) are consumed before sealed ones; `MadeDishSheet.deductions` uses same sort so result amounts stay consistent
- [x] **Onboarding long-press tip** — "Add Your Ingredients" page now shows a subtle tip chip: "Long press any ingredient card to quickly log how much you used"; `OnboardingPageView` gains optional `tip` parameter rendered as a `hand.tap` icon + caption chip in sage-backed `BackgroundSecondary` rounded rect

### ✅ Completed (Session 16 — Shopping Scanner + Per-Size Inventory Tracking)
- [x] **Size-aware ingredient merging** — merge key changed from `name + unit` to `name + unit + containerSize + containerSizeUnit` in `AddIngredientView`, `EditIngredientView`, and `FinishShoppingView`; scanning a 12.5 oz can and a 6 oz can of the same product creates two separate entries; scanning a second 12.5 oz can adds to the existing entry
- [x] **Barcode scanner in Shopping List** — new `barcode.viewfinder` toolbar button on the Shopping List tab; during shopping, scan a product barcode to add it directly as a purchased item; shows a `ShopScanConfirmSheet` with pre-filled name, unit, container size, and category (same Open Food Facts parsing as Ingredients tab); tapping "Add to Cart" marks it as purchased + scanned; if the product already exists as an unpurchased list item (normalized name match), it's checked off instead of duplicated
- [x] **Scanned items flagged on list** — scanned shopping items show a small `barcode.viewfinder` icon next to the name in `ShoppingItemRowView`; normal manually-added items are unchanged
- [x] **FinishShoppingView redesigned — two sections**:
  - Section 1 "🥦 Fresh & Manual Items" — non-scanned items, sorted produce (vegetables + fruit) first; each item has a full `QuantityPickerView` + `CategoryGridPicker` so you can input exactly how much you grabbed
  - Section 2 "📱 Scanned Items" — compact read-only `ScannedItemConfirmRow` cards showing name, barcode-filled quantity, category emoji; no input needed since barcode provided exact details
- [x] **"Looks Good" CTA** — when only scanned items exist, the primary button reads "Looks Good — Add to Ingredients"; when a mix of manual + scanned exists it reads "Add All to Ingredients & Finish"
- [x] **Scanned item merge at finish** — `FinishShoppingView.addAllToIngredients()` now uses `name + unit + containerSize` merge key for scanned items and `name + unit + containerSize == 0` for manual items; scanned items carry their container size into ingredients automatically
- [x] **`ShoppingItem` model additions** — `isScanned: Bool = false`, `containerSize: Double = 0.0`, `containerSizeUnit: String = ""`; safe additive SwiftData migration (defaults); `displayQuantity` now shows "2 cans · 12.5 oz" for scanned items with container size

### ✅ Completed (Session 15 — Barcode Auto-Fill)
- [x] **Barcode auto-fills ingredient details** — `lookupBarcode` in `AddIngredientView.swift` now extracts three additional fields from Open Food Facts: `packaging` (→ `QuantityUnit`), `quantity` (→ `containerSize` + `containerSizeUnit`), and `categories_tags` (→ `IngredientCategory`). After scanning, the full add-ingredient form is pre-populated — name, unit, container size, and category — so the user just reviews and taps "Add to Ingredients" with no confirmation dialog needed.
- [x] **Confirmation dialog removed** — the old `confirmationDialog` that asked the user to manually pick a category is gone; category is now inferred from barcode data (falling back to `IngredientCategory.suggested(for:)` when tags are absent)
- [x] **Packaging → unit mapping** — checks for "can/tin", "bottle", "jar", "bag/pouch", "box/carton", "packet", "pack" in the `packaging` string; sets the appropriate `QuantityUnit` (`.can`, `.bottle`, `.jar`, `.bag`, `.box`, `.packet`, `.package`)
- [x] **Quantity string parsing** — `parseQuantityString` handles "12.5 oz", "400 g", "355 ml", "1 L", "12 fl oz"; ml auto-converts to fl oz, L auto-converts to cups; result pre-fills `containerSize` + `containerSizeUnit`
- [x] **Category tag mapping** — `detectCategory(from:productName:)` maps Open Food Facts `categories_tags` (e.g. "en:dairies", "en:meats", "en:canned-foods") to `IngredientCategory`; falls back to name-based detection for unrecognized tags
- [x] **Barcode memory stores full details** — `BarcodeMemory` gains `unitRaw: String = "item"`, `containerSize: Double = 0.0`, `containerSizeUnitRaw: String = ""`; safe additive SwiftData migration (defaults). On re-scan of a known barcode, all fields are restored instantly without a network call
- [x] **Barcode fill hint** — a "Filled from barcode: can, 12.5 oz, Canned & Jarred" hint line appears below the name field (replaces the "Auto-sorted to…" hint when barcode data is present)
- [x] **Loading state on scan button** — scan button shows spinner + "Looking up barcode…" text while the Open Food Facts request is in flight; button is disabled during lookup to prevent double-scans
- [x] **Barcode memory saved at `saveIngredient` time** — moved from `confirmBarcodeItem` (deleted) into `saveIngredient`; single save covers barcode memory + ingredient insert in one transaction

### ✅ Completed (Session 14 — Custom Recipe Matching, Quantities, Menu UX)
- [x] **Custom recipes in Ready to Make** — `RecipesView` now queries `CustomRecipe` and computes `readyCustomRecipes` (100% ingredient match via `IngredientNormalizer.extractIngredientName` + `matches`); displayed in a "Your Recipes" horizontal scroll section above Spoonacular results; tapping opens `CustomRecipeDetailView`; `CustomRecipeReadyCardView` shows photo/placeholder, "My Recipe" badge, title, cook time
- [x] **Container size field for quantities** — `Ingredient` model gains `containerSize: Double = 0.0` and `containerSizeUnit: String = ""`; `displayQuantity` now renders "3 cans · 12.5 oz" when set; `QuantityPickerView` shows an optional "Size per container" row with a numeric field + unit buttons (oz, lbs, g, kg, fl oz, cup) when container category is selected; `AddIngredientView` and `EditIngredientView` pass bindings through; safe additive SwiftData migration (default 0)
- [x] **`extractIngredientName` moved to `IngredientNormalizer`** — shared static `extractIngredientName(_:)` replaces the private `extractName` in `CustomRecipeDetailView`; now reused by `RecipesView.readyCustomRecipes` and any future callers
- [x] **Add meal button in Menu day header** — `DayMenuCardView` now shows a `plus.circle.fill` button in the day header when entries are not empty, calling `onAddMeal?()` to open `MealPickerSheet`; previously only the empty-state row was tappable
- [x] **Per-meal trash button** — replaced non-functional `.swipeActions` (requires `List`) with an explicit trash icon button at the trailing edge of each `MenuMealRowView`; always visible, no swipe required, works with multiple meals per day
- [x] **Toggle-to-deselect in MealPickerSheet** — tapping an already-added recipe removes it from that day instead of doing nothing; `plus.circle.fill` / `checkmark.circle.fill` icon toggles to reflect state; uses `toggleRecipe(_:)` helper
- [x] **Toggle-to-deselect in AddToMenuSheet** — same toggle logic for the per-recipe day picker; tapping a ✓ day removes the entry; sheet only auto-dismisses when a new entry is added (not on removal)

### ✅ Completed (Session 13 — Onboarding, Nutrition & Polish)
- [x] **First-launch onboarding** — 3-page swipeable sheet gated by `@AppStorage("hasSeenOnboardingV2")`; pages: "Add Your Ingredients" (cabinet.fill), "Discover Recipes" (fork.knife), "Plan the Week" (calendar.badge.plus); animated capsule page dots; "Next" / "Get Started" button; `.interactiveDismissDisabled()` prevents accidental dismissal; lives in `MainTabView.swift`
- [x] **"Repeat Onboarding" in Settings** — standalone "Walkthrough" section between Common Staples and App Info; tapping sets `hasSeenOnboarding = false` to replay the sheet on next foreground; chevron arrow matches app style
- [x] **Weekly summary strip — cook time removed** — `weeklySummaryStrip` now shows only "N meals planned this week"; `let timeStr: String` changed to `String?` with `guard totalMinutes > 0 else { return nil }` to fix compile error
- [x] **Mock nutrition for all 60 Recipes-tab recipes** — `RecipeNutrition(nutrients: [...])` added to every `RecipeDetail` entry in `MockRecipeService.swift` (IDs 1001–1060); macros (Calories, Protein, Carbohydrates, Fat) tailored per recipe
- [x] **Mock nutrition for all 130 Browse-tab recipes** — `SpoonacularService.fetchRecipeDetail` fallback changed from `nutrition: nil` to `matchingDetail?.nutrition ?? genericNutrition(for:)`; `genericNutrition(for:)` estimates macros from title keywords: desserts (360 kcal), soups (240), salads (220), breakfast (340), pasta (520), protein-heavy (420), default (380)
- [x] **Emoji centering fix in IngredientCardView** — nested `ZStack` (default center alignment) for circle + emoji; outer `ZStack(alignment: .topTrailing)` only for the orange low-stock badge dot; fixes emoji pulled off-center by trailing alignment
- [x] **Day emojis removed from AddToMenuSheet** — `Text(day.emoji)` removed from day picker rows; rows show plain day name + ✅/+ indicator only
- [x] **Build error fixes** — resolved: extraneous `}` at top level in `MenuView`; `QuantityUnit` missing `.halfDozen/.dozen/.eighteenPack` members in `Ingredient.isLowStock`; 60× "Missing argument 'nutrition'" by adding `nutrition: RecipeNutrition? = nil` default to `RecipeDetail.init`; type-checker timeout in `DayMenuCardView` by extracting inline closures to named helper methods; extra `onAddMeal` argument by adding `var onAddMeal: (() -> Void)? = nil` to `DayMenuCardView`

### ✅ Completed (Session 12 — Bug Fixes)
- [x] **Browse category switching fixed** — moved `browseRecipes` computation from inline `let` inside `LazyVStack` to a `currentBrowseRecipes` computed property on `RecipesView`; added `.id(browseViewModel.selectedCategory)` to the browse feed `LazyVStack` to force rebuild on category change
- [x] **Menu day emojis removed** — removed `Text(day.emoji)` from `DayMenuCardView` header; day cards now show plain day name only

### ✅ Completed (Session 11 — Menu Tab + Browse Merge)
- [x] **Menu tab** — replaced Browse tab (#2) with a `MenuView` weekly dinner planner; shows Monday–Sunday as expandable day cards; each day lists planned meals with image, name, cook time; swipe to remove a meal; trash button to clear the week
- [x] **MenuEntry SwiftData model** — new `Models/MenuEntry.swift` with `recipeId`, `recipeTitle`, `recipeImage`, `dayOfWeek` (Int), `readyInMinutes`, `servings`, `dateAdded`; registered in `StockerApp.swift`
- [x] **WeekDay enum** — Monday–Sunday with `displayName`, `shortName`, `emoji`; lives in `MenuEntry.swift`
- [x] **AddToMenuSheet** — half-sheet day picker; shows recipe preview at top; 7 day rows (emoji + name + ✅ if already added); tapping a day adds the recipe and dismisses; `@Query` prevents duplicate adds per day
- [x] **"Add to Menu" button** — `calendar.badge.plus` icon on `RecipeCardView` (Ready to Make), `RecipeFeedCardView` (Almost There), and `BrowseFeedCardView` (Browse section); optional `onAddToMenu: (() -> Void)?` closure; tapping opens `AddToMenuSheet`
- [x] **Browse merged into Recipes tab** — `BrowseViewModel` state added to `RecipesView`; full category pills + vertical feed rendered as a "Browse" section below Almost There; swipe-to-add and Add to Menu both work on Browse cards; `BrowseView.swift` retained for its helper structs but is no longer a tab
- [x] **⚠️ SwiftData reinstall required** — `MenuEntry` is a new model; delete app from device/simulator and reinstall via Cmd+R

### ✅ Completed (Session 10 — UX Features + Code Quality)
- [x] **Recipe scaling** — `@State private var servingScale: Int = 1` (1–8×) added to `RecipeDetailView`; interactive stepper replaces static servings pill; `scaledIngredientText(_:)` formats scaled amounts; `addMissingToShoppingList` multiplies recipe amounts by scale; stats pills wrapped in horizontal `ScrollView` to prevent wrapping
- [x] **Swipe-to-add on Recipes + Browse feed cards** — new `SwipeToAddContainer.swift` generic view using `simultaneousGesture(DragGesture(...))` with horizontal/vertical direction check; swipe left reveals green "Add Missing" cart button; tapping button or swiping right closes it; wired into `RecipesView` (Almost There section) and `BrowseView` feed with toast notifications
- [x] **Search bar on Recipes tab** — `.searchable(text:)` added to `RecipesView`; `filteredMakeNow` and `filteredAlmostThere` computed vars filter by `localizedCaseInsensitiveContains`; empty-state shows magnifying glass with search term when no results
- [x] **`UnitConversionHelper.swift`** — new `Utilities/UnitConversionHelper.swift` with `mapToQuantityUnit`, `resolveShoppingQuantity`, and `convertBetweenUnits` static methods; eliminated duplicate unit conversion code from `RecipeDetailView` and `MadeDishSheet`
- [x] **`IngredientNormalizer.isEggIngredient`** — moved from private method in `RecipeDetailView` to shared static on `IngredientNormalizer`; excludes eggplant, egg noodles, egg rolls, egg whites, egg yolks
- [x] `MadeDishSheet` duplicate methods removed — replaced inline `mapUnit` and `convertToInventoryUnit` with `UnitConversionHelper.mapToQuantityUnit` and `UnitConversionHelper.convertBetweenUnits`
- [x] `RecipesView` and `BrowseView` now query `ShoppingItem`s and have `addMissingToShoppingList(recipe:)` for the swipe action (uses `UnitConversionHelper.resolveShoppingQuantity`, stacks existing items, skips staples)

### ✅ Completed (Session 9 — Codebase Optimizations)
- [x] `HapticFeedback` enum — centralized haptic helper in `Utilities/HapticFeedback.swift`; replaced 24 inline `UIImpactFeedbackGenerator` instantiations across all views
- [x] `BrowseViewModel` O(1) ingredient matching — builds `Set<String>` of normalized inventory names once per call; uses `isDisjoint(with:)` instead of nested array `contains` loop
- [x] Standardized `PantryStaplesManager` access — `RecipeDetailView.addMissingToShoppingList()` and `MadeDishSheet.deductions` now use the view's `@ObservedObject staplesManager` instead of `PantryStaplesManager.shared` directly; `MadeDishSheet` gets its own `@ObservedObject private var staplesManager = PantryStaplesManager.shared`
- [x] `showToast(_:duration:)` free function — extracted from `StringExtensions.swift`; replaces the repeated `withAnimation { showToast = true } / DispatchQueue.main.asyncAfter(2.5)` pattern in `RecipeDetailView` (×2) and `InventoryView` (×1)
- [x] `CachedAsyncImage` — new `Views/CachedAsyncImage.swift` backed by `ImageCache` (NSCache, 200 entries / 50 MB limit); replaced `AsyncImage` in RecipeCardView, RecipeDetailView, RecipesView (RecipeFeedCardView), BrowseView, FavoritesView (FavoriteCardView), SavedRecipeDetailView; images are served from cache on second load with zero network round-trip
- [x] Batched `modelContext.save()` in `AddIngredientView.confirmBarcodeItem()` — removed the intermediate save after barcode memory insert; now a single save covers both the `BarcodeMemory` insert and the ingredient insert/merge

### ✅ Completed (Session 8 additions)
- [x] Edit ingredient auto-merges on save — `EditIngredientView.saveChanges()` checks for another ingredient with the same name + unit (excluding self); if found, adds quantities together and deletes the duplicate; if no conflict, updates in place as before

### ✅ Completed (Session 7 additions)
- [x] Finish Shopping merges into existing inventory — `FinishShoppingView.addAllToIngredients()` now checks if ingredient with same name + unit exists and adds quantity instead of inserting a duplicate (e.g. 3.25 lbs + 4 lbs = 7.25 lbs)
- [x] Add Ingredient merges on duplicate name — `AddIngredientView.saveIngredient()` and `confirmBarcodeItem()` both check existing inventory; same unit → stacks quantity; different unit → new entry
- [x] Quantity display shows 2 decimal places — `IngredientQuantity.displayString` changed from `%.1f` to `%.2f` so 3.25 shows as "3.25" not "3.2"; integers still show without decimals

### ✅ Completed (Session 6 additions)
- [x] Ingredient cart button no longer copies quantity — adds item name only (1 item) to shopping list; shows "already on your list" toast if duplicate
- [x] Shopping list merging — `AddShoppingItemView.saveItem()` checks for existing item by name and stacks quantity instead of creating duplicates; same for all add paths
- [x] Haptic feedback expanded — settings gear on all tabs (light impact), ingredients + button (medium), recipe refresh button (medium), browse category filters (light), Favorites create recipe + (medium), Shopping "Finish" button (medium), tab bar switching (light via onChange in MainTabView)

### ✅ Completed (Session 5 additions)
- [x] Haptic feedback throughout the app — `UIImpactFeedbackGenerator` / `UINotificationFeedbackGenerator` added to: ShoppingList (toggle check = medium, delete = light), RecipeDetail (save/unsave = medium, add missing = success notification, made dish confirm = success notification), Inventory (delete confirm = warning notification, category pill tap = light)
- [x] Shopping List share button — toolbar share icon exports formatted list grouped by category as text via `UIActivityViewController`; "Shared from StockIt 🛒" footer
- [x] Add to Shopping List from Ingredients tab — cart icon button on every ingredient card; stacks quantity if item already exists; toast confirmation; `@Query private var shoppingItems` added to `InventoryView`
- [x] NoRecipesView centered — `.frame(maxWidth: .infinity)` + `.padding(.vertical, 60)` added
- [x] Custom Recipe ingredient matching fixed — `extractName()` in `CustomRecipeDetailView` now handles compound tokens like "2lb", "400g", "1tsp"
- [x] Servings pill wrapping fixed — `StatPillView` gets `.lineLimit(1)` + `.fixedSize(horizontal: true, vertical: false)`, pills wrapped in `ScrollView(.horizontal)` in `CustomRecipeDetailView`

### ✅ Completed (Session 4 additions)
- [x] App renamed from "Stocker" to **StockIt** — `CFBundleDisplayName` updated in Info.plist; "Shared from StockIt" in share sheets
- [x] Photo upload for custom recipes — `PhotosPicker` added to `CreateRecipeView` and `EditCustomRecipeView`; hero photo shown in `CustomRecipeDetailView`; photo thumbnail in `CustomRecipeCardView`
- [x] Berry plurals fixed — "blueberries", "strawberries", "raspberries", "blackberries" etc. now correctly categorize as Produce
- [x] Shopping list quantity stacking — adding same ingredient from multiple recipes now adds to existing quantity instead of creating duplicates
- [x] Barcode scanner now returns full product name — combines brand + product_name from Open Food Facts API (e.g. "Cheez-It Original Crackers" instead of just "Original")
- [x] Recipe tab reloads when pantry staples are toggled — `RecipesView` now observes `PantryStaplesManager.objectWillChange` and forces a reload
- [x] Browse tab "Need X ingredients" count now respects pantry staples — `BrowseViewModel.recipes()` checks `isStapleSync`; `BrowseView` observes `PantryStaplesManager` for live redraws

### ✅ Completed (Session 3 additions)
- [x] Staples no longer show as "Missing" on recipe cards — `PantryStaplesManager.isStapleSync()` added (nonisolated static, reads UserDefaults directly to bypass @MainActor restriction)
- [x] SpoonacularService mock paths (Recipes + Browse tabs) now treat active staples as usedIngredients
- [x] Settings gear button on ALL tabs — Recipes, Browse, Favorites, Shopping (was only on Ingredients before)
- [x] MainTabView passes `showingSettings` binding to all 5 tab views; sheet stays at TabView level

### ✅ Completed (Session 2 additions)
- [x] Simplified egg tracking — individual eggs only (removed dozen/half dozen/18-pack)
- [x] "Made This Dish" button in RecipeDetailView — smart unit-aware quantity subtraction
- [x] MadeDishSheet confirmation — shows before/after for each ingredient, skips unit mismatches
- [x] Auto-categorization expanded — standalone "Beef", "Pork", "Chicken", "Turkey", "Lamb" etc.
- [x] Pantry staples toggleable — two-tier system: Spoonacular core (water/salt/pepper/oil/flour/sugar) + individual toggles (butter, garlic, olive oil, baking soda, etc.)
- [x] Pantry staples shown at bottom of recipe ingredient lists — no checkbox, neutral styling
- [x] Staples excluded from "Add Missing to Shopping List"
- [x] Favorites tab — organized into Breakfast, Lunch, Dinner, Soup, Snacks, Desserts sections
- [x] Favorites tab — auto-detects meal category from recipe title on save
- [x] Favorites tab — "Move to…" context menu to re-categorize saved recipes
- [x] Favorites tab — segment picker: "Saved" vs "My Recipes"
- [x] Custom recipe creation — CreateRecipeView with ingredients, steps, meal category, notes
- [x] Custom recipe creation — Private checkbox (hides Spoonacular upload option when on)
- [x] Custom recipes — live inventory match % shown while editing
- [x] Custom recipes — ingredient line indicator (green = owned, red = missing)
- [x] Custom recipe detail view — same ingredient matching as regular recipes
- [x] Custom recipe edit + delete from detail view
- [x] MealCategory model — Breakfast/Lunch/Dinner/Soup/Snacks/Desserts/Uncategorized
- [x] CustomRecipe SwiftData model registered in StockerApp
- [x] SettingsView — two-tier pantry staples toggles (Core Staples + Common Staples)
- [x] Ingredient categories confirmed: Protein → Produce → Dairy → Pantry → Herbs & Spices → Other

### ✅ Completed (Session 1)
- [x] Full project setup and folder structure
- [x] All SwiftData models with structured quantities
- [x] 5-tab navigation (Ingredients, Recipes, Browse, Favorites, Shopping)
- [x] 8-category ingredient system with emoji icons
- [x] Smart auto-categorization (broth/soup checked before protein)
- [x] Structured quantity picker with egg-specific units
- [x] Dynamic container labels ("1 packet" vs "2 packets")
- [x] Auto title-case on ingredient names (focus loss — fixes space input bug)
- [x] Add ingredient — manual entry + barcode scanner with targeting box UI
- [x] Barcode scanner remembers products per barcode
- [x] Edit ingredient screen with save + delete button
- [x] Swipe right to delete, swipe left to edit (real device confirmed)
- [x] Delete from edit screen with confirmation dialog
- [x] Ingredient normalization (150+ families, strict exact matching)
- [x] "pepper" alone normalizes to "black pepper"
- [x] No pantry assumptions — ever
- [x] Broth types kept specific — chicken broth ≠ beef broth
- [x] Mock data with dynamic matching (accurate percentages)
- [x] Recipes tab — Ready to Make + Almost There sections
- [x] Spoonacular quality score badge on recipe cards
- [x] Auto-refresh when ingredients change
- [x] Manual refresh button
- [x] Recipe detail with normalized ingredient checklist
- [x] Numbered instruction steps
- [x] Toast notification when items added to shopping list
- [x] Smart quantity resolution in shopping list (recipe amounts, egg units, round up)
- [x] Save to Favorites, Share, Add Missing to Shopping List
- [x] Browse tab — 13 category pills + vertical feed
- [x] 130 browse mock recipes with accurate match percentages
- [x] Browse recipes show full instructions (matched or category-aware generic)
- [x] 60 recipes tab mock recipes with full instructions and scores
- [x] Favorites screen with offline storage
- [x] Shopping list grouped by category with emoji headers
- [x] Finish Shopping → add purchased items to ingredients
- [x] Dark mode support
- [x] Custom leaf app icon (light + dark)
- [x] Wireless deployment to iPhone 15 Pro Max
- [x] Camera permission for barcode scanner
- [x] Performance — removed sleep delays, fast-path HTML parsing

### 📋 Up Next
- [ ] **⚠️ SwiftData reinstall may be required** — `ShoppingItem` gained 3 new fields (`isScanned`, `containerSize`, `containerSizeUnit`) and `BarcodeMemory` gained 3 fields last session — if the app crashes on launch, delete from device/simulator and reinstall via Cmd+R
- [ ] Photos library permission: add `NSPhotoLibraryUsageDescription` to Info.plist if Xcode warns
- [ ] Low stock alerts — define threshold per ingredient or category; show badge/warning on Ingredients tab
- [ ] Menu tab: ability to re-order meals within a day
- [ ] Freemium model implementation (Browse = paid, barcode = paid, 5 favorites limit)
- [ ] AdMob banner + native ads integration
- [ ] SwiftData migrations (prevent data wipe on model changes)
- [ ] App Store assets (screenshots, description, keywords)
- [ ] Upgrade to paid Apple Developer account ($99/year)
- [ ] Upgrade Spoonacular to Cook plan ($29/month)
- [ ] Switch `useMockData = false` and test with real API
- [ ] Spoonacular upload for non-private custom recipes (stub in CreateRecipeView)
- [ ] App Store submission

---

## Important Reminders
- API key lives **only** in `SpoonacularService.swift` — never share or commit it
- Set `useMockData = false` when testing real API or publishing
- SwiftData model changes require full app deletion and reinstall
- Free API tier = 50 requests/day — resets midnight UTC
- Free developer account = app expires every 7 days, reinstall via Cmd+R
- Always **Cmd+S** before closing Xcode
