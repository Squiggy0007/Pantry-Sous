import Foundation

/// Shared unit mapping and conversion logic.
/// Extracted from RecipeDetailView / MadeDishSheet to eliminate duplication.
struct UnitConversionHelper {

    // MARK: - Map string → QuantityUnit
    static func mapToQuantityUnit(_ unitString: String) -> QuantityUnit {
        switch unitString.lowercased().trimmingCharacters(in: .whitespaces) {
        case "tsp", "teaspoon", "teaspoons":           return .tsp
        case "tbsp", "tablespoon", "tablespoons":      return .tbsp
        case "cup", "cups":                            return .cup
        case "fl oz", "fluid ounce", "fluid ounces":  return .flOz
        case "oz", "ounce", "ounces":                  return .oz
        case "lbs", "lb", "pound", "pounds":           return .lbs
        case "g", "gram", "grams":                     return .g
        case "kg", "kilogram", "kilograms":            return .kg
        case "pint", "pints":                          return .pint
        case "quart", "quarts":                        return .quart
        case "gallon", "gallons":                      return .gallon
        case "can", "cans":                            return .can
        case "bag", "bags":                            return .bag
        case "box", "boxes":                           return .box
        case "bottle", "bottles":                      return .bottle
        case "jar", "jars":                            return .jar
        case "package", "packages":                    return .package
        case "packet", "packets":                      return .packet
        default:                                       return .item
        }
    }

    // MARK: - Resolve shopping quantity from a recipe ingredient
    /// Maps a recipe ingredient's amount + unit string to the best QuantityUnit
    /// for the shopping list. Handles egg special-casing and whole-item rounding.
    static func resolveShoppingQuantity(
        ingredientName: String,
        amount: Double,
        unitString: String
    ) -> (Double, QuantityUnit) {
        // Egg special case — always track as individual eggs
        if IngredientNormalizer.isEggIngredient(ingredientName) {
            return (max(1, ceil(amount)), .egg)
        }

        let mappedUnit = mapToQuantityUnit(unitString)

        // Whole items always round up (e.g. 2.5 lemons → 3)
        if mappedUnit == .item {
            return (max(1, ceil(amount)), .item)
        }

        return (amount, mappedUnit)
    }

    // MARK: - Convert between compatible units
    /// Converts `amount` from `fromUnit` to `toUnit`.
    /// Pass `ingredientHint` (the ingredient name) to enable density-based
    /// cross-category conversions (e.g. "2 cups cheddar" → lbs).
    /// Returns 0 when units are incompatible and no density is known.
    static func convertBetweenUnits(
        amount: Double,
        from fromUnit: QuantityUnit,
        to toUnit: QuantityUnit,
        ingredientHint: String? = nil
    ) -> Double {
        if fromUnit == toUnit { return amount }

        // Volume (base: tsp)
        let volumeToTsp: [QuantityUnit: Double] = [
            .tsp: 1, .tbsp: 3, .cup: 48, .flOz: 6,
            .pint: 96, .quart: 192, .gallon: 768
        ]
        if let from = volumeToTsp[fromUnit], let to = volumeToTsp[toUnit] {
            return amount * from / to
        }

        // Weight (base: g)
        let weightToG: [QuantityUnit: Double] = [
            .g: 1, .kg: 1000, .oz: 28.3495, .lbs: 453.592
        ]
        if let from = weightToG[fromUnit], let to = weightToG[toUnit] {
            return amount * from / to
        }

        // Count (item ↔ egg treated as interchangeable for deduction purposes)
        if (fromUnit == .item || fromUnit == .egg) &&
           (toUnit == .item || toUnit == .egg) {
            return amount
        }

        // Cross-category: volume ↔ weight via ingredient density
        let isFromVolume = volumeToTsp[fromUnit] != nil
        let isToVolume   = volumeToTsp[toUnit]   != nil
        let isFromWeight = weightToG[fromUnit]    != nil
        let isToWeight   = weightToG[toUnit]      != nil

        if (isFromVolume && isToWeight) || (isFromWeight && isToVolume),
           let hint = ingredientHint,
           let ozPerCup = densityOzPerCup(for: hint) {
            return convertVolumeWeight(
                amount: amount, from: fromUnit, to: toUnit,
                ozPerCup: ozPerCup,
                volumeToTsp: volumeToTsp, weightToG: weightToG
            )
        }

        // Incompatible — no deduction possible
        return 0
    }

    // MARK: - Density Lookup (oz per cup)
    /// Returns the approximate weight in oz for one cup of the named ingredient.
    /// Uses keyword matching from most-specific to least-specific.
    /// Covers 300+ ingredient patterns across all major food categories.
    /// Returns nil only for truly unmappable items (whole uncut fruit/veg, bones, etc.).
    static func densityOzPerCup(for name: String) -> Double? {
        let n = name.lowercased()

        // ═══════════════════════════════════════════════════════════════════
        // CHEESE
        // ═══════════════════════════════════════════════════════════════════
        if n.contains("cream cheese")                                { return 8.0  }
        if n.contains("cottage cheese")                              { return 8.2  }
        if n.contains("ricotta")                                     { return 8.0  }
        if n.contains("mascarpone")                                  { return 8.5  }
        if n.contains("brie") || n.contains("camembert")            { return 8.5  }
        if n.contains("goat cheese") || n.contains("chèvre")
            || n.contains("chevre")                                  { return 4.8  }
        if n.contains("blue cheese") || n.contains("gorgonzola")
            || n.contains("roquefort") || n.contains("stilton")     { return 5.0  }
        if n.contains("feta")                                        { return 5.0  }
        if n.contains("halloumi")                                    { return 8.0  }
        if n.contains("paneer")                                      { return 6.0  }
        if n.contains("queso fresco") || n.contains("queso blanco") { return 5.0  }
        if n.contains("velveeta") || n.contains("processed cheese") { return 8.0  }
        if n.contains("american cheese")                             { return 5.0  }
        // Hard/finely grated
        if n.contains("parmesan") || n.contains("parmigiano")
            || n.contains("romano") || n.contains("pecorino")
            || n.contains("asiago") || n.contains("cotija")         { return 3.5  }
        // Shredded / grated medium cheeses
        if n.contains("shredded") || n.contains("grated")
            || n.contains("cheddar") || n.contains("mozzarella")
            || n.contains("provolone") || n.contains("colby")
            || n.contains("pepper jack") || n.contains("monterey jack")
            || n.contains("gruyere") || n.contains("gruyère")
            || n.contains("emmental") || n.contains("fontina")
            || n.contains("gouda") || n.contains("edam")
            || n.contains("havarti") || n.contains("muenster")
            || n.contains("swiss cheese") || n.contains("jarlsberg") { return 4.0 }
        if n.contains("cheese")                                      { return 4.0  }

        // ═══════════════════════════════════════════════════════════════════
        // DAIRY & EGGS
        // ═══════════════════════════════════════════════════════════════════
        if n.contains("sour cream") || n.contains("crème fraîche")
            || n.contains("creme fraiche")                           { return 8.5  }
        if n.contains("heavy cream") || n.contains("whipping cream")
            || n.contains("double cream")                            { return 8.2  }
        if n.contains("half and half") || n.contains("half-and-half") { return 8.5 }
        if n.contains("evaporated milk")                             { return 9.0  }
        if n.contains("sweetened condensed") || n.contains("condensed milk") { return 11.0 }
        if n.contains("buttermilk")                                  { return 8.5  }
        if n.contains("skim milk") || n.contains("nonfat milk")
            || n.contains("non-fat milk") || n.contains("fat-free milk") { return 8.6 }
        if n.contains("whole milk") || n.contains("full fat milk")  { return 8.5  }
        if n.contains("2% milk") || n.contains("reduced fat milk")  { return 8.5  }
        if n.contains("oat milk")                                    { return 8.4  }
        if n.contains("almond milk")                                 { return 8.3  }
        if n.contains("soy milk") || n.contains("soymilk")          { return 8.4  }
        if n.contains("coconut milk")                                { return 8.5  }
        if n.contains("rice milk")                                   { return 8.4  }
        if n.contains("cashew milk")                                 { return 8.3  }
        if n.contains("hemp milk")                                   { return 8.4  }
        if n.contains("milk")                                        { return 8.5  }
        if n.contains("heavy whipping")                              { return 8.2  }
        if n.contains("light cream") || n.contains("table cream")   { return 8.4  }
        if n.contains("clotted cream")                               { return 8.8  }
        if n.contains("whipped cream")                               { return 2.0  } // airy
        if n.contains("cream")                                       { return 8.2  }
        if n.contains("ghee")                                        { return 7.8  }
        if n.contains("clarified butter")                            { return 7.8  }
        if n.contains("butter")                                      { return 8.0  }
        if n.contains("greek yogurt") || n.contains("greek yoghurt") { return 8.6 }
        if n.contains("yogurt") || n.contains("yoghurt")            { return 8.5  }
        if n.contains("kefir")                                       { return 8.5  }
        if n.contains("ice cream") || n.contains("gelato")
            || n.contains("frozen yogurt") || n.contains("froyo")   { return 4.5  }
        if n.contains("sorbet") || n.contains("sherbet")            { return 8.5  }
        if n.contains("egg white")                                   { return 8.5  }
        if n.contains("egg yolk")                                    { return 8.8  }

        // ═══════════════════════════════════════════════════════════════════
        // FLOUR & DRY BAKING
        // ═══════════════════════════════════════════════════════════════════
        if n.contains("bread flour")                                 { return 4.5  }
        if n.contains("cake flour") || n.contains("pastry flour")   { return 4.0  }
        if n.contains("self-rising flour") || n.contains("self rising flour") { return 4.5 }
        if n.contains("whole wheat flour") || n.contains("wholemeal flour")
            || n.contains("whole grain flour")                       { return 4.25 }
        if n.contains("spelt flour")                                 { return 4.25 }
        if n.contains("rye flour")                                   { return 4.5  }
        if n.contains("oat flour")                                   { return 3.5  }
        if n.contains("almond flour") || n.contains("almond meal")  { return 3.8  }
        if n.contains("coconut flour")                               { return 4.5  }
        if n.contains("cassava flour") || n.contains("tapioca flour")
            || n.contains("arrowroot flour")                         { return 4.25 }
        if n.contains("chickpea flour") || n.contains("garbanzo flour")
            || n.contains("besan") || n.contains("gram flour")      { return 3.5  }
        if n.contains("buckwheat flour")                             { return 4.25 }
        if n.contains("teff flour")                                  { return 4.5  }
        if n.contains("sorghum flour")                               { return 4.75 }
        if n.contains("rice flour")                                  { return 5.0  }
        if n.contains("gluten-free flour") || n.contains("gluten free flour") { return 4.25 }
        if n.contains("flour")                                       { return 4.25 }
        if n.contains("cornstarch") || n.contains("corn starch")    { return 4.5  }
        if n.contains("arrowroot starch") || n.contains("arrowroot powder") { return 4.5 }
        if n.contains("tapioca starch") || n.contains("tapioca pearl") { return 5.5 }
        if n.contains("potato starch")                               { return 5.5  }
        if n.contains("dutch process cocoa") || n.contains("dutch-process cocoa") { return 3.5 }
        if n.contains("cocoa powder") || n.contains("cacao powder")
            || n.contains("unsweetened cocoa")                       { return 3.2  }
        if n.contains("cacao nibs")                                  { return 5.0  }
        if n.contains("baking powder")                               { return 8.0  }
        if n.contains("baking soda") || n.contains("bicarbonate of soda")
            || n.contains("bicarb")                                  { return 9.6  }
        if n.contains("cream of tartar")                             { return 6.0  }
        if n.contains("dry milk") || n.contains("powdered milk")
            || n.contains("milk powder")                             { return 4.5  }
        if n.contains("whey protein") || n.contains("protein powder") { return 3.8 }
        if n.contains("yeast")                                       { return 5.0  }

        // ═══════════════════════════════════════════════════════════════════
        // SUGAR & SWEETENERS
        // ═══════════════════════════════════════════════════════════════════
        if n.contains("powdered sugar") || n.contains("confectioners sugar")
            || n.contains("confectioners' sugar") || n.contains("icing sugar") { return 4.0 }
        if n.contains("dark brown sugar")                            { return 7.5  }
        if n.contains("light brown sugar")                           { return 7.0  }
        if n.contains("brown sugar")                                 { return 7.5  }
        if n.contains("coconut sugar") || n.contains("palm sugar")  { return 6.8  }
        if n.contains("raw sugar") || n.contains("turbinado")
            || n.contains("demerara") || n.contains("muscovado")    { return 7.5  }
        if n.contains("granulated sugar") || n.contains("white sugar")
            || n.contains("caster sugar") || n.contains("castor sugar") { return 7.05 }
        if n.contains("sugar")                                       { return 7.05 }
        if n.contains("honey")                                       { return 12.0 }
        if n.contains("pure maple syrup") || n.contains("maple syrup") { return 11.0 }
        if n.contains("blackstrap molasses") || n.contains("molasses") { return 11.5 }
        if n.contains("corn syrup")                                  { return 11.5 }
        if n.contains("golden syrup")                                { return 11.5 }
        if n.contains("agave nectar") || n.contains("agave syrup")
            || n.contains("agave")                                   { return 11.0 }
        if n.contains("date syrup") || n.contains("date molasses")  { return 11.0 }
        if n.contains("rice syrup") || n.contains("brown rice syrup") { return 11.5 }
        if n.contains("syrup")                                       { return 11.0 }
        if n.contains("stevia")                                      { return 7.5  }
        if n.contains("monk fruit") || n.contains("erythritol")
            || n.contains("xylitol") || n.contains("allulose")      { return 7.0  }
        if n.contains("artificial sweetener") || n.contains("sugar substitute") { return 7.0 }
        if n.contains("jam") || n.contains("jelly") || n.contains("marmalade")
            || n.contains("fruit preserve") || n.contains("fruit spread") { return 10.0 }
        if n.contains("nutella") || n.contains("hazelnut spread")   { return 9.5  }

        // ═══════════════════════════════════════════════════════════════════
        // GRAINS, PASTA & BREAD
        // ═══════════════════════════════════════════════════════════════════
        if n.contains("steel cut oat") || n.contains("steel-cut oat") { return 6.5 }
        if n.contains("rolled oat") || n.contains("quick oat")
            || n.contains("old fashioned oat") || n.contains("oatmeal") { return 3.17 }
        if n.contains("oat")                                         { return 3.17 }
        if n.contains("jasmine rice") || n.contains("basmati rice")
            || n.contains("white rice") || n.contains("long grain rice")
            || n.contains("short grain rice") || n.contains("arborio")
            || n.contains("sushi rice")                              { return 6.5  }
        if n.contains("brown rice") || n.contains("wild rice")      { return 6.75 }
        if n.contains("black rice") || n.contains("forbidden rice")
            || n.contains("red rice")                                { return 6.75 }
        if n.contains("rice")                                        { return 6.5  }
        if n.contains("breadcrumb") || n.contains("bread crumb")
            || n.contains("panko")                                   { return 4.0  }
        if n.contains("cornmeal") || n.contains("polenta")
            || n.contains("grits")                                   { return 5.0  }
        if n.contains("couscous")                                    { return 6.0  }
        if n.contains("pearl barley") || n.contains("barley")       { return 7.0  }
        if n.contains("quinoa")                                      { return 6.7  }
        if n.contains("millet")                                      { return 7.0  }
        if n.contains("amaranth")                                    { return 6.75 }
        if n.contains("bulgur") || n.contains("cracked wheat")      { return 5.5  }
        if n.contains("farro") || n.contains("spelt berry")
            || n.contains("wheat berry")                             { return 6.75 }
        if n.contains("freekeh")                                     { return 6.5  }
        if n.contains("buckwheat") || n.contains("kasha")           { return 6.0  }
        if n.contains("teff")                                        { return 6.75 }
        if n.contains("sorghum grain") || n.contains("sorghum berry") { return 6.5 }
        if n.contains("orzo")                                        { return 6.0  }
        if n.contains("spaghetti") || n.contains("linguine")
            || n.contains("angel hair") || n.contains("capellini")
            || n.contains("vermicelli") || n.contains("bucatini")   { return 3.0  }
        if n.contains("penne") || n.contains("rigatoni")
            || n.contains("ziti") || n.contains("mostaccioli")
            || n.contains("cavatappi") || n.contains("rotini")
            || n.contains("fusilli") || n.contains("farfalle")
            || n.contains("bowtie pasta")                            { return 3.5  }
        if n.contains("fettuccine") || n.contains("tagliatelle")
            || n.contains("pappardelle") || n.contains("lasagna")
            || n.contains("lasagne")                                 { return 3.5  }
        if n.contains("macaroni") || n.contains("elbow pasta")      { return 3.75 }
        if n.contains("egg noodle") || n.contains("wide noodle")    { return 2.5  }
        if n.contains("rice noodle") || n.contains("rice vermicelli")
            || n.contains("glass noodle") || n.contains("cellophane noodle")
            || n.contains("bean thread")                             { return 2.5  }
        if n.contains("udon") || n.contains("soba") || n.contains("ramen")
            || n.contains("lo mein") || n.contains("chow mein")     { return 4.0  }
        if n.contains("pasta") || n.contains("noodle")              { return 3.5  }
        if n.contains("stuffing mix") || n.contains("stuffing")     { return 2.5  }
        if n.contains("crouton")                                     { return 2.0  }
        if n.contains("corn tortilla chip") || n.contains("tortilla chip")
            || n.contains("nacho chip")                              { return 1.75 }
        if n.contains("potato chip") || n.contains("crisps")        { return 1.25 }
        if n.contains("pretzel")                                     { return 4.0  }
        if n.contains("graham cracker") || n.contains("graham crumb") { return 4.0 }
        if n.contains("ritz cracker") || n.contains("butter cracker") { return 2.5 }
        if n.contains("saltine") || n.contains("soda cracker")      { return 2.5  }
        if n.contains("cracker")                                     { return 3.0  }
        if n.contains("granola")                                     { return 4.0  }
        if n.contains("cereal") || n.contains("corn flake")
            || n.contains("bran flake")                              { return 2.0  }
        if n.contains("popcorn")                                     { return 0.35 }

        // ═══════════════════════════════════════════════════════════════════
        // OILS, FATS & COOKING LIQUIDS
        // ═══════════════════════════════════════════════════════════════════
        if n.contains("extra virgin olive oil") || n.contains("olive oil") { return 7.7 }
        if n.contains("avocado oil")                                 { return 7.5  }
        if n.contains("coconut oil")                                 { return 7.3  }
        if n.contains("sesame oil")                                  { return 7.5  }
        if n.contains("vegetable oil") || n.contains("canola oil")
            || n.contains("corn oil") || n.contains("sunflower oil")
            || n.contains("safflower oil") || n.contains("grapeseed oil")
            || n.contains("peanut oil") || n.contains("flaxseed oil")
            || n.contains("walnut oil") || n.contains("almond oil") { return 7.5  }
        if n.contains("lard") || n.contains("shortening")
            || n.contains("crisco") || n.contains("tallow")
            || n.contains("schmaltz") || n.contains("duck fat")
            || n.contains("bacon fat") || n.contains("bacon grease") { return 7.3 }
        if n.contains("oil")                                         { return 7.5  }

        // ═══════════════════════════════════════════════════════════════════
        // BROTH, STOCK & COOKING LIQUIDS (critical for recipe matching)
        // ═══════════════════════════════════════════════════════════════════
        if n.contains("chicken broth") || n.contains("chicken stock")
            || n.contains("chicken bone broth")                      { return 8.5  }
        if n.contains("beef broth") || n.contains("beef stock")
            || n.contains("beef bone broth")                         { return 8.6  }
        if n.contains("vegetable broth") || n.contains("vegetable stock")
            || n.contains("veggie broth")                            { return 8.5  }
        if n.contains("fish stock") || n.contains("clam juice")
            || n.contains("seafood stock")                           { return 8.5  }
        if n.contains("bone broth")                                  { return 8.5  }
        if n.contains("broth") || n.contains("stock")               { return 8.5  }
        if n.contains("dashi")                                       { return 8.4  }
        if n.contains("consomme") || n.contains("consommé")         { return 8.5  }

        // ═══════════════════════════════════════════════════════════════════
        // ALCOHOL & BEVERAGES USED IN COOKING
        // ═══════════════════════════════════════════════════════════════════
        if n.contains("dry white wine") || n.contains("white wine") { return 8.5  }
        if n.contains("red wine") || n.contains("dry red wine")     { return 8.5  }
        if n.contains("sparkling wine") || n.contains("champagne")
            || n.contains("prosecco")                                { return 8.4  }
        if n.contains("beer") || n.contains("ale") || n.contains("lager")
            || n.contains("stout") || n.contains("porter")          { return 8.4  }
        if n.contains("vodka") || n.contains("gin") || n.contains("rum")
            || n.contains("tequila") || n.contains("whiskey")
            || n.contains("whisky") || n.contains("bourbon")
            || n.contains("brandy") || n.contains("cognac")         { return 7.5  }
        if n.contains("sake") || n.contains("mirin")                { return 8.5  }
        if n.contains("sherry") || n.contains("marsala")
            || n.contains("port wine") || n.contains("madeira")
            || n.contains("vermouth")                                { return 8.7  }
        if n.contains("wine")                                        { return 8.5  }
        if n.contains("apple juice") || n.contains("apple cider")
            || n.contains("apple cider vinegar")                     { return 8.6  }
        if n.contains("orange juice") || n.contains("grapefruit juice") { return 8.8 }
        if n.contains("lemon juice") || n.contains("lime juice")    { return 8.7  }
        if n.contains("pineapple juice") || n.contains("cranberry juice")
            || n.contains("pomegranate juice") || n.contains("grape juice")
            || n.contains("cherry juice")                            { return 8.8  }
        if n.contains("tomato juice") || n.contains("v8")           { return 8.6  }
        if n.contains("juice")                                       { return 8.7  }
        if n.contains("coffee") || n.contains("espresso")
            || n.contains("cold brew")                               { return 8.4  }
        if n.contains("tea") || n.contains("green tea")
            || n.contains("black tea") || n.contains("herbal tea")  { return 8.4  }
        if n.contains("water")                                       { return 8.35 }

        // ═══════════════════════════════════════════════════════════════════
        // SAUCES, CONDIMENTS & PASTES
        // ═══════════════════════════════════════════════════════════════════
        if n.contains("tomato paste")                                { return 9.0  }
        if n.contains("sun-dried tomato") || n.contains("sun dried tomato") { return 5.0 }
        if n.contains("tomato sauce") || n.contains("crushed tomato")
            || n.contains("diced tomato") || n.contains("stewed tomato")
            || n.contains("whole tomato")                            { return 8.5  }
        if n.contains("marinara") || n.contains("pasta sauce")
            || n.contains("arrabiata") || n.contains("arrabbiata")
            || n.contains("bolognese") || n.contains("alfredo sauce")
            || n.contains("vodka sauce") || n.contains("pesto")     { return 8.5  }
        if n.contains("enchilada sauce") || n.contains("red enchilada")
            || n.contains("green enchilada")                         { return 8.6  }
        if n.contains("bbq sauce") || n.contains("barbecue sauce")  { return 9.5  }
        if n.contains("buffalo sauce") || n.contains("buffalo wing sauce") { return 8.7 }
        if n.contains("ketchup") || n.contains("catsup")            { return 9.5  }
        if n.contains("soy sauce") || n.contains("tamari")
            || n.contains("liquid aminos") || n.contains("coconut aminos") { return 8.7 }
        if n.contains("fish sauce")                                  { return 8.7  }
        if n.contains("oyster sauce")                                { return 9.5  }
        if n.contains("hoisin sauce") || n.contains("hoisin")       { return 9.5  }
        if n.contains("teriyaki sauce") || n.contains("teriyaki")   { return 9.0  }
        if n.contains("worcestershire")                              { return 8.5  }
        if n.contains("steak sauce") || n.contains("a1 sauce")      { return 9.0  }
        if n.contains("sriracha") || n.contains("sambal")
            || n.contains("hot sauce") || n.contains("tabasco")
            || n.contains("crystal hot sauce") || n.contains("franks")
            || n.contains("cholula")                                 { return 8.5  }
        if n.contains("gochujang") || n.contains("doubanjiang")
            || n.contains("chili bean paste") || n.contains("chili garlic sauce")
            || n.contains("chili garlic paste")                      { return 9.0  }
        if n.contains("miso paste") || n.contains("white miso")
            || n.contains("red miso") || n.contains("yellow miso")  { return 9.0  }
        if n.contains("tahini")                                      { return 9.5  }
        if n.contains("harissa")                                     { return 8.8  }
        if n.contains("tzatziki")                                    { return 8.5  }
        if n.contains("guacamole")                                   { return 8.5  }
        if n.contains("hummus")                                      { return 8.6  }
        if n.contains("salsa verde") || n.contains("green salsa")
            || n.contains("tomatillo salsa")                         { return 8.5  }
        if n.contains("salsa")                                       { return 8.5  }
        if n.contains("pico de gallo")                               { return 8.5  }
        if n.contains("mayo") || n.contains("mayonnaise")
            || n.contains("aioli")                                   { return 8.5  }
        if n.contains("miracle whip")                                { return 8.0  }
        if n.contains("dijon mustard") || n.contains("yellow mustard")
            || n.contains("whole grain mustard") || n.contains("spicy mustard")
            || n.contains("honey mustard")                           { return 9.0  }
        if n.contains("mustard")                                     { return 9.0  }
        if n.contains("ranch dressing") || n.contains("ranch dip")  { return 8.7  }
        if n.contains("caesar dressing")                             { return 8.7  }
        if n.contains("balsamic vinegar")                            { return 9.0  }
        if n.contains("rice wine vinegar") || n.contains("rice vinegar") { return 8.5 }
        if n.contains("red wine vinegar") || n.contains("white wine vinegar")
            || n.contains("sherry vinegar") || n.contains("champagne vinegar") { return 8.5 }
        if n.contains("white vinegar") || n.contains("distilled vinegar") { return 8.5 }
        if n.contains("vinegar")                                     { return 8.5  }
        if n.contains("peanut butter")                               { return 9.0  }
        if n.contains("almond butter") || n.contains("sunflower butter")
            || n.contains("cashew butter") || n.contains("pecan butter")
            || n.contains("hazelnut butter") || n.contains("walnut butter")
            || n.contains("nut butter")                              { return 9.0  }
        if n.contains("tahini")                                      { return 9.5  }
        if n.contains("cream of mushroom") || n.contains("cream of chicken")
            || n.contains("cream of celery") || n.contains("cream of tomato")
            || n.contains("condensed soup")                          { return 9.0  }

        // ═══════════════════════════════════════════════════════════════════
        // SPICES & DRIED SEASONINGS (measured in tsp/tbsp but stored in oz)
        // ═══════════════════════════════════════════════════════════════════
        if n.contains("kosher salt")                                 { return 7.0  }
        if n.contains("sea salt flake") || n.contains("flaky salt")
            || n.contains("maldon")                                  { return 4.5  }
        if n.contains("sea salt") || n.contains("himalayan salt")
            || n.contains("pink salt")                               { return 9.0  }
        if n.contains("table salt") || n.contains("iodized salt")   { return 9.6  }
        if n.contains("salt")                                        { return 9.0  }
        if n.contains("black pepper") || n.contains("white pepper")
            || n.contains("red pepper flake") || n.contains("crushed red pepper")
            || n.contains("cayenne pepper") || n.contains("cayenne")
            || n.contains("ground pepper")                           { return 4.5  }
        if n.contains("peppercorn")                                  { return 5.0  }
        if n.contains("pepper")                                      { return 4.5  }
        if n.contains("garlic powder") || n.contains("garlic salt")
            || n.contains("granulated garlic")                       { return 4.5  }
        if n.contains("onion powder") || n.contains("onion flake")
            || n.contains("dried onion")                             { return 4.5  }
        if n.contains("ground cumin") || n.contains("cumin seed")
            || n.contains("cumin")                                   { return 3.5  }
        if n.contains("smoked paprika") || n.contains("sweet paprika")
            || n.contains("hot paprika") || n.contains("paprika")   { return 4.3  }
        if n.contains("chili powder") || n.contains("chile powder") { return 4.3  }
        if n.contains("ancho chili") || n.contains("chipotle powder")
            || n.contains("chipotle chili") || n.contains("pasilla")
            || n.contains("guajillo") || n.contains("new mexico chili") { return 4.0 }
        if n.contains("ground cinnamon") || n.contains("cinnamon stick")
            || n.contains("cinnamon")                                { return 4.3  }
        if n.contains("ground nutmeg") || n.contains("nutmeg")      { return 4.5  }
        if n.contains("ground clove") || n.contains("whole clove")
            || n.contains("clove")                                   { return 4.5  }
        if n.contains("ground allspice") || n.contains("allspice")  { return 4.5  }
        if n.contains("ground ginger") || n.contains("dried ginger")
            || n.contains("powdered ginger")                         { return 4.0  }
        if n.contains("ground turmeric") || n.contains("turmeric")  { return 4.5  }
        if n.contains("ground cardamom") || n.contains("cardamom")  { return 4.0  }
        if n.contains("ground coriander") || n.contains("coriander seed")
            || n.contains("coriander")                               { return 3.5  }
        if n.contains("mustard seed") || n.contains("mustard powder")
            || n.contains("dry mustard")                             { return 5.5  }
        if n.contains("celery seed") || n.contains("celery salt")   { return 5.5  }
        if n.contains("fennel seed")                                 { return 3.0  }
        if n.contains("caraway seed")                                { return 4.5  }
        if n.contains("dill seed") || n.contains("dill weed")
            || n.contains("dried dill")                              { return 3.0  }
        if n.contains("dried oregano") || n.contains("ground oregano")
            || n.contains("oregano")                                 { return 2.5  }
        if n.contains("dried thyme") || n.contains("ground thyme")
            || n.contains("thyme")                                   { return 2.5  }
        if n.contains("dried basil") || n.contains("ground basil")
            || n.contains("basil")                                   { return 2.0  }
        if n.contains("dried rosemary") || n.contains("rosemary")   { return 2.0  }
        if n.contains("dried parsley") || n.contains("parsley flake")
            || n.contains("parsley")                                 { return 1.5  }
        if n.contains("dried cilantro") || n.contains("coriander leaf") { return 1.5 }
        if n.contains("dried sage") || n.contains("ground sage")
            || n.contains("sage")                                    { return 2.5  }
        if n.contains("dried mint") || n.contains("peppermint leaf") { return 2.0 }
        if n.contains("dried marjoram") || n.contains("marjoram")   { return 2.5  }
        if n.contains("dried tarragon") || n.contains("tarragon")   { return 2.5  }
        if n.contains("italian seasoning") || n.contains("herbes de provence")
            || n.contains("fines herbes")                            { return 2.5  }
        if n.contains("taco seasoning") || n.contains("fajita seasoning")
            || n.contains("enchilada seasoning") || n.contains("mexican seasoning") { return 4.5 }
        if n.contains("cajun seasoning") || n.contains("creole seasoning")
            || n.contains("old bay")                                 { return 5.0  }
        if n.contains("everything bagel") || n.contains("everything seasoning") { return 5.5 }
        if n.contains("five spice") || n.contains("chinese five spice")
            || n.contains("garam masala") || n.contains("curry powder")
            || n.contains("ras el hanout") || n.contains("baharat")
            || n.contains("berbere") || n.contains("za'atar")
            || n.contains("zaatar")                                  { return 4.0  }
        if n.contains("dried herb") || n.contains("mixed herb")     { return 2.5  }
        if n.contains("seasoning") || n.contains("spice blend")
            || n.contains("spice mix")                               { return 4.5  }

        // ═══════════════════════════════════════════════════════════════════
        // FRESH HERBS (much lighter than dried)
        // ═══════════════════════════════════════════════════════════════════
        if n.contains("fresh basil") || n.contains("basil leaf")    { return 0.9  }
        if n.contains("fresh parsley") || n.contains("flat leaf parsley")
            || n.contains("italian parsley")                         { return 1.0  }
        if n.contains("fresh cilantro") || n.contains("fresh coriander") { return 0.9 }
        if n.contains("fresh mint") || n.contains("spearmint")      { return 0.9  }
        if n.contains("fresh dill")                                  { return 0.9  }
        if n.contains("fresh thyme")                                 { return 0.5  }
        if n.contains("fresh rosemary")                              { return 0.7  }
        if n.contains("fresh sage")                                  { return 0.7  }
        if n.contains("fresh tarragon") || n.contains("fresh chervil") { return 0.7 }
        if n.contains("fresh chive") || n.contains("chive")         { return 1.5  }
        if n.contains("scallion") || n.contains("green onion")
            || n.contains("spring onion") || n.contains("salad onion") { return 3.5 }
        if n.contains("fresh herb")                                  { return 0.9  }

        // ═══════════════════════════════════════════════════════════════════
        // BAKING EXTRAS & CHOCOLATE
        // ═══════════════════════════════════════════════════════════════════
        if n.contains("chocolate chip") || n.contains("chocolate chunk")
            || n.contains("mini chocolate chip")                     { return 6.0  }
        if n.contains("white chocolate chip") || n.contains("white chocolate chunk") { return 6.0 }
        if n.contains("peanut butter chip") || n.contains("butterscotch chip")
            || n.contains("caramel bit")                             { return 6.0  }
        if n.contains("dark chocolate") || n.contains("bittersweet chocolate")
            || n.contains("semisweet chocolate") || n.contains("milk chocolate")
            || n.contains("white chocolate")                         { return 6.0  }
        if n.contains("chocolate")                                   { return 6.0  }
        if n.contains("sweetened shredded coconut") || n.contains("flaked coconut")
            || n.contains("desiccated coconut")                      { return 3.0  }
        if n.contains("unsweetened coconut") || n.contains("coconut flake") { return 2.5 }
        if n.contains("toasted coconut")                             { return 3.0  }
        if n.contains("coconut")                                     { return 3.0  }
        if n.contains("mini marshmallow") || n.contains("miniature marshmallow") { return 1.8 }
        if n.contains("large marshmallow") || n.contains("regular marshmallow")
            || n.contains("marshmallow")                             { return 2.0  }
        if n.contains("sprinkle") || n.contains("jimmie")
            || n.contains("nonpareil")                               { return 5.5  }
        if n.contains("vanilla extract") || n.contains("almond extract")
            || n.contains("peppermint extract") || n.contains("lemon extract")
            || n.contains("orange extract")                          { return 8.5  }
        if n.contains("vanilla bean paste") || n.contains("vanilla paste") { return 10.0 }
        if n.contains("food coloring") || n.contains("food colouring") { return 8.5 }
        if n.contains("gelatin powder") || n.contains("gelatine powder") { return 5.0 }
        if n.contains("agar agar") || n.contains("agar-agar")       { return 3.0  }
        if n.contains("pectin")                                      { return 5.5  }

        // ═══════════════════════════════════════════════════════════════════
        // PROTEINS — GROUND & COOKED MEATS
        // ═══════════════════════════════════════════════════════════════════
        if n.contains("ground beef") || n.contains("ground bison")  { return 8.0  }
        if n.contains("ground turkey") || n.contains("ground chicken") { return 8.0 }
        if n.contains("ground pork") || n.contains("ground lamb")
            || n.contains("ground veal")                             { return 8.0  }
        if n.contains("cooked chicken") || n.contains("shredded chicken")
            || n.contains("pulled chicken") || n.contains("rotisserie chicken")
            || n.contains("diced chicken") || n.contains("chopped chicken") { return 5.0 }
        if n.contains("cooked beef") || n.contains("shredded beef")
            || n.contains("pulled beef") || n.contains("diced beef")
            || n.contains("chopped beef") || n.contains("ground cooked beef") { return 5.5 }
        if n.contains("cooked turkey") || n.contains("shredded turkey")
            || n.contains("diced turkey")                            { return 5.0  }
        if n.contains("cooked pork") || n.contains("shredded pork")
            || n.contains("pulled pork") || n.contains("carnitas")  { return 5.5  }
        if n.contains("cooked ham") || n.contains("diced ham")
            || n.contains("chopped ham") || n.contains("cubed ham") { return 5.5  }
        if n.contains("bacon bit") || n.contains("real bacon bit")
            || n.contains("cooked bacon") || n.contains("crumbled bacon") { return 4.0 }
        if n.contains("pepperoni") || n.contains("salami")
            || n.contains("chorizo") || n.contains("andouille")
            || n.contains("kielbasa") || n.contains("sausage")      { return 5.0  }
        if n.contains("prosciutto") || n.contains("pancetta")
            || n.contains("capicola") || n.contains("coppa")
            || n.contains("deli meat") || n.contains("lunch meat")  { return 4.5  }
        if n.contains("canned tuna") || n.contains("canned salmon")
            || n.contains("canned chicken") || n.contains("canned crab") { return 6.0 }
        if n.contains("cooked shrimp") || n.contains("cooked prawn") { return 5.0 }
        if n.contains("cooked crab") || n.contains("lump crab")
            || n.contains("imitation crab")                          { return 5.0  }
        if n.contains("cooked lobster") || n.contains("lobster meat") { return 5.0 }
        if n.contains("cooked scallop") || n.contains("bay scallop") { return 5.5 }
        if n.contains("firm tofu") || n.contains("extra firm tofu")
            || n.contains("silken tofu") || n.contains("soft tofu") { return 8.5  }
        if n.contains("tofu")                                        { return 8.0  }
        if n.contains("tempeh")                                      { return 8.5  }
        if n.contains("seitan")                                      { return 5.5  }
        if n.contains("edamame")                                     { return 5.0  }
        if n.contains("textured vegetable protein") || n.contains("tvp")
            || n.contains("soy crumble") || n.contains("beyond meat")
            || n.contains("impossible meat") || n.contains("plant-based meat") { return 6.5 }

        // ═══════════════════════════════════════════════════════════════════
        // BEANS, LEGUMES & LENTILS
        // ═══════════════════════════════════════════════════════════════════
        if n.contains("black bean")                                  { return 6.0  }
        if n.contains("kidney bean") || n.contains("red kidney bean") { return 6.25 }
        if n.contains("pinto bean")                                  { return 6.0  }
        if n.contains("white bean") || n.contains("great northern bean")
            || n.contains("navy bean") || n.contains("cannellini")  { return 6.0  }
        if n.contains("chickpea") || n.contains("garbanzo")         { return 6.25 }
        if n.contains("black eyed pea") || n.contains("black-eyed pea")
            || n.contains("cowpea")                                  { return 6.0  }
        if n.contains("edamame")                                     { return 5.0  }
        if n.contains("split pea") || n.contains("split green pea")
            || n.contains("split yellow pea")                        { return 6.75 }
        if n.contains("green lentil") || n.contains("brown lentil")
            || n.contains("puy lentil") || n.contains("french lentil") { return 6.75 }
        if n.contains("red lentil") || n.contains("yellow lentil")
            || n.contains("masoor") || n.contains("chana dal")
            || n.contains("toor dal") || n.contains("moong dal")
            || n.contains("urad dal")                                { return 7.0  }
        if n.contains("lentil")                                      { return 6.75 }
        if n.contains("adzuki") || n.contains("azuki") || n.contains("red bean") { return 6.5 }
        if n.contains("mung bean") || n.contains("moong bean")      { return 6.5  }
        if n.contains("fava bean") || n.contains("broad bean")      { return 5.75 }
        if n.contains("lima bean") || n.contains("butter bean")     { return 6.5  }
        if n.contains("soy bean") || n.contains("soybean")          { return 6.0  }
        if n.contains("bean") || n.contains("legume")               { return 6.0  }

        // ═══════════════════════════════════════════════════════════════════
        // NUTS & SEEDS
        // ═══════════════════════════════════════════════════════════════════
        if n.contains("sliced almond") || n.contains("slivered almond") { return 3.5 }
        if n.contains("whole almond") || n.contains("raw almond")
            || n.contains("roasted almond") || n.contains("almond") { return 5.0  }
        if n.contains("whole cashew") || n.contains("raw cashew")
            || n.contains("roasted cashew") || n.contains("cashew") { return 4.5  }
        if n.contains("whole pecan") || n.contains("chopped pecan")
            || n.contains("pecan")                                   { return 4.0  }
        if n.contains("whole pistachio") || n.contains("shelled pistachio")
            || n.contains("pistachio")                               { return 4.5  }
        if n.contains("whole walnut") || n.contains("chopped walnut")
            || n.contains("walnut")                                   { return 3.5 }
        if n.contains("macadamia") || n.contains("macademia")       { return 4.75 }
        if n.contains("hazelnut") || n.contains("filbert")          { return 4.75 }
        if n.contains("brazil nut")                                  { return 5.0  }
        if n.contains("pine nut") || n.contains("pignoli")          { return 5.0  }
        if n.contains("peanut")                                      { return 5.0  }
        if n.contains("chestnut")                                    { return 5.0  }
        if n.contains("sunflower seed")                              { return 5.0  }
        if n.contains("pumpkin seed") || n.contains("pepita")       { return 5.0  }
        if n.contains("sesame seed")                                 { return 6.0  }
        if n.contains("poppy seed")                                  { return 6.0  }
        if n.contains("flaxseed") || n.contains("flax seed")
            || n.contains("ground flax") || n.contains("milled flax") { return 6.0 }
        if n.contains("chia seed") || n.contains("chia")            { return 6.0  }
        if n.contains("hemp seed") || n.contains("hemp heart")      { return 5.5  }
        if n.contains("seed")                                        { return 5.0  }
        if n.contains("nut")                                         { return 4.0  }

        // ═══════════════════════════════════════════════════════════════════
        // VEGETABLES — FRESH
        // ═══════════════════════════════════════════════════════════════════
        if n.contains("baby spinach") || n.contains("spinach leaf") { return 1.5  }
        if n.contains("cooked spinach") || n.contains("sauteed spinach")
            || n.contains("wilted spinach")                          { return 7.0  }
        if n.contains("spinach")                                     { return 1.5  }
        if n.contains("baby arugula") || n.contains("arugula")
            || n.contains("rocket")                                  { return 1.25 }
        if n.contains("spring mix") || n.contains("mixed green")
            || n.contains("mesclun") || n.contains("salad green")   { return 1.5  }
        if n.contains("romaine") || n.contains("cos lettuce")       { return 1.75 }
        if n.contains("iceberg lettuce") || n.contains("shredded lettuce") { return 2.5 }
        if n.contains("butter lettuce") || n.contains("bibb lettuce")
            || n.contains("boston lettuce")                          { return 1.5  }
        if n.contains("red leaf lettuce") || n.contains("green leaf lettuce") { return 1.75 }
        if n.contains("lettuce")                                     { return 2.0  }
        if n.contains("baby kale") || n.contains("chopped kale")
            || n.contains("kale")                                    { return 2.25 }
        if n.contains("swiss chard") || n.contains("rainbow chard") { return 2.0  }
        if n.contains("collard green")                               { return 2.0  }
        if n.contains("beet green") || n.contains("turnip green")
            || n.contains("mustard green")                           { return 1.75 }
        if n.contains("napa cabbage") || n.contains("savoy cabbage")
            || n.contains("shredded cabbage") || n.contains("coleslaw mix")
            || n.contains("cabbage")                                 { return 3.5  }
        if n.contains("bok choy") || n.contains("pak choi")
            || n.contains("chinese cabbage")                         { return 2.5  }
        if n.contains("brussels sprout") || n.contains("brussel sprout") { return 4.5 }
        if n.contains("shallot") || n.contains("pearl onion")       { return 5.5  }
        if n.contains("yellow onion") || n.contains("white onion")
            || n.contains("red onion") || n.contains("sweet onion")
            || n.contains("vidalia") || n.contains("diced onion")
            || n.contains("chopped onion") || n.contains("minced onion")
            || n.contains("sliced onion")                            { return 5.0  }
        if n.contains("leek") || n.contains("sliced leek")
            || n.contains("chopped leek")                            { return 3.5  }
        if n.contains("garlic clove") || n.contains("minced garlic")
            || n.contains("chopped garlic") || n.contains("garlic") { return 5.0  }
        if n.contains("ginger root") || n.contains("fresh ginger")
            || n.contains("grated ginger") || n.contains("minced ginger") { return 5.5 }
        if n.contains("white mushroom") || n.contains("button mushroom")
            || n.contains("cremini mushroom") || n.contains("baby bella")
            || n.contains("portobello mushroom") || n.contains("portabella")
            || n.contains("sliced mushroom") || n.contains("chopped mushroom")
            || n.contains("diced mushroom")                          { return 2.5  }
        if n.contains("shiitake mushroom") || n.contains("oyster mushroom")
            || n.contains("king trumpet") || n.contains("maitake")
            || n.contains("chanterelle") || n.contains("porcini")   { return 2.5  }
        if n.contains("dried mushroom") || n.contains("dried shiitake")
            || n.contains("mushroom powder")                         { return 2.0  }
        if n.contains("mushroom")                                    { return 2.5  }
        if n.contains("red bell pepper") || n.contains("yellow bell pepper")
            || n.contains("orange bell pepper") || n.contains("green bell pepper")
            || n.contains("bell pepper") || n.contains("sweet pepper")
            || n.contains("diced pepper") || n.contains("chopped pepper")
            || n.contains("sliced pepper")                           { return 5.3  }
        if n.contains("jalapeno") || n.contains("jalapeño")
            || n.contains("serrano pepper") || n.contains("poblano")
            || n.contains("anaheim pepper") || n.contains("hatch chile")
            || n.contains("banana pepper") || n.contains("pepperoncini") { return 5.0 }
        if n.contains("habanero") || n.contains("thai chili")
            || n.contains("bird's eye chili") || n.contains("birds eye chili")
            || n.contains("fresno pepper")                           { return 5.0  }
        if n.contains("broccoli floret") || n.contains("broccoli rabe")
            || n.contains("broccolini") || n.contains("broccoli")   { return 3.0  }
        if n.contains("cauliflower floret") || n.contains("cauliflower rice")
            || n.contains("cauliflower")                             { return 3.5  }
        if n.contains("baby carrot") || n.contains("shredded carrot")
            || n.contains("grated carrot") || n.contains("diced carrot")
            || n.contains("sliced carrot") || n.contains("carrot")  { return 4.5  }
        if n.contains("celery stalk") || n.contains("diced celery")
            || n.contains("sliced celery") || n.contains("chopped celery")
            || n.contains("celery")                                  { return 4.0  }
        if n.contains("cherry tomato") || n.contains("grape tomato") { return 5.5 }
        if n.contains("roma tomato") || n.contains("plum tomato")   { return 6.5  }
        if n.contains("beefsteak tomato") || n.contains("heirloom tomato")
            || n.contains("diced tomato") || n.contains("chopped tomato")
            || n.contains("sliced tomato") || n.contains("tomato")  { return 7.0  }
        if n.contains("zucchini") || n.contains("courgette")        { return 4.5  }
        if n.contains("yellow squash") || n.contains("summer squash") { return 4.5 }
        if n.contains("butternut squash") || n.contains("acorn squash")
            || n.contains("delicata squash") || n.contains("kabocha")
            || n.contains("spaghetti squash") || n.contains("winter squash")
            || n.contains("pumpkin puree") || n.contains("canned pumpkin") { return 8.5 }
        if n.contains("pumpkin")                                     { return 5.0  }
        if n.contains("squash")                                      { return 5.0  }
        if n.contains("sweet potato") || n.contains("yam")
            || n.contains("sweet potato puree") || n.contains("mashed sweet potato") { return 7.5 }
        if n.contains("russet potato") || n.contains("yukon gold")
            || n.contains("red potato") || n.contains("fingerling")
            || n.contains("mashed potato") || n.contains("diced potato")
            || n.contains("cubed potato") || n.contains("shredded potato")
            || n.contains("hash brown")                              { return 5.5  }
        if n.contains("potato")                                      { return 5.5  }
        if n.contains("frozen corn") || n.contains("corn kernel")
            || n.contains("canned corn") || n.contains("sweet corn") { return 5.5 }
        if n.contains("corn")                                        { return 5.5  }
        if n.contains("frozen pea") || n.contains("green pea")
            || n.contains("sweet pea")                               { return 4.5  }
        if n.contains("snap pea") || n.contains("snow pea")         { return 3.5  }
        if n.contains("green bean") || n.contains("french bean")
            || n.contains("string bean") || n.contains("haricot vert") { return 3.5 }
        if n.contains("asparagus")                                   { return 5.0  }
        if n.contains("artichoke heart") || n.contains("artichoke") { return 5.5  }
        if n.contains("roasted red pepper") || n.contains("jarred roasted pepper") { return 6.5 }
        if n.contains("water chestnut")                              { return 5.0  }
        if n.contains("bamboo shoot")                                { return 4.5  }
        if n.contains("bean sprout") || n.contains("mung bean sprout") { return 3.5 }
        if n.contains("beet") || n.contains("beetroot")             { return 6.0  }
        if n.contains("parsnip")                                     { return 4.5  }
        if n.contains("turnip") || n.contains("rutabaga")           { return 5.0  }
        if n.contains("fennel bulb") || n.contains("sliced fennel")
            || n.contains("fennel")                                  { return 3.5  }
        if n.contains("jicama")                                      { return 5.0  }
        if n.contains("radish")                                      { return 4.0  }
        if n.contains("daikon")                                      { return 4.5  }
        if n.contains("tomatillo")                                   { return 5.5  }
        if n.contains("cactus") || n.contains("nopal") || n.contains("nopales") { return 4.5 }
        if n.contains("okra")                                        { return 3.5  }
        if n.contains("eggplant") || n.contains("aubergine")        { return 4.0  }
        if n.contains("cucumber") || n.contains("english cucumber")
            || n.contains("persian cucumber")                        { return 5.5  }
        if n.contains("avocado")                                     { return 8.5  }
        if n.contains("roasted vegetable") || n.contains("frozen vegetable")
            || n.contains("mixed vegetable")                         { return 5.0  }

        // ═══════════════════════════════════════════════════════════════════
        // FRUIT — FRESH, FROZEN & DRIED
        // ═══════════════════════════════════════════════════════════════════
        if n.contains("blueberry") || n.contains("fresh blueberry")
            || n.contains("frozen blueberry")                        { return 5.0  }
        if n.contains("raspberry") || n.contains("fresh raspberry")
            || n.contains("frozen raspberry")                        { return 4.25 }
        if n.contains("blackberry") || n.contains("fresh blackberry")
            || n.contains("frozen blackberry")                       { return 5.0  }
        if n.contains("strawberry") || n.contains("sliced strawberry")
            || n.contains("fresh strawberry") || n.contains("frozen strawberry") { return 5.5 }
        if n.contains("cranberry") || n.contains("fresh cranberry")
            || n.contains("frozen cranberry")                        { return 4.0  }
        if n.contains("cherry") || n.contains("sweet cherry")
            || n.contains("tart cherry") || n.contains("bing cherry") { return 5.5 }
        if n.contains("grape")                                       { return 5.75 }
        if n.contains("diced apple") || n.contains("sliced apple")
            || n.contains("chopped apple") || n.contains("apple")   { return 4.5  }
        if n.contains("diced pear") || n.contains("sliced pear")
            || n.contains("pear")                                    { return 5.5  }
        if n.contains("sliced banana") || n.contains("mashed banana")
            || n.contains("banana")                                  { return 8.0  }
        if n.contains("mango chunk") || n.contains("diced mango")
            || n.contains("mango")                                   { return 5.5  }
        if n.contains("pineapple chunk") || n.contains("diced pineapple")
            || n.contains("pineapple")                               { return 5.5  }
        if n.contains("peach") || n.contains("nectarine")           { return 5.5  }
        if n.contains("plum") || n.contains("apricot")              { return 5.5  }
        if n.contains("kiwi") || n.contains("kiwifruit")            { return 6.0  }
        if n.contains("papaya") || n.contains("pawpaw")             { return 5.5  }
        if n.contains("guava")                                       { return 5.5  }
        if n.contains("lychee") || n.contains("litchi")             { return 5.5  }
        if n.contains("fig")                                         { return 5.5  }
        if n.contains("pomegranate seed") || n.contains("pomegranate aril") { return 6.5 }
        if n.contains("watermelon chunk") || n.contains("watermelon cube")
            || n.contains("watermelon")                              { return 5.5  }
        if n.contains("cantaloupe") || n.contains("honeydew")
            || n.contains("melon")                                   { return 5.5  }
        // Dried fruit
        if n.contains("golden raisin") || n.contains("sultana")     { return 5.5  }
        if n.contains("raisin")                                      { return 5.5  }
        if n.contains("dried cranberry") || n.contains("craisin")   { return 5.5  }
        if n.contains("dried cherry") || n.contains("tart dried cherry") { return 5.0 }
        if n.contains("dried apricot") || n.contains("dried peach")
            || n.contains("dried mango") || n.contains("dried papaya") { return 4.5 }
        if n.contains("dried blueberry") || n.contains("dried raspberry") { return 5.0 }
        if n.contains("medjool date") || n.contains("deglet date")
            || n.contains("pitted date") || n.contains("date")      { return 6.5  }
        if n.contains("dried fig") || n.contains("fig")             { return 5.5  }
        if n.contains("prune") || n.contains("dried plum")          { return 5.5  }
        if n.contains("dried pineapple") || n.contains("dried banana chip")
            || n.contains("banana chip")                             { return 4.5  }
        if n.contains("dried fruit") || n.contains("mixed dried fruit")
            || n.contains("fruit mix")                               { return 5.5  }
        if n.contains("freeze dried fruit") || n.contains("freeze-dried fruit") { return 1.5 }

        // ═══════════════════════════════════════════════════════════════════
        // INTERNATIONAL / SPECIALTY INGREDIENTS
        // ═══════════════════════════════════════════════════════════════════
        if n.contains("coconut cream")                               { return 8.7  }
        if n.contains("coconut water")                               { return 8.5  }
        if n.contains("tamarind paste") || n.contains("tamarind concentrate") { return 9.5 }
        if n.contains("curry paste") || n.contains("red curry paste")
            || n.contains("green curry paste") || n.contains("yellow curry paste")
            || n.contains("massaman paste") || n.contains("panang paste") { return 8.5 }
        if n.contains("oyster mushroom") || n.contains("dried porcini") { return 2.5 }
        if n.contains("nori") || n.contains("dried seaweed")
            || n.contains("wakame") || n.contains("kombu")          { return 1.5  }
        if n.contains("mung bean noodle") || n.contains("saifun")   { return 2.5  }
        if n.contains("rice paper")                                  { return 3.0  }
        if n.contains("wonton wrapper") || n.contains("gyoza wrapper")
            || n.contains("dumpling wrapper") || n.contains("egg roll wrapper")
            || n.contains("spring roll wrapper")                     { return 4.0  }
        if n.contains("corn tortilla") || n.contains("flour tortilla") { return 4.5 }
        if n.contains("pita bread") || n.contains("naan bread")
            || n.contains("naan")                                    { return 4.0  }
        if n.contains("panko breadcrumb") || n.contains("japanese breadcrumb") { return 3.5 }
        if n.contains("nutritional yeast") || n.contains("nooch")   { return 2.5  }
        if n.contains("wheat germ")                                  { return 4.0  }
        if n.contains("wheat bran") || n.contains("oat bran")       { return 2.0  }
        if n.contains("psyllium husk") || n.contains("psyllium powder") { return 3.0 }
        if n.contains("flaxseed meal") || n.contains("ground flaxseed") { return 5.0 }
        if n.contains("vital wheat gluten")                          { return 4.0  }
        if n.contains("lecithin")                                    { return 7.5  }
        if n.contains("xanthan gum") || n.contains("guar gum")      { return 5.5  }

        return nil
    }

    // MARK: - Cross-category volume↔weight bridge
    private static func convertVolumeWeight(
        amount: Double,
        from fromUnit: QuantityUnit,
        to toUnit: QuantityUnit,
        ozPerCup: Double,
        volumeToTsp: [QuantityUnit: Double],
        weightToG: [QuantityUnit: Double]
    ) -> Double {
        // Step 1: normalise source to oz
        var ozAmount: Double
        if let tspFactor = volumeToTsp[fromUnit] {
            // Volume → oz:  amount in source unit → cups → oz
            let cups = amount * tspFactor / 48.0   // 48 tsp per cup
            ozAmount = cups * ozPerCup
        } else if let gFactor = weightToG[fromUnit] {
            // Weight → oz
            ozAmount = amount * gFactor / 28.3495
        } else {
            return 0
        }

        // Step 2: convert oz to target unit
        if let tspFactor = volumeToTsp[toUnit] {
            // oz → cups → target volume unit
            let cups = ozAmount / ozPerCup
            return cups * 48.0 / tspFactor        // 48 tsp per cup
        } else if let gFactor = weightToG[toUnit] {
            return ozAmount * 28.3495 / gFactor   // oz → g → target weight unit
        }

        return 0
    }
}
