import Foundation

enum IngredientCategory: String, Codable, CaseIterable {
    case protein        = "Protein"
    case produce        = "Produce"
    case dairy          = "Dairy"
    case pantry         = "Pantry"
    case herbsAndSpices = "Herbs & Spices"
    case other          = "Other"

    var emoji: String {
        switch self {
        case .protein:        return "🥩"
        case .produce:        return "🥬"
        case .dairy:          return "🧀"
        case .pantry:         return "🧺"
        case .herbsAndSpices: return "🌿"
        case .other:          return "📦"
        }
    }

    // Display order for tabs — .other intentionally excluded (legacy fallback only)
    static var orderedCases: [IngredientCategory] {
        [.protein, .produce, .dairy, .pantry, .herbsAndSpices]
    }

    static func suggested(for name: String) -> IngredientCategory {
        let n = name.lowercased().trimmingCharacters(in: .whitespaces)

        if isSeasoningFormName(n) { return .herbsAndSpices }

        // ─────────────────────────────────────────────────────────────────
        // PANTRY — checked FIRST
        // Must come before protein to prevent "chicken broth" → protein
        // Covers: canned, jarred, dry goods, baked goods, oils, condiments,
        // broths, nuts, seeds, sweeteners, bread, pasta, rice, flour, etc.
        // ─────────────────────────────────────────────────────────────────
        let pantryKeywords: [String] = [
            // ── Broths & Stocks ──
            "broth", "stock", "bone broth", "chicken broth", "beef broth",
            "vegetable broth", "fish stock", "dashi", "bouillon",
            // ── Soups & Canned Meals ──
            "soup", "chili", "stew", "chowder",
            "cream of chicken", "cream of mushroom", "cream of celery",
            "cream of tomato", "french onion soup", "tomato bisque",
            // ── Canned Tomatoes & Tomato Products ──
            "tomato sauce", "tomato paste", "crushed tomato", "diced tomato",
            "whole tomato", "stewed tomato", "fire roasted tomato",
            "tomato puree", "san marzano",
            // ── Pasta Sauces & Jarred Sauces ──
            "marinara", "pasta sauce", "arrabiata", "puttanesca",
            "pizza sauce", "alfredo sauce", "vodka sauce",
            "enchilada sauce", "mole sauce", "tikka masala sauce",
            "curry sauce", "stir fry sauce", "teriyaki sauce",
            // ── Canned Beans & Legumes ──
            "black bean", "kidney bean", "pinto bean", "navy bean",
            "white bean", "cannellini", "chickpea", "garbanzo",
            "refried bean", "baked bean", "lentil can", "split pea can",
            "lima bean", "butter bean", "great northern bean",
            "fava bean", "edamame can",
            // ── Canned Vegetables & Fruit ──
            "canned corn", "canned pea", "canned carrot", "canned beet",
            "canned green bean", "canned artichoke", "canned pumpkin",
            "canned mushroom", "canned spinach",
            "canned peach", "canned pear", "canned pineapple",
            "canned mandarin", "canned cherry", "canned apricot",
            "fruit cocktail", "pie filling",
            // ── Canned Fish & Seafood ──
            "canned tuna", "canned salmon", "canned sardine",
            "canned anchovy", "canned clam", "canned crab",
            "canned oyster", "canned shrimp",
            // ── Coconut Products ──
            "coconut milk", "coconut cream", "coconut water",
            "coconut flake", "shredded coconut", "desiccated coconut",
            // ── Dairy Alternatives (shelf stable) ──
            "evaporated milk", "condensed milk", "sweetened condensed",
            "shelf stable milk", "uht milk",
            // ── Condiments ──
            "ketchup", "mustard", "yellow mustard", "dijon mustard",
            "whole grain mustard", "honey mustard",
            "mayo", "mayonnaise", "miracle whip",
            "relish", "sweet relish", "dill relish",
            "hot sauce", "sriracha", "tabasco", "buffalo sauce",
            "chili sauce", "sweet chili", "sambal oelek",
            "worcestershire", "steak sauce", "a1 sauce",
            "hoisin", "oyster sauce", "fish sauce", "soy sauce",
            "tamari", "coconut aminos", "liquid aminos",
            "teriyaki", "ponzu", "mirin", "sake", "rice wine",
            "cooking wine", "white wine for cooking", "red wine for cooking",
            "bbq sauce", "barbecue sauce",
            "salsa", "pico de gallo", "taco sauce",
            "hot salsa", "mild salsa", "medium salsa",
            "guacamole jar", "queso dip",
            "tartar sauce", "cocktail sauce", "remoulade",
            "tzatziki", "hummus store",
            // ── Vinegars ──
            "apple cider vinegar", "white vinegar", "distilled vinegar",
            "red wine vinegar", "white wine vinegar",
            "balsamic vinegar", "balsamic glaze", "balsamic reduction",
            "rice vinegar", "champagne vinegar", "sherry vinegar",
            "malt vinegar",
            // ── Oils ──
            "olive oil", "extra virgin olive oil", "light olive oil",
            "vegetable oil", "canola oil", "avocado oil",
            "sesame oil", "coconut oil", "grapeseed oil",
            "sunflower oil", "peanut oil", "corn oil",
            "safflower oil", "walnut oil", "truffle oil",
            "cooking spray", "nonstick spray", "pam",
            // ── Nut Butters & Spreads ──
            "peanut butter", "almond butter", "cashew butter",
            "sunflower butter", "tahini", "nutella", "cookie butter",
            "sunflower seed butter", "soy nut butter",
            // ── Jams, Jellies & Preserves ──
            "jam", "jelly", "preserve", "marmalade", "fruit spread",
            "apple butter", "lemon curd",
            // ── Sweeteners ──
            "honey", "maple syrup", "agave", "agave nectar",
            "molasses", "blackstrap molasses", "corn syrup",
            "light corn syrup", "dark corn syrup",
            "golden syrup", "simple syrup", "rice syrup",
            // ── Pickled & Fermented ──
            "pickle", "dill pickle", "bread and butter pickle",
            "gherkin", "cornichon", "pickled jalapeño", "pickled onion",
            "pickled ginger", "pickled beet", "kimchi", "sauerkraut",
            "pickled vegetable", "banana pepper jar", "pepperoncini jar",
            // ── Olives & Capers ──
            "olive", "kalamata olive", "green olive", "black olive",
            "castelvetrano", "stuffed olive", "olive tapenade",
            "caper", "caper berry",
            // ── Jarred Vegetables & Antipasto ──
            "sun dried tomato", "roasted red pepper", "artichoke heart",
            "bamboo shoot", "water chestnut", "hearts of palm",
            "pimento", "roasted garlic jar", "marinated artichoke",
            "antipasto", "giardiniera",
            // ── Pastes & Concentrated Flavors ──
            "miso paste", "curry paste", "red curry paste",
            "green curry paste", "yellow curry paste",
            "gochujang", "doenjang", "doubanjiang",
            "harissa", "chipotle in adobo", "adobo sauce",
            "tomato concentrate", "anchovy paste", "lobster paste",
            "shrimp paste", "fermented black bean", "oyster paste",
            // ── Pasta & Noodles ──
            "pasta", "spaghetti", "linguine", "fettuccine", "penne",
            "rigatoni", "fusilli", "rotini", "farfalle", "bow tie",
            "orzo", "gnocchi", "shells", "elbow macaroni", "macaroni",
            "lasagna noodle", "egg noodle", "wide noodle",
            "udon", "soba", "ramen noodle", "rice noodle", "pad thai noodle",
            "glass noodle", "cellophane noodle", "vermicelli",
            "couscous", "angel hair", "bucatini", "orecchiette",
            "cavatappi", "pappardelle", "tagliatelle",
            // ── Rice & Grains ──
            "rice", "white rice", "brown rice", "jasmine rice",
            "basmati rice", "arborio rice", "sushi rice", "short grain rice",
            "long grain rice", "wild rice", "black rice", "red rice",
            "quinoa", "bulgur", "farro", "freekeh", "barley",
            "millet", "amaranth", "teff", "spelt", "kamut",
            "polenta", "grits", "cornmeal", "hominy",
            "oat", "rolled oat", "steel cut oat", "quick oat",
            "instant oatmeal", "oat bran",
            // ── Flour & Baking ──
            "flour", "all purpose flour", "bread flour", "cake flour",
            "pastry flour", "self rising flour", "whole wheat flour",
            "almond flour", "coconut flour", "rice flour",
            "chickpea flour", "buckwheat flour", "rye flour",
            "spelt flour", "gluten free flour", "cassava flour",
            "semolina", "vital wheat gluten",
            "baking soda", "baking powder", "cream of tartar",
            "cornstarch", "arrowroot", "tapioca starch", "potato starch",
            "yeast", "active dry yeast", "instant yeast", "bread yeast",
            "baking chocolate", "cocoa powder", "dutch cocoa",
            "chocolate chip", "white chocolate chip", "dark chocolate chip",
            "baking chip", "chocolate chunk", "chocolate bar baking",
            "unsweetened chocolate", "dark chocolate baking",
            // ── Sugar & Sweeteners (dry) ──
            "sugar", "white sugar", "granulated sugar",
            "brown sugar", "light brown sugar", "dark brown sugar",
            "powdered sugar", "confectioners sugar", "icing sugar",
            "raw sugar", "turbinado", "demerara", "coconut sugar",
            "stevia", "monk fruit", "erythritol", "xylitol", "splenda",
            // ── Bread & Baked Goods ──
            "bread", "white bread", "wheat bread", "sourdough",
            "rye bread", "pumpernickel", "brioche", "challah",
            "ciabatta", "baguette", "focaccia", "naan",
            "pita bread", "pita", "lavash", "flatbread",
            "tortilla", "flour tortilla", "corn tortilla", "wrap",
            "burger bun", "hot dog bun", "slider bun", "dinner roll",
            "english muffin", "bagel", "croissant", "pretzel bun",
            "taco shell", "tostada", "wonton wrapper", "dumpling wrapper",
            "spring roll wrapper", "phyllo dough", "puff pastry",
            "pie crust", "pizza dough", "pizza crust",
            "breadcrumb", "panko", "seasoned breadcrumb",
            "crouton", "stuffing mix", "cracker", "graham cracker",
            "saltine", "ritz cracker", "rice cake",
            // ── Breakfast & Cereal ──
            "cereal", "granola", "muesli", "oatmeal packet",
            "pancake mix", "waffle mix", "biscuit mix", "cake mix",
            "brownie mix", "muffin mix", "cornbread mix",
            "instant grits", "cream of wheat",
            // ── Chips & Snacks ──
            "tortilla chip", "corn chip", "potato chip",
            "pretzel", "popcorn", "pork rind", "rice cracker",
            "pita chip", "bagel chip", "cracker",
            // ── Nuts & Seeds ──
            "almond", "walnut", "pecan", "cashew", "pistachio",
            "peanut", "macadamia", "brazil nut", "hazelnut",
            "pine nut", "chestnut", "mixed nut",
            "sunflower seed", "pumpkin seed", "pepita",
            "flaxseed", "chia seed", "hemp seed", "sesame seed",
            "poppy seed",
            // ── Dried Fruit ──
            "raisin", "golden raisin", "sultana", "dried cranberry",
            "dried cherry", "dried apricot", "dried mango",
            "dried blueberry", "dried fig", "prune", "dried plum",
            "medjool date", "dried date", "currant",
            "dried pineapple", "dried apple", "dried banana chip",
            // ── Canned/Jarred Proteins (shelf stable) ──
            "spam", "corned beef hash", "canned chicken",
            // ── Extracts & Flavorings (non-spice) ──
            "vanilla extract", "almond extract", "lemon extract",
            "orange extract", "peppermint extract",
            "coconut extract", "rum extract",
            // ── Leavening & Thickeners ──
            "gelatin", "unflavored gelatin", "agar agar",
            "pectin", "xanthan gum", "guar gum",
            // ── Misc Pantry ──
            "nutritional yeast", "msg", "dextrose",
            "food coloring", "sprinkle", "edible glitter",
            "dried mushroom", "dried porcini", "dried shiitake",
            "sun dried", "dehydrated",
            "stock cube", "bouillon cube", "base paste",
            "instant mashed potato", "potato flake",
            "textured vegetable protein", "tvp",
            "protein powder", "collagen powder",
            "coffee", "instant coffee", "espresso powder",
            "tea", "herbal tea", "matcha powder",
            "cocoa mix", "hot chocolate mix",
            "drink mix", "kool aid", "powdered lemonade",
            "sparkling water", "club soda", "tonic water",
            "soda", "cola", "juice box",
            "juice", "lemon juice", "lime juice", "orange juice", "apple juice",
            "papaya juice", "fruit juice",
            "beer", "wine", "white wine", "red wine", "champagne",
            "vodka", "rum", "whiskey", "bourbon", "tequila", "gin",
            "cooking sherry", "vermouth",
            "water"
        ]
        if pantryKeywords.contains(where: { n.contains($0) }) { return .pantry }

        // ─────────────────────────────────────────────────────────────────
        // HERBS & SPICES
        // Fresh + dried herbs, loose spices, blends, garlic, ginger
        // ─────────────────────────────────────────────────────────────────
        let herbsSpicesKeywords: [String] = [
            // ── Salt & Pepper ──
            "salt", "black pepper", "white pepper", "pink pepper",
            "peppercorn", "sea salt", "kosher salt", "himalayan salt",
            "fleur de sel", "celery salt", "garlic salt", "onion salt",
            "seasoned salt", "smoked salt", "truffle salt",
            // ── Individual Spices ──
            "cumin", "coriander", "turmeric", "paprika", "smoked paprika",
            "sweet paprika", "hot paprika",
            "cayenne", "chili powder", "chipotle powder", "ancho powder",
            "cinnamon", "ground cinnamon", "cinnamon stick",
            "nutmeg", "ground nutmeg", "clove", "ground clove",
            "allspice", "cardamom", "green cardamom", "black cardamom",
            "ginger powder", "ground ginger",
            "mace", "star anise", "fennel seed", "caraway seed",
            "mustard seed", "yellow mustard seed", "black mustard seed",
            "celery seed", "poppy seed", "nigella seed",
            "saffron", "sumac", "za'atar", "dukkah",
            "ras el hanout", "baharat", "berbere",
            "five spice", "chinese five spice",
            "fenugreek", "ajwain", "asafoetida", "hing",
            "annatto", "achiote",
            "vanilla bean", "vanilla pod",
            // ── Powder & Granulated Aromatics ──
            "garlic powder", "onion powder", "shallot powder",
            "mushroom powder", "tomato powder", "beet powder",
            "wasabi powder", "horseradish powder",
            // ── Dried Herbs ──
            "dried basil", "dried oregano", "dried thyme",
            "dried rosemary", "dried parsley", "dried dill",
            "dried sage", "dried marjoram", "dried bay",
            "bay leaf", "dried mint", "dried cilantro",
            "dried chive", "dried tarragon", "dried lavender",
            "dried lemongrass",
            // ── Fresh Herbs ──
            "fresh basil", "basil", "fresh oregano", "oregano",
            "fresh thyme", "thyme", "fresh rosemary", "rosemary",
            "fresh parsley", "parsley", "fresh dill", "dill",
            "fresh sage", "sage", "fresh marjoram", "marjoram",
            "fresh mint", "mint", "fresh cilantro", "cilantro",
            "fresh chive", "fresh tarragon", "tarragon",
            "fresh lavender", "lavender", "lemongrass",
            "kaffir lime leaf", "curry leaf", "makrut lime",
            "epazote", "culantro", "shiso", "perilla",
            // ── Blended Seasonings & Rubs ──
            "garam masala", "curry powder", "tikka masala powder",
            "tandoori masala", "chaat masala", "sambar powder",
            "taco seasoning", "fajita seasoning", "burrito seasoning",
            "cajun seasoning", "creole seasoning", "old bay",
            "jerk seasoning", "jamaican jerk", "adobo seasoning",
            "sazon", "sofrito dry",
            "ranch seasoning", "dry ranch", "onion soup mix dry",
            "everything bagel seasoning",
            "lemon pepper seasoning", "garlic herb seasoning",
            "steak seasoning", "montreal steak", "chicago steak",
            "poultry seasoning", "seafood seasoning", "fish seasoning",
            "bbq rub", "dry rub", "spice rub", "spice blend",
            "pumpkin pie spice", "apple pie spice", "chai spice",
            "italian seasoning", "herbs de provence", "bouquet garni",
            "za'atar blend", "harissa powder", "berbere blend",
            // ── Fresh Aromatics ──
            "garlic", "garlic clove", "garlic bulb", "garlic head",
            "elephant garlic", "black garlic",
            "fresh ginger", "ginger root", "ginger knob",
            "galangal", "turmeric root", "fresh turmeric",
            "horseradish root", "wasabi root", "fresh wasabi",
            // ── Pepper Varieties (not black pepper — those above) ──
            "szechuan pepper", "sichuan pepper", "long pepper",
            "grains of paradise",
            // ── Chili Peppers (dried, not fresh) ──
            "dried chili", "red pepper flake", "chili flake",
            "dried ancho", "dried pasilla", "dried guajillo",
            "dried chipotle", "dried arbol", "dried habanero",
            "dried cayenne pepper", "bird eye chili dried",
            "korean chili flake", "gochugaru",
            // ── Asian Spices & Aromatics ──
            "togarashi", "shichimi togarashi", "furikake",
            "dashi powder", "bonito powder",
            // ── Finishing & Garnish ──
            "flaky salt", "maldon salt", "smoked flaky salt"
        ]
        // Guard: "sausage" contains "sage" — don't let it land in Herbs & Spices
        let herbFalsePositives = ["sausage"]
        if !herbFalsePositives.contains(where: { n.contains($0) }),
           herbsSpicesKeywords.contains(where: { n.contains($0) }) { return .herbsAndSpices }

        // ─────────────────────────────────────────────────────────────────
        // PROTEIN
        // ─────────────────────────────────────────────────────────────────
        let proteinKeywords: [String] = [
            // ── Standalone animal names (must appear first for plain "Beef", "Pork", etc.) ──
            "beef", "pork", "chicken", "turkey", "lamb", "veal",
            "venison", "duck", "rabbit", "bison", "elk", "goose",
            "quail", "pheasant", "salmon", "tuna", "tilapia", "cod",
            "halibut", "shrimp", "prawn", "lobster", "crab", "scallop",
            "clam", "mussel", "oyster", "squid", "calamari", "octopus",
            "trout", "bass", "snapper", "mahi", "swordfish", "sardine",
            "herring", "mackerel", "catfish", "flounder", "pollock",
            "haddock", "grouper", "monkfish", "barramundi", "branzino",
            "anchovies", "anchovy",
            // ── Chicken ──
            "chicken breast", "chicken thigh", "chicken leg",
            "chicken wing", "chicken drumstick", "chicken tender",
            "chicken cutlet", "chicken strip", "chicken fillet",
            "whole chicken", "rotisserie chicken",
            "ground chicken", "minced chicken",
            "chicken liver", "chicken heart", "chicken gizzard",
            // ── Turkey ──
            "turkey breast", "turkey thigh", "turkey leg",
            "turkey wing", "ground turkey", "minced turkey",
            "whole turkey", "turkey cutlet", "turkey meatball",
            // ── Beef ──
            "ground beef", "minced beef", "beef mince",
            "chuck roast", "chuck steak", "beef chuck",
            "ribeye", "rib eye", "rib-eye steak",
            "sirloin", "top sirloin", "bottom sirloin", "sirloin steak",
            "filet mignon", "beef tenderloin", "tenderloin steak",
            "t-bone", "t bone", "porterhouse",
            "new york strip", "ny strip", "strip steak",
            "flank steak", "skirt steak", "hanger steak",
            "flat iron steak", "denver steak",
            "beef brisket", "brisket",
            "beef short rib", "short rib", "beef rib",
            "beef shank", "oxtail", "osso buco beef",
            "beef stew meat", "stew beef", "beef cubes",
            "beef roast", "pot roast", "round roast", "rump roast",
            "eye of round", "top round", "bottom round",
            "london broil", "tri tip", "tri-tip",
            "beef liver", "beef heart", "beef kidney", "beef tongue",
            "corned beef", "pastrami",
            "beef sausage", "beef meatball", "beef hot dog",
            "beef jerky", "beef burger patty",
            // ── Pork ──
            "ground pork", "minced pork",
            "pork chop", "bone-in pork chop", "pork loin chop",
            "pork tenderloin", "pork loin", "pork roast",
            "pork shoulder", "pork butt", "boston butt", "pork collar",
            "pork belly", "pork ribs", "baby back rib", "spare rib",
            "st louis rib", "pork rib rack",
            "pork leg", "ham hock", "pork knuckle", "pork shank",
            "pork cutlet", "pork schnitzel", "pork escalope",
            "pulled pork", "carnitas", "pork meatball",
            "ham", "honey ham", "spiral ham", "black forest ham",
            "prosciutto", "prosciutto crudo", "prosciutto cotto",
            "pancetta", "guanciale", "lardons", "pork lard",
            "bacon", "canadian bacon", "back bacon", "thick cut bacon",
            "turkey bacon", "pork belly bacon",
            "sausage", "pork sausage", "italian sausage", "sweet italian sausage",
            "chorizo", "spanish chorizo", "mexican chorizo",
            "andouille", "bratwurst", "brat", "kielbasa",
            "hot dog", "frankfurter", "wiener",
            "pepperoni", "salami", "genoa salami", "hard salami",
            "mortadella", "bologna", "coppa", "soppressata",
            // ── Lamb & Game ──
            "ground lamb", "minced lamb",
            "lamb chop", "rack of lamb", "lamb rack",
            "lamb shoulder", "lamb leg", "leg of lamb",
            "lamb shank", "lamb loin", "lamb cutlet",
            "lamb breast", "lamb neck",
            "lamb liver", "lamb kidney",
            "ground venison", "venison steak", "venison chop", "venison",
            "duck breast", "duck leg", "duck confit", "whole duck", "duck",
            "rabbit", "whole rabbit", "rabbit leg",
            "bison", "bison burger", "ground bison",
            "elk", "boar", "wild boar",
            "quail", "pheasant", "goose", "cornish hen",
            // ── Seafood — Fish ──
            "salmon fillet", "salmon steak", "salmon",
            "smoked salmon", "lox", "gravlax",
            "tuna steak", "ahi tuna", "yellowfin tuna", "bluefin tuna",
            "tilapia", "cod fillet", "cod",
            "halibut", "halibut fillet", "halibut steak",
            "sea bass", "chilean sea bass", "striped bass",
            "mahi mahi", "mahi-mahi", "dolphinfish",
            "swordfish", "snapper", "red snapper",
            "trout", "rainbow trout", "arctic char",
            "catfish", "flounder", "sole", "dover sole",
            "turbot", "sardine fresh", "herring fresh",
            "mackerel", "barramundi", "branzino", "european sea bass",
            "monkfish", "grouper", "pollock", "haddock",
            "whiting", "walleye", "perch", "bass fillet",
            "white fish", "whitefish",
            // ── Seafood — Shellfish ──
            "shrimp", "prawn", "tiger prawn", "jumbo shrimp",
            "gulf shrimp", "rock shrimp",
            "scallop", "bay scallop", "sea scallop",
            "lobster tail", "whole lobster", "lobster", "langoustine",
            "crab", "king crab leg", "dungeness crab", "blue crab",
            "stone crab", "snow crab", "crab cake",
            "clam", "littleneck clam", "manila clam", "razor clam",
            "mussel", "blue mussel", "green mussel",
            "oyster", "raw oyster",
            "squid", "calamari", "octopus", "cuttlefish",
            // ── Eggs ──
            "egg", "eggs", "egg white", "egg yolk",
            "large egg", "extra large egg", "medium egg",
            "brown egg", "white egg", "free range egg",
            "duck egg", "quail egg",
            // ── Plant-Based Proteins ──
            "tofu", "firm tofu", "silken tofu", "extra firm tofu",
            "soft tofu", "medium firm tofu",
            "tempeh", "seitan", "wheat meat",
            "textured soy", "soy protein",
            "beyond burger", "impossible burger", "beyond meat",
            "impossible meat", "plant based burger",
            // ── Other Proteins ──
            "paneer", "halloumi", "quark protein",
            "deli chicken", "deli ham", "deli roast beef",
            "deli turkey", "deli meat", "lunch meat",
            "liverwurst", "pate", "foie gras"
        ]
        // Guard: "eggplant" / "egg noodle" / "egg roll" contain "egg" — those are produce/pantry
        let proteinFalsePositives = ["eggplant", "egg noodle", "egg roll"]
        if !proteinFalsePositives.contains(where: { n.contains($0) }),
           proteinKeywords.contains(where: { n.contains($0) }) { return .protein }

        // ─────────────────────────────────────────────────────────────────
        // DAIRY
        // ─────────────────────────────────────────────────────────────────
        let dairyKeywords: [String] = [
            // ── Milk ──
            "whole milk", "2% milk", "1% milk", "skim milk",
            "lowfat milk", "reduced fat milk", "full fat milk",
            "milk", "raw milk",
            "buttermilk", "cultured buttermilk",
            "lactose free milk", "lactaid",
            "oat milk", "almond milk", "soy milk", "cashew milk",
            "rice milk", "hemp milk", "flax milk", "macadamia milk",
            "pea milk", "coconut milk beverage",
            // ── Cream ──
            "heavy cream", "heavy whipping cream", "whipping cream",
            "light cream", "half and half", "coffee cream",
            "double cream", "single cream", "table cream",
            "sour cream", "low fat sour cream",
            "creme fraiche", "clotted cream",
            // ── Butter & Ghee ──
            "butter", "unsalted butter", "salted butter",
            "european butter", "cultured butter", "grass fed butter",
            "kerrygold", "plugra",
            "ghee", "clarified butter",
            "vegan butter", "plant butter", "margarine",
            "earth balance", "miyoko",
            // ── Yogurt ──
            "greek yogurt", "plain yogurt", "vanilla yogurt",
            "whole milk yogurt", "lowfat yogurt", "nonfat yogurt",
            "yogurt", "skyr", "icelandic yogurt",
            "kefir", "drinkable yogurt", "labneh",
            "coconut yogurt", "almond yogurt", "soy yogurt",
            "oat yogurt", "cashew yogurt",
            // ── Soft Cheese ──
            "cream cheese", "neufchatel", "whipped cream cheese",
            "brie", "camembert", "ricotta", "whole milk ricotta",
            "mascarpone", "cottage cheese", "pot cheese",
            "burrata", "stracciatella",
            "fresh mozzarella", "mozzarella ball", "ciliegine",
            "bocconcini", "zarella",   // "zarella" catches truncated API names like "M Zarella"
            // ── Semi-Soft Cheese ──
            "mozzarella", "shredded mozzarella", "low moisture mozzarella",
            "provolone", "fontina", "havarti", "muenster",
            "monterey jack", "colby jack", "colby", "pepper jack",
            "gouda", "smoked gouda", "aged gouda", "edam",
            "american cheese", "velveeta",
            // ── Semi-Hard Cheese ──
            "cheddar", "sharp cheddar", "mild cheddar", "white cheddar",
            "yellow cheddar", "extra sharp cheddar", "aged cheddar",
            "swiss", "gruyere", "emmental", "jarlsberg",
            "manchego", "comte", "appenzeller",
            // ── Hard Cheese ──
            "parmesan", "parmigiano reggiano", "grana padano",
            "pecorino", "pecorino romano", "romano",
            "asiago", "aged asiago",
            // ── Blue & Specialty ──
            "feta", "greek feta", "bulgarian feta",
            "queso fresco", "queso blanco", "cotija", "panela",
            "oaxaca cheese", "asadero", "quesillo",
            "blue cheese", "gorgonzola", "roquefort", "stilton",
            "danish blue", "maytag blue",
            "limburger", "taleggio", "epoisses",
            "halloumi", "saganaki",
            // ── Packaged & Processed ──
            "string cheese", "babybel", "laughing cow",
            "kraft singles", "cheese slice", "american slice",
            "shredded cheese", "cheese blend", "mexican blend",
            "italian blend", "four cheese blend",
            // ── Ice Cream & Frozen ──
            "ice cream", "gelato", "frozen yogurt",
            "whipped cream", "cool whip",
            "condensed milk dairy"
        ]
        if dairyKeywords.contains(where: { n.contains($0) }) { return .dairy }

        // ─────────────────────────────────────────────────────────────────
        // PRODUCE
        // Vegetables, fruits, fresh mushrooms, fresh aromatics (not garlic/ginger)
        // ─────────────────────────────────────────────────────────────────
        let produceKeywords: [String] = [
            // ── Leafy Greens ──
            "spinach", "baby spinach", "kale", "lacinato kale",
            "curly kale", "red kale", "chard", "swiss chard",
            "rainbow chard", "collard green", "mustard green",
            "beet green", "turnip green", "dandelion green",
            "romaine", "romaine lettuce", "iceberg", "iceberg lettuce",
            "butter lettuce", "boston lettuce", "bibb lettuce",
            "green leaf lettuce", "red leaf lettuce", "oak leaf lettuce",
            "arugula", "rocket", "wild arugula",
            "watercress", "endive", "belgian endive", "radicchio",
            "spring mix", "mixed greens", "mesclun", "salad mix",
            "baby arugula", "baby kale", "power greens",
            "microgreen", "sprout",
            // ── Cabbage Family ──
            "cabbage", "napa cabbage", "savoy cabbage", "red cabbage",
            "green cabbage", "pointed cabbage",
            "bok choy", "baby bok choy", "pak choi", "tatsoi",
            // ── Brassicas ──
            "broccoli", "broccoli floret", "broccolini", "broccoli rabe",
            "rapini", "cauliflower", "romanesco", "purple cauliflower",
            "brussels sprout", "kohlrabi",
            // ── Root Vegetables ──
            "carrot", "baby carrot", "rainbow carrot",
            "parsnip", "turnip", "rutabaga", "swede",
            "beet", "red beet", "golden beet", "chioggia beet",
            "radish", "french radish", "daikon", "watermelon radish",
            "potato", "russet potato", "yukon gold", "red potato",
            "fingerling potato", "new potato", "baby potato",
            "purple potato", "blue potato",
            "sweet potato", "garnet yam", "jewel yam", "purple sweet potato",
            "yam",
            "celery root", "celeriac", "sunchoke", "jerusalem artichoke",
            "jicama", "lotus root", "taro root", "cassava", "yuca",
            "malanga", "parsley root",
            // ── Alliums (not garlic — that's Herbs) ──
            "onion", "yellow onion", "white onion", "red onion",
            "sweet onion", "vidalia", "walla walla", "cipollini",
            "pearl onion", "cocktail onion",
            "shallot", "french shallot", "banana shallot",
            "leek", "baby leek",
            "green onion", "scallion", "spring onion",
            "chive", "garlic chive",
            // ── Nightshades ──
            "tomato", "cherry tomato", "grape tomato", "roma tomato",
            "heirloom tomato", "beefsteak tomato", "plum tomato",
            "vine tomato", "campari tomato", "kumato",
            "bell pepper", "red bell pepper", "green bell pepper",
            "yellow bell pepper", "orange bell pepper",
            "mini sweet pepper", "sweet pepper",
            "poblano", "anaheim pepper", "pasilla pepper",
            "jalapeno", "serrano", "habanero", "thai chili",
            "fresno chili", "banana pepper", "pepperoncini fresh",
            "ghost pepper", "scotch bonnet",
            "eggplant", "globe eggplant", "italian eggplant",
            "japanese eggplant", "chinese eggplant",
            "thai eggplant", "graffiti eggplant",
            "tomatillo",
            // ── Squash & Gourd ──
            "zucchini", "courgette", "yellow squash", "summer squash",
            "pattypan squash", "delicata squash", "acorn squash",
            "butternut squash", "spaghetti squash", "kabocha squash",
            "pumpkin", "sugar pumpkin", "pie pumpkin",
            "hubbard squash", "honeynut squash", "carnival squash",
            "cucumber", "english cucumber", "persian cucumber",
            "pickling cucumber", "kirby cucumber",
            "bitter melon", "chayote", "luffa",
            // ── Fungi ──
            "mushroom", "cremini mushroom", "button mushroom",
            "portobello mushroom", "shiitake mushroom",
            "oyster mushroom", "enoki mushroom", "maitake",
            "chanterelle", "morel", "porcini fresh",
            "king trumpet", "lion's mane mushroom", "beech mushroom",
            // ── Pods & Corn ──
            "green bean", "haricot vert", "french green bean",
            "snap pea", "snow pea", "sugar snap pea",
            "fresh edamame", "fresh soybean",
            "corn", "sweet corn", "corn on the cob", "baby corn",
            "okra",
            // ── Artichoke & Specialty ──
            "artichoke", "globe artichoke",
            "asparagus", "white asparagus", "purple asparagus",
            "fennel", "fennel bulb", "celery", "celery stalk",
            "rhubarb",
            // ── Fruits — Citrus ──
            "lemon", "eureka lemon", "meyer lemon",
            "lime", "key lime", "persian lime",
            "orange", "navel orange", "blood orange", "cara cara",
            "grapefruit", "ruby red grapefruit", "pink grapefruit",
            "tangerine", "clementine", "mandarin", "satsuma",
            "yuzu", "kumquat", "pomelo",
            // ── Fruits — Berries ──
            "strawberry", "strawberries",
            "blueberry", "blueberries",
            "raspberry", "raspberries",
            "blackberry", "blackberries",
            "boysenberry", "boysenberries",
            "marionberry", "marionberries",
            "huckleberry", "huckleberries",
            "cranberry", "cranberries",
            "gooseberry", "gooseberries",
            "currant fresh",
            "elderberry", "elderberries",
            "mulberry", "mulberries",
            // ── Fruits — Stone ──
            "peach", "white peach", "yellow peach", "donut peach",
            "nectarine", "plum", "pluot", "apricot",
            "cherry", "bing cherry", "rainier cherry",
            // ── Fruits — Tropical ──
            "mango", "ataulfo mango", "champagne mango",
            "pineapple", "papaya", "guava", "passionfruit",
            "starfruit", "carambola", "dragon fruit", "pitaya",
            "lychee", "longan", "rambutan", "jackfruit", "durian",
            "coconut fresh", "young coconut",
            "banana", "plantain", "burro banana",
            // ── Fruits — Melon ──
            "watermelon", "seedless watermelon", "mini watermelon",
            "cantaloupe", "honeydew", "casaba melon",
            "galia melon", "canary melon",
            // ── Fruits — Apple & Pear ──
            "apple", "gala apple", "fuji apple", "honeycrisp",
            "granny smith", "pink lady", "braeburn", "mcintosh",
            "pear", "bartlett pear", "bosc pear", "anjou pear",
            "asian pear",
            // ── Fruits — Grape & Fig ──
            "grape", "red grape", "green grape", "concord grape",
            "fig", "black fig", "brown turkey fig",
            "pomegranate", "persimmon", "quince",
            "kiwi", "golden kiwi", "kiwi berry",
            "avocado", "hass avocado", "florida avocado"
        ]
        if produceKeywords.contains(where: { n.contains($0) }) { return .produce }

        // ─────────────────────────────────────────────────────────────────
        // PANTRY — default fallback for anything unrecognized
        // ─────────────────────────────────────────────────────────────────
        return .pantry
    }

    private static func isSeasoningFormName(_ name: String) -> Bool {
        let seasoningFormWords = ["minced", "ground", "chopped", "dried", "powder", "flakes", "flake"]
        guard seasoningFormWords.contains(where: { name.contains($0) }) else { return false }

        let notSeasoningWords = [
            "ground beef", "minced beef", "ground chicken", "minced chicken",
            "ground turkey", "minced turkey", "ground pork", "minced pork",
            "ground lamb", "minced lamb", "ground bison", "ground venison",
            "powdered sugar", "confectioners sugar", "icing sugar",
            "baking powder", "cocoa powder", "protein powder", "collagen powder",
            "dried cranberry", "dried cranberries", "dried cherry", "dried cherries",
            "dried apricot", "dried apricots", "dried mango", "dried blueberry",
            "dried blueberries", "dried fig", "dried figs", "dried plum",
            "dried pineapple", "dried apple", "dried banana"
        ]

        return !notSeasoningWords.contains(where: { name.contains($0) })
    }
}
