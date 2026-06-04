# Pantry Sous

Pantry Sous is an iOS app for managing household food inventory, finding recipes based on what is actually in the kitchen, planning meals, and building shopping lists.

The guiding rule is simple: if an ingredient is not in your inventory, Pantry Sous treats it as missing. No hidden pantry assumptions.

## Features

- Track pantry, fridge, freezer, and grocery ingredients by category
- Add ingredients manually or with barcode scanning
- Store package size, quantity, category, nutrition, allergen, and barcode details
- Discover recipes that match your current inventory
- Browse recipe categories such as Trending, Breakfast, Lunch, Dinner, Soup, Snacks, Desserts, and cuisines
- View recipe details with owned/missing ingredient checks
- Add missing ingredients to the shopping list
- Save favorite recipes for offline access
- Create and edit custom recipes
- Plan weekly dinners with a Menu tab
- Mark shopping list items as purchased and move them into inventory
- Support light and dark app icons

## Screens and Tabs

Pantry Sous uses five main tabs:

- Ingredients: inventory management and barcode/manual ingredient entry
- Recipes: recipe matching, recipe browsing, and recipe detail views
- Menu: weekly dinner planning
- Favorites: saved recipes and custom recipes
- Shopping: grouped shopping list and finish-shopping flow

## Tech Stack

- Swift
- SwiftUI
- SwiftData
- iOS 17+
- CodeScanner for barcode scanning
- Spoonacular API for recipe search and recipe details
- Open Food Facts for barcode product lookup
- USDA FoodData Central for nutrition lookup

## Privacy

Pantry Sous stores user pantry, shopping list, saved recipe, custom recipe, and meal planning data locally on the device.

The app does not currently include accounts, ads, tracking, or third-party analytics SDKs.

Some app features send search terms, ingredient names, product names, or barcode numbers to third-party services so they can return recipe, product, or nutrition data.

Privacy Policy: https://squiggy0007.github.io/Pantry-Sous/privacy.html

Support: https://squiggy0007.github.io/Pantry-Sous/support.html

## Local Development

Open the project in Xcode:

```bash
open Stocker.xcodeproj
```

The app expects local API keys for Spoonacular and USDA FoodData Central. Real keys are not committed to this repository.

Create the ignored local secrets file:

```bash
bash setup_secrets.sh
```

Then edit:

```text
Stocker/secrets.xcconfig
```

Replace the placeholder values:

```text
SPOONACULAR_API_KEY = YOUR_SPOONACULAR_KEY_HERE
USDA_API_KEY = YOUR_USDA_KEY_HERE
```

`Stocker/Config.xcconfig` includes this ignored secrets file at build time.

## Secret Handling

The repository is configured so local keys and build artifacts are not committed:

- `Stocker/secrets.xcconfig`
- `*secrets*.xcconfig`
- local Xcode user data
- DerivedData
- build outputs
- app archives
- `.ipa`, `.app`, `.xcarchive`, `.xcresult`, and dSYM files

If you fork or clone this project, create your own API keys and never commit them.

## App Store Review Notes

Pantry Sous does not require login. Reviewers can test the app by adding ingredients manually, scanning a barcode after granting camera permission, browsing recipes, saving recipes, creating custom recipes, adding missing recipe ingredients to the shopping list, and planning meals.

## Project Status

Pantry Sous is in active development and beta testing.

Planned future work may include Pantry Sous Plus features such as unlimited custom recipes, advanced nutrition/allergen tools, household sharing, meal plan exports, and other power-user functionality.

## License

This project is currently proprietary and all rights are reserved unless a license is added later.
