import Foundation

// MARK: - Browse Categories
enum BrowseCategory: String, CaseIterable {
    case trending = "Trending"
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case soup = "Soup"
    case snacks = "Snacks"
    case desserts = "Desserts"
    case american = "American"
    case italian = "Italian"
    case mexican = "Mexican"
    case asian = "Asian"
    case mediterranean = "Mediterranean"
    case indian = "Indian"

    var icon: String {
        switch self {
        case .trending: return "flame.fill"
        case .breakfast: return "sunrise.fill"
        case .lunch: return "sun.max.fill"
        case .dinner: return "moon.stars.fill"
        case .soup: return "drop.fill"
        case .snacks: return "leaf.fill"
        case .desserts: return "birthday.cake.fill"
        case .american: return "flag.fill"
        case .italian: return "fork.knife"
        case .mexican: return "flame"
        case .asian: return "wind"
        case .mediterranean: return "water.waves"
        case .indian: return "sparkles"
        }
    }
}

// MARK: - Browse Mock Recipes
let mockBrowseRecipes: [BrowseCategory: [SpoonacularRecipe]] = [

    .trending: [
        SpoonacularRecipe(id: 2001, title: "Creamy Tuscan Chicken", image: "https://img.spoonacular.com/recipes/716426-312x231.jpg", readyInMinutes: 30, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 1, name: "chicken breast", original: "4 chicken breasts", amount: 4, unit: "piece", image: nil),
            RecipeIngredient(id: 100, name: "sun dried tomatoes", original: "1/2 cup sun dried tomatoes", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 101, name: "spinach", original: "2 cups spinach", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 102, name: "heavy cream", original: "1 cup heavy cream", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "4 cloves garlic", amount: 4, unit: "cloves", image: nil),
            RecipeIngredient(id: 8, name: "parmesan", original: "1/2 cup parmesan", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "2 tbsp olive oil", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 94),
        SpoonacularRecipe(id: 2002, title: "Honey Garlic Salmon", image: "https://img.spoonacular.com/recipes/654812-312x231.jpg", readyInMinutes: 20, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 103, name: "salmon", original: "2 salmon fillets", amount: 2, unit: "piece", image: nil),
            RecipeIngredient(id: 104, name: "honey", original: "3 tbsp honey", amount: 3, unit: "tbsp", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "4 cloves garlic", amount: 4, unit: "cloves", image: nil),
            RecipeIngredient(id: 4, name: "soy sauce", original: "2 tbsp soy sauce", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 3, name: "butter", original: "1 tbsp butter", amount: 1, unit: "tbsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 92),
        SpoonacularRecipe(id: 2003, title: "One Pan Pasta", image: "https://img.spoonacular.com/recipes/632660-312x231.jpg", readyInMinutes: 25, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 7, name: "pasta", original: "400g spaghetti", amount: 400, unit: "g", image: nil),
            RecipeIngredient(id: 105, name: "cherry tomatoes", original: "1 cup cherry tomatoes", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "4 cloves garlic", amount: 4, unit: "cloves", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "3 tbsp olive oil", amount: 3, unit: "tbsp", image: nil),
            RecipeIngredient(id: 106, name: "basil", original: "fresh basil", amount: 1, unit: "bunch", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 90),
        SpoonacularRecipe(id: 2004, title: "Sheet Pan Fajitas", image: "https://img.spoonacular.com/recipes/633942-312x231.jpg", readyInMinutes: 35, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 1, name: "chicken breast", original: "500g chicken breast", amount: 500, unit: "g", image: nil),
            RecipeIngredient(id: 107, name: "bell pepper", original: "3 bell peppers", amount: 3, unit: "whole", image: nil),
            RecipeIngredient(id: 108, name: "onion", original: "1 onion", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 109, name: "fajita seasoning", original: "2 tbsp fajita seasoning", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "2 tbsp olive oil", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 110, name: "tortillas", original: "8 flour tortillas", amount: 8, unit: "whole", image: nil)
        ], spoonacularScore: 90),
        SpoonacularRecipe(id: 2005, title: "Beef Tacos", image: "https://img.spoonacular.com/recipes/634269-312x231.jpg", readyInMinutes: 25, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 11, name: "ground beef", original: "500g ground beef", amount: 500, unit: "g", image: nil),
            RecipeIngredient(id: 110, name: "tortillas", original: "8 corn tortillas", amount: 8, unit: "whole", image: nil),
            RecipeIngredient(id: 111, name: "taco seasoning", original: "2 tbsp taco seasoning", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 112, name: "cheddar", original: "1 cup shredded cheddar", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 113, name: "salsa", original: "1/2 cup salsa", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 114, name: "sour cream", original: "1/4 cup sour cream", amount: 0.25, unit: "cup", image: nil)
        ], spoonacularScore: 89),
        SpoonacularRecipe(id: 2006, title: "Mushroom Risotto", image: "https://img.spoonacular.com/recipes/644826-312x231.jpg", readyInMinutes: 45, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 115, name: "arborio rice", original: "1.5 cups arborio rice", amount: 1.5, unit: "cups", image: nil),
            RecipeIngredient(id: 116, name: "mushrooms", original: "300g mushrooms", amount: 300, unit: "g", image: nil),
            RecipeIngredient(id: 117, name: "white wine", original: "1/2 cup white wine", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 14, name: "chicken broth", original: "4 cups chicken broth", amount: 4, unit: "cups", image: nil),
            RecipeIngredient(id: 8, name: "parmesan", original: "1/2 cup parmesan", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 3, name: "butter", original: "2 tbsp butter", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "2 cloves garlic", amount: 2, unit: "cloves", image: nil)
        ], spoonacularScore: 93),
        SpoonacularRecipe(id: 2007, title: "Avocado Toast", image: "https://img.spoonacular.com/recipes/660306-312x231.jpg", readyInMinutes: 10, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 118, name: "avocado", original: "2 ripe avocados", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 13, name: "bread", original: "4 slices sourdough", amount: 4, unit: "slices", image: nil),
            RecipeIngredient(id: 16, name: "lemon", original: "juice of 1 lemon", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil),
            RecipeIngredient(id: 17, name: "black pepper", original: "pepper to taste", amount: 1, unit: "pinch", image: nil),
            RecipeIngredient(id: 119, name: "red pepper flakes", original: "pinch red pepper flakes", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 85),
        SpoonacularRecipe(id: 2008, title: "Butter Chicken", image: "https://img.spoonacular.com/recipes/633956-312x231.jpg", readyInMinutes: 45, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 1, name: "chicken breast", original: "600g chicken breast", amount: 600, unit: "g", image: nil),
            RecipeIngredient(id: 120, name: "tomato sauce", original: "1 can tomato sauce", amount: 1, unit: "can", image: nil),
            RecipeIngredient(id: 102, name: "heavy cream", original: "1/2 cup heavy cream", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 3, name: "butter", original: "2 tbsp butter", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "4 cloves garlic", amount: 4, unit: "cloves", image: nil),
            RecipeIngredient(id: 121, name: "garam masala", original: "2 tsp garam masala", amount: 2, unit: "tsp", image: nil),
            RecipeIngredient(id: 122, name: "cumin", original: "1 tsp cumin", amount: 1, unit: "tsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 95),
        SpoonacularRecipe(id: 2009, title: "Classic Beef Burger", image: "https://img.spoonacular.com/recipes/642585-312x231.jpg", readyInMinutes: 20, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 11, name: "ground beef", original: "600g ground beef", amount: 600, unit: "g", image: nil),
            RecipeIngredient(id: 123, name: "burger buns", original: "4 burger buns", amount: 4, unit: "whole", image: nil),
            RecipeIngredient(id: 112, name: "cheddar", original: "4 slices cheddar", amount: 4, unit: "slices", image: nil),
            RecipeIngredient(id: 124, name: "lettuce", original: "4 lettuce leaves", amount: 4, unit: "whole", image: nil),
            RecipeIngredient(id: 105, name: "tomato", original: "1 tomato sliced", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil),
            RecipeIngredient(id: 17, name: "black pepper", original: "pepper to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 88),
        SpoonacularRecipe(id: 2010, title: "Shrimp Stir Fry", image: "https://img.spoonacular.com/recipes/633942-312x231.jpg", readyInMinutes: 20, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 125, name: "shrimp", original: "300g shrimp", amount: 300, unit: "g", image: nil),
            RecipeIngredient(id: 107, name: "bell pepper", original: "2 bell peppers", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 126, name: "broccoli", original: "1 cup broccoli", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 4, name: "soy sauce", original: "3 tbsp soy sauce", amount: 3, unit: "tbsp", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "3 cloves garlic", amount: 3, unit: "cloves", image: nil),
            RecipeIngredient(id: 127, name: "ginger", original: "1 tsp fresh ginger", amount: 1, unit: "tsp", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "2 tbsp oil", amount: 2, unit: "tbsp", image: nil)
        ], spoonacularScore: 88)
    ],

    .breakfast: [
        SpoonacularRecipe(id: 3001, title: "Fluffy Buttermilk Pancakes", image: "https://img.spoonacular.com/recipes/660306-312x231.jpg", readyInMinutes: 20, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 128, name: "flour", original: "2 cups flour", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 129, name: "buttermilk", original: "2 cups buttermilk", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 6, name: "eggs", original: "2 eggs", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 3, name: "butter", original: "3 tbsp melted butter", amount: 3, unit: "tbsp", image: nil),
            RecipeIngredient(id: 130, name: "sugar", original: "2 tbsp sugar", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 131, name: "baking powder", original: "2 tsp baking powder", amount: 2, unit: "tsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "1/2 tsp salt", amount: 0.5, unit: "tsp", image: nil)
        ], spoonacularScore: 90),
        SpoonacularRecipe(id: 3002, title: "Veggie Breakfast Burrito", image: "https://img.spoonacular.com/recipes/642585-312x231.jpg", readyInMinutes: 15, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 6, name: "eggs", original: "4 eggs", amount: 4, unit: "whole", image: nil),
            RecipeIngredient(id: 110, name: "tortillas", original: "2 large flour tortillas", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 107, name: "bell pepper", original: "1 bell pepper diced", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 108, name: "onion", original: "1/2 onion diced", amount: 0.5, unit: "whole", image: nil),
            RecipeIngredient(id: 112, name: "cheddar", original: "1/2 cup cheddar", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 87),
        SpoonacularRecipe(id: 3003, title: "Banana Oat Smoothie", image: "https://img.spoonacular.com/recipes/644826-312x231.jpg", readyInMinutes: 5, servings: 1, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 132, name: "banana", original: "1 frozen banana", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 133, name: "oats", original: "1/2 cup rolled oats", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 134, name: "almond milk", original: "1 cup almond milk", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 135, name: "peanut butter", original: "2 tbsp peanut butter", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 104, name: "honey", original: "1 tbsp honey", amount: 1, unit: "tbsp", image: nil)
        ], spoonacularScore: 85),
        SpoonacularRecipe(id: 3004, title: "Eggs Benedict", image: "https://img.spoonacular.com/recipes/632660-312x231.jpg", readyInMinutes: 25, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 6, name: "eggs", original: "4 eggs", amount: 4, unit: "whole", image: nil),
            RecipeIngredient(id: 136, name: "english muffins", original: "2 english muffins", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 137, name: "canadian bacon", original: "4 slices canadian bacon", amount: 4, unit: "slices", image: nil),
            RecipeIngredient(id: 3, name: "butter", original: "4 tbsp butter", amount: 4, unit: "tbsp", image: nil),
            RecipeIngredient(id: 16, name: "lemon juice", original: "1 tbsp lemon juice", amount: 1, unit: "tbsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 91),
        SpoonacularRecipe(id: 3005, title: "Overnight Oats", image: "https://img.spoonacular.com/recipes/633956-312x231.jpg", readyInMinutes: 5, servings: 1, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 133, name: "oats", original: "1/2 cup rolled oats", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 134, name: "almond milk", original: "1/2 cup almond milk", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 138, name: "greek yogurt", original: "1/4 cup greek yogurt", amount: 0.25, unit: "cup", image: nil),
            RecipeIngredient(id: 139, name: "chia seeds", original: "1 tbsp chia seeds", amount: 1, unit: "tbsp", image: nil),
            RecipeIngredient(id: 104, name: "honey", original: "1 tbsp honey", amount: 1, unit: "tbsp", image: nil),
            RecipeIngredient(id: 140, name: "blueberries", original: "1/4 cup blueberries", amount: 0.25, unit: "cup", image: nil)
        ], spoonacularScore: 88),
        SpoonacularRecipe(id: 3006, title: "French Toast", image: "https://img.spoonacular.com/recipes/634269-312x231.jpg", readyInMinutes: 15, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 13, name: "bread", original: "4 thick slices bread", amount: 4, unit: "slices", image: nil),
            RecipeIngredient(id: 6, name: "eggs", original: "2 eggs", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 141, name: "milk", original: "1/4 cup milk", amount: 0.25, unit: "cup", image: nil),
            RecipeIngredient(id: 142, name: "cinnamon", original: "1 tsp cinnamon", amount: 1, unit: "tsp", image: nil),
            RecipeIngredient(id: 3, name: "butter", original: "1 tbsp butter", amount: 1, unit: "tbsp", image: nil),
            RecipeIngredient(id: 130, name: "sugar", original: "1 tbsp sugar", amount: 1, unit: "tbsp", image: nil)
        ], spoonacularScore: 87),
        SpoonacularRecipe(id: 3007, title: "Spinach Feta Omelette", image: "https://img.spoonacular.com/recipes/654812-312x231.jpg", readyInMinutes: 10, servings: 1, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 6, name: "eggs", original: "3 eggs", amount: 3, unit: "whole", image: nil),
            RecipeIngredient(id: 101, name: "spinach", original: "1 cup spinach", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 143, name: "feta", original: "1/4 cup feta cheese", amount: 0.25, unit: "cup", image: nil),
            RecipeIngredient(id: 3, name: "butter", original: "1 tbsp butter", amount: 1, unit: "tbsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil),
            RecipeIngredient(id: 17, name: "black pepper", original: "pepper to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 88),
        SpoonacularRecipe(id: 3008, title: "Blueberry Muffins", image: "https://img.spoonacular.com/recipes/633942-312x231.jpg", readyInMinutes: 30, servings: 12, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 128, name: "flour", original: "2 cups flour", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 140, name: "blueberries", original: "1.5 cups blueberries", amount: 1.5, unit: "cups", image: nil),
            RecipeIngredient(id: 130, name: "sugar", original: "3/4 cup sugar", amount: 0.75, unit: "cup", image: nil),
            RecipeIngredient(id: 6, name: "eggs", original: "2 eggs", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 141, name: "milk", original: "1/2 cup milk", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 3, name: "butter", original: "1/3 cup butter", amount: 0.33, unit: "cup", image: nil),
            RecipeIngredient(id: 131, name: "baking powder", original: "2 tsp baking powder", amount: 2, unit: "tsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "1/2 tsp salt", amount: 0.5, unit: "tsp", image: nil)
        ], spoonacularScore: 91),
        SpoonacularRecipe(id: 3009, title: "Shakshuka", image: "https://img.spoonacular.com/recipes/716426-312x231.jpg", readyInMinutes: 25, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 6, name: "eggs", original: "4 eggs", amount: 4, unit: "whole", image: nil),
            RecipeIngredient(id: 120, name: "tomato sauce", original: "1 can crushed tomatoes", amount: 1, unit: "can", image: nil),
            RecipeIngredient(id: 107, name: "bell pepper", original: "1 bell pepper diced", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 108, name: "onion", original: "1 onion diced", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "3 cloves garlic", amount: 3, unit: "cloves", image: nil),
            RecipeIngredient(id: 144, name: "paprika", original: "1 tsp paprika", amount: 1, unit: "tsp", image: nil),
            RecipeIngredient(id: 122, name: "cumin", original: "1 tsp cumin", amount: 1, unit: "tsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 92),
        SpoonacularRecipe(id: 3010, title: "Acai Bowl", image: "https://img.spoonacular.com/recipes/642585-312x231.jpg", readyInMinutes: 10, servings: 1, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 145, name: "acai", original: "1 packet frozen acai", amount: 1, unit: "packet", image: nil),
            RecipeIngredient(id: 132, name: "banana", original: "1 banana", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 134, name: "almond milk", original: "1/4 cup almond milk", amount: 0.25, unit: "cup", image: nil),
            RecipeIngredient(id: 140, name: "blueberries", original: "1/4 cup blueberries", amount: 0.25, unit: "cup", image: nil),
            RecipeIngredient(id: 133, name: "granola", original: "1/4 cup granola", amount: 0.25, unit: "cup", image: nil),
            RecipeIngredient(id: 104, name: "honey", original: "1 tbsp honey", amount: 1, unit: "tbsp", image: nil)
        ], spoonacularScore: 86)
    ],

    .lunch: [
        SpoonacularRecipe(id: 4001, title: "Greek Salad", image: "https://img.spoonacular.com/recipes/644826-312x231.jpg", readyInMinutes: 15, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 146, name: "cucumber", original: "1 large cucumber", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 105, name: "tomatoes", original: "2 cups cherry tomatoes", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 147, name: "kalamata olives", original: "1/2 cup kalamata olives", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 143, name: "feta", original: "1/2 cup feta cheese", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 108, name: "red onion", original: "1/2 red onion", amount: 0.5, unit: "whole", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "3 tbsp olive oil", amount: 3, unit: "tbsp", image: nil),
            RecipeIngredient(id: 16, name: "lemon", original: "juice of 1 lemon", amount: 1, unit: "whole", image: nil)
        ], spoonacularScore: 90),
        SpoonacularRecipe(id: 4002, title: "Turkey BLT Wrap", image: "https://img.spoonacular.com/recipes/633956-312x231.jpg", readyInMinutes: 10, servings: 1, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 110, name: "tortillas", original: "1 large flour tortilla", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 148, name: "turkey", original: "4 oz deli turkey", amount: 4, unit: "oz", image: nil),
            RecipeIngredient(id: 137, name: "bacon", original: "2 strips bacon", amount: 2, unit: "strips", image: nil),
            RecipeIngredient(id: 124, name: "lettuce", original: "2 lettuce leaves", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 105, name: "tomato", original: "1 tomato sliced", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 149, name: "mayo", original: "1 tbsp mayo", amount: 1, unit: "tbsp", image: nil)
        ], spoonacularScore: 85),
        SpoonacularRecipe(id: 4003, title: "Caprese Sandwich", image: "https://img.spoonacular.com/recipes/632660-312x231.jpg", readyInMinutes: 10, servings: 1, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 150, name: "ciabatta bread", original: "1 ciabatta roll", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 151, name: "fresh mozzarella", original: "4 oz fresh mozzarella", amount: 4, unit: "oz", image: nil),
            RecipeIngredient(id: 105, name: "tomatoes", original: "2 ripe tomatoes sliced", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 106, name: "basil", original: "fresh basil leaves", amount: 1, unit: "bunch", image: nil),
            RecipeIngredient(id: 152, name: "balsamic glaze", original: "2 tbsp balsamic glaze", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "1 tbsp olive oil", amount: 1, unit: "tbsp", image: nil)
        ], spoonacularScore: 88),
        SpoonacularRecipe(id: 4004, title: "Chicken Caesar Salad", image: "https://img.spoonacular.com/recipes/634269-312x231.jpg", readyInMinutes: 20, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 1, name: "chicken breast", original: "2 chicken breasts", amount: 2, unit: "piece", image: nil),
            RecipeIngredient(id: 153, name: "romaine lettuce", original: "1 head romaine lettuce", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 154, name: "caesar dressing", original: "1/4 cup caesar dressing", amount: 0.25, unit: "cup", image: nil),
            RecipeIngredient(id: 155, name: "croutons", original: "1 cup croutons", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 8, name: "parmesan", original: "1/4 cup parmesan", amount: 0.25, unit: "cup", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 86),
        SpoonacularRecipe(id: 4005, title: "Tomato Basil Soup", image: "https://img.spoonacular.com/recipes/654812-312x231.jpg", readyInMinutes: 30, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 120, name: "tomatoes", original: "2 cans crushed tomatoes", amount: 2, unit: "can", image: nil),
            RecipeIngredient(id: 108, name: "onion", original: "1 onion diced", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "4 cloves garlic", amount: 4, unit: "cloves", image: nil),
            RecipeIngredient(id: 106, name: "basil", original: "1/4 cup fresh basil", amount: 0.25, unit: "cup", image: nil),
            RecipeIngredient(id: 102, name: "heavy cream", original: "1/4 cup heavy cream", amount: 0.25, unit: "cup", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "2 tbsp olive oil", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 91),
        SpoonacularRecipe(id: 4006, title: "Quinoa Power Bowl", image: "https://img.spoonacular.com/recipes/716426-312x231.jpg", readyInMinutes: 25, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 156, name: "quinoa", original: "1 cup quinoa", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 157, name: "chickpeas", original: "1 can chickpeas", amount: 1, unit: "can", image: nil),
            RecipeIngredient(id: 118, name: "avocado", original: "1 avocado", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 101, name: "spinach", original: "2 cups spinach", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 105, name: "cherry tomatoes", original: "1 cup cherry tomatoes", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 16, name: "lemon", original: "juice of 1 lemon", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "2 tbsp olive oil", amount: 2, unit: "tbsp", image: nil)
        ], spoonacularScore: 90),
        SpoonacularRecipe(id: 4007, title: "Grilled Cheese Sandwich", image: "https://img.spoonacular.com/recipes/633942-312x231.jpg", readyInMinutes: 10, servings: 1, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 13, name: "bread", original: "2 slices bread", amount: 2, unit: "slices", image: nil),
            RecipeIngredient(id: 112, name: "cheddar", original: "2 slices cheddar", amount: 2, unit: "slices", image: nil),
            RecipeIngredient(id: 151, name: "mozzarella", original: "2 slices mozzarella", amount: 2, unit: "slices", image: nil),
            RecipeIngredient(id: 3, name: "butter", original: "2 tbsp butter", amount: 2, unit: "tbsp", image: nil)
        ], spoonacularScore: 85),
        SpoonacularRecipe(id: 4008, title: "Tuna Salad Sandwich", image: "https://img.spoonacular.com/recipes/660306-312x231.jpg", readyInMinutes: 10, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 158, name: "canned tuna", original: "2 cans tuna", amount: 2, unit: "can", image: nil),
            RecipeIngredient(id: 149, name: "mayo", original: "3 tbsp mayo", amount: 3, unit: "tbsp", image: nil),
            RecipeIngredient(id: 159, name: "celery", original: "2 stalks celery diced", amount: 2, unit: "stalks", image: nil),
            RecipeIngredient(id: 108, name: "red onion", original: "2 tbsp red onion diced", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 13, name: "bread", original: "4 slices bread", amount: 4, unit: "slices", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 85),
        SpoonacularRecipe(id: 4009, title: "Black Bean Quesadilla", image: "https://img.spoonacular.com/recipes/632660-312x231.jpg", readyInMinutes: 15, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 110, name: "tortillas", original: "4 flour tortillas", amount: 4, unit: "whole", image: nil),
            RecipeIngredient(id: 160, name: "black beans", original: "1 can black beans", amount: 1, unit: "can", image: nil),
            RecipeIngredient(id: 112, name: "cheddar", original: "1 cup shredded cheddar", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 107, name: "bell pepper", original: "1 bell pepper diced", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 113, name: "salsa", original: "1/4 cup salsa", amount: 0.25, unit: "cup", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 86),
        SpoonacularRecipe(id: 4010, title: "Lentil Soup", image: "https://img.spoonacular.com/recipes/644826-312x231.jpg", readyInMinutes: 40, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 161, name: "lentils", original: "1.5 cups red lentils", amount: 1.5, unit: "cups", image: nil),
            RecipeIngredient(id: 108, name: "onion", original: "1 onion diced", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 15, name: "carrots", original: "2 carrots diced", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "3 cloves garlic", amount: 3, unit: "cloves", image: nil),
            RecipeIngredient(id: 122, name: "cumin", original: "2 tsp cumin", amount: 2, unit: "tsp", image: nil),
            RecipeIngredient(id: 162, name: "vegetable broth", original: "4 cups vegetable broth", amount: 4, unit: "cups", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 89)
    ],

    .dinner: [
        SpoonacularRecipe(id: 5001, title: "Beef Stew", image: "https://img.spoonacular.com/recipes/633956-312x231.jpg", readyInMinutes: 90, servings: 6, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 163, name: "beef chuck", original: "2 lbs beef chuck cubed", amount: 2, unit: "lbs", image: nil),
            RecipeIngredient(id: 164, name: "potatoes", original: "3 potatoes cubed", amount: 3, unit: "whole", image: nil),
            RecipeIngredient(id: 15, name: "carrots", original: "3 carrots sliced", amount: 3, unit: "whole", image: nil),
            RecipeIngredient(id: 108, name: "onion", original: "1 onion diced", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 12, name: "beef broth", original: "3 cups beef broth", amount: 3, unit: "cups", image: nil),
            RecipeIngredient(id: 165, name: "tomato paste", original: "2 tbsp tomato paste", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "3 cloves garlic", amount: 3, unit: "cloves", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 94),
        SpoonacularRecipe(id: 5002, title: "Baked Lemon Herb Chicken", image: "https://img.spoonacular.com/recipes/716426-312x231.jpg", readyInMinutes: 45, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 1, name: "chicken breast", original: "4 chicken breasts", amount: 4, unit: "piece", image: nil),
            RecipeIngredient(id: 16, name: "lemon", original: "2 lemons", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "4 cloves garlic", amount: 4, unit: "cloves", image: nil),
            RecipeIngredient(id: 166, name: "rosemary", original: "2 sprigs fresh rosemary", amount: 2, unit: "sprigs", image: nil),
            RecipeIngredient(id: 167, name: "thyme", original: "4 sprigs fresh thyme", amount: 4, unit: "sprigs", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "3 tbsp olive oil", amount: 3, unit: "tbsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 90),
        SpoonacularRecipe(id: 5003, title: "Spaghetti Bolognese", image: "https://img.spoonacular.com/recipes/642585-312x231.jpg", readyInMinutes: 60, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 7, name: "pasta", original: "400g spaghetti", amount: 400, unit: "g", image: nil),
            RecipeIngredient(id: 11, name: "ground beef", original: "500g ground beef", amount: 500, unit: "g", image: nil),
            RecipeIngredient(id: 120, name: "tomato sauce", original: "1 can crushed tomatoes", amount: 1, unit: "can", image: nil),
            RecipeIngredient(id: 108, name: "onion", original: "1 onion diced", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "3 cloves garlic", amount: 3, unit: "cloves", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "2 tbsp olive oil", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 8, name: "parmesan", original: "1/2 cup parmesan", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 92),
        SpoonacularRecipe(id: 5004, title: "Pork Tenderloin with Roasted Vegetables", image: "https://img.spoonacular.com/recipes/633942-312x231.jpg", readyInMinutes: 50, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 168, name: "pork tenderloin", original: "1.5 lb pork tenderloin", amount: 1.5, unit: "lbs", image: nil),
            RecipeIngredient(id: 164, name: "potatoes", original: "3 potatoes cubed", amount: 3, unit: "whole", image: nil),
            RecipeIngredient(id: 126, name: "broccoli", original: "2 cups broccoli", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 107, name: "bell pepper", original: "2 bell peppers", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "3 cloves garlic", amount: 3, unit: "cloves", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "3 tbsp olive oil", amount: 3, unit: "tbsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 90),
        SpoonacularRecipe(id: 5005, title: "Salmon with Asparagus", image: "https://img.spoonacular.com/recipes/660306-312x231.jpg", readyInMinutes: 25, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 103, name: "salmon", original: "2 salmon fillets", amount: 2, unit: "piece", image: nil),
            RecipeIngredient(id: 169, name: "asparagus", original: "1 bunch asparagus", amount: 1, unit: "bunch", image: nil),
            RecipeIngredient(id: 16, name: "lemon", original: "1 lemon", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "2 cloves garlic", amount: 2, unit: "cloves", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "2 tbsp olive oil", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 90),
        SpoonacularRecipe(id: 5006, title: "Chicken Tikka Masala", image: "https://img.spoonacular.com/recipes/654812-312x231.jpg", readyInMinutes: 50, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 1, name: "chicken breast", original: "600g chicken breast", amount: 600, unit: "g", image: nil),
            RecipeIngredient(id: 120, name: "tomato sauce", original: "1 can crushed tomatoes", amount: 1, unit: "can", image: nil),
            RecipeIngredient(id: 102, name: "heavy cream", original: "1/2 cup heavy cream", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 121, name: "garam masala", original: "2 tsp garam masala", amount: 2, unit: "tsp", image: nil),
            RecipeIngredient(id: 122, name: "cumin", original: "1 tsp cumin", amount: 1, unit: "tsp", image: nil),
            RecipeIngredient(id: 144, name: "paprika", original: "1 tsp paprika", amount: 1, unit: "tsp", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "4 cloves garlic", amount: 4, unit: "cloves", image: nil),
            RecipeIngredient(id: 127, name: "ginger", original: "1 tbsp fresh ginger", amount: 1, unit: "tbsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 95),
        SpoonacularRecipe(id: 5007, title: "Shrimp Tacos", image: "https://img.spoonacular.com/recipes/632660-312x231.jpg", readyInMinutes: 20, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 125, name: "shrimp", original: "400g shrimp", amount: 400, unit: "g", image: nil),
            RecipeIngredient(id: 110, name: "tortillas", original: "8 corn tortillas", amount: 8, unit: "whole", image: nil),
            RecipeIngredient(id: 170, name: "coleslaw", original: "1 cup coleslaw mix", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 111, name: "taco seasoning", original: "1 tbsp taco seasoning", amount: 1, unit: "tbsp", image: nil),
            RecipeIngredient(id: 16, name: "lime", original: "2 limes", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "1 tbsp oil", amount: 1, unit: "tbsp", image: nil)
        ], spoonacularScore: 87),
        SpoonacularRecipe(id: 5008, title: "Eggplant Parmesan", image: "https://img.spoonacular.com/recipes/633956-312x231.jpg", readyInMinutes: 60, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 171, name: "eggplant", original: "2 large eggplants", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 120, name: "tomato sauce", original: "2 cups tomato sauce", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 151, name: "mozzarella", original: "2 cups shredded mozzarella", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 8, name: "parmesan", original: "1/2 cup parmesan", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 128, name: "flour", original: "1 cup flour", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 6, name: "eggs", original: "2 eggs beaten", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 89),
        SpoonacularRecipe(id: 5009, title: "Stuffed Bell Peppers", image: "https://img.spoonacular.com/recipes/716426-312x231.jpg", readyInMinutes: 50, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 107, name: "bell peppers", original: "4 bell peppers", amount: 4, unit: "whole", image: nil),
            RecipeIngredient(id: 11, name: "ground beef", original: "400g ground beef", amount: 400, unit: "g", image: nil),
            RecipeIngredient(id: 5, name: "rice", original: "1 cup cooked rice", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 120, name: "tomato sauce", original: "1 cup tomato sauce", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 112, name: "cheddar", original: "1 cup shredded cheddar", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "2 cloves garlic", amount: 2, unit: "cloves", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 91),
        SpoonacularRecipe(id: 5010, title: "Pot Roast", image: "https://img.spoonacular.com/recipes/642585-312x231.jpg", readyInMinutes: 240, servings: 6, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 215, name: "chuck roast", original: "3 lb chuck roast", amount: 3, unit: "lbs", image: nil),
            RecipeIngredient(id: 164, name: "potatoes", original: "4 potatoes quartered", amount: 4, unit: "whole", image: nil),
            RecipeIngredient(id: 15, name: "carrots", original: "4 carrots", amount: 4, unit: "whole", image: nil),
            RecipeIngredient(id: 108, name: "onion", original: "1 onion quartered", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 12, name: "beef broth", original: "2 cups beef broth", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "4 cloves garlic", amount: 4, unit: "cloves", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 93)
    ],

    .soup: [
        SpoonacularRecipe(id: 6001, title: "Classic Chicken Noodle Soup", image: "https://img.spoonacular.com/recipes/633956-312x231.jpg", readyInMinutes: 45, servings: 6, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 1, name: "chicken breast", original: "2 chicken breasts", amount: 2, unit: "piece", image: nil),
            RecipeIngredient(id: 174, name: "egg noodles", original: "2 cups egg noodles", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 15, name: "carrots", original: "3 carrots sliced", amount: 3, unit: "whole", image: nil),
            RecipeIngredient(id: 159, name: "celery", original: "3 stalks celery", amount: 3, unit: "stalks", image: nil),
            RecipeIngredient(id: 108, name: "onion", original: "1 onion diced", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 14, name: "chicken broth", original: "6 cups chicken broth", amount: 6, unit: "cups", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 94),
        SpoonacularRecipe(id: 6002, title: "French Onion Soup", image: "https://img.spoonacular.com/recipes/644826-312x231.jpg", readyInMinutes: 60, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 175, name: "yellow onions", original: "4 large yellow onions", amount: 4, unit: "whole", image: nil),
            RecipeIngredient(id: 12, name: "beef broth", original: "4 cups beef broth", amount: 4, unit: "cups", image: nil),
            RecipeIngredient(id: 117, name: "white wine", original: "1/2 cup white wine", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 13, name: "bread", original: "4 slices baguette", amount: 4, unit: "slices", image: nil),
            RecipeIngredient(id: 176, name: "gruyere", original: "1 cup gruyere cheese", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 3, name: "butter", original: "2 tbsp butter", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 93),
        SpoonacularRecipe(id: 6003, title: "Broccoli Cheddar Soup", image: "https://img.spoonacular.com/recipes/632660-312x231.jpg", readyInMinutes: 35, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 126, name: "broccoli", original: "4 cups broccoli florets", amount: 4, unit: "cups", image: nil),
            RecipeIngredient(id: 112, name: "cheddar", original: "2 cups shredded cheddar", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 162, name: "vegetable broth", original: "2 cups vegetable broth", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 102, name: "heavy cream", original: "1 cup heavy cream", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 108, name: "onion", original: "1 onion diced", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 3, name: "butter", original: "2 tbsp butter", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 90),
        SpoonacularRecipe(id: 6004, title: "Minestrone", image: "https://img.spoonacular.com/recipes/634269-312x231.jpg", readyInMinutes: 45, servings: 6, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 162, name: "vegetable broth", original: "4 cups vegetable broth", amount: 4, unit: "cups", image: nil),
            RecipeIngredient(id: 120, name: "tomatoes", original: "1 can diced tomatoes", amount: 1, unit: "can", image: nil),
            RecipeIngredient(id: 157, name: "chickpeas", original: "1 can chickpeas", amount: 1, unit: "can", image: nil),
            RecipeIngredient(id: 7, name: "pasta", original: "1 cup small pasta", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 126, name: "broccoli", original: "1 cup broccoli", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 15, name: "carrots", original: "2 carrots diced", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "3 cloves garlic", amount: 3, unit: "cloves", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 89),
        SpoonacularRecipe(id: 6005, title: "Butternut Squash Soup", image: "https://img.spoonacular.com/recipes/654812-312x231.jpg", readyInMinutes: 40, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 177, name: "butternut squash", original: "1 large butternut squash", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 162, name: "vegetable broth", original: "3 cups vegetable broth", amount: 3, unit: "cups", image: nil),
            RecipeIngredient(id: 108, name: "onion", original: "1 onion diced", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 102, name: "heavy cream", original: "1/4 cup heavy cream", amount: 0.25, unit: "cup", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "2 cloves garlic", amount: 2, unit: "cloves", image: nil),
            RecipeIngredient(id: 127, name: "ginger", original: "1 tsp fresh ginger", amount: 1, unit: "tsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 91),
        SpoonacularRecipe(id: 6006, title: "Clam Chowder", image: "https://img.spoonacular.com/recipes/716426-312x231.jpg", readyInMinutes: 40, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 178, name: "clams", original: "2 cans clams", amount: 2, unit: "can", image: nil),
            RecipeIngredient(id: 164, name: "potatoes", original: "3 potatoes diced", amount: 3, unit: "whole", image: nil),
            RecipeIngredient(id: 137, name: "bacon", original: "4 strips bacon", amount: 4, unit: "strips", image: nil),
            RecipeIngredient(id: 108, name: "onion", original: "1 onion diced", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 102, name: "heavy cream", original: "2 cups heavy cream", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 3, name: "butter", original: "2 tbsp butter", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 92),
        SpoonacularRecipe(id: 6007, title: "Chicken and Rice Soup", image: "https://img.spoonacular.com/recipes/633942-312x231.jpg", readyInMinutes: 45, servings: 6, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 1, name: "chicken breast", original: "2 chicken breasts", amount: 2, unit: "piece", image: nil),
            RecipeIngredient(id: 5, name: "rice", original: "1 cup rice", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 14, name: "chicken broth", original: "4 cups chicken broth", amount: 4, unit: "cups", image: nil),
            RecipeIngredient(id: 15, name: "carrots", original: "2 carrots diced", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "2 cloves garlic", amount: 2, unit: "cloves", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 93),
        SpoonacularRecipe(id: 6008, title: "Tomato Tortellini Soup", image: "https://img.spoonacular.com/recipes/660306-312x231.jpg", readyInMinutes: 25, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 182, name: "cheese tortellini", original: "1 package cheese tortellini", amount: 1, unit: "package", image: nil),
            RecipeIngredient(id: 120, name: "tomatoes", original: "1 can crushed tomatoes", amount: 1, unit: "can", image: nil),
            RecipeIngredient(id: 162, name: "vegetable broth", original: "3 cups vegetable broth", amount: 3, unit: "cups", image: nil),
            RecipeIngredient(id: 101, name: "spinach", original: "2 cups spinach", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "3 cloves garlic", amount: 3, unit: "cloves", image: nil),
            RecipeIngredient(id: 8, name: "parmesan", original: "1/4 cup parmesan", amount: 0.25, unit: "cup", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 90),
        SpoonacularRecipe(id: 6009, title: "Spicy Black Bean Soup", image: "https://img.spoonacular.com/recipes/632660-312x231.jpg", readyInMinutes: 35, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 160, name: "black beans", original: "2 cans black beans", amount: 2, unit: "can", image: nil),
            RecipeIngredient(id: 162, name: "vegetable broth", original: "2 cups vegetable broth", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 108, name: "onion", original: "1 onion diced", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "3 cloves garlic", amount: 3, unit: "cloves", image: nil),
            RecipeIngredient(id: 122, name: "cumin", original: "2 tsp cumin", amount: 2, unit: "tsp", image: nil),
            RecipeIngredient(id: 119, name: "red pepper flakes", original: "1 tsp red pepper flakes", amount: 1, unit: "tsp", image: nil),
            RecipeIngredient(id: 16, name: "lime", original: "1 lime", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 88),
        SpoonacularRecipe(id: 6010, title: "Lentil Soup", image: "https://img.spoonacular.com/recipes/644826-312x231.jpg", readyInMinutes: 40, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 161, name: "lentils", original: "1.5 cups red lentils", amount: 1.5, unit: "cups", image: nil),
            RecipeIngredient(id: 108, name: "onion", original: "1 onion diced", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 15, name: "carrots", original: "2 carrots diced", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "3 cloves garlic", amount: 3, unit: "cloves", image: nil),
            RecipeIngredient(id: 122, name: "cumin", original: "2 tsp cumin", amount: 2, unit: "tsp", image: nil),
            RecipeIngredient(id: 162, name: "vegetable broth", original: "4 cups vegetable broth", amount: 4, unit: "cups", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 89)
    ],

    .snacks: [
        SpoonacularRecipe(id: 7001, title: "Guacamole", image: "https://img.spoonacular.com/recipes/642585-312x231.jpg", readyInMinutes: 10, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 118, name: "avocado", original: "3 ripe avocados", amount: 3, unit: "whole", image: nil),
            RecipeIngredient(id: 16, name: "lime", original: "juice of 2 limes", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 108, name: "red onion", original: "1/4 red onion minced", amount: 0.25, unit: "whole", image: nil),
            RecipeIngredient(id: 185, name: "cilantro", original: "2 tbsp fresh cilantro", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 186, name: "jalapeno", original: "1 jalapeno minced", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 92),
        SpoonacularRecipe(id: 7002, title: "Hummus", image: "https://img.spoonacular.com/recipes/633942-312x231.jpg", readyInMinutes: 10, servings: 6, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 157, name: "chickpeas", original: "1 can chickpeas", amount: 1, unit: "can", image: nil),
            RecipeIngredient(id: 187, name: "tahini", original: "3 tbsp tahini", amount: 3, unit: "tbsp", image: nil),
            RecipeIngredient(id: 16, name: "lemon", original: "juice of 1 lemon", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "2 cloves garlic", amount: 2, unit: "cloves", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "3 tbsp olive oil", amount: 3, unit: "tbsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 91),
        SpoonacularRecipe(id: 7003, title: "Baked Sweet Potato Fries", image: "https://img.spoonacular.com/recipes/633956-312x231.jpg", readyInMinutes: 30, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 188, name: "sweet potatoes", original: "2 large sweet potatoes", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "2 tbsp olive oil", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil),
            RecipeIngredient(id: 144, name: "paprika", original: "1 tsp paprika", amount: 1, unit: "tsp", image: nil),
            RecipeIngredient(id: 17, name: "black pepper", original: "pepper to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 87),
        SpoonacularRecipe(id: 7004, title: "Caprese Skewers", image: "https://img.spoonacular.com/recipes/716426-312x231.jpg", readyInMinutes: 10, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 151, name: "fresh mozzarella", original: "8 oz fresh mozzarella balls", amount: 8, unit: "oz", image: nil),
            RecipeIngredient(id: 105, name: "cherry tomatoes", original: "1 cup cherry tomatoes", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 106, name: "basil", original: "fresh basil leaves", amount: 1, unit: "bunch", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "2 tbsp olive oil", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 152, name: "balsamic glaze", original: "balsamic glaze to drizzle", amount: 1, unit: "tbsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 89),
        SpoonacularRecipe(id: 7005, title: "Deviled Eggs", image: "https://img.spoonacular.com/recipes/654812-312x231.jpg", readyInMinutes: 20, servings: 6, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 6, name: "eggs", original: "6 hard boiled eggs", amount: 6, unit: "whole", image: nil),
            RecipeIngredient(id: 149, name: "mayo", original: "3 tbsp mayo", amount: 3, unit: "tbsp", image: nil),
            RecipeIngredient(id: 189, name: "mustard", original: "1 tsp dijon mustard", amount: 1, unit: "tsp", image: nil),
            RecipeIngredient(id: 144, name: "paprika", original: "paprika for garnish", amount: 1, unit: "pinch", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 85),
        SpoonacularRecipe(id: 7006, title: "Spinach Artichoke Dip", image: "https://img.spoonacular.com/recipes/632660-312x231.jpg", readyInMinutes: 25, servings: 8, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 101, name: "spinach", original: "2 cups frozen spinach", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 190, name: "artichoke hearts", original: "1 can artichoke hearts", amount: 1, unit: "can", image: nil),
            RecipeIngredient(id: 191, name: "cream cheese", original: "8 oz cream cheese", amount: 8, unit: "oz", image: nil),
            RecipeIngredient(id: 114, name: "sour cream", original: "1/2 cup sour cream", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 8, name: "parmesan", original: "1/2 cup parmesan", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "2 cloves garlic", amount: 2, unit: "cloves", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 90),
        SpoonacularRecipe(id: 7007, title: "Energy Balls", image: "https://img.spoonacular.com/recipes/634269-312x231.jpg", readyInMinutes: 15, servings: 12, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 133, name: "oats", original: "1 cup rolled oats", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 135, name: "peanut butter", original: "1/2 cup peanut butter", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 104, name: "honey", original: "1/3 cup honey", amount: 0.33, unit: "cup", image: nil),
            RecipeIngredient(id: 192, name: "chocolate chips", original: "1/2 cup chocolate chips", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 139, name: "chia seeds", original: "2 tbsp chia seeds", amount: 2, unit: "tbsp", image: nil)
        ], spoonacularScore: 88),
        SpoonacularRecipe(id: 7008, title: "Bruschetta", image: "https://img.spoonacular.com/recipes/642585-312x231.jpg", readyInMinutes: 15, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 13, name: "bread", original: "1 baguette sliced", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 105, name: "tomatoes", original: "4 ripe tomatoes diced", amount: 4, unit: "whole", image: nil),
            RecipeIngredient(id: 106, name: "basil", original: "1/4 cup fresh basil", amount: 0.25, unit: "cup", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "2 cloves garlic", amount: 2, unit: "cloves", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "3 tbsp olive oil", amount: 3, unit: "tbsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 87),
        SpoonacularRecipe(id: 7009, title: "Nachos", image: "https://img.spoonacular.com/recipes/633942-312x231.jpg", readyInMinutes: 15, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 193, name: "tortilla chips", original: "1 bag tortilla chips", amount: 1, unit: "bag", image: nil),
            RecipeIngredient(id: 112, name: "cheddar", original: "2 cups shredded cheddar", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 160, name: "black beans", original: "1 can black beans", amount: 1, unit: "can", image: nil),
            RecipeIngredient(id: 113, name: "salsa", original: "1/2 cup salsa", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 186, name: "jalapeno", original: "1 jalapeno sliced", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 114, name: "sour cream", original: "1/4 cup sour cream", amount: 0.25, unit: "cup", image: nil)
        ], spoonacularScore: 86),
        SpoonacularRecipe(id: 7010, title: "Cheese Quesadilla", image: "https://img.spoonacular.com/recipes/716426-312x231.jpg", readyInMinutes: 10, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 110, name: "tortillas", original: "2 large flour tortillas", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 112, name: "cheddar", original: "1 cup shredded cheddar", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 151, name: "mozzarella", original: "1/2 cup mozzarella", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 3, name: "butter", original: "1 tbsp butter", amount: 1, unit: "tbsp", image: nil)
        ], spoonacularScore: 85)
    ],

    .desserts: [
        SpoonacularRecipe(id: 8001, title: "Chocolate Chip Cookies", image: "https://img.spoonacular.com/recipes/633956-312x231.jpg", readyInMinutes: 30, servings: 24, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 128, name: "flour", original: "2.25 cups flour", amount: 2.25, unit: "cups", image: nil),
            RecipeIngredient(id: 192, name: "chocolate chips", original: "2 cups chocolate chips", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 3, name: "butter", original: "1 cup butter", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 130, name: "sugar", original: "3/4 cup sugar", amount: 0.75, unit: "cup", image: nil),
            RecipeIngredient(id: 194, name: "brown sugar", original: "3/4 cup brown sugar", amount: 0.75, unit: "cup", image: nil),
            RecipeIngredient(id: 6, name: "eggs", original: "2 eggs", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 195, name: "vanilla extract", original: "2 tsp vanilla extract", amount: 2, unit: "tsp", image: nil),
            RecipeIngredient(id: 232, name: "baking soda", original: "1 tsp baking soda", amount: 1, unit: "tsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "1 tsp salt", amount: 1, unit: "tsp", image: nil)
        ], spoonacularScore: 94),
        SpoonacularRecipe(id: 8002, title: "Banana Bread", image: "https://img.spoonacular.com/recipes/716426-312x231.jpg", readyInMinutes: 65, servings: 8, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 132, name: "bananas", original: "3 ripe bananas mashed", amount: 3, unit: "whole", image: nil),
            RecipeIngredient(id: 128, name: "flour", original: "1.5 cups flour", amount: 1.5, unit: "cups", image: nil),
            RecipeIngredient(id: 130, name: "sugar", original: "3/4 cup sugar", amount: 0.75, unit: "cup", image: nil),
            RecipeIngredient(id: 3, name: "butter", original: "1/3 cup butter melted", amount: 0.33, unit: "cup", image: nil),
            RecipeIngredient(id: 6, name: "eggs", original: "1 egg", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 195, name: "vanilla extract", original: "1 tsp vanilla extract", amount: 1, unit: "tsp", image: nil),
            RecipeIngredient(id: 232, name: "baking soda", original: "1 tsp baking soda", amount: 1, unit: "tsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "1/4 tsp salt", amount: 0.25, unit: "tsp", image: nil)
        ], spoonacularScore: 92),
        SpoonacularRecipe(id: 8003, title: "Classic Cheesecake", image: "https://img.spoonacular.com/recipes/642585-312x231.jpg", readyInMinutes: 90, servings: 12, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 191, name: "cream cheese", original: "3 packages cream cheese", amount: 3, unit: "package", image: nil),
            RecipeIngredient(id: 130, name: "sugar", original: "1 cup sugar", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 6, name: "eggs", original: "3 eggs", amount: 3, unit: "whole", image: nil),
            RecipeIngredient(id: 195, name: "vanilla extract", original: "1 tsp vanilla extract", amount: 1, unit: "tsp", image: nil),
            RecipeIngredient(id: 196, name: "graham crackers", original: "1.5 cups graham cracker crumbs", amount: 1.5, unit: "cups", image: nil),
            RecipeIngredient(id: 3, name: "butter", original: "5 tbsp butter melted", amount: 5, unit: "tbsp", image: nil)
        ], spoonacularScore: 93),
        SpoonacularRecipe(id: 8004, title: "Brownies", image: "https://img.spoonacular.com/recipes/633942-312x231.jpg", readyInMinutes: 40, servings: 16, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 197, name: "dark chocolate", original: "200g dark chocolate", amount: 200, unit: "g", image: nil),
            RecipeIngredient(id: 3, name: "butter", original: "1/2 cup butter", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 130, name: "sugar", original: "1 cup sugar", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 6, name: "eggs", original: "3 eggs", amount: 3, unit: "whole", image: nil),
            RecipeIngredient(id: 128, name: "flour", original: "3/4 cup flour", amount: 0.75, unit: "cup", image: nil),
            RecipeIngredient(id: 198, name: "cocoa powder", original: "1/4 cup cocoa powder", amount: 0.25, unit: "cup", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "1/4 tsp salt", amount: 0.25, unit: "tsp", image: nil)
        ], spoonacularScore: 93),
        SpoonacularRecipe(id: 8005, title: "Apple Pie", image: "https://img.spoonacular.com/recipes/654812-312x231.jpg", readyInMinutes: 70, servings: 8, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 202, name: "apples", original: "6 apples peeled and sliced", amount: 6, unit: "whole", image: nil),
            RecipeIngredient(id: 128, name: "flour", original: "2.5 cups flour", amount: 2.5, unit: "cups", image: nil),
            RecipeIngredient(id: 130, name: "sugar", original: "3/4 cup sugar", amount: 0.75, unit: "cup", image: nil),
            RecipeIngredient(id: 142, name: "cinnamon", original: "1 tsp cinnamon", amount: 1, unit: "tsp", image: nil),
            RecipeIngredient(id: 3, name: "butter", original: "1 cup cold butter", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "1/2 tsp salt", amount: 0.5, unit: "tsp", image: nil)
        ], spoonacularScore: 91),
        SpoonacularRecipe(id: 8006, title: "Lemon Bars", image: "https://img.spoonacular.com/recipes/632660-312x231.jpg", readyInMinutes: 45, servings: 16, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 16, name: "lemon", original: "3 lemons zested and juiced", amount: 3, unit: "whole", image: nil),
            RecipeIngredient(id: 128, name: "flour", original: "1.5 cups flour", amount: 1.5, unit: "cups", image: nil),
            RecipeIngredient(id: 130, name: "sugar", original: "1.5 cups sugar", amount: 1.5, unit: "cups", image: nil),
            RecipeIngredient(id: 6, name: "eggs", original: "4 eggs", amount: 4, unit: "whole", image: nil),
            RecipeIngredient(id: 3, name: "butter", original: "3/4 cup butter", amount: 0.75, unit: "cup", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "1/4 tsp salt", amount: 0.25, unit: "tsp", image: nil)
        ], spoonacularScore: 90),
        SpoonacularRecipe(id: 8007, title: "Tiramisu", image: "https://img.spoonacular.com/recipes/716426-312x231.jpg", readyInMinutes: 30, servings: 8, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 199, name: "ladyfingers", original: "24 ladyfinger cookies", amount: 24, unit: "whole", image: nil),
            RecipeIngredient(id: 200, name: "mascarpone", original: "500g mascarpone", amount: 500, unit: "g", image: nil),
            RecipeIngredient(id: 6, name: "eggs", original: "4 egg yolks", amount: 4, unit: "whole", image: nil),
            RecipeIngredient(id: 130, name: "sugar", original: "1/2 cup sugar", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 201, name: "espresso", original: "1 cup strong espresso", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 198, name: "cocoa powder", original: "cocoa powder for dusting", amount: 1, unit: "tbsp", image: nil)
        ], spoonacularScore: 94),
        SpoonacularRecipe(id: 8008, title: "Churros", image: "https://img.spoonacular.com/recipes/634269-312x231.jpg", readyInMinutes: 30, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 128, name: "flour", original: "1 cup flour", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 3, name: "butter", original: "2 tbsp butter", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 130, name: "sugar", original: "1/4 cup sugar", amount: 0.25, unit: "cup", image: nil),
            RecipeIngredient(id: 142, name: "cinnamon", original: "1 tsp cinnamon", amount: 1, unit: "tsp", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "oil for frying", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "pinch of salt", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 89),
        SpoonacularRecipe(id: 8009, title: "Panna Cotta", image: "https://img.spoonacular.com/recipes/642585-312x231.jpg", readyInMinutes: 20, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 102, name: "heavy cream", original: "2 cups heavy cream", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 130, name: "sugar", original: "1/4 cup sugar", amount: 0.25, unit: "cup", image: nil),
            RecipeIngredient(id: 195, name: "vanilla extract", original: "1 tsp vanilla extract", amount: 1, unit: "tsp", image: nil),
            RecipeIngredient(id: 203, name: "gelatin", original: "1 packet gelatin", amount: 1, unit: "packet", image: nil),
            RecipeIngredient(id: 140, name: "berries", original: "1 cup mixed berries", amount: 1, unit: "cup", image: nil)
        ], spoonacularScore: 90),
        SpoonacularRecipe(id: 8010, title: "Mango Sorbet", image: "https://img.spoonacular.com/recipes/644826-312x231.jpg", readyInMinutes: 15, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 204, name: "mango", original: "3 cups frozen mango", amount: 3, unit: "cups", image: nil),
            RecipeIngredient(id: 16, name: "lime", original: "juice of 1 lime", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 130, name: "sugar", original: "2 tbsp sugar", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 205, name: "coconut milk", original: "1/4 cup coconut milk", amount: 0.25, unit: "cup", image: nil)
        ], spoonacularScore: 88)
    ],

    .american: [
        SpoonacularRecipe(id: 9001, title: "BBQ Ribs", image: "https://img.spoonacular.com/recipes/633956-312x231.jpg", readyInMinutes: 180, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 206, name: "pork ribs", original: "2 racks pork ribs", amount: 2, unit: "racks", image: nil),
            RecipeIngredient(id: 207, name: "bbq sauce", original: "1 cup BBQ sauce", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 194, name: "brown sugar", original: "2 tbsp brown sugar", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 144, name: "paprika", original: "2 tsp paprika", amount: 2, unit: "tsp", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "1 tsp garlic powder", amount: 1, unit: "tsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 92),
        SpoonacularRecipe(id: 9002, title: "Mac and Cheese", image: "https://img.spoonacular.com/recipes/716426-312x231.jpg", readyInMinutes: 30, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 208, name: "macaroni", original: "2 cups elbow macaroni", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 112, name: "cheddar", original: "2 cups shredded cheddar", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 141, name: "milk", original: "1 cup milk", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 3, name: "butter", original: "2 tbsp butter", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 128, name: "flour", original: "2 tbsp flour", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 90),
        SpoonacularRecipe(id: 9003, title: "Meatloaf", image: "https://img.spoonacular.com/recipes/642585-312x231.jpg", readyInMinutes: 75, servings: 6, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 11, name: "ground beef", original: "2 lbs ground beef", amount: 2, unit: "lbs", image: nil),
            RecipeIngredient(id: 6, name: "eggs", original: "2 eggs", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 209, name: "breadcrumbs", original: "1 cup breadcrumbs", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 108, name: "onion", original: "1 onion diced", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 207, name: "ketchup", original: "1/2 cup ketchup", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 189, name: "mustard", original: "1 tbsp mustard", amount: 1, unit: "tbsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 86),
        SpoonacularRecipe(id: 9004, title: "Buffalo Chicken Wings", image: "https://img.spoonacular.com/recipes/633942-312x231.jpg", readyInMinutes: 45, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 210, name: "chicken wings", original: "2 lbs chicken wings", amount: 2, unit: "lbs", image: nil),
            RecipeIngredient(id: 211, name: "hot sauce", original: "1/2 cup hot sauce", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 3, name: "butter", original: "1/4 cup butter", amount: 0.25, unit: "cup", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "1 tsp garlic powder", amount: 1, unit: "tsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil),
            RecipeIngredient(id: 17, name: "black pepper", original: "pepper to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 87),
        SpoonacularRecipe(id: 9005, title: "Pulled Pork Sandwich", image: "https://img.spoonacular.com/recipes/660306-312x231.jpg", readyInMinutes: 240, servings: 8, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 212, name: "pork shoulder", original: "4 lbs pork shoulder", amount: 4, unit: "lbs", image: nil),
            RecipeIngredient(id: 207, name: "bbq sauce", original: "1 cup BBQ sauce", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 123, name: "burger buns", original: "8 burger buns", amount: 8, unit: "whole", image: nil),
            RecipeIngredient(id: 194, name: "brown sugar", original: "2 tbsp brown sugar", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 144, name: "paprika", original: "1 tbsp paprika", amount: 1, unit: "tbsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 91),
        SpoonacularRecipe(id: 9006, title: "Cornbread", image: "https://img.spoonacular.com/recipes/654812-312x231.jpg", readyInMinutes: 30, servings: 8, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 213, name: "cornmeal", original: "1 cup cornmeal", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 128, name: "flour", original: "1 cup flour", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 130, name: "sugar", original: "1/4 cup sugar", amount: 0.25, unit: "cup", image: nil),
            RecipeIngredient(id: 6, name: "eggs", original: "2 eggs", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 141, name: "milk", original: "1 cup milk", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 3, name: "butter", original: "1/4 cup butter melted", amount: 0.25, unit: "cup", image: nil),
            RecipeIngredient(id: 131, name: "baking powder", original: "1 tbsp baking powder", amount: 1, unit: "tbsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "1/2 tsp salt", amount: 0.5, unit: "tsp", image: nil)
        ], spoonacularScore: 88),
        SpoonacularRecipe(id: 9007, title: "Fried Chicken", image: "https://img.spoonacular.com/recipes/632660-312x231.jpg", readyInMinutes: 45, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 1, name: "chicken", original: "1 whole chicken cut up", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 128, name: "flour", original: "2 cups flour", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 129, name: "buttermilk", original: "2 cups buttermilk", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 144, name: "paprika", original: "1 tbsp paprika", amount: 1, unit: "tbsp", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "1 tsp garlic powder", amount: 1, unit: "tsp", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "oil for frying", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 89),
        SpoonacularRecipe(id: 9008, title: "Pot Roast", image: "https://img.spoonacular.com/recipes/634269-312x231.jpg", readyInMinutes: 240, servings: 6, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 215, name: "chuck roast", original: "3 lb chuck roast", amount: 3, unit: "lbs", image: nil),
            RecipeIngredient(id: 164, name: "potatoes", original: "4 potatoes quartered", amount: 4, unit: "whole", image: nil),
            RecipeIngredient(id: 15, name: "carrots", original: "4 carrots", amount: 4, unit: "whole", image: nil),
            RecipeIngredient(id: 108, name: "onion", original: "1 onion quartered", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 12, name: "beef broth", original: "2 cups beef broth", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "4 cloves garlic", amount: 4, unit: "cloves", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 93),
        SpoonacularRecipe(id: 9009, title: "Classic Beef Burger", image: "https://img.spoonacular.com/recipes/633942-312x231.jpg", readyInMinutes: 20, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 11, name: "ground beef", original: "600g ground beef", amount: 600, unit: "g", image: nil),
            RecipeIngredient(id: 123, name: "burger buns", original: "4 burger buns", amount: 4, unit: "whole", image: nil),
            RecipeIngredient(id: 112, name: "cheddar", original: "4 slices cheddar", amount: 4, unit: "slices", image: nil),
            RecipeIngredient(id: 124, name: "lettuce", original: "4 lettuce leaves", amount: 4, unit: "whole", image: nil),
            RecipeIngredient(id: 105, name: "tomato", original: "1 tomato sliced", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil),
            RecipeIngredient(id: 17, name: "black pepper", original: "pepper to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 88),
        SpoonacularRecipe(id: 9010, title: "Sloppy Joes", image: "https://img.spoonacular.com/recipes/633956-312x231.jpg", readyInMinutes: 25, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 11, name: "ground beef", original: "1 lb ground beef", amount: 1, unit: "lbs", image: nil),
            RecipeIngredient(id: 207, name: "ketchup", original: "1/2 cup ketchup", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 108, name: "onion", original: "1 onion diced", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 107, name: "bell pepper", original: "1 bell pepper diced", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 189, name: "mustard", original: "1 tbsp mustard", amount: 1, unit: "tbsp", image: nil),
            RecipeIngredient(id: 123, name: "burger buns", original: "4 burger buns", amount: 4, unit: "whole", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 86)
    ],

    .italian: [
        SpoonacularRecipe(id: 10001, title: "Cacio e Pepe", image: "https://img.spoonacular.com/recipes/716426-312x231.jpg", readyInMinutes: 20, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 7, name: "pasta", original: "200g spaghetti", amount: 200, unit: "g", image: nil),
            RecipeIngredient(id: 8, name: "parmesan", original: "1 cup pecorino romano", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 17, name: "black pepper", original: "2 tsp coarsely ground black pepper", amount: 2, unit: "tsp", image: nil),
            RecipeIngredient(id: 3, name: "butter", original: "2 tbsp butter", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt for pasta water", amount: 1, unit: "tbsp", image: nil)
        ], spoonacularScore: 93),
        SpoonacularRecipe(id: 10002, title: "Chicken Piccata", image: "https://img.spoonacular.com/recipes/642585-312x231.jpg", readyInMinutes: 30, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 1, name: "chicken breast", original: "4 chicken breasts pounded thin", amount: 4, unit: "piece", image: nil),
            RecipeIngredient(id: 16, name: "lemon", original: "2 lemons juiced", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 216, name: "capers", original: "2 tbsp capers", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 3, name: "butter", original: "4 tbsp butter", amount: 4, unit: "tbsp", image: nil),
            RecipeIngredient(id: 14, name: "chicken broth", original: "1/2 cup chicken broth", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 128, name: "flour", original: "1/2 cup flour", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 91),
        SpoonacularRecipe(id: 10003, title: "Pesto Pasta", image: "https://img.spoonacular.com/recipes/633942-312x231.jpg", readyInMinutes: 20, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 7, name: "pasta", original: "400g pasta", amount: 400, unit: "g", image: nil),
            RecipeIngredient(id: 217, name: "pesto", original: "1/2 cup basil pesto", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 8, name: "parmesan", original: "1/4 cup parmesan", amount: 0.25, unit: "cup", image: nil),
            RecipeIngredient(id: 105, name: "cherry tomatoes", original: "1 cup cherry tomatoes halved", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "2 tbsp olive oil", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 90),
        SpoonacularRecipe(id: 10004, title: "Margherita Pizza", image: "https://img.spoonacular.com/recipes/660306-312x231.jpg", readyInMinutes: 30, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 219, name: "pizza dough", original: "1 ball pizza dough", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 120, name: "tomato sauce", original: "1/2 cup tomato sauce", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 151, name: "fresh mozzarella", original: "8 oz fresh mozzarella", amount: 8, unit: "oz", image: nil),
            RecipeIngredient(id: 106, name: "basil", original: "fresh basil leaves", amount: 1, unit: "bunch", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "2 tbsp olive oil", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 91),
        SpoonacularRecipe(id: 10005, title: "Spaghetti Bolognese", image: "https://img.spoonacular.com/recipes/642585-312x231.jpg", readyInMinutes: 60, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 7, name: "pasta", original: "400g spaghetti", amount: 400, unit: "g", image: nil),
            RecipeIngredient(id: 11, name: "ground beef", original: "500g ground beef", amount: 500, unit: "g", image: nil),
            RecipeIngredient(id: 120, name: "tomato sauce", original: "1 can crushed tomatoes", amount: 1, unit: "can", image: nil),
            RecipeIngredient(id: 108, name: "onion", original: "1 onion diced", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "3 cloves garlic", amount: 3, unit: "cloves", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "2 tbsp olive oil", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 8, name: "parmesan", original: "1/2 cup parmesan", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 92),
        SpoonacularRecipe(id: 10006, title: "Carbonara", image: "https://img.spoonacular.com/recipes/632660-312x231.jpg", readyInMinutes: 25, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 7, name: "pasta", original: "200g spaghetti", amount: 200, unit: "g", image: nil),
            RecipeIngredient(id: 225, name: "pancetta", original: "100g pancetta", amount: 100, unit: "g", image: nil),
            RecipeIngredient(id: 6, name: "eggs", original: "3 egg yolks", amount: 3, unit: "whole", image: nil),
            RecipeIngredient(id: 8, name: "parmesan", original: "1/2 cup pecorino romano", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 17, name: "black pepper", original: "lots of black pepper", amount: 2, unit: "tsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt for pasta water", amount: 1, unit: "tbsp", image: nil)
        ], spoonacularScore: 94),
        SpoonacularRecipe(id: 10007, title: "Chicken Marsala", image: "https://img.spoonacular.com/recipes/634269-312x231.jpg", readyInMinutes: 35, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 1, name: "chicken breast", original: "4 chicken breasts", amount: 4, unit: "piece", image: nil),
            RecipeIngredient(id: 116, name: "mushrooms", original: "2 cups mushrooms sliced", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 221, name: "marsala wine", original: "3/4 cup marsala wine", amount: 0.75, unit: "cup", image: nil),
            RecipeIngredient(id: 14, name: "chicken broth", original: "1/4 cup chicken broth", amount: 0.25, unit: "cup", image: nil),
            RecipeIngredient(id: 3, name: "butter", original: "3 tbsp butter", amount: 3, unit: "tbsp", image: nil),
            RecipeIngredient(id: 128, name: "flour", original: "1/2 cup flour", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 92),
        SpoonacularRecipe(id: 10008, title: "Lasagna", image: "https://img.spoonacular.com/recipes/644826-312x231.jpg", readyInMinutes: 90, servings: 8, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 223, name: "lasagna noodles", original: "12 lasagna noodles", amount: 12, unit: "whole", image: nil),
            RecipeIngredient(id: 11, name: "ground beef", original: "1 lb ground beef", amount: 1, unit: "lbs", image: nil),
            RecipeIngredient(id: 120, name: "tomato sauce", original: "2 cans tomato sauce", amount: 2, unit: "can", image: nil),
            RecipeIngredient(id: 224, name: "ricotta", original: "2 cups ricotta cheese", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 151, name: "mozzarella", original: "2 cups shredded mozzarella", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 8, name: "parmesan", original: "1/2 cup parmesan", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 6, name: "eggs", original: "1 egg", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 95),
        SpoonacularRecipe(id: 10009, title: "Eggplant Parmesan", image: "https://img.spoonacular.com/recipes/716426-312x231.jpg", readyInMinutes: 60, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 171, name: "eggplant", original: "2 large eggplants", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 120, name: "tomato sauce", original: "2 cups tomato sauce", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 151, name: "mozzarella", original: "2 cups shredded mozzarella", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 8, name: "parmesan", original: "1/2 cup parmesan", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 128, name: "flour", original: "1 cup flour", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 6, name: "eggs", original: "2 eggs beaten", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 89),
        SpoonacularRecipe(id: 10010, title: "Mushroom Risotto", image: "https://img.spoonacular.com/recipes/642585-312x231.jpg", readyInMinutes: 45, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 115, name: "arborio rice", original: "1.5 cups arborio rice", amount: 1.5, unit: "cups", image: nil),
            RecipeIngredient(id: 116, name: "mushrooms", original: "300g mushrooms sliced", amount: 300, unit: "g", image: nil),
            RecipeIngredient(id: 117, name: "white wine", original: "1/2 cup white wine", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 14, name: "chicken broth", original: "4 cups chicken broth", amount: 4, unit: "cups", image: nil),
            RecipeIngredient(id: 8, name: "parmesan", original: "1/2 cup parmesan", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 3, name: "butter", original: "2 tbsp butter", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "2 cloves garlic", amount: 2, unit: "cloves", image: nil)
        ], spoonacularScore: 93)
    ],

    .mexican: [
        SpoonacularRecipe(id: 11001, title: "Chicken Enchiladas", image: "https://img.spoonacular.com/recipes/633956-312x231.jpg", readyInMinutes: 45, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 1, name: "chicken breast", original: "2 chicken breasts shredded", amount: 2, unit: "piece", image: nil),
            RecipeIngredient(id: 110, name: "tortillas", original: "8 corn tortillas", amount: 8, unit: "whole", image: nil),
            RecipeIngredient(id: 226, name: "enchilada sauce", original: "2 cups enchilada sauce", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 112, name: "cheddar", original: "1.5 cups shredded cheddar", amount: 1.5, unit: "cups", image: nil),
            RecipeIngredient(id: 108, name: "onion", original: "1 onion diced", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 91),
        SpoonacularRecipe(id: 11002, title: "Beef Tacos", image: "https://img.spoonacular.com/recipes/716426-312x231.jpg", readyInMinutes: 25, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 11, name: "ground beef", original: "500g ground beef", amount: 500, unit: "g", image: nil),
            RecipeIngredient(id: 110, name: "tortillas", original: "8 corn tortillas", amount: 8, unit: "whole", image: nil),
            RecipeIngredient(id: 111, name: "taco seasoning", original: "2 tbsp taco seasoning", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 112, name: "cheddar", original: "1 cup shredded cheddar", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 113, name: "salsa", original: "1/2 cup salsa", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 114, name: "sour cream", original: "1/4 cup sour cream", amount: 0.25, unit: "cup", image: nil)
        ], spoonacularScore: 89),
        SpoonacularRecipe(id: 11003, title: "Sheet Pan Fajitas", image: "https://img.spoonacular.com/recipes/642585-312x231.jpg", readyInMinutes: 35, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 1, name: "chicken breast", original: "500g chicken breast", amount: 500, unit: "g", image: nil),
            RecipeIngredient(id: 107, name: "bell pepper", original: "3 bell peppers", amount: 3, unit: "whole", image: nil),
            RecipeIngredient(id: 108, name: "onion", original: "1 onion", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 109, name: "fajita seasoning", original: "2 tbsp fajita seasoning", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "2 tbsp olive oil", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 110, name: "tortillas", original: "8 flour tortillas", amount: 8, unit: "whole", image: nil)
        ], spoonacularScore: 90),
        SpoonacularRecipe(id: 11004, title: "Guacamole", image: "https://img.spoonacular.com/recipes/633942-312x231.jpg", readyInMinutes: 10, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 118, name: "avocado", original: "3 ripe avocados", amount: 3, unit: "whole", image: nil),
            RecipeIngredient(id: 16, name: "lime", original: "juice of 2 limes", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 108, name: "red onion", original: "1/4 red onion minced", amount: 0.25, unit: "whole", image: nil),
            RecipeIngredient(id: 185, name: "cilantro", original: "2 tbsp fresh cilantro", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 186, name: "jalapeno", original: "1 jalapeno minced", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 92),
        SpoonacularRecipe(id: 11005, title: "Black Bean Quesadilla", image: "https://img.spoonacular.com/recipes/660306-312x231.jpg", readyInMinutes: 15, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 110, name: "tortillas", original: "4 flour tortillas", amount: 4, unit: "whole", image: nil),
            RecipeIngredient(id: 160, name: "black beans", original: "1 can black beans", amount: 1, unit: "can", image: nil),
            RecipeIngredient(id: 112, name: "cheddar", original: "1 cup shredded cheddar", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 107, name: "bell pepper", original: "1 bell pepper diced", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 113, name: "salsa", original: "1/4 cup salsa", amount: 0.25, unit: "cup", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 86),
        SpoonacularRecipe(id: 11006, title: "Carnitas", image: "https://img.spoonacular.com/recipes/654812-312x231.jpg", readyInMinutes: 180, servings: 8, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 212, name: "pork shoulder", original: "4 lbs pork shoulder", amount: 4, unit: "lbs", image: nil),
            RecipeIngredient(id: 229, name: "orange", original: "juice of 2 oranges", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 228, name: "lime", original: "juice of 2 limes", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "4 cloves garlic", amount: 4, unit: "cloves", image: nil),
            RecipeIngredient(id: 122, name: "cumin", original: "2 tsp cumin", amount: 2, unit: "tsp", image: nil),
            RecipeIngredient(id: 108, name: "onion", original: "1 onion", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 93),
        SpoonacularRecipe(id: 11007, title: "Fish Tacos", image: "https://img.spoonacular.com/recipes/632660-312x231.jpg", readyInMinutes: 25, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 227, name: "white fish", original: "1 lb white fish fillets", amount: 1, unit: "lbs", image: nil),
            RecipeIngredient(id: 110, name: "tortillas", original: "8 corn tortillas", amount: 8, unit: "whole", image: nil),
            RecipeIngredient(id: 170, name: "coleslaw", original: "2 cups coleslaw mix", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 16, name: "lime", original: "2 limes", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 185, name: "cilantro", original: "fresh cilantro", amount: 1, unit: "bunch", image: nil),
            RecipeIngredient(id: 111, name: "taco seasoning", original: "1 tbsp taco seasoning", amount: 1, unit: "tbsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 90),
        SpoonacularRecipe(id: 11008, title: "Nachos", image: "https://img.spoonacular.com/recipes/634269-312x231.jpg", readyInMinutes: 15, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 193, name: "tortilla chips", original: "1 bag tortilla chips", amount: 1, unit: "bag", image: nil),
            RecipeIngredient(id: 112, name: "cheddar", original: "2 cups shredded cheddar", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 160, name: "black beans", original: "1 can black beans", amount: 1, unit: "can", image: nil),
            RecipeIngredient(id: 113, name: "salsa", original: "1/2 cup salsa", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 186, name: "jalapeno", original: "1 jalapeno sliced", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 114, name: "sour cream", original: "1/4 cup sour cream", amount: 0.25, unit: "cup", image: nil)
        ], spoonacularScore: 86),
        SpoonacularRecipe(id: 11009, title: "Shrimp Tacos", image: "https://img.spoonacular.com/recipes/644826-312x231.jpg", readyInMinutes: 20, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 125, name: "shrimp", original: "400g shrimp", amount: 400, unit: "g", image: nil),
            RecipeIngredient(id: 110, name: "tortillas", original: "8 corn tortillas", amount: 8, unit: "whole", image: nil),
            RecipeIngredient(id: 170, name: "coleslaw", original: "1 cup coleslaw mix", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 111, name: "taco seasoning", original: "1 tbsp taco seasoning", amount: 1, unit: "tbsp", image: nil),
            RecipeIngredient(id: 16, name: "lime", original: "2 limes", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "1 tbsp oil", amount: 1, unit: "tbsp", image: nil)
        ], spoonacularScore: 87),
        SpoonacularRecipe(id: 11010, title: "Chiles Rellenos", image: "https://img.spoonacular.com/recipes/716426-312x231.jpg", readyInMinutes: 45, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 231, name: "poblano peppers", original: "4 poblano peppers", amount: 4, unit: "whole", image: nil),
            RecipeIngredient(id: 232, name: "queso fresco", original: "1 cup queso fresco", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 6, name: "eggs", original: "3 eggs separated", amount: 3, unit: "whole", image: nil),
            RecipeIngredient(id: 128, name: "flour", original: "1/2 cup flour", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 120, name: "tomato sauce", original: "1 cup tomato sauce", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "oil for frying", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 88)
    ],

    .asian: [
        SpoonacularRecipe(id: 12001, title: "Pad Thai", image: "https://img.spoonacular.com/recipes/716426-312x231.jpg", readyInMinutes: 25, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 179, name: "rice noodles", original: "200g rice noodles", amount: 200, unit: "g", image: nil),
            RecipeIngredient(id: 125, name: "shrimp", original: "200g shrimp", amount: 200, unit: "g", image: nil),
            RecipeIngredient(id: 6, name: "eggs", original: "2 eggs", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 235, name: "pad thai sauce", original: "3 tbsp pad thai sauce", amount: 3, unit: "tbsp", image: nil),
            RecipeIngredient(id: 181, name: "bean sprouts", original: "1 cup bean sprouts", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 236, name: "peanuts", original: "1/4 cup crushed peanuts", amount: 0.25, unit: "cup", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "2 tbsp oil", amount: 2, unit: "tbsp", image: nil)
        ], spoonacularScore: 92),
        SpoonacularRecipe(id: 12002, title: "Chicken Fried Rice", image: "https://img.spoonacular.com/recipes/642585-312x231.jpg", readyInMinutes: 25, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 1, name: "chicken breast", original: "1 chicken breast", amount: 1, unit: "piece", image: nil),
            RecipeIngredient(id: 5, name: "rice", original: "2 cups cooked rice", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 6, name: "eggs", original: "2 eggs", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 4, name: "soy sauce", original: "2 tbsp soy sauce", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "2 cloves garlic", amount: 2, unit: "cloves", image: nil),
            RecipeIngredient(id: 9, name: "sesame oil", original: "1 tsp sesame oil", amount: 1, unit: "tsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 88),
        SpoonacularRecipe(id: 12003, title: "Shrimp Stir Fry", image: "https://img.spoonacular.com/recipes/633942-312x231.jpg", readyInMinutes: 20, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 125, name: "shrimp", original: "300g shrimp", amount: 300, unit: "g", image: nil),
            RecipeIngredient(id: 107, name: "bell pepper", original: "2 bell peppers", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 126, name: "broccoli", original: "1 cup broccoli", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 4, name: "soy sauce", original: "3 tbsp soy sauce", amount: 3, unit: "tbsp", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "3 cloves garlic", amount: 3, unit: "cloves", image: nil),
            RecipeIngredient(id: 127, name: "ginger", original: "1 tsp fresh ginger", amount: 1, unit: "tsp", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "2 tbsp oil", amount: 2, unit: "tbsp", image: nil)
        ], spoonacularScore: 88),
        SpoonacularRecipe(id: 12004, title: "Teriyaki Chicken", image: "https://img.spoonacular.com/recipes/633956-312x231.jpg", readyInMinutes: 25, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 1, name: "chicken thighs", original: "600g chicken thighs", amount: 600, unit: "g", image: nil),
            RecipeIngredient(id: 4, name: "soy sauce", original: "4 tbsp soy sauce", amount: 4, unit: "tbsp", image: nil),
            RecipeIngredient(id: 104, name: "honey", original: "2 tbsp honey", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 243, name: "mirin", original: "2 tbsp mirin", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 127, name: "ginger", original: "1 tsp ginger", amount: 1, unit: "tsp", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "2 cloves garlic", amount: 2, unit: "cloves", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "1 tbsp oil", amount: 1, unit: "tbsp", image: nil)
        ], spoonacularScore: 91),
        SpoonacularRecipe(id: 12005, title: "Thai Green Curry", image: "https://img.spoonacular.com/recipes/716426-312x231.jpg", readyInMinutes: 30, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 1, name: "chicken breast", original: "600g chicken breast", amount: 600, unit: "g", image: nil),
            RecipeIngredient(id: 205, name: "coconut milk", original: "1 can coconut milk", amount: 1, unit: "can", image: nil),
            RecipeIngredient(id: 248, name: "green curry paste", original: "2 tbsp green curry paste", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 126, name: "broccoli", original: "1 cup broccoli", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 107, name: "bell pepper", original: "1 bell pepper", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 4, name: "fish sauce", original: "1 tbsp fish sauce", amount: 1, unit: "tbsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 93),
        SpoonacularRecipe(id: 12006, title: "Honey Garlic Salmon", image: "https://img.spoonacular.com/recipes/654812-312x231.jpg", readyInMinutes: 20, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 103, name: "salmon", original: "2 salmon fillets", amount: 2, unit: "piece", image: nil),
            RecipeIngredient(id: 104, name: "honey", original: "3 tbsp honey", amount: 3, unit: "tbsp", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "4 cloves garlic", amount: 4, unit: "cloves", image: nil),
            RecipeIngredient(id: 4, name: "soy sauce", original: "2 tbsp soy sauce", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 3, name: "butter", original: "1 tbsp butter", amount: 1, unit: "tbsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 92),
        SpoonacularRecipe(id: 12007, title: "Dumplings", image: "https://img.spoonacular.com/recipes/632660-312x231.jpg", readyInMinutes: 45, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 241, name: "dumpling wrappers", original: "40 dumpling wrappers", amount: 40, unit: "whole", image: nil),
            RecipeIngredient(id: 168, name: "ground pork", original: "300g ground pork", amount: 300, unit: "g", image: nil),
            RecipeIngredient(id: 242, name: "cabbage", original: "1 cup napa cabbage minced", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 127, name: "ginger", original: "1 tbsp fresh ginger", amount: 1, unit: "tbsp", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "2 cloves garlic", amount: 2, unit: "cloves", image: nil),
            RecipeIngredient(id: 4, name: "soy sauce", original: "2 tbsp soy sauce", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 9, name: "sesame oil", original: "1 tsp sesame oil", amount: 1, unit: "tsp", image: nil)
        ], spoonacularScore: 91),
        SpoonacularRecipe(id: 12008, title: "Miso Soup", image: "https://img.spoonacular.com/recipes/633956-312x231.jpg", readyInMinutes: 15, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 244, name: "miso paste", original: "3 tbsp white miso paste", amount: 3, unit: "tbsp", image: nil),
            RecipeIngredient(id: 245, name: "dashi stock", original: "3 cups dashi stock", amount: 3, unit: "cups", image: nil),
            RecipeIngredient(id: 246, name: "tofu", original: "150g silken tofu cubed", amount: 150, unit: "g", image: nil),
            RecipeIngredient(id: 240, name: "nori", original: "1 sheet nori cut", amount: 1, unit: "sheet", image: nil),
            RecipeIngredient(id: 108, name: "green onions", original: "2 green onions sliced", amount: 2, unit: "whole", image: nil)
        ], spoonacularScore: 87),
        SpoonacularRecipe(id: 12009, title: "Spring Rolls", image: "https://img.spoonacular.com/recipes/642585-312x231.jpg", readyInMinutes: 30, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 249, name: "spring roll wrappers", original: "12 spring roll wrappers", amount: 12, unit: "whole", image: nil),
            RecipeIngredient(id: 242, name: "cabbage", original: "2 cups shredded cabbage", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 15, name: "carrots", original: "2 carrots julienned", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 250, name: "glass noodles", original: "100g glass noodles", amount: 100, unit: "g", image: nil),
            RecipeIngredient(id: 4, name: "soy sauce", original: "2 tbsp soy sauce", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "oil for frying", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 88),
        SpoonacularRecipe(id: 12010, title: "Bibimbap", image: "https://img.spoonacular.com/recipes/633942-312x231.jpg", readyInMinutes: 40, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 5, name: "rice", original: "2 cups cooked rice", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 11, name: "ground beef", original: "200g ground beef", amount: 200, unit: "g", image: nil),
            RecipeIngredient(id: 6, name: "eggs", original: "2 fried eggs", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 126, name: "broccoli", original: "1 cup broccoli", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 15, name: "carrots", original: "1 carrot julienned", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 237, name: "gochujang", original: "2 tbsp gochujang", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 4, name: "soy sauce", original: "2 tbsp soy sauce", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 9, name: "sesame oil", original: "1 tbsp sesame oil", amount: 1, unit: "tbsp", image: nil)
        ], spoonacularScore: 93)
    ],

    .mediterranean: [
        SpoonacularRecipe(id: 13001, title: "Greek Salad", image: "https://img.spoonacular.com/recipes/644826-312x231.jpg", readyInMinutes: 15, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 146, name: "cucumber", original: "1 large cucumber", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 105, name: "tomatoes", original: "2 cups cherry tomatoes", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 147, name: "kalamata olives", original: "1/2 cup kalamata olives", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 143, name: "feta", original: "1/2 cup feta cheese", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 108, name: "red onion", original: "1/2 red onion", amount: 0.5, unit: "whole", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "3 tbsp olive oil", amount: 3, unit: "tbsp", image: nil),
            RecipeIngredient(id: 16, name: "lemon", original: "juice of 1 lemon", amount: 1, unit: "whole", image: nil)
        ], spoonacularScore: 90),
        SpoonacularRecipe(id: 13002, title: "Hummus", image: "https://img.spoonacular.com/recipes/633942-312x231.jpg", readyInMinutes: 10, servings: 6, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 157, name: "chickpeas", original: "1 can chickpeas", amount: 1, unit: "can", image: nil),
            RecipeIngredient(id: 187, name: "tahini", original: "3 tbsp tahini", amount: 3, unit: "tbsp", image: nil),
            RecipeIngredient(id: 16, name: "lemon", original: "juice of 1 lemon", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "2 cloves garlic", amount: 2, unit: "cloves", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "3 tbsp olive oil", amount: 3, unit: "tbsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 91),
        SpoonacularRecipe(id: 13003, title: "Shakshuka", image: "https://img.spoonacular.com/recipes/716426-312x231.jpg", readyInMinutes: 25, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 6, name: "eggs", original: "4 eggs", amount: 4, unit: "whole", image: nil),
            RecipeIngredient(id: 120, name: "tomatoes", original: "1 can crushed tomatoes", amount: 1, unit: "can", image: nil),
            RecipeIngredient(id: 107, name: "bell pepper", original: "1 bell pepper", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 108, name: "onion", original: "1 onion", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "3 cloves garlic", amount: 3, unit: "cloves", image: nil),
            RecipeIngredient(id: 144, name: "paprika", original: "1 tsp paprika", amount: 1, unit: "tsp", image: nil),
            RecipeIngredient(id: 122, name: "cumin", original: "1 tsp cumin", amount: 1, unit: "tsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 92),
        SpoonacularRecipe(id: 13004, title: "Falafel", image: "https://img.spoonacular.com/recipes/642585-312x231.jpg", readyInMinutes: 30, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 157, name: "chickpeas", original: "2 cans chickpeas", amount: 2, unit: "can", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "3 cloves garlic", amount: 3, unit: "cloves", image: nil),
            RecipeIngredient(id: 108, name: "onion", original: "1 small onion", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 185, name: "cilantro", original: "1/4 cup cilantro", amount: 0.25, unit: "cup", image: nil),
            RecipeIngredient(id: 122, name: "cumin", original: "2 tsp cumin", amount: 2, unit: "tsp", image: nil),
            RecipeIngredient(id: 128, name: "flour", original: "3 tbsp flour", amount: 3, unit: "tbsp", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "oil for frying", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 90),
        SpoonacularRecipe(id: 13005, title: "Tabbouleh", image: "https://img.spoonacular.com/recipes/633956-312x231.jpg", readyInMinutes: 20, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 253, name: "bulgur wheat", original: "1 cup bulgur wheat", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 185, name: "parsley", original: "2 cups fresh parsley", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 105, name: "tomatoes", original: "2 tomatoes diced", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 146, name: "cucumber", original: "1 cucumber diced", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 16, name: "lemon", original: "juice of 2 lemons", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "3 tbsp olive oil", amount: 3, unit: "tbsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 88),
        SpoonacularRecipe(id: 13006, title: "Lamb Kebabs", image: "https://img.spoonacular.com/recipes/660306-312x231.jpg", readyInMinutes: 30, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 251, name: "ground lamb", original: "500g ground lamb", amount: 500, unit: "g", image: nil),
            RecipeIngredient(id: 108, name: "onion", original: "1 onion grated", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "2 cloves garlic", amount: 2, unit: "cloves", image: nil),
            RecipeIngredient(id: 122, name: "cumin", original: "1 tsp cumin", amount: 1, unit: "tsp", image: nil),
            RecipeIngredient(id: 144, name: "paprika", original: "1 tsp paprika", amount: 1, unit: "tsp", image: nil),
            RecipeIngredient(id: 185, name: "parsley", original: "2 tbsp fresh parsley", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 91),
        SpoonacularRecipe(id: 13007, title: "Baba Ganoush", image: "https://img.spoonacular.com/recipes/642585-312x231.jpg", readyInMinutes: 40, servings: 6, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 171, name: "eggplant", original: "2 large eggplants", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 187, name: "tahini", original: "3 tbsp tahini", amount: 3, unit: "tbsp", image: nil),
            RecipeIngredient(id: 16, name: "lemon", original: "juice of 2 lemons", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "2 cloves garlic", amount: 2, unit: "cloves", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "2 tbsp olive oil", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 89),
        SpoonacularRecipe(id: 13008, title: "Spanakopita", image: "https://img.spoonacular.com/recipes/633942-312x231.jpg", readyInMinutes: 60, servings: 8, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 254, name: "phyllo dough", original: "1 package phyllo dough", amount: 1, unit: "package", image: nil),
            RecipeIngredient(id: 101, name: "spinach", original: "1 lb frozen spinach", amount: 1, unit: "lbs", image: nil),
            RecipeIngredient(id: 143, name: "feta", original: "2 cups feta cheese", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 6, name: "eggs", original: "2 eggs", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 108, name: "onion", original: "1 onion diced", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 3, name: "butter", original: "1/2 cup butter melted", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 92),
        SpoonacularRecipe(id: 13009, title: "Chicken Shawarma", image: "https://img.spoonacular.com/recipes/716426-312x231.jpg", readyInMinutes: 40, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 1, name: "chicken thighs", original: "600g chicken thighs", amount: 600, unit: "g", image: nil),
            RecipeIngredient(id: 256, name: "pita bread", original: "4 pita breads", amount: 4, unit: "whole", image: nil),
            RecipeIngredient(id: 122, name: "cumin", original: "2 tsp cumin", amount: 2, unit: "tsp", image: nil),
            RecipeIngredient(id: 144, name: "paprika", original: "1 tsp paprika", amount: 1, unit: "tsp", image: nil),
            RecipeIngredient(id: 142, name: "cinnamon", original: "1/2 tsp cinnamon", amount: 0.5, unit: "tsp", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "3 tbsp olive oil", amount: 3, unit: "tbsp", image: nil),
            RecipeIngredient(id: 16, name: "lemon", original: "juice of 1 lemon", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 93),
        SpoonacularRecipe(id: 13010, title: "Moussaka", image: "https://img.spoonacular.com/recipes/642585-312x231.jpg", readyInMinutes: 90, servings: 6, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 171, name: "eggplant", original: "2 large eggplants", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 251, name: "ground lamb", original: "500g ground lamb", amount: 500, unit: "g", image: nil),
            RecipeIngredient(id: 120, name: "tomatoes", original: "1 can crushed tomatoes", amount: 1, unit: "can", image: nil),
            RecipeIngredient(id: 102, name: "heavy cream", original: "1 cup heavy cream", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 8, name: "parmesan", original: "1/2 cup parmesan", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "3 cloves garlic", amount: 3, unit: "cloves", image: nil),
            RecipeIngredient(id: 142, name: "cinnamon", original: "1 tsp cinnamon", amount: 1, unit: "tsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 91)
    ],

    .indian: [
        SpoonacularRecipe(id: 14001, title: "Butter Chicken", image: "https://img.spoonacular.com/recipes/716426-312x231.jpg", readyInMinutes: 45, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 1, name: "chicken breast", original: "600g chicken breast", amount: 600, unit: "g", image: nil),
            RecipeIngredient(id: 120, name: "tomato sauce", original: "1 can tomato sauce", amount: 1, unit: "can", image: nil),
            RecipeIngredient(id: 102, name: "heavy cream", original: "1/2 cup heavy cream", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 3, name: "butter", original: "2 tbsp butter", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "4 cloves garlic", amount: 4, unit: "cloves", image: nil),
            RecipeIngredient(id: 121, name: "garam masala", original: "2 tsp garam masala", amount: 2, unit: "tsp", image: nil),
            RecipeIngredient(id: 122, name: "cumin", original: "1 tsp cumin", amount: 1, unit: "tsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 95),
        SpoonacularRecipe(id: 14002, title: "Saag Paneer", image: "https://img.spoonacular.com/recipes/642585-312x231.jpg", readyInMinutes: 40, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 258, name: "paneer", original: "250g paneer cubed", amount: 250, unit: "g", image: nil),
            RecipeIngredient(id: 101, name: "spinach", original: "500g fresh spinach", amount: 500, unit: "g", image: nil),
            RecipeIngredient(id: 102, name: "heavy cream", original: "1/4 cup heavy cream", amount: 0.25, unit: "cup", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "3 cloves garlic", amount: 3, unit: "cloves", image: nil),
            RecipeIngredient(id: 127, name: "ginger", original: "1 tbsp fresh ginger", amount: 1, unit: "tbsp", image: nil),
            RecipeIngredient(id: 121, name: "garam masala", original: "1 tsp garam masala", amount: 1, unit: "tsp", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "2 tbsp oil", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 90),
        SpoonacularRecipe(id: 14003, title: "Chicken Biryani", image: "https://img.spoonacular.com/recipes/633942-312x231.jpg", readyInMinutes: 60, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 1, name: "chicken thighs", original: "600g chicken thighs", amount: 600, unit: "g", image: nil),
            RecipeIngredient(id: 259, name: "basmati rice", original: "2 cups basmati rice", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 138, name: "yogurt", original: "1/2 cup yogurt", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 121, name: "garam masala", original: "2 tsp garam masala", amount: 2, unit: "tsp", image: nil),
            RecipeIngredient(id: 220, name: "saffron", original: "1 pinch saffron", amount: 1, unit: "pinch", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "4 cloves garlic", amount: 4, unit: "cloves", image: nil),
            RecipeIngredient(id: 127, name: "ginger", original: "2 tbsp fresh ginger", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 108, name: "onion", original: "2 onions sliced", amount: 2, unit: "whole", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 94),
        SpoonacularRecipe(id: 14004, title: "Chana Masala", image: "https://img.spoonacular.com/recipes/633956-312x231.jpg", readyInMinutes: 35, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 157, name: "chickpeas", original: "2 cans chickpeas", amount: 2, unit: "can", image: nil),
            RecipeIngredient(id: 120, name: "tomatoes", original: "1 can crushed tomatoes", amount: 1, unit: "can", image: nil),
            RecipeIngredient(id: 108, name: "onion", original: "1 large onion", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "4 cloves garlic", amount: 4, unit: "cloves", image: nil),
            RecipeIngredient(id: 127, name: "ginger", original: "1 tbsp fresh ginger", amount: 1, unit: "tbsp", image: nil),
            RecipeIngredient(id: 121, name: "garam masala", original: "2 tsp garam masala", amount: 2, unit: "tsp", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "2 tbsp oil", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 91),
        SpoonacularRecipe(id: 14005, title: "Dal Makhani", image: "https://img.spoonacular.com/recipes/716426-312x231.jpg", readyInMinutes: 60, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 257, name: "black lentils", original: "1 cup black lentils", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 120, name: "tomatoes", original: "1 can crushed tomatoes", amount: 1, unit: "can", image: nil),
            RecipeIngredient(id: 102, name: "heavy cream", original: "1/2 cup heavy cream", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 3, name: "butter", original: "2 tbsp butter", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "4 cloves garlic", amount: 4, unit: "cloves", image: nil),
            RecipeIngredient(id: 127, name: "ginger", original: "1 tbsp fresh ginger", amount: 1, unit: "tbsp", image: nil),
            RecipeIngredient(id: 121, name: "garam masala", original: "2 tsp garam masala", amount: 2, unit: "tsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 93),
        SpoonacularRecipe(id: 14006, title: "Aloo Gobi", image: "https://img.spoonacular.com/recipes/642585-312x231.jpg", readyInMinutes: 35, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 164, name: "potatoes", original: "3 potatoes cubed", amount: 3, unit: "whole", image: nil),
            RecipeIngredient(id: 260, name: "cauliflower", original: "1 head cauliflower", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 108, name: "onion", original: "1 onion diced", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "3 cloves garlic", amount: 3, unit: "cloves", image: nil),
            RecipeIngredient(id: 127, name: "ginger", original: "1 tbsp fresh ginger", amount: 1, unit: "tbsp", image: nil),
            RecipeIngredient(id: 122, name: "cumin", original: "1 tsp cumin", amount: 1, unit: "tsp", image: nil),
            RecipeIngredient(id: 144, name: "turmeric", original: "1/2 tsp turmeric", amount: 0.5, unit: "tsp", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "2 tbsp oil", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 88),
        SpoonacularRecipe(id: 14007, title: "Tandoori Chicken", image: "https://img.spoonacular.com/recipes/633956-312x231.jpg", readyInMinutes: 50, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 1, name: "chicken", original: "1 whole chicken cut up", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 138, name: "yogurt", original: "1 cup yogurt", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 263, name: "tandoori masala", original: "2 tbsp tandoori masala", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "4 cloves garlic", amount: 4, unit: "cloves", image: nil),
            RecipeIngredient(id: 127, name: "ginger", original: "2 tbsp fresh ginger", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 16, name: "lemon", original: "juice of 1 lemon", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 92),
        SpoonacularRecipe(id: 14008, title: "Tikka Masala", image: "https://img.spoonacular.com/recipes/716426-312x231.jpg", readyInMinutes: 50, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 1, name: "chicken breast", original: "600g chicken breast", amount: 600, unit: "g", image: nil),
            RecipeIngredient(id: 120, name: "tomato sauce", original: "1 can crushed tomatoes", amount: 1, unit: "can", image: nil),
            RecipeIngredient(id: 102, name: "heavy cream", original: "1/2 cup heavy cream", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 121, name: "garam masala", original: "2 tsp garam masala", amount: 2, unit: "tsp", image: nil),
            RecipeIngredient(id: 122, name: "cumin", original: "1 tsp cumin", amount: 1, unit: "tsp", image: nil),
            RecipeIngredient(id: 144, name: "paprika", original: "1 tsp paprika", amount: 1, unit: "tsp", image: nil),
            RecipeIngredient(id: 2, name: "garlic", original: "4 cloves garlic", amount: 4, unit: "cloves", image: nil),
            RecipeIngredient(id: 127, name: "ginger", original: "1 tbsp fresh ginger", amount: 1, unit: "tbsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 95),
        SpoonacularRecipe(id: 14009, title: "Samosas", image: "https://img.spoonacular.com/recipes/642585-312x231.jpg", readyInMinutes: 60, servings: 8, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 128, name: "flour", original: "2 cups flour", amount: 2, unit: "cups", image: nil),
            RecipeIngredient(id: 164, name: "potatoes", original: "3 potatoes boiled and mashed", amount: 3, unit: "whole", image: nil),
            RecipeIngredient(id: 247, name: "peas", original: "1/2 cup peas", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 122, name: "cumin", original: "1 tsp cumin", amount: 1, unit: "tsp", image: nil),
            RecipeIngredient(id: 185, name: "cilantro", original: "2 tbsp cilantro", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "oil for frying", amount: 1, unit: "cup", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 89),
        SpoonacularRecipe(id: 14010, title: "Korma", image: "https://img.spoonacular.com/recipes/633942-312x231.jpg", readyInMinutes: 45, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
            RecipeIngredient(id: 1, name: "chicken breast", original: "600g chicken breast", amount: 600, unit: "g", image: nil),
            RecipeIngredient(id: 264, name: "korma paste", original: "3 tbsp korma paste", amount: 3, unit: "tbsp", image: nil),
            RecipeIngredient(id: 102, name: "heavy cream", original: "1/2 cup heavy cream", amount: 0.5, unit: "cup", image: nil),
            RecipeIngredient(id: 138, name: "yogurt", original: "1/4 cup yogurt", amount: 0.25, unit: "cup", image: nil),
            RecipeIngredient(id: 108, name: "onion", original: "1 onion", amount: 1, unit: "whole", image: nil),
            RecipeIngredient(id: 236, name: "cashews", original: "1/4 cup cashews", amount: 0.25, unit: "cup", image: nil),
            RecipeIngredient(id: 9, name: "oil", original: "2 tbsp oil", amount: 2, unit: "tbsp", image: nil),
            RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
        ], spoonacularScore: 91)
    ]
]

// Browse recipe details share the same mock detail pool as the Recipes tab.
// When useMockData = false, real Spoonacular API details are fetched.
let mockBrowseRecipeDetails: [Int: RecipeDetail] = [:]
