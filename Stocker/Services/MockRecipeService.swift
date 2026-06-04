import Foundation

let mockRecipes: [SpoonacularRecipe] = [

    // MARK: - Chicken
    SpoonacularRecipe(id: 1001, title: "Garlic Butter Chicken", image: "https://img.spoonacular.com/recipes/632660-312x231.jpg", readyInMinutes: 30, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 1, name: "chicken breast", original: "2 chicken breasts", amount: 2, unit: "piece", image: nil),
        RecipeIngredient(id: 2, name: "garlic", original: "4 cloves garlic", amount: 4, unit: "cloves", image: nil),
        RecipeIngredient(id: 3, name: "butter", original: "2 tablespoons butter", amount: 2, unit: "tablespoons", image: nil),
        RecipeIngredient(id: 16, name: "lemon", original: "juice of 1 lemon", amount: 1, unit: "whole", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil),
        RecipeIngredient(id: 17, name: "black pepper", original: "black pepper to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 92),
    SpoonacularRecipe(id: 1002, title: "Chicken Fried Rice", image: "https://img.spoonacular.com/recipes/634269-312x231.jpg", readyInMinutes: 25, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 1, name: "chicken breast", original: "1 chicken breast", amount: 1, unit: "piece", image: nil),
        RecipeIngredient(id: 5, name: "rice", original: "2 cups rice", amount: 2, unit: "cups", image: nil),
        RecipeIngredient(id: 6, name: "eggs", original: "2 eggs", amount: 2, unit: "whole", image: nil),
        RecipeIngredient(id: 4, name: "soy sauce", original: "2 tablespoons soy sauce", amount: 2, unit: "tablespoons", image: nil),
        RecipeIngredient(id: 2, name: "garlic", original: "2 cloves garlic", amount: 2, unit: "cloves", image: nil),
        RecipeIngredient(id: 9, name: "oil", original: "1 tablespoon oil", amount: 1, unit: "tablespoon", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 88),
    SpoonacularRecipe(id: 1008, title: "Chicken and Rice Soup", image: "https://img.spoonacular.com/recipes/633956-312x231.jpg", readyInMinutes: 45, servings: 6, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 1, name: "chicken breast", original: "2 chicken breasts", amount: 2, unit: "piece", image: nil),
        RecipeIngredient(id: 5, name: "rice", original: "1 cup rice", amount: 1, unit: "cup", image: nil),
        RecipeIngredient(id: 14, name: "chicken broth", original: "4 cups chicken broth", amount: 4, unit: "cups", image: nil),
        RecipeIngredient(id: 15, name: "carrots", original: "2 carrots diced", amount: 2, unit: "whole", image: nil),
        RecipeIngredient(id: 2, name: "garlic", original: "2 cloves garlic", amount: 2, unit: "cloves", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 93),
    SpoonacularRecipe(id: 1009, title: "Baked Lemon Herb Chicken", image: "https://img.spoonacular.com/recipes/716426-312x231.jpg", readyInMinutes: 45, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 1, name: "chicken breast", original: "4 chicken breasts", amount: 4, unit: "piece", image: nil),
        RecipeIngredient(id: 16, name: "lemon", original: "2 lemons", amount: 2, unit: "whole", image: nil),
        RecipeIngredient(id: 2, name: "garlic", original: "4 cloves garlic", amount: 4, unit: "cloves", image: nil),
        RecipeIngredient(id: 166, name: "rosemary", original: "2 sprigs rosemary", amount: 2, unit: "sprigs", image: nil),
        RecipeIngredient(id: 167, name: "thyme", original: "4 sprigs thyme", amount: 4, unit: "sprigs", image: nil),
        RecipeIngredient(id: 9, name: "oil", original: "3 tbsp olive oil", amount: 3, unit: "tbsp", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 90),
    SpoonacularRecipe(id: 1010, title: "Creamy Tuscan Chicken", image: "https://img.spoonacular.com/recipes/654812-312x231.jpg", readyInMinutes: 30, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 1, name: "chicken breast", original: "4 chicken breasts", amount: 4, unit: "piece", image: nil),
        RecipeIngredient(id: 100, name: "sun dried tomatoes", original: "1/2 cup sun dried tomatoes", amount: 0.5, unit: "cup", image: nil),
        RecipeIngredient(id: 101, name: "spinach", original: "2 cups spinach", amount: 2, unit: "cups", image: nil),
        RecipeIngredient(id: 102, name: "heavy cream", original: "1 cup heavy cream", amount: 1, unit: "cup", image: nil),
        RecipeIngredient(id: 2, name: "garlic", original: "4 cloves garlic", amount: 4, unit: "cloves", image: nil),
        RecipeIngredient(id: 8, name: "parmesan", original: "1/2 cup parmesan", amount: 0.5, unit: "cup", image: nil),
        RecipeIngredient(id: 9, name: "oil", original: "2 tbsp olive oil", amount: 2, unit: "tbsp", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 94),
    SpoonacularRecipe(id: 1011, title: "Chicken Tikka Masala", image: "https://img.spoonacular.com/recipes/633942-312x231.jpg", readyInMinutes: 50, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
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
    SpoonacularRecipe(id: 1012, title: "Buffalo Chicken Wings", image: "https://img.spoonacular.com/recipes/716426-312x231.jpg", readyInMinutes: 45, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 210, name: "chicken wings", original: "2 lbs chicken wings", amount: 2, unit: "lbs", image: nil),
        RecipeIngredient(id: 211, name: "hot sauce", original: "1/2 cup hot sauce", amount: 0.5, unit: "cup", image: nil),
        RecipeIngredient(id: 3, name: "butter", original: "1/4 cup butter", amount: 0.25, unit: "cup", image: nil),
        RecipeIngredient(id: 2, name: "garlic", original: "1 tsp garlic powder", amount: 1, unit: "tsp", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil),
        RecipeIngredient(id: 17, name: "black pepper", original: "pepper to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 87),
    SpoonacularRecipe(id: 1013, title: "Chicken Caesar Salad", image: "https://img.spoonacular.com/recipes/642585-312x231.jpg", readyInMinutes: 20, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 1, name: "chicken breast", original: "2 chicken breasts", amount: 2, unit: "piece", image: nil),
        RecipeIngredient(id: 153, name: "romaine lettuce", original: "1 head romaine lettuce", amount: 1, unit: "whole", image: nil),
        RecipeIngredient(id: 154, name: "caesar dressing", original: "1/4 cup caesar dressing", amount: 0.25, unit: "cup", image: nil),
        RecipeIngredient(id: 155, name: "croutons", original: "1 cup croutons", amount: 1, unit: "cup", image: nil),
        RecipeIngredient(id: 8, name: "parmesan", original: "1/4 cup parmesan", amount: 0.25, unit: "cup", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 86),
    SpoonacularRecipe(id: 1014, title: "Fried Chicken", image: "https://img.spoonacular.com/recipes/634269-312x231.jpg", readyInMinutes: 45, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 1, name: "chicken", original: "1 whole chicken cut up", amount: 1, unit: "whole", image: nil),
        RecipeIngredient(id: 128, name: "flour", original: "2 cups flour", amount: 2, unit: "cups", image: nil),
        RecipeIngredient(id: 129, name: "buttermilk", original: "2 cups buttermilk", amount: 2, unit: "cups", image: nil),
        RecipeIngredient(id: 144, name: "paprika", original: "1 tbsp paprika", amount: 1, unit: "tbsp", image: nil),
        RecipeIngredient(id: 2, name: "garlic", original: "1 tsp garlic powder", amount: 1, unit: "tsp", image: nil),
        RecipeIngredient(id: 9, name: "oil", original: "oil for frying", amount: 2, unit: "cups", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 89),
    SpoonacularRecipe(id: 1015, title: "Teriyaki Chicken", image: "https://img.spoonacular.com/recipes/633956-312x231.jpg", readyInMinutes: 25, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 1, name: "chicken thighs", original: "600g chicken thighs", amount: 600, unit: "g", image: nil),
        RecipeIngredient(id: 4, name: "soy sauce", original: "4 tbsp soy sauce", amount: 4, unit: "tbsp", image: nil),
        RecipeIngredient(id: 104, name: "honey", original: "2 tbsp honey", amount: 2, unit: "tbsp", image: nil),
        RecipeIngredient(id: 243, name: "mirin", original: "2 tbsp mirin", amount: 2, unit: "tbsp", image: nil),
        RecipeIngredient(id: 127, name: "ginger", original: "1 tsp ginger", amount: 1, unit: "tsp", image: nil),
        RecipeIngredient(id: 2, name: "garlic", original: "2 cloves garlic", amount: 2, unit: "cloves", image: nil),
        RecipeIngredient(id: 9, name: "oil", original: "1 tbsp oil", amount: 1, unit: "tbsp", image: nil)
    ], spoonacularScore: 91),

    // MARK: - Beef
    SpoonacularRecipe(id: 1005, title: "Beef and Rice Bowl", image: "https://img.spoonacular.com/recipes/633942-312x231.jpg", readyInMinutes: 35, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 11, name: "ground beef", original: "500g ground beef", amount: 500, unit: "g", image: nil),
        RecipeIngredient(id: 5, name: "rice", original: "2 cups rice", amount: 2, unit: "cups", image: nil),
        RecipeIngredient(id: 12, name: "beef broth", original: "1 cup beef broth", amount: 1, unit: "cup", image: nil),
        RecipeIngredient(id: 2, name: "garlic", original: "2 cloves garlic", amount: 2, unit: "cloves", image: nil),
        RecipeIngredient(id: 4, name: "soy sauce", original: "2 tablespoons soy sauce", amount: 2, unit: "tablespoons", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 87),
    SpoonacularRecipe(id: 1016, title: "Spaghetti Bolognese", image: "https://img.spoonacular.com/recipes/642585-312x231.jpg", readyInMinutes: 60, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 7, name: "pasta", original: "400g spaghetti", amount: 400, unit: "g", image: nil),
        RecipeIngredient(id: 11, name: "ground beef", original: "500g ground beef", amount: 500, unit: "g", image: nil),
        RecipeIngredient(id: 120, name: "tomato sauce", original: "1 can crushed tomatoes", amount: 1, unit: "can", image: nil),
        RecipeIngredient(id: 108, name: "onion", original: "1 onion diced", amount: 1, unit: "whole", image: nil),
        RecipeIngredient(id: 2, name: "garlic", original: "3 cloves garlic", amount: 3, unit: "cloves", image: nil),
        RecipeIngredient(id: 9, name: "oil", original: "2 tbsp olive oil", amount: 2, unit: "tbsp", image: nil),
        RecipeIngredient(id: 8, name: "parmesan", original: "1/2 cup parmesan", amount: 0.5, unit: "cup", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 92),
    SpoonacularRecipe(id: 1017, title: "Classic Beef Burger", image: "https://img.spoonacular.com/recipes/633942-312x231.jpg", readyInMinutes: 20, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 11, name: "ground beef", original: "600g ground beef", amount: 600, unit: "g", image: nil),
        RecipeIngredient(id: 123, name: "burger buns", original: "4 burger buns", amount: 4, unit: "whole", image: nil),
        RecipeIngredient(id: 112, name: "cheddar", original: "4 slices cheddar", amount: 4, unit: "slices", image: nil),
        RecipeIngredient(id: 124, name: "lettuce", original: "4 lettuce leaves", amount: 4, unit: "whole", image: nil),
        RecipeIngredient(id: 105, name: "tomato", original: "1 tomato sliced", amount: 1, unit: "whole", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil),
        RecipeIngredient(id: 17, name: "black pepper", original: "pepper to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 88),
    SpoonacularRecipe(id: 1018, title: "Beef Stew", image: "https://img.spoonacular.com/recipes/633956-312x231.jpg", readyInMinutes: 90, servings: 6, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 163, name: "beef chuck", original: "2 lbs beef chuck cubed", amount: 2, unit: "lbs", image: nil),
        RecipeIngredient(id: 164, name: "potatoes", original: "3 potatoes cubed", amount: 3, unit: "whole", image: nil),
        RecipeIngredient(id: 15, name: "carrots", original: "3 carrots sliced", amount: 3, unit: "whole", image: nil),
        RecipeIngredient(id: 108, name: "onion", original: "1 onion diced", amount: 1, unit: "whole", image: nil),
        RecipeIngredient(id: 12, name: "beef broth", original: "3 cups beef broth", amount: 3, unit: "cups", image: nil),
        RecipeIngredient(id: 165, name: "tomato paste", original: "2 tbsp tomato paste", amount: 2, unit: "tbsp", image: nil),
        RecipeIngredient(id: 2, name: "garlic", original: "3 cloves garlic", amount: 3, unit: "cloves", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 94),
    SpoonacularRecipe(id: 1019, title: "Beef Tacos", image: "https://img.spoonacular.com/recipes/634269-312x231.jpg", readyInMinutes: 25, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 11, name: "ground beef", original: "500g ground beef", amount: 500, unit: "g", image: nil),
        RecipeIngredient(id: 110, name: "tortillas", original: "8 corn tortillas", amount: 8, unit: "whole", image: nil),
        RecipeIngredient(id: 111, name: "taco seasoning", original: "2 tbsp taco seasoning", amount: 2, unit: "tbsp", image: nil),
        RecipeIngredient(id: 112, name: "cheddar", original: "1 cup shredded cheddar", amount: 1, unit: "cup", image: nil),
        RecipeIngredient(id: 113, name: "salsa", original: "1/2 cup salsa", amount: 0.5, unit: "cup", image: nil),
        RecipeIngredient(id: 114, name: "sour cream", original: "1/4 cup sour cream", amount: 0.25, unit: "cup", image: nil)
    ], spoonacularScore: 89),
    SpoonacularRecipe(id: 1020, title: "Stuffed Bell Peppers", image: "https://img.spoonacular.com/recipes/716426-312x231.jpg", readyInMinutes: 50, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 107, name: "bell peppers", original: "4 bell peppers", amount: 4, unit: "whole", image: nil),
        RecipeIngredient(id: 11, name: "ground beef", original: "400g ground beef", amount: 400, unit: "g", image: nil),
        RecipeIngredient(id: 5, name: "rice", original: "1 cup cooked rice", amount: 1, unit: "cup", image: nil),
        RecipeIngredient(id: 120, name: "tomato sauce", original: "1 cup tomato sauce", amount: 1, unit: "cup", image: nil),
        RecipeIngredient(id: 112, name: "cheddar", original: "1 cup shredded cheddar", amount: 1, unit: "cup", image: nil),
        RecipeIngredient(id: 2, name: "garlic", original: "2 cloves garlic", amount: 2, unit: "cloves", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 91),
    SpoonacularRecipe(id: 1021, title: "Pot Roast", image: "https://img.spoonacular.com/recipes/642585-312x231.jpg", readyInMinutes: 240, servings: 6, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 215, name: "chuck roast", original: "3 lb chuck roast", amount: 3, unit: "lbs", image: nil),
        RecipeIngredient(id: 164, name: "potatoes", original: "4 potatoes quartered", amount: 4, unit: "whole", image: nil),
        RecipeIngredient(id: 15, name: "carrots", original: "4 carrots", amount: 4, unit: "whole", image: nil),
        RecipeIngredient(id: 108, name: "onion", original: "1 onion quartered", amount: 1, unit: "whole", image: nil),
        RecipeIngredient(id: 12, name: "beef broth", original: "2 cups beef broth", amount: 2, unit: "cups", image: nil),
        RecipeIngredient(id: 2, name: "garlic", original: "4 cloves garlic", amount: 4, unit: "cloves", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 93),
    SpoonacularRecipe(id: 1022, title: "Meatloaf", image: "https://img.spoonacular.com/recipes/633942-312x231.jpg", readyInMinutes: 75, servings: 6, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 11, name: "ground beef", original: "2 lbs ground beef", amount: 2, unit: "lbs", image: nil),
        RecipeIngredient(id: 6, name: "eggs", original: "2 eggs", amount: 2, unit: "whole", image: nil),
        RecipeIngredient(id: 209, name: "breadcrumbs", original: "1 cup breadcrumbs", amount: 1, unit: "cup", image: nil),
        RecipeIngredient(id: 108, name: "onion", original: "1 onion diced", amount: 1, unit: "whole", image: nil),
        RecipeIngredient(id: 207, name: "ketchup", original: "1/2 cup ketchup", amount: 0.5, unit: "cup", image: nil),
        RecipeIngredient(id: 189, name: "mustard", original: "1 tbsp mustard", amount: 1, unit: "tbsp", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 86),

    // MARK: - Eggs
    SpoonacularRecipe(id: 1004, title: "Classic Omelette", image: "https://img.spoonacular.com/recipes/642585-312x231.jpg", readyInMinutes: 10, servings: 1, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 6, name: "eggs", original: "3 eggs", amount: 3, unit: "whole", image: nil),
        RecipeIngredient(id: 3, name: "butter", original: "1 tablespoon butter", amount: 1, unit: "tablespoon", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "pinch of salt", amount: 1, unit: "pinch", image: nil),
        RecipeIngredient(id: 17, name: "black pepper", original: "pinch of black pepper", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 89),
    SpoonacularRecipe(id: 1006, title: "Scrambled Eggs with Toast", image: "https://img.spoonacular.com/recipes/660306-312x231.jpg", readyInMinutes: 10, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 6, name: "eggs", original: "4 eggs", amount: 4, unit: "whole", image: nil),
        RecipeIngredient(id: 3, name: "butter", original: "1 tablespoon butter", amount: 1, unit: "tablespoon", image: nil),
        RecipeIngredient(id: 13, name: "bread", original: "2 slices bread", amount: 2, unit: "slices", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil),
        RecipeIngredient(id: 17, name: "black pepper", original: "pepper to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 85),
    SpoonacularRecipe(id: 1023, title: "Shakshuka", image: "https://img.spoonacular.com/recipes/716426-312x231.jpg", readyInMinutes: 25, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 6, name: "eggs", original: "4 eggs", amount: 4, unit: "whole", image: nil),
        RecipeIngredient(id: 120, name: "tomato sauce", original: "1 can crushed tomatoes", amount: 1, unit: "can", image: nil),
        RecipeIngredient(id: 107, name: "bell pepper", original: "1 bell pepper diced", amount: 1, unit: "whole", image: nil),
        RecipeIngredient(id: 108, name: "onion", original: "1 onion diced", amount: 1, unit: "whole", image: nil),
        RecipeIngredient(id: 2, name: "garlic", original: "3 cloves garlic", amount: 3, unit: "cloves", image: nil),
        RecipeIngredient(id: 144, name: "paprika", original: "1 tsp paprika", amount: 1, unit: "tsp", image: nil),
        RecipeIngredient(id: 122, name: "cumin", original: "1 tsp cumin", amount: 1, unit: "tsp", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 92),
    SpoonacularRecipe(id: 1024, title: "Spinach Feta Omelette", image: "https://img.spoonacular.com/recipes/654812-312x231.jpg", readyInMinutes: 10, servings: 1, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 6, name: "eggs", original: "3 eggs", amount: 3, unit: "whole", image: nil),
        RecipeIngredient(id: 101, name: "spinach", original: "1 cup spinach", amount: 1, unit: "cup", image: nil),
        RecipeIngredient(id: 143, name: "feta", original: "1/4 cup feta cheese", amount: 0.25, unit: "cup", image: nil),
        RecipeIngredient(id: 3, name: "butter", original: "1 tbsp butter", amount: 1, unit: "tbsp", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil),
        RecipeIngredient(id: 17, name: "black pepper", original: "pepper to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 88),
    SpoonacularRecipe(id: 1025, title: "Deviled Eggs", image: "https://img.spoonacular.com/recipes/633942-312x231.jpg", readyInMinutes: 20, servings: 6, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 6, name: "eggs", original: "6 hard boiled eggs", amount: 6, unit: "whole", image: nil),
        RecipeIngredient(id: 149, name: "mayo", original: "3 tbsp mayo", amount: 3, unit: "tbsp", image: nil),
        RecipeIngredient(id: 189, name: "mustard", original: "1 tsp dijon mustard", amount: 1, unit: "tsp", image: nil),
        RecipeIngredient(id: 144, name: "paprika", original: "paprika for garnish", amount: 1, unit: "pinch", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 85),

    // MARK: - Pasta
    SpoonacularRecipe(id: 1003, title: "Lemon Garlic Pasta", image: "https://img.spoonacular.com/recipes/654812-312x231.jpg", readyInMinutes: 20, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 7, name: "pasta", original: "200g pasta", amount: 200, unit: "g", image: nil),
        RecipeIngredient(id: 2, name: "garlic", original: "3 cloves garlic", amount: 3, unit: "cloves", image: nil),
        RecipeIngredient(id: 9, name: "oil", original: "3 tablespoons olive oil", amount: 3, unit: "tablespoons", image: nil),
        RecipeIngredient(id: 8, name: "parmesan", original: "50g parmesan", amount: 50, unit: "g", image: nil),
        RecipeIngredient(id: 16, name: "lemon", original: "zest and juice of 1 lemon", amount: 1, unit: "whole", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 91),
    SpoonacularRecipe(id: 1026, title: "Cacio e Pepe", image: "https://img.spoonacular.com/recipes/716426-312x231.jpg", readyInMinutes: 20, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 7, name: "pasta", original: "200g spaghetti", amount: 200, unit: "g", image: nil),
        RecipeIngredient(id: 8, name: "parmesan", original: "1 cup pecorino romano", amount: 1, unit: "cup", image: nil),
        RecipeIngredient(id: 17, name: "black pepper", original: "2 tsp coarsely ground black pepper", amount: 2, unit: "tsp", image: nil),
        RecipeIngredient(id: 3, name: "butter", original: "2 tbsp butter", amount: 2, unit: "tbsp", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt for pasta water", amount: 1, unit: "tbsp", image: nil)
    ], spoonacularScore: 93),
    SpoonacularRecipe(id: 1027, title: "Carbonara", image: "https://img.spoonacular.com/recipes/642585-312x231.jpg", readyInMinutes: 25, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 7, name: "pasta", original: "200g spaghetti", amount: 200, unit: "g", image: nil),
        RecipeIngredient(id: 225, name: "pancetta", original: "100g pancetta", amount: 100, unit: "g", image: nil),
        RecipeIngredient(id: 6, name: "eggs", original: "3 egg yolks", amount: 3, unit: "whole", image: nil),
        RecipeIngredient(id: 8, name: "parmesan", original: "1/2 cup pecorino romano", amount: 0.5, unit: "cup", image: nil),
        RecipeIngredient(id: 17, name: "black pepper", original: "lots of black pepper", amount: 2, unit: "tsp", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt for pasta water", amount: 1, unit: "tbsp", image: nil)
    ], spoonacularScore: 94),
    SpoonacularRecipe(id: 1028, title: "Pesto Pasta", image: "https://img.spoonacular.com/recipes/633942-312x231.jpg", readyInMinutes: 20, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 7, name: "pasta", original: "400g pasta", amount: 400, unit: "g", image: nil),
        RecipeIngredient(id: 217, name: "pesto", original: "1/2 cup basil pesto", amount: 0.5, unit: "cup", image: nil),
        RecipeIngredient(id: 8, name: "parmesan", original: "1/4 cup parmesan", amount: 0.25, unit: "cup", image: nil),
        RecipeIngredient(id: 105, name: "cherry tomatoes", original: "1 cup cherry tomatoes", amount: 1, unit: "cup", image: nil),
        RecipeIngredient(id: 9, name: "oil", original: "2 tbsp olive oil", amount: 2, unit: "tbsp", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 90),
    SpoonacularRecipe(id: 1029, title: "Lasagna", image: "https://img.spoonacular.com/recipes/716426-312x231.jpg", readyInMinutes: 90, servings: 8, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 223, name: "lasagna noodles", original: "12 lasagna noodles", amount: 12, unit: "whole", image: nil),
        RecipeIngredient(id: 11, name: "ground beef", original: "1 lb ground beef", amount: 1, unit: "lbs", image: nil),
        RecipeIngredient(id: 120, name: "tomato sauce", original: "2 cans tomato sauce", amount: 2, unit: "can", image: nil),
        RecipeIngredient(id: 224, name: "ricotta", original: "2 cups ricotta cheese", amount: 2, unit: "cups", image: nil),
        RecipeIngredient(id: 151, name: "mozzarella", original: "2 cups shredded mozzarella", amount: 2, unit: "cups", image: nil),
        RecipeIngredient(id: 8, name: "parmesan", original: "1/2 cup parmesan", amount: 0.5, unit: "cup", image: nil),
        RecipeIngredient(id: 6, name: "eggs", original: "1 egg", amount: 1, unit: "whole", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 95),

    // MARK: - Rice
    SpoonacularRecipe(id: 1007, title: "Garlic Rice", image: "https://img.spoonacular.com/recipes/644826-312x231.jpg", readyInMinutes: 20, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 5, name: "rice", original: "2 cups long grain rice", amount: 2, unit: "cups", image: nil),
        RecipeIngredient(id: 2, name: "garlic", original: "6 cloves garlic minced", amount: 6, unit: "cloves", image: nil),
        RecipeIngredient(id: 9, name: "oil", original: "2 tablespoons olive oil", amount: 2, unit: "tablespoons", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "1 teaspoon salt", amount: 1, unit: "teaspoon", image: nil),
        RecipeIngredient(id: 18, name: "water", original: "4 cups water", amount: 4, unit: "cups", image: nil)
    ], spoonacularScore: 86),
    SpoonacularRecipe(id: 1030, title: "Mushroom Risotto", image: "https://img.spoonacular.com/recipes/644826-312x231.jpg", readyInMinutes: 45, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 115, name: "arborio rice", original: "1.5 cups arborio rice", amount: 1.5, unit: "cups", image: nil),
        RecipeIngredient(id: 116, name: "mushrooms", original: "300g mushrooms", amount: 300, unit: "g", image: nil),
        RecipeIngredient(id: 117, name: "white wine", original: "1/2 cup white wine", amount: 0.5, unit: "cup", image: nil),
        RecipeIngredient(id: 14, name: "chicken broth", original: "4 cups chicken broth", amount: 4, unit: "cups", image: nil),
        RecipeIngredient(id: 8, name: "parmesan", original: "1/2 cup parmesan", amount: 0.5, unit: "cup", image: nil),
        RecipeIngredient(id: 3, name: "butter", original: "2 tbsp butter", amount: 2, unit: "tbsp", image: nil),
        RecipeIngredient(id: 2, name: "garlic", original: "2 cloves garlic", amount: 2, unit: "cloves", image: nil)
    ], spoonacularScore: 93),

    // MARK: - Salmon & Seafood
    SpoonacularRecipe(id: 1031, title: "Honey Garlic Salmon", image: "https://img.spoonacular.com/recipes/654812-312x231.jpg", readyInMinutes: 20, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 103, name: "salmon", original: "2 salmon fillets", amount: 2, unit: "piece", image: nil),
        RecipeIngredient(id: 104, name: "honey", original: "3 tbsp honey", amount: 3, unit: "tbsp", image: nil),
        RecipeIngredient(id: 2, name: "garlic", original: "4 cloves garlic", amount: 4, unit: "cloves", image: nil),
        RecipeIngredient(id: 4, name: "soy sauce", original: "2 tbsp soy sauce", amount: 2, unit: "tbsp", image: nil),
        RecipeIngredient(id: 3, name: "butter", original: "1 tbsp butter", amount: 1, unit: "tbsp", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 92),
    SpoonacularRecipe(id: 1032, title: "Salmon with Asparagus", image: "https://img.spoonacular.com/recipes/660306-312x231.jpg", readyInMinutes: 25, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 103, name: "salmon", original: "2 salmon fillets", amount: 2, unit: "piece", image: nil),
        RecipeIngredient(id: 169, name: "asparagus", original: "1 bunch asparagus", amount: 1, unit: "bunch", image: nil),
        RecipeIngredient(id: 16, name: "lemon", original: "1 lemon", amount: 1, unit: "whole", image: nil),
        RecipeIngredient(id: 2, name: "garlic", original: "2 cloves garlic", amount: 2, unit: "cloves", image: nil),
        RecipeIngredient(id: 9, name: "oil", original: "2 tbsp olive oil", amount: 2, unit: "tbsp", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 90),
    SpoonacularRecipe(id: 1033, title: "Shrimp Stir Fry", image: "https://img.spoonacular.com/recipes/633942-312x231.jpg", readyInMinutes: 20, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 125, name: "shrimp", original: "300g shrimp", amount: 300, unit: "g", image: nil),
        RecipeIngredient(id: 107, name: "bell pepper", original: "2 bell peppers", amount: 2, unit: "whole", image: nil),
        RecipeIngredient(id: 126, name: "broccoli", original: "1 cup broccoli", amount: 1, unit: "cup", image: nil),
        RecipeIngredient(id: 4, name: "soy sauce", original: "3 tbsp soy sauce", amount: 3, unit: "tbsp", image: nil),
        RecipeIngredient(id: 2, name: "garlic", original: "3 cloves garlic", amount: 3, unit: "cloves", image: nil),
        RecipeIngredient(id: 127, name: "ginger", original: "1 tsp fresh ginger", amount: 1, unit: "tsp", image: nil),
        RecipeIngredient(id: 9, name: "oil", original: "2 tbsp oil", amount: 2, unit: "tbsp", image: nil)
    ], spoonacularScore: 88),
    SpoonacularRecipe(id: 1034, title: "Shrimp Tacos", image: "https://img.spoonacular.com/recipes/632660-312x231.jpg", readyInMinutes: 20, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 125, name: "shrimp", original: "400g shrimp", amount: 400, unit: "g", image: nil),
        RecipeIngredient(id: 110, name: "tortillas", original: "8 corn tortillas", amount: 8, unit: "whole", image: nil),
        RecipeIngredient(id: 170, name: "coleslaw", original: "1 cup coleslaw mix", amount: 1, unit: "cup", image: nil),
        RecipeIngredient(id: 111, name: "taco seasoning", original: "1 tbsp taco seasoning", amount: 1, unit: "tbsp", image: nil),
        RecipeIngredient(id: 16, name: "lime", original: "2 limes", amount: 2, unit: "whole", image: nil),
        RecipeIngredient(id: 9, name: "oil", original: "1 tbsp oil", amount: 1, unit: "tbsp", image: nil)
    ], spoonacularScore: 87),

    // MARK: - Pork
    SpoonacularRecipe(id: 1035, title: "Pork Tenderloin with Roasted Vegetables", image: "https://img.spoonacular.com/recipes/633942-312x231.jpg", readyInMinutes: 50, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 168, name: "pork tenderloin", original: "1.5 lb pork tenderloin", amount: 1.5, unit: "lbs", image: nil),
        RecipeIngredient(id: 164, name: "potatoes", original: "3 potatoes cubed", amount: 3, unit: "whole", image: nil),
        RecipeIngredient(id: 126, name: "broccoli", original: "2 cups broccoli", amount: 2, unit: "cups", image: nil),
        RecipeIngredient(id: 107, name: "bell pepper", original: "2 bell peppers", amount: 2, unit: "whole", image: nil),
        RecipeIngredient(id: 2, name: "garlic", original: "3 cloves garlic", amount: 3, unit: "cloves", image: nil),
        RecipeIngredient(id: 9, name: "oil", original: "3 tbsp olive oil", amount: 3, unit: "tbsp", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 90),
    SpoonacularRecipe(id: 1036, title: "Pulled Pork", image: "https://img.spoonacular.com/recipes/660306-312x231.jpg", readyInMinutes: 240, servings: 8, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 212, name: "pork shoulder", original: "4 lbs pork shoulder", amount: 4, unit: "lbs", image: nil),
        RecipeIngredient(id: 207, name: "bbq sauce", original: "1 cup BBQ sauce", amount: 1, unit: "cup", image: nil),
        RecipeIngredient(id: 194, name: "brown sugar", original: "2 tbsp brown sugar", amount: 2, unit: "tbsp", image: nil),
        RecipeIngredient(id: 144, name: "paprika", original: "1 tbsp paprika", amount: 1, unit: "tbsp", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 91),
    SpoonacularRecipe(id: 1037, title: "BBQ Ribs", image: "https://img.spoonacular.com/recipes/633956-312x231.jpg", readyInMinutes: 180, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 206, name: "pork ribs", original: "2 racks pork ribs", amount: 2, unit: "racks", image: nil),
        RecipeIngredient(id: 207, name: "bbq sauce", original: "1 cup BBQ sauce", amount: 1, unit: "cup", image: nil),
        RecipeIngredient(id: 194, name: "brown sugar", original: "2 tbsp brown sugar", amount: 2, unit: "tbsp", image: nil),
        RecipeIngredient(id: 144, name: "paprika", original: "2 tsp paprika", amount: 2, unit: "tsp", image: nil),
        RecipeIngredient(id: 2, name: "garlic", original: "1 tsp garlic powder", amount: 1, unit: "tsp", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 92),

    // MARK: - Soups
    SpoonacularRecipe(id: 1038, title: "Classic Chicken Noodle Soup", image: "https://img.spoonacular.com/recipes/633956-312x231.jpg", readyInMinutes: 45, servings: 6, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 1, name: "chicken breast", original: "2 chicken breasts", amount: 2, unit: "piece", image: nil),
        RecipeIngredient(id: 174, name: "egg noodles", original: "2 cups egg noodles", amount: 2, unit: "cups", image: nil),
        RecipeIngredient(id: 15, name: "carrots", original: "3 carrots sliced", amount: 3, unit: "whole", image: nil),
        RecipeIngredient(id: 159, name: "celery", original: "3 stalks celery", amount: 3, unit: "stalks", image: nil),
        RecipeIngredient(id: 108, name: "onion", original: "1 onion diced", amount: 1, unit: "whole", image: nil),
        RecipeIngredient(id: 14, name: "chicken broth", original: "6 cups chicken broth", amount: 6, unit: "cups", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 94),
    SpoonacularRecipe(id: 1039, title: "Tomato Basil Soup", image: "https://img.spoonacular.com/recipes/654812-312x231.jpg", readyInMinutes: 30, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 120, name: "crushed tomatoes", original: "2 cans crushed tomatoes", amount: 2, unit: "can", image: nil),
        RecipeIngredient(id: 108, name: "onion", original: "1 onion diced", amount: 1, unit: "whole", image: nil),
        RecipeIngredient(id: 2, name: "garlic", original: "4 cloves garlic", amount: 4, unit: "cloves", image: nil),
        RecipeIngredient(id: 106, name: "basil", original: "1/4 cup fresh basil", amount: 0.25, unit: "cup", image: nil),
        RecipeIngredient(id: 102, name: "heavy cream", original: "1/4 cup heavy cream", amount: 0.25, unit: "cup", image: nil),
        RecipeIngredient(id: 9, name: "oil", original: "2 tbsp olive oil", amount: 2, unit: "tbsp", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 91),
    SpoonacularRecipe(id: 1040, title: "Broccoli Cheddar Soup", image: "https://img.spoonacular.com/recipes/632660-312x231.jpg", readyInMinutes: 35, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 126, name: "broccoli", original: "4 cups broccoli florets", amount: 4, unit: "cups", image: nil),
        RecipeIngredient(id: 112, name: "cheddar", original: "2 cups shredded cheddar", amount: 2, unit: "cups", image: nil),
        RecipeIngredient(id: 162, name: "vegetable broth", original: "2 cups vegetable broth", amount: 2, unit: "cups", image: nil),
        RecipeIngredient(id: 102, name: "heavy cream", original: "1 cup heavy cream", amount: 1, unit: "cup", image: nil),
        RecipeIngredient(id: 108, name: "onion", original: "1 onion diced", amount: 1, unit: "whole", image: nil),
        RecipeIngredient(id: 3, name: "butter", original: "2 tbsp butter", amount: 2, unit: "tbsp", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 90),
    SpoonacularRecipe(id: 1041, title: "Lentil Soup", image: "https://img.spoonacular.com/recipes/644826-312x231.jpg", readyInMinutes: 40, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 161, name: "lentils", original: "1.5 cups red lentils", amount: 1.5, unit: "cups", image: nil),
        RecipeIngredient(id: 108, name: "onion", original: "1 onion diced", amount: 1, unit: "whole", image: nil),
        RecipeIngredient(id: 15, name: "carrots", original: "2 carrots diced", amount: 2, unit: "whole", image: nil),
        RecipeIngredient(id: 2, name: "garlic", original: "3 cloves garlic", amount: 3, unit: "cloves", image: nil),
        RecipeIngredient(id: 122, name: "cumin", original: "2 tsp cumin", amount: 2, unit: "tsp", image: nil),
        RecipeIngredient(id: 162, name: "vegetable broth", original: "4 cups vegetable broth", amount: 4, unit: "cups", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 89),
    SpoonacularRecipe(id: 1042, title: "Spicy Black Bean Soup", image: "https://img.spoonacular.com/recipes/644826-312x231.jpg", readyInMinutes: 35, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 160, name: "black beans", original: "2 cans black beans", amount: 2, unit: "can", image: nil),
        RecipeIngredient(id: 162, name: "vegetable broth", original: "2 cups vegetable broth", amount: 2, unit: "cups", image: nil),
        RecipeIngredient(id: 108, name: "onion", original: "1 onion diced", amount: 1, unit: "whole", image: nil),
        RecipeIngredient(id: 2, name: "garlic", original: "3 cloves garlic", amount: 3, unit: "cloves", image: nil),
        RecipeIngredient(id: 122, name: "cumin", original: "2 tsp cumin", amount: 2, unit: "tsp", image: nil),
        RecipeIngredient(id: 119, name: "red pepper flakes", original: "1 tsp red pepper flakes", amount: 1, unit: "tsp", image: nil),
        RecipeIngredient(id: 16, name: "lime", original: "1 lime", amount: 1, unit: "whole", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 88),

    // MARK: - Vegetarian
    SpoonacularRecipe(id: 1043, title: "Margherita Pizza", image: "https://img.spoonacular.com/recipes/660306-312x231.jpg", readyInMinutes: 30, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 219, name: "pizza dough", original: "1 ball pizza dough", amount: 1, unit: "whole", image: nil),
        RecipeIngredient(id: 120, name: "tomato sauce", original: "1/2 cup tomato sauce", amount: 0.5, unit: "cup", image: nil),
        RecipeIngredient(id: 151, name: "fresh mozzarella", original: "8 oz fresh mozzarella", amount: 8, unit: "oz", image: nil),
        RecipeIngredient(id: 106, name: "basil", original: "fresh basil leaves", amount: 1, unit: "bunch", image: nil),
        RecipeIngredient(id: 9, name: "oil", original: "2 tbsp olive oil", amount: 2, unit: "tbsp", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 91),
    SpoonacularRecipe(id: 1044, title: "Eggplant Parmesan", image: "https://img.spoonacular.com/recipes/633956-312x231.jpg", readyInMinutes: 60, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 171, name: "eggplant", original: "2 large eggplants", amount: 2, unit: "whole", image: nil),
        RecipeIngredient(id: 120, name: "tomato sauce", original: "2 cups tomato sauce", amount: 2, unit: "cups", image: nil),
        RecipeIngredient(id: 151, name: "mozzarella", original: "2 cups shredded mozzarella", amount: 2, unit: "cups", image: nil),
        RecipeIngredient(id: 8, name: "parmesan", original: "1/2 cup parmesan", amount: 0.5, unit: "cup", image: nil),
        RecipeIngredient(id: 128, name: "flour", original: "1 cup flour", amount: 1, unit: "cup", image: nil),
        RecipeIngredient(id: 6, name: "eggs", original: "2 eggs beaten", amount: 2, unit: "whole", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 89),
    SpoonacularRecipe(id: 1045, title: "Black Bean Quesadilla", image: "https://img.spoonacular.com/recipes/632660-312x231.jpg", readyInMinutes: 15, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 110, name: "tortillas", original: "4 flour tortillas", amount: 4, unit: "whole", image: nil),
        RecipeIngredient(id: 160, name: "black beans", original: "1 can black beans", amount: 1, unit: "can", image: nil),
        RecipeIngredient(id: 112, name: "cheddar", original: "1 cup shredded cheddar", amount: 1, unit: "cup", image: nil),
        RecipeIngredient(id: 107, name: "bell pepper", original: "1 bell pepper diced", amount: 1, unit: "whole", image: nil),
        RecipeIngredient(id: 113, name: "salsa", original: "1/4 cup salsa", amount: 0.25, unit: "cup", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 86),
    SpoonacularRecipe(id: 1046, title: "Avocado Toast", image: "https://img.spoonacular.com/recipes/660306-312x231.jpg", readyInMinutes: 10, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 118, name: "avocado", original: "2 ripe avocados", amount: 2, unit: "whole", image: nil),
        RecipeIngredient(id: 13, name: "bread", original: "4 slices sourdough bread", amount: 4, unit: "slices", image: nil),
        RecipeIngredient(id: 16, name: "lemon", original: "juice of 1 lemon", amount: 1, unit: "whole", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil),
        RecipeIngredient(id: 17, name: "black pepper", original: "pepper to taste", amount: 1, unit: "pinch", image: nil),
        RecipeIngredient(id: 119, name: "red pepper flakes", original: "pinch red pepper flakes", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 85),
    SpoonacularRecipe(id: 1047, title: "Grilled Cheese Sandwich", image: "https://img.spoonacular.com/recipes/633942-312x231.jpg", readyInMinutes: 10, servings: 1, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 13, name: "bread", original: "2 slices bread", amount: 2, unit: "slices", image: nil),
        RecipeIngredient(id: 112, name: "cheddar", original: "2 slices cheddar", amount: 2, unit: "slices", image: nil),
        RecipeIngredient(id: 151, name: "mozzarella", original: "2 slices mozzarella", amount: 2, unit: "slices", image: nil),
        RecipeIngredient(id: 3, name: "butter", original: "2 tbsp butter", amount: 2, unit: "tbsp", image: nil)
    ], spoonacularScore: 85),
    SpoonacularRecipe(id: 1048, title: "Quinoa Power Bowl", image: "https://img.spoonacular.com/recipes/716426-312x231.jpg", readyInMinutes: 25, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 156, name: "quinoa", original: "1 cup quinoa", amount: 1, unit: "cup", image: nil),
        RecipeIngredient(id: 157, name: "chickpeas", original: "1 can chickpeas", amount: 1, unit: "can", image: nil),
        RecipeIngredient(id: 118, name: "avocado", original: "1 avocado", amount: 1, unit: "whole", image: nil),
        RecipeIngredient(id: 101, name: "spinach", original: "2 cups spinach", amount: 2, unit: "cups", image: nil),
        RecipeIngredient(id: 105, name: "cherry tomatoes", original: "1 cup cherry tomatoes", amount: 1, unit: "cup", image: nil),
        RecipeIngredient(id: 16, name: "lemon", original: "juice of 1 lemon", amount: 1, unit: "whole", image: nil),
        RecipeIngredient(id: 9, name: "oil", original: "2 tbsp olive oil", amount: 2, unit: "tbsp", image: nil)
    ], spoonacularScore: 90),

    // MARK: - Breakfast
    SpoonacularRecipe(id: 1049, title: "Fluffy Pancakes", image: "https://img.spoonacular.com/recipes/660306-312x231.jpg", readyInMinutes: 20, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 128, name: "flour", original: "2 cups flour", amount: 2, unit: "cups", image: nil),
        RecipeIngredient(id: 141, name: "milk", original: "1.5 cups milk", amount: 1.5, unit: "cups", image: nil),
        RecipeIngredient(id: 6, name: "eggs", original: "2 eggs", amount: 2, unit: "whole", image: nil),
        RecipeIngredient(id: 3, name: "butter", original: "3 tbsp butter", amount: 3, unit: "tbsp", image: nil),
        RecipeIngredient(id: 130, name: "sugar", original: "2 tbsp sugar", amount: 2, unit: "tbsp", image: nil),
        RecipeIngredient(id: 131, name: "baking powder", original: "2 tsp baking powder", amount: 2, unit: "tsp", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "1/2 tsp salt", amount: 0.5, unit: "tsp", image: nil)
    ], spoonacularScore: 88),
    SpoonacularRecipe(id: 1050, title: "French Toast", image: "https://img.spoonacular.com/recipes/634269-312x231.jpg", readyInMinutes: 15, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 13, name: "bread", original: "4 thick slices bread", amount: 4, unit: "slices", image: nil),
        RecipeIngredient(id: 6, name: "eggs", original: "2 eggs", amount: 2, unit: "whole", image: nil),
        RecipeIngredient(id: 141, name: "milk", original: "1/4 cup milk", amount: 0.25, unit: "cup", image: nil),
        RecipeIngredient(id: 142, name: "cinnamon", original: "1 tsp cinnamon", amount: 1, unit: "tsp", image: nil),
        RecipeIngredient(id: 3, name: "butter", original: "1 tbsp butter", amount: 1, unit: "tbsp", image: nil),
        RecipeIngredient(id: 130, name: "sugar", original: "1 tbsp sugar", amount: 1, unit: "tbsp", image: nil)
    ], spoonacularScore: 87),

    // MARK: - Mexican
    SpoonacularRecipe(id: 1051, title: "Sheet Pan Fajitas", image: "https://img.spoonacular.com/recipes/633942-312x231.jpg", readyInMinutes: 35, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 1, name: "chicken breast", original: "500g chicken breast", amount: 500, unit: "g", image: nil),
        RecipeIngredient(id: 107, name: "bell pepper", original: "3 bell peppers", amount: 3, unit: "whole", image: nil),
        RecipeIngredient(id: 108, name: "onion", original: "1 onion", amount: 1, unit: "whole", image: nil),
        RecipeIngredient(id: 109, name: "fajita seasoning", original: "2 tbsp fajita seasoning", amount: 2, unit: "tbsp", image: nil),
        RecipeIngredient(id: 9, name: "oil", original: "2 tbsp olive oil", amount: 2, unit: "tbsp", image: nil),
        RecipeIngredient(id: 110, name: "tortillas", original: "8 flour tortillas", amount: 8, unit: "whole", image: nil)
    ], spoonacularScore: 90),
    SpoonacularRecipe(id: 1052, title: "Chicken Enchiladas", image: "https://img.spoonacular.com/recipes/633956-312x231.jpg", readyInMinutes: 45, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 1, name: "chicken breast", original: "2 chicken breasts shredded", amount: 2, unit: "piece", image: nil),
        RecipeIngredient(id: 110, name: "tortillas", original: "8 corn tortillas", amount: 8, unit: "whole", image: nil),
        RecipeIngredient(id: 226, name: "enchilada sauce", original: "2 cups enchilada sauce", amount: 2, unit: "cups", image: nil),
        RecipeIngredient(id: 112, name: "cheddar", original: "1.5 cups shredded cheddar", amount: 1.5, unit: "cups", image: nil),
        RecipeIngredient(id: 108, name: "onion", original: "1 onion diced", amount: 1, unit: "whole", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 91),

    // MARK: - Asian
    SpoonacularRecipe(id: 1053, title: "Pad Thai", image: "https://img.spoonacular.com/recipes/716426-312x231.jpg", readyInMinutes: 25, servings: 2, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 179, name: "rice noodles", original: "200g rice noodles", amount: 200, unit: "g", image: nil),
        RecipeIngredient(id: 125, name: "shrimp", original: "200g shrimp", amount: 200, unit: "g", image: nil),
        RecipeIngredient(id: 6, name: "eggs", original: "2 eggs", amount: 2, unit: "whole", image: nil),
        RecipeIngredient(id: 235, name: "pad thai sauce", original: "3 tbsp pad thai sauce", amount: 3, unit: "tbsp", image: nil),
        RecipeIngredient(id: 181, name: "bean sprouts", original: "1 cup bean sprouts", amount: 1, unit: "cup", image: nil),
        RecipeIngredient(id: 236, name: "peanuts", original: "1/4 cup crushed peanuts", amount: 0.25, unit: "cup", image: nil),
        RecipeIngredient(id: 9, name: "oil", original: "2 tbsp oil", amount: 2, unit: "tbsp", image: nil)
    ], spoonacularScore: 92),
    SpoonacularRecipe(id: 1054, title: "Thai Green Curry", image: "https://img.spoonacular.com/recipes/716426-312x231.jpg", readyInMinutes: 30, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 1, name: "chicken breast", original: "600g chicken breast", amount: 600, unit: "g", image: nil),
        RecipeIngredient(id: 205, name: "coconut milk", original: "1 can coconut milk", amount: 1, unit: "can", image: nil),
        RecipeIngredient(id: 248, name: "green curry paste", original: "2 tbsp green curry paste", amount: 2, unit: "tbsp", image: nil),
        RecipeIngredient(id: 126, name: "broccoli", original: "1 cup broccoli", amount: 1, unit: "cup", image: nil),
        RecipeIngredient(id: 107, name: "bell pepper", original: "1 bell pepper", amount: 1, unit: "whole", image: nil),
        RecipeIngredient(id: 4, name: "fish sauce", original: "1 tbsp fish sauce", amount: 1, unit: "tbsp", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 93),

    // MARK: - Indian
    SpoonacularRecipe(id: 1055, title: "Butter Chicken", image: "https://img.spoonacular.com/recipes/633956-312x231.jpg", readyInMinutes: 45, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 1, name: "chicken breast", original: "600g chicken breast", amount: 600, unit: "g", image: nil),
        RecipeIngredient(id: 120, name: "tomato sauce", original: "1 can tomato sauce", amount: 1, unit: "can", image: nil),
        RecipeIngredient(id: 102, name: "heavy cream", original: "1/2 cup heavy cream", amount: 0.5, unit: "cup", image: nil),
        RecipeIngredient(id: 3, name: "butter", original: "2 tbsp butter", amount: 2, unit: "tbsp", image: nil),
        RecipeIngredient(id: 2, name: "garlic", original: "4 cloves garlic", amount: 4, unit: "cloves", image: nil),
        RecipeIngredient(id: 121, name: "garam masala", original: "2 tsp garam masala", amount: 2, unit: "tsp", image: nil),
        RecipeIngredient(id: 122, name: "cumin", original: "1 tsp cumin", amount: 1, unit: "tsp", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 95),
    SpoonacularRecipe(id: 1056, title: "Chana Masala", image: "https://img.spoonacular.com/recipes/642585-312x231.jpg", readyInMinutes: 35, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 157, name: "chickpeas", original: "2 cans chickpeas", amount: 2, unit: "can", image: nil),
        RecipeIngredient(id: 120, name: "crushed tomatoes", original: "1 can crushed tomatoes", amount: 1, unit: "can", image: nil),
        RecipeIngredient(id: 108, name: "onion", original: "1 large onion", amount: 1, unit: "whole", image: nil),
        RecipeIngredient(id: 2, name: "garlic", original: "4 cloves garlic", amount: 4, unit: "cloves", image: nil),
        RecipeIngredient(id: 127, name: "ginger", original: "1 tbsp fresh ginger", amount: 1, unit: "tbsp", image: nil),
        RecipeIngredient(id: 121, name: "garam masala", original: "2 tsp garam masala", amount: 2, unit: "tsp", image: nil),
        RecipeIngredient(id: 9, name: "oil", original: "2 tbsp oil", amount: 2, unit: "tbsp", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 91),
    SpoonacularRecipe(id: 1057, title: "Saag Paneer", image: "https://img.spoonacular.com/recipes/642585-312x231.jpg", readyInMinutes: 40, servings: 4, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 258, name: "paneer", original: "250g paneer cubed", amount: 250, unit: "g", image: nil),
        RecipeIngredient(id: 101, name: "spinach", original: "500g fresh spinach", amount: 500, unit: "g", image: nil),
        RecipeIngredient(id: 102, name: "heavy cream", original: "1/4 cup heavy cream", amount: 0.25, unit: "cup", image: nil),
        RecipeIngredient(id: 2, name: "garlic", original: "3 cloves garlic", amount: 3, unit: "cloves", image: nil),
        RecipeIngredient(id: 127, name: "ginger", original: "1 tbsp fresh ginger", amount: 1, unit: "tbsp", image: nil),
        RecipeIngredient(id: 121, name: "garam masala", original: "1 tsp garam masala", amount: 1, unit: "tsp", image: nil),
        RecipeIngredient(id: 9, name: "oil", original: "2 tbsp oil", amount: 2, unit: "tbsp", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch", image: nil)
    ], spoonacularScore: 90),

    // MARK: - Desserts
    SpoonacularRecipe(id: 1058, title: "Banana Bread", image: "https://img.spoonacular.com/recipes/716426-312x231.jpg", readyInMinutes: 65, servings: 8, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 132, name: "bananas", original: "3 ripe bananas mashed", amount: 3, unit: "whole", image: nil),
        RecipeIngredient(id: 128, name: "flour", original: "1.5 cups flour", amount: 1.5, unit: "cups", image: nil),
        RecipeIngredient(id: 130, name: "sugar", original: "3/4 cup sugar", amount: 0.75, unit: "cup", image: nil),
        RecipeIngredient(id: 3, name: "butter", original: "1/3 cup butter melted", amount: 0.33, unit: "cup", image: nil),
        RecipeIngredient(id: 6, name: "eggs", original: "1 egg", amount: 1, unit: "whole", image: nil),
        RecipeIngredient(id: 195, name: "vanilla extract", original: "1 tsp vanilla extract", amount: 1, unit: "tsp", image: nil),
        RecipeIngredient(id: 232, name: "baking soda", original: "1 tsp baking soda", amount: 1, unit: "tsp", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "1/4 tsp salt", amount: 0.25, unit: "tsp", image: nil)
    ], spoonacularScore: 92),
    SpoonacularRecipe(id: 1059, title: "Chocolate Chip Cookies", image: "https://img.spoonacular.com/recipes/633956-312x231.jpg", readyInMinutes: 30, servings: 24, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
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
    SpoonacularRecipe(id: 1060, title: "Brownies", image: "https://img.spoonacular.com/recipes/633942-312x231.jpg", readyInMinutes: 40, servings: 16, usedIngredientCount: 0, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [
        RecipeIngredient(id: 197, name: "dark chocolate", original: "200g dark chocolate", amount: 200, unit: "g", image: nil),
        RecipeIngredient(id: 3, name: "butter", original: "1/2 cup butter", amount: 0.5, unit: "cup", image: nil),
        RecipeIngredient(id: 130, name: "sugar", original: "1 cup sugar", amount: 1, unit: "cup", image: nil),
        RecipeIngredient(id: 6, name: "eggs", original: "3 eggs", amount: 3, unit: "whole", image: nil),
        RecipeIngredient(id: 128, name: "flour", original: "3/4 cup flour", amount: 0.75, unit: "cup", image: nil),
        RecipeIngredient(id: 198, name: "cocoa powder", original: "1/4 cup cocoa powder", amount: 0.25, unit: "cup", image: nil),
        RecipeIngredient(id: 10, name: "salt", original: "1/4 tsp salt", amount: 0.25, unit: "tsp", image: nil)
    ], spoonacularScore: 93)
]

let mockRecipeDetails: [Int: RecipeDetail] = [
    1001: RecipeDetail(
        id: 1001, title: "Garlic Butter Chicken",
        image: "https://img.spoonacular.com/recipes/632660-556x370.jpg",
        readyInMinutes: 30, servings: 4,
        extendedIngredients: [
            ExtendedIngredient(id: 1, name: "chicken breast", original: "2 chicken breasts", amount: 2, unit: "piece"),
            ExtendedIngredient(id: 2, name: "garlic", original: "4 cloves garlic, minced", amount: 4, unit: "cloves"),
            ExtendedIngredient(id: 3, name: "butter", original: "2 tablespoons butter", amount: 2, unit: "tablespoons"),
            ExtendedIngredient(id: 16, name: "lemon", original: "juice of 1 lemon", amount: 1, unit: "whole"),
            ExtendedIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch"),
            ExtendedIngredient(id: 17, name: "black pepper", original: "black pepper to taste", amount: 1, unit: "pinch")
        ],
        aggregateLikes: 245, spoonacularScore: 92,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Season chicken breasts on both sides with salt and black pepper."),
            InstructionStep(number: 2, step: "Heat butter in a large skillet over medium-high heat until melted and foamy."),
            InstructionStep(number: 3, step: "Add chicken breasts and cook for 6–7 minutes per side until golden brown and cooked through to 165°F."),
            InstructionStep(number: 4, step: "Add minced garlic to the pan and cook for 1–2 minutes, stirring constantly until fragrant."),
            InstructionStep(number: 5, step: "Squeeze lemon juice over the chicken and spoon the pan juices over top to baste."),
            InstructionStep(number: 6, step: "Remove from heat, let rest 5 minutes, then serve with pan sauce drizzled over top.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 320, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 42, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 4, unit: "g"),
            NutrientInfo(name: "Fat", amount: 14, unit: "g")
        ])
    ),
    1002: RecipeDetail(
        id: 1002, title: "Chicken Fried Rice",
        image: "https://img.spoonacular.com/recipes/634269-556x370.jpg",
        readyInMinutes: 25, servings: 4,
        extendedIngredients: [
            ExtendedIngredient(id: 1, name: "chicken breast", original: "1 chicken breast, diced", amount: 1, unit: "piece"),
            ExtendedIngredient(id: 5, name: "rice", original: "2 cups cooked rice (day-old preferred)", amount: 2, unit: "cups"),
            ExtendedIngredient(id: 6, name: "eggs", original: "2 eggs, beaten", amount: 2, unit: "whole"),
            ExtendedIngredient(id: 4, name: "soy sauce", original: "2 tablespoons soy sauce", amount: 2, unit: "tablespoons"),
            ExtendedIngredient(id: 2, name: "garlic", original: "2 cloves garlic, minced", amount: 2, unit: "cloves"),
            ExtendedIngredient(id: 9, name: "oil", original: "1 tablespoon oil", amount: 1, unit: "tablespoon"),
            ExtendedIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch")
        ],
        aggregateLikes: 189, spoonacularScore: 88,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Heat oil in a large wok or skillet over high heat until shimmering."),
            InstructionStep(number: 2, step: "Add diced chicken and cook until golden brown, about 5–6 minutes. Remove and set aside."),
            InstructionStep(number: 3, step: "Add garlic to the same pan and stir-fry for 30 seconds until fragrant."),
            InstructionStep(number: 4, step: "Push everything to the side, pour beaten eggs into the center, and scramble until just set."),
            InstructionStep(number: 5, step: "Add cold cooked rice and stir-fry everything together, breaking up clumps, for 3–4 minutes."),
            InstructionStep(number: 6, step: "Return chicken to the pan, drizzle with soy sauce, toss to combine, and serve immediately.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 410, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 28, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 52, unit: "g"),
            NutrientInfo(name: "Fat", amount: 9, unit: "g")
        ])
    ),
    1003: RecipeDetail(
        id: 1003, title: "Lemon Garlic Pasta",
        image: "https://img.spoonacular.com/recipes/654812-556x370.jpg",
        readyInMinutes: 20, servings: 2,
        extendedIngredients: [
            ExtendedIngredient(id: 7, name: "pasta", original: "200g spaghetti", amount: 200, unit: "g"),
            ExtendedIngredient(id: 2, name: "garlic", original: "3 cloves garlic, minced", amount: 3, unit: "cloves"),
            ExtendedIngredient(id: 9, name: "oil", original: "3 tablespoons olive oil", amount: 3, unit: "tablespoons"),
            ExtendedIngredient(id: 8, name: "parmesan", original: "50g parmesan, freshly grated", amount: 50, unit: "g"),
            ExtendedIngredient(id: 16, name: "lemon", original: "zest and juice of 1 lemon", amount: 1, unit: "whole"),
            ExtendedIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch")
        ],
        aggregateLikes: 312, spoonacularScore: 91,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Cook pasta in well-salted boiling water until al dente. Reserve 1/2 cup pasta water before draining."),
            InstructionStep(number: 2, step: "While pasta cooks, heat olive oil in a large pan over medium heat."),
            InstructionStep(number: 3, step: "Add minced garlic and cook 1–2 minutes until fragrant but not browned."),
            InstructionStep(number: 4, step: "Add drained pasta, lemon zest, and lemon juice to the pan. Toss to coat."),
            InstructionStep(number: 5, step: "Add pasta water a splash at a time, tossing until a light sauce forms."),
            InstructionStep(number: 6, step: "Remove from heat, toss in parmesan, season with salt, and serve immediately.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 520, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 18, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 68, unit: "g"),
            NutrientInfo(name: "Fat", amount: 20, unit: "g")
        ])
    ),
    1004: RecipeDetail(
        id: 1004, title: "Classic Omelette",
        image: "https://img.spoonacular.com/recipes/642585-556x370.jpg",
        readyInMinutes: 10, servings: 1,
        extendedIngredients: [
            ExtendedIngredient(id: 6, name: "eggs", original: "3 large eggs", amount: 3, unit: "whole"),
            ExtendedIngredient(id: 3, name: "butter", original: "1 tablespoon butter", amount: 1, unit: "tablespoon"),
            ExtendedIngredient(id: 10, name: "salt", original: "pinch of salt", amount: 1, unit: "pinch"),
            ExtendedIngredient(id: 17, name: "black pepper", original: "pinch of black pepper", amount: 1, unit: "pinch")
        ],
        aggregateLikes: 156, spoonacularScore: 89,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Crack eggs into a bowl, season with salt and pepper, and whisk vigorously until frothy."),
            InstructionStep(number: 2, step: "Melt butter in a non-stick pan over medium heat, swirling to coat the surface evenly."),
            InstructionStep(number: 3, step: "Pour in eggs and let sit undisturbed for 20–30 seconds until edges begin to set."),
            InstructionStep(number: 4, step: "Use a silicone spatula to gently push cooked edges toward center, tilting pan to let raw egg flow to edges."),
            InstructionStep(number: 5, step: "When eggs are mostly set but still glossy on top, fold in half and slide onto a plate. Serve immediately.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 280, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 18, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 2, unit: "g"),
            NutrientInfo(name: "Fat", amount: 22, unit: "g")
        ])
    ),
    1005: RecipeDetail(
        id: 1005, title: "Beef and Rice Bowl",
        image: "https://img.spoonacular.com/recipes/633942-556x370.jpg",
        readyInMinutes: 35, servings: 4,
        extendedIngredients: [
            ExtendedIngredient(id: 11, name: "ground beef", original: "500g ground beef", amount: 500, unit: "g"),
            ExtendedIngredient(id: 5, name: "rice", original: "2 cups rice", amount: 2, unit: "cups"),
            ExtendedIngredient(id: 12, name: "beef broth", original: "1 cup beef broth", amount: 1, unit: "cup"),
            ExtendedIngredient(id: 2, name: "garlic", original: "2 cloves garlic, minced", amount: 2, unit: "cloves"),
            ExtendedIngredient(id: 4, name: "soy sauce", original: "2 tablespoons soy sauce", amount: 2, unit: "tablespoons"),
            ExtendedIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch")
        ],
        aggregateLikes: 201, spoonacularScore: 87,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Cook rice according to package instructions. Set aside and keep warm."),
            InstructionStep(number: 2, step: "Heat a large skillet over medium-high heat. Add ground beef and break apart with a wooden spoon."),
            InstructionStep(number: 3, step: "Cook beef until browned all over, about 8–10 minutes. Drain excess fat."),
            InstructionStep(number: 4, step: "Add minced garlic and cook for 1 minute until fragrant."),
            InstructionStep(number: 5, step: "Pour in beef broth and soy sauce. Stir and simmer for 5 minutes until slightly reduced."),
            InstructionStep(number: 6, step: "Spoon beef mixture over bowls of rice and season to taste with salt.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 580, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 35, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 58, unit: "g"),
            NutrientInfo(name: "Fat", amount: 22, unit: "g")
        ])
    ),
    1006: RecipeDetail(
        id: 1006, title: "Scrambled Eggs with Toast",
        image: "https://img.spoonacular.com/recipes/660306-556x370.jpg",
        readyInMinutes: 10, servings: 2,
        extendedIngredients: [
            ExtendedIngredient(id: 6, name: "eggs", original: "4 large eggs", amount: 4, unit: "whole"),
            ExtendedIngredient(id: 3, name: "butter", original: "1 tablespoon butter", amount: 1, unit: "tablespoon"),
            ExtendedIngredient(id: 13, name: "bread", original: "2 slices bread", amount: 2, unit: "slices"),
            ExtendedIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch"),
            ExtendedIngredient(id: 17, name: "black pepper", original: "pepper to taste", amount: 1, unit: "pinch")
        ],
        aggregateLikes: 134, spoonacularScore: 85,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Crack eggs into a bowl, season with salt and pepper, and whisk until fully combined."),
            InstructionStep(number: 2, step: "Toast bread to your desired doneness and set aside."),
            InstructionStep(number: 3, step: "Melt butter in a non-stick pan over low-medium heat."),
            InstructionStep(number: 4, step: "Pour in eggs and fold slowly with a spatula, creating large soft curds. Do not rush."),
            InstructionStep(number: 5, step: "Remove from heat while eggs are still slightly underdone — residual heat finishes cooking them."),
            InstructionStep(number: 6, step: "Serve immediately over or alongside toast.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 320, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 18, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 28, unit: "g"),
            NutrientInfo(name: "Fat", amount: 15, unit: "g")
        ])
    ),
    1007: RecipeDetail(
        id: 1007, title: "Garlic Rice",
        image: "https://img.spoonacular.com/recipes/644826-556x370.jpg",
        readyInMinutes: 20, servings: 4,
        extendedIngredients: [
            ExtendedIngredient(id: 5, name: "rice", original: "2 cups long grain rice", amount: 2, unit: "cups"),
            ExtendedIngredient(id: 2, name: "garlic", original: "6 cloves garlic, minced", amount: 6, unit: "cloves"),
            ExtendedIngredient(id: 9, name: "oil", original: "2 tablespoons olive oil", amount: 2, unit: "tablespoons"),
            ExtendedIngredient(id: 10, name: "salt", original: "1 teaspoon salt", amount: 1, unit: "teaspoon"),
            ExtendedIngredient(id: 18, name: "water", original: "4 cups water", amount: 4, unit: "cups")
        ],
        aggregateLikes: 178, spoonacularScore: 86,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Heat olive oil in a medium saucepan over medium heat."),
            InstructionStep(number: 2, step: "Add minced garlic and cook 1–2 minutes until golden and fragrant. Do not burn."),
            InstructionStep(number: 3, step: "Add rice and stir to coat with the garlic oil, toasting for 1–2 minutes."),
            InstructionStep(number: 4, step: "Pour in water and salt. Bring to a rolling boil."),
            InstructionStep(number: 5, step: "Reduce to lowest heat, cover tightly, and cook 18 minutes until water is absorbed."),
            InstructionStep(number: 6, step: "Remove from heat and let stand covered 5 minutes. Fluff with a fork before serving.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 280, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 5, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 52, unit: "g"),
            NutrientInfo(name: "Fat", amount: 7, unit: "g")
        ])
    ),
    1008: RecipeDetail(
        id: 1008, title: "Chicken and Rice Soup",
        image: "https://img.spoonacular.com/recipes/633956-556x370.jpg",
        readyInMinutes: 45, servings: 6,
        extendedIngredients: [
            ExtendedIngredient(id: 1, name: "chicken breast", original: "2 chicken breasts", amount: 2, unit: "piece"),
            ExtendedIngredient(id: 5, name: "rice", original: "1 cup rice", amount: 1, unit: "cup"),
            ExtendedIngredient(id: 14, name: "chicken broth", original: "4 cups chicken broth", amount: 4, unit: "cups"),
            ExtendedIngredient(id: 15, name: "carrots", original: "2 carrots, diced", amount: 2, unit: "whole"),
            ExtendedIngredient(id: 2, name: "garlic", original: "2 cloves garlic", amount: 2, unit: "cloves"),
            ExtendedIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch")
        ],
        aggregateLikes: 267, spoonacularScore: 93,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Bring chicken broth to a boil in a large pot over medium-high heat."),
            InstructionStep(number: 2, step: "Add whole chicken breasts and cook 15–20 minutes until cooked through."),
            InstructionStep(number: 3, step: "Remove chicken, shred with two forks, and set aside."),
            InstructionStep(number: 4, step: "Add diced carrots, garlic, and rice to the broth. Reduce heat and simmer 18 minutes."),
            InstructionStep(number: 5, step: "Return shredded chicken to the pot, season with salt, and simmer 5 more minutes."),
            InstructionStep(number: 6, step: "Taste and adjust seasoning. Serve hot.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 240, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 22, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 28, unit: "g"),
            NutrientInfo(name: "Fat", amount: 4, unit: "g")
        ])
    ),
    1009: RecipeDetail(
        id: 1009, title: "Baked Lemon Herb Chicken",
        image: "https://img.spoonacular.com/recipes/716426-556x370.jpg",
        readyInMinutes: 45, servings: 4,
        extendedIngredients: [
            ExtendedIngredient(id: 1, name: "chicken breast", original: "4 chicken breasts", amount: 4, unit: "piece"),
            ExtendedIngredient(id: 16, name: "lemon", original: "2 lemons, sliced", amount: 2, unit: "whole"),
            ExtendedIngredient(id: 2, name: "garlic", original: "4 cloves garlic, minced", amount: 4, unit: "cloves"),
            ExtendedIngredient(id: 166, name: "rosemary", original: "2 sprigs fresh rosemary", amount: 2, unit: "sprigs"),
            ExtendedIngredient(id: 167, name: "thyme", original: "4 sprigs fresh thyme", amount: 4, unit: "sprigs"),
            ExtendedIngredient(id: 9, name: "oil", original: "3 tbsp olive oil", amount: 3, unit: "tbsp"),
            ExtendedIngredient(id: 10, name: "salt", original: "1 tsp salt", amount: 1, unit: "tsp")
        ],
        aggregateLikes: 220, spoonacularScore: 90,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Preheat oven to 400°F (200°C)."),
            InstructionStep(number: 2, step: "Mix olive oil, minced garlic, salt, and herb leaves in a small bowl."),
            InstructionStep(number: 3, step: "Rub the herb mixture all over the chicken breasts and place in a baking dish."),
            InstructionStep(number: 4, step: "Lay lemon slices over and around the chicken."),
            InstructionStep(number: 5, step: "Bake uncovered for 25–30 minutes until internal temperature reaches 165°F."),
            InstructionStep(number: 6, step: "Let rest 5 minutes before serving. Squeeze any remaining lemon slices over top.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 290, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 40, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 4, unit: "g"),
            NutrientInfo(name: "Fat", amount: 12, unit: "g")
        ])
    ),
    1010: RecipeDetail(
        id: 1010, title: "Creamy Tuscan Chicken",
        image: "https://img.spoonacular.com/recipes/654812-556x370.jpg",
        readyInMinutes: 30, servings: 4,
        extendedIngredients: [
            ExtendedIngredient(id: 1, name: "chicken breast", original: "4 chicken breasts", amount: 4, unit: "piece"),
            ExtendedIngredient(id: 100, name: "sun dried tomatoes", original: "1/2 cup sun dried tomatoes, chopped", amount: 0.5, unit: "cup"),
            ExtendedIngredient(id: 101, name: "spinach", original: "2 cups fresh spinach", amount: 2, unit: "cups"),
            ExtendedIngredient(id: 102, name: "heavy cream", original: "1 cup heavy cream", amount: 1, unit: "cup"),
            ExtendedIngredient(id: 2, name: "garlic", original: "4 cloves garlic, minced", amount: 4, unit: "cloves"),
            ExtendedIngredient(id: 8, name: "parmesan", original: "1/2 cup parmesan, grated", amount: 0.5, unit: "cup"),
            ExtendedIngredient(id: 9, name: "oil", original: "2 tbsp olive oil", amount: 2, unit: "tbsp"),
            ExtendedIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch")
        ],
        aggregateLikes: 310, spoonacularScore: 94,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Season chicken with salt. Heat olive oil in a large skillet over medium-high heat."),
            InstructionStep(number: 2, step: "Sear chicken 5–6 minutes per side until golden and cooked through. Remove and set aside."),
            InstructionStep(number: 3, step: "In the same pan, sauté garlic for 30 seconds. Add sun-dried tomatoes and cook 1 minute."),
            InstructionStep(number: 4, step: "Pour in heavy cream and bring to a gentle simmer, scraping up any browned bits."),
            InstructionStep(number: 5, step: "Stir in parmesan until melted and sauce thickens slightly, about 2 minutes."),
            InstructionStep(number: 6, step: "Add spinach and stir until wilted. Return chicken to the pan, spoon sauce over top, and serve.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 520, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 44, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 8, unit: "g"),
            NutrientInfo(name: "Fat", amount: 34, unit: "g")
        ])
    ),
    1011: RecipeDetail(
        id: 1011, title: "Chicken Tikka Masala",
        image: "https://img.spoonacular.com/recipes/633942-556x370.jpg",
        readyInMinutes: 50, servings: 4,
        extendedIngredients: [
            ExtendedIngredient(id: 1, name: "chicken breast", original: "600g chicken breast, cubed", amount: 600, unit: "g"),
            ExtendedIngredient(id: 120, name: "tomato sauce", original: "1 can crushed tomatoes", amount: 1, unit: "can"),
            ExtendedIngredient(id: 102, name: "heavy cream", original: "1/2 cup heavy cream", amount: 0.5, unit: "cup"),
            ExtendedIngredient(id: 121, name: "garam masala", original: "2 tsp garam masala", amount: 2, unit: "tsp"),
            ExtendedIngredient(id: 122, name: "cumin", original: "1 tsp ground cumin", amount: 1, unit: "tsp"),
            ExtendedIngredient(id: 144, name: "paprika", original: "1 tsp paprika", amount: 1, unit: "tsp"),
            ExtendedIngredient(id: 2, name: "garlic", original: "4 cloves garlic, minced", amount: 4, unit: "cloves"),
            ExtendedIngredient(id: 127, name: "ginger", original: "1 tbsp fresh ginger, grated", amount: 1, unit: "tbsp"),
            ExtendedIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch")
        ],
        aggregateLikes: 380, spoonacularScore: 95,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Toss chicken with half the garam masala, cumin, paprika, salt, and a drizzle of oil. Marinate 15 minutes if time allows."),
            InstructionStep(number: 2, step: "Cook chicken in a hot skillet until browned on all sides. Remove and set aside."),
            InstructionStep(number: 3, step: "In the same pan, sauté garlic and ginger for 1 minute until fragrant."),
            InstructionStep(number: 4, step: "Add crushed tomatoes and remaining spices. Simmer 10 minutes, stirring occasionally."),
            InstructionStep(number: 5, step: "Stir in heavy cream and return chicken to the sauce. Simmer 10 more minutes."),
            InstructionStep(number: 6, step: "Taste, adjust seasoning, and serve over basmati rice with naan if desired.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 480, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 38, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 14, unit: "g"),
            NutrientInfo(name: "Fat", amount: 28, unit: "g")
        ])
    ),
    1012: RecipeDetail(
        id: 1012, title: "Buffalo Chicken Wings",
        image: "https://img.spoonacular.com/recipes/716426-556x370.jpg",
        readyInMinutes: 45, servings: 4,
        extendedIngredients: [
            ExtendedIngredient(id: 210, name: "chicken wings", original: "2 lbs chicken wings", amount: 2, unit: "lbs"),
            ExtendedIngredient(id: 211, name: "hot sauce", original: "1/2 cup hot sauce", amount: 0.5, unit: "cup"),
            ExtendedIngredient(id: 3, name: "butter", original: "1/4 cup butter, melted", amount: 0.25, unit: "cup"),
            ExtendedIngredient(id: 2, name: "garlic", original: "1 tsp garlic powder", amount: 1, unit: "tsp"),
            ExtendedIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch"),
            ExtendedIngredient(id: 17, name: "black pepper", original: "black pepper to taste", amount: 1, unit: "pinch")
        ],
        aggregateLikes: 290, spoonacularScore: 87,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Preheat oven to 425°F (220°C). Pat wings dry with paper towels."),
            InstructionStep(number: 2, step: "Season wings with salt, pepper, and garlic powder. Arrange in a single layer on a wire rack over a baking sheet."),
            InstructionStep(number: 3, step: "Bake 25 minutes, flip, then bake another 20–25 minutes until crispy."),
            InstructionStep(number: 4, step: "Whisk together hot sauce and melted butter in a large bowl."),
            InstructionStep(number: 5, step: "Toss hot crispy wings in buffalo sauce until fully coated."),
            InstructionStep(number: 6, step: "Serve immediately with celery sticks and blue cheese or ranch dipping sauce.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 560, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 42, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 6, unit: "g"),
            NutrientInfo(name: "Fat", amount: 40, unit: "g")
        ])
    ),
    1013: RecipeDetail(
        id: 1013, title: "Chicken Caesar Salad",
        image: "https://img.spoonacular.com/recipes/642585-556x370.jpg",
        readyInMinutes: 20, servings: 2,
        extendedIngredients: [
            ExtendedIngredient(id: 1, name: "chicken breast", original: "2 chicken breasts", amount: 2, unit: "piece"),
            ExtendedIngredient(id: 153, name: "romaine lettuce", original: "1 head romaine lettuce, chopped", amount: 1, unit: "whole"),
            ExtendedIngredient(id: 154, name: "caesar dressing", original: "1/4 cup caesar dressing", amount: 0.25, unit: "cup"),
            ExtendedIngredient(id: 155, name: "croutons", original: "1 cup croutons", amount: 1, unit: "cup"),
            ExtendedIngredient(id: 8, name: "parmesan", original: "1/4 cup parmesan, shaved", amount: 0.25, unit: "cup"),
            ExtendedIngredient(id: 10, name: "salt", original: "salt and pepper to taste", amount: 1, unit: "pinch")
        ],
        aggregateLikes: 180, spoonacularScore: 86,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Season chicken breasts with salt and pepper on both sides."),
            InstructionStep(number: 2, step: "Heat a grill pan or skillet over medium-high heat with a drizzle of oil."),
            InstructionStep(number: 3, step: "Cook chicken 6–7 minutes per side until cooked through. Let rest 5 minutes, then slice."),
            InstructionStep(number: 4, step: "Wash and dry romaine lettuce. Chop into bite-sized pieces and place in a large bowl."),
            InstructionStep(number: 5, step: "Drizzle caesar dressing over lettuce and toss to coat evenly."),
            InstructionStep(number: 6, step: "Top with sliced chicken, croutons, and shaved parmesan. Serve immediately.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 420, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 38, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 18, unit: "g"),
            NutrientInfo(name: "Fat", amount: 22, unit: "g")
        ])
    ),
    1014: RecipeDetail(
        id: 1014, title: "Fried Chicken",
        image: "https://img.spoonacular.com/recipes/634269-556x370.jpg",
        readyInMinutes: 45, servings: 4,
        extendedIngredients: [
            ExtendedIngredient(id: 1, name: "chicken", original: "1 whole chicken, cut into pieces", amount: 1, unit: "whole"),
            ExtendedIngredient(id: 128, name: "flour", original: "2 cups all-purpose flour", amount: 2, unit: "cups"),
            ExtendedIngredient(id: 129, name: "buttermilk", original: "2 cups buttermilk", amount: 2, unit: "cups"),
            ExtendedIngredient(id: 144, name: "paprika", original: "1 tbsp paprika", amount: 1, unit: "tbsp"),
            ExtendedIngredient(id: 2, name: "garlic", original: "1 tsp garlic powder", amount: 1, unit: "tsp"),
            ExtendedIngredient(id: 9, name: "oil", original: "oil for frying", amount: 2, unit: "cups"),
            ExtendedIngredient(id: 10, name: "salt", original: "2 tsp salt", amount: 2, unit: "tsp")
        ],
        aggregateLikes: 340, spoonacularScore: 89,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Soak chicken pieces in buttermilk for at least 30 minutes (or overnight in fridge)."),
            InstructionStep(number: 2, step: "Mix flour, paprika, garlic powder, and salt in a large bowl."),
            InstructionStep(number: 3, step: "Heat 2 inches of oil in a heavy pot or cast iron skillet to 350°F (175°C)."),
            InstructionStep(number: 4, step: "Remove chicken from buttermilk, letting excess drip off. Dredge in seasoned flour, pressing to adhere."),
            InstructionStep(number: 5, step: "Fry in batches without overcrowding, 12–15 minutes, turning once, until golden and cooked through to 165°F."),
            InstructionStep(number: 6, step: "Drain on a wire rack. Season with a pinch of salt while still hot and serve.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 650, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 46, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 38, unit: "g"),
            NutrientInfo(name: "Fat", amount: 32, unit: "g")
        ])
    ),
    1015: RecipeDetail(
        id: 1015, title: "Teriyaki Chicken",
        image: "https://img.spoonacular.com/recipes/633956-556x370.jpg",
        readyInMinutes: 25, servings: 4,
        extendedIngredients: [
            ExtendedIngredient(id: 1, name: "chicken thighs", original: "600g boneless chicken thighs", amount: 600, unit: "g"),
            ExtendedIngredient(id: 4, name: "soy sauce", original: "4 tbsp soy sauce", amount: 4, unit: "tbsp"),
            ExtendedIngredient(id: 104, name: "honey", original: "2 tbsp honey", amount: 2, unit: "tbsp"),
            ExtendedIngredient(id: 243, name: "mirin", original: "2 tbsp mirin", amount: 2, unit: "tbsp"),
            ExtendedIngredient(id: 127, name: "ginger", original: "1 tsp fresh ginger, grated", amount: 1, unit: "tsp"),
            ExtendedIngredient(id: 2, name: "garlic", original: "2 cloves garlic, minced", amount: 2, unit: "cloves"),
            ExtendedIngredient(id: 9, name: "oil", original: "1 tbsp oil", amount: 1, unit: "tbsp")
        ],
        aggregateLikes: 275, spoonacularScore: 91,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Whisk together soy sauce, honey, mirin, ginger, and garlic in a small bowl."),
            InstructionStep(number: 2, step: "Heat oil in a skillet over medium-high heat. Add chicken thighs smooth side down."),
            InstructionStep(number: 3, step: "Cook 5–6 minutes until golden. Flip and cook another 4–5 minutes."),
            InstructionStep(number: 4, step: "Pour teriyaki sauce over chicken and reduce heat to medium."),
            InstructionStep(number: 5, step: "Cook 3–4 more minutes, turning chicken in sauce, until it thickens to a glaze."),
            InstructionStep(number: 6, step: "Slice and serve over steamed rice, spooning extra sauce on top.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 380, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 36, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 22, unit: "g"),
            NutrientInfo(name: "Fat", amount: 14, unit: "g")
        ])
    ),
    1016: RecipeDetail(
        id: 1016, title: "Spaghetti Bolognese",
        image: "https://img.spoonacular.com/recipes/642585-556x370.jpg",
        readyInMinutes: 60, servings: 4,
        extendedIngredients: [
            ExtendedIngredient(id: 7, name: "pasta", original: "400g spaghetti", amount: 400, unit: "g"),
            ExtendedIngredient(id: 11, name: "ground beef", original: "500g ground beef", amount: 500, unit: "g"),
            ExtendedIngredient(id: 120, name: "tomato sauce", original: "1 can crushed tomatoes", amount: 1, unit: "can"),
            ExtendedIngredient(id: 108, name: "onion", original: "1 onion, diced", amount: 1, unit: "whole"),
            ExtendedIngredient(id: 2, name: "garlic", original: "3 cloves garlic, minced", amount: 3, unit: "cloves"),
            ExtendedIngredient(id: 9, name: "oil", original: "2 tbsp olive oil", amount: 2, unit: "tbsp"),
            ExtendedIngredient(id: 8, name: "parmesan", original: "1/2 cup parmesan, grated", amount: 0.5, unit: "cup"),
            ExtendedIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch")
        ],
        aggregateLikes: 350, spoonacularScore: 92,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Heat olive oil in a large heavy pot over medium heat. Add onion and cook 5 minutes until softened."),
            InstructionStep(number: 2, step: "Add garlic and cook 1 minute until fragrant."),
            InstructionStep(number: 3, step: "Add ground beef, breaking up with a spoon. Cook until no pink remains, about 10 minutes. Drain excess fat."),
            InstructionStep(number: 4, step: "Pour in crushed tomatoes, season with salt, and simmer on low for 20–30 minutes, stirring occasionally."),
            InstructionStep(number: 5, step: "Cook spaghetti in well-salted boiling water until al dente. Reserve 1/2 cup pasta water."),
            InstructionStep(number: 6, step: "Toss pasta with sauce, adding pasta water as needed. Serve topped with parmesan.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 680, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 38, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 74, unit: "g"),
            NutrientInfo(name: "Fat", amount: 24, unit: "g")
        ])
    ),
    1017: RecipeDetail(
        id: 1017, title: "Classic Beef Burger",
        image: "https://img.spoonacular.com/recipes/633942-556x370.jpg",
        readyInMinutes: 20, servings: 4,
        extendedIngredients: [
            ExtendedIngredient(id: 11, name: "ground beef", original: "600g ground beef (80/20)", amount: 600, unit: "g"),
            ExtendedIngredient(id: 123, name: "burger buns", original: "4 burger buns, toasted", amount: 4, unit: "whole"),
            ExtendedIngredient(id: 112, name: "cheddar", original: "4 slices cheddar cheese", amount: 4, unit: "slices"),
            ExtendedIngredient(id: 124, name: "lettuce", original: "4 lettuce leaves", amount: 4, unit: "whole"),
            ExtendedIngredient(id: 105, name: "tomato", original: "1 tomato, sliced", amount: 1, unit: "whole"),
            ExtendedIngredient(id: 10, name: "salt", original: "1 tsp salt", amount: 1, unit: "tsp"),
            ExtendedIngredient(id: 17, name: "black pepper", original: "1/2 tsp black pepper", amount: 0.5, unit: "tsp")
        ],
        aggregateLikes: 290, spoonacularScore: 88,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Divide ground beef into 4 equal portions. Gently form into patties about 3/4 inch thick. Season both sides with salt and pepper."),
            InstructionStep(number: 2, step: "Heat a cast iron skillet or grill over high heat until very hot."),
            InstructionStep(number: 3, step: "Cook patties 3–4 minutes per side for medium, or to your desired doneness. Do not press down."),
            InstructionStep(number: 4, step: "Place a slice of cheddar on each patty in the last minute of cooking. Cover to melt."),
            InstructionStep(number: 5, step: "Toast buns cut-side down in the same pan for 1 minute until golden."),
            InstructionStep(number: 6, step: "Build burgers with lettuce, tomato, patty, and your favorite condiments. Serve immediately.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 720, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 44, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 42, unit: "g"),
            NutrientInfo(name: "Fat", amount: 38, unit: "g")
        ])
    ),
    1018: RecipeDetail(
        id: 1018, title: "Beef Stew",
        image: "https://img.spoonacular.com/recipes/633956-556x370.jpg",
        readyInMinutes: 90, servings: 6,
        extendedIngredients: [
            ExtendedIngredient(id: 163, name: "beef chuck", original: "2 lbs beef chuck, cut into 1.5-inch cubes", amount: 2, unit: "lbs"),
            ExtendedIngredient(id: 164, name: "potatoes", original: "3 Yukon gold potatoes, cubed", amount: 3, unit: "whole"),
            ExtendedIngredient(id: 15, name: "carrots", original: "3 carrots, sliced into rounds", amount: 3, unit: "whole"),
            ExtendedIngredient(id: 108, name: "onion", original: "1 large onion, diced", amount: 1, unit: "whole"),
            ExtendedIngredient(id: 12, name: "beef broth", original: "3 cups beef broth", amount: 3, unit: "cups"),
            ExtendedIngredient(id: 165, name: "tomato paste", original: "2 tbsp tomato paste", amount: 2, unit: "tbsp"),
            ExtendedIngredient(id: 2, name: "garlic", original: "3 cloves garlic, minced", amount: 3, unit: "cloves"),
            ExtendedIngredient(id: 10, name: "salt", original: "salt and pepper to taste", amount: 1, unit: "pinch")
        ],
        aggregateLikes: 320, spoonacularScore: 94,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Pat beef dry and season generously with salt and pepper. Heat oil in a large Dutch oven over high heat."),
            InstructionStep(number: 2, step: "Sear beef in batches until browned on all sides, about 3–4 minutes per side. Remove and set aside."),
            InstructionStep(number: 3, step: "Reduce heat to medium. Cook onion 5 minutes until softened. Add garlic for 1 minute."),
            InstructionStep(number: 4, step: "Stir in tomato paste and cook 2 minutes. Return beef and pour in beef broth."),
            InstructionStep(number: 5, step: "Bring to a boil, then reduce heat and simmer covered for 45 minutes."),
            InstructionStep(number: 6, step: "Add potatoes and carrots. Simmer uncovered 30 more minutes until vegetables are tender and stew has thickened.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 460, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 36, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 32, unit: "g"),
            NutrientInfo(name: "Fat", amount: 18, unit: "g")
        ])
    ),
    1019: RecipeDetail(
        id: 1019, title: "Beef Tacos",
        image: "https://img.spoonacular.com/recipes/634269-556x370.jpg",
        readyInMinutes: 25, servings: 4,
        extendedIngredients: [
            ExtendedIngredient(id: 11, name: "ground beef", original: "500g ground beef", amount: 500, unit: "g"),
            ExtendedIngredient(id: 110, name: "tortillas", original: "8 corn tortillas", amount: 8, unit: "whole"),
            ExtendedIngredient(id: 111, name: "taco seasoning", original: "2 tbsp taco seasoning", amount: 2, unit: "tbsp"),
            ExtendedIngredient(id: 112, name: "cheddar", original: "1 cup shredded cheddar", amount: 1, unit: "cup"),
            ExtendedIngredient(id: 113, name: "salsa", original: "1/2 cup salsa", amount: 0.5, unit: "cup"),
            ExtendedIngredient(id: 114, name: "sour cream", original: "1/4 cup sour cream", amount: 0.25, unit: "cup")
        ],
        aggregateLikes: 260, spoonacularScore: 89,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Heat a large skillet over medium-high heat. Add ground beef and break apart."),
            InstructionStep(number: 2, step: "Cook until browned throughout, about 8 minutes. Drain excess fat."),
            InstructionStep(number: 3, step: "Add taco seasoning and 1/4 cup water. Stir and simmer 2–3 minutes until absorbed."),
            InstructionStep(number: 4, step: "Warm tortillas in a dry skillet or wrap in damp paper towel and microwave 30 seconds."),
            InstructionStep(number: 5, step: "Fill each tortilla with seasoned beef."),
            InstructionStep(number: 6, step: "Top with shredded cheddar, salsa, and sour cream. Serve immediately.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 540, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 32, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 46, unit: "g"),
            NutrientInfo(name: "Fat", amount: 24, unit: "g")
        ])
    ),
    1020: RecipeDetail(
        id: 1020, title: "Stuffed Bell Peppers",
        image: "https://img.spoonacular.com/recipes/716426-556x370.jpg",
        readyInMinutes: 50, servings: 4,
        extendedIngredients: [
            ExtendedIngredient(id: 107, name: "bell peppers", original: "4 large bell peppers, tops cut off and seeded", amount: 4, unit: "whole"),
            ExtendedIngredient(id: 11, name: "ground beef", original: "400g ground beef", amount: 400, unit: "g"),
            ExtendedIngredient(id: 5, name: "rice", original: "1 cup cooked rice", amount: 1, unit: "cup"),
            ExtendedIngredient(id: 120, name: "tomato sauce", original: "1 cup tomato sauce", amount: 1, unit: "cup"),
            ExtendedIngredient(id: 112, name: "cheddar", original: "1 cup shredded cheddar", amount: 1, unit: "cup"),
            ExtendedIngredient(id: 2, name: "garlic", original: "2 cloves garlic, minced", amount: 2, unit: "cloves"),
            ExtendedIngredient(id: 10, name: "salt", original: "salt and pepper to taste", amount: 1, unit: "pinch")
        ],
        aggregateLikes: 235, spoonacularScore: 91,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Preheat oven to 375°F (190°C). Slice off the tops of peppers and remove seeds. Place cut-side up in a baking dish."),
            InstructionStep(number: 2, step: "Brown ground beef with garlic in a skillet over medium-high heat. Drain fat."),
            InstructionStep(number: 3, step: "Stir in cooked rice, tomato sauce, and season generously with salt and pepper."),
            InstructionStep(number: 4, step: "Spoon beef mixture evenly into each pepper, packing firmly."),
            InstructionStep(number: 5, step: "Top each pepper with shredded cheddar."),
            InstructionStep(number: 6, step: "Cover with foil and bake 30 minutes. Remove foil and bake 10 more minutes until cheese is golden and bubbling.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 420, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 28, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 34, unit: "g"),
            NutrientInfo(name: "Fat", amount: 18, unit: "g")
        ])
    ),
    1021: RecipeDetail(
        id: 1021, title: "Pot Roast",
        image: "https://img.spoonacular.com/recipes/642585-556x370.jpg",
        readyInMinutes: 240, servings: 6,
        extendedIngredients: [
            ExtendedIngredient(id: 215, name: "chuck roast", original: "3 lb chuck roast", amount: 3, unit: "lbs"),
            ExtendedIngredient(id: 164, name: "potatoes", original: "4 potatoes, quartered", amount: 4, unit: "whole"),
            ExtendedIngredient(id: 15, name: "carrots", original: "4 large carrots, cut into chunks", amount: 4, unit: "whole"),
            ExtendedIngredient(id: 108, name: "onion", original: "1 large onion, quartered", amount: 1, unit: "whole"),
            ExtendedIngredient(id: 12, name: "beef broth", original: "2 cups beef broth", amount: 2, unit: "cups"),
            ExtendedIngredient(id: 2, name: "garlic", original: "4 cloves garlic", amount: 4, unit: "cloves"),
            ExtendedIngredient(id: 10, name: "salt", original: "salt and pepper to taste", amount: 1, unit: "pinch")
        ],
        aggregateLikes: 410, spoonacularScore: 93,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Preheat oven to 325°F (165°C). Pat roast dry and season all over with salt and pepper."),
            InstructionStep(number: 2, step: "Heat oil in a Dutch oven over high heat. Sear roast 4 minutes per side until deeply browned. Remove."),
            InstructionStep(number: 3, step: "Add onion and garlic to the pot, cook 3 minutes. Pour in beef broth and scrape up browned bits."),
            InstructionStep(number: 4, step: "Return roast to pot. Cover and cook in oven for 2.5 hours."),
            InstructionStep(number: 5, step: "Add potatoes and carrots around the roast. Cover and cook 45 more minutes until vegetables are tender and meat falls apart."),
            InstructionStep(number: 6, step: "Rest 10 minutes before slicing. Serve with vegetables and pan juices.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 520, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 48, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 24, unit: "g"),
            NutrientInfo(name: "Fat", amount: 24, unit: "g")
        ])
    ),
    1022: RecipeDetail(
        id: 1022, title: "Meatloaf",
        image: "https://img.spoonacular.com/recipes/633942-556x370.jpg",
        readyInMinutes: 75, servings: 6,
        extendedIngredients: [
            ExtendedIngredient(id: 11, name: "ground beef", original: "2 lbs ground beef", amount: 2, unit: "lbs"),
            ExtendedIngredient(id: 6, name: "eggs", original: "2 eggs", amount: 2, unit: "whole"),
            ExtendedIngredient(id: 209, name: "breadcrumbs", original: "1 cup breadcrumbs", amount: 1, unit: "cup"),
            ExtendedIngredient(id: 108, name: "onion", original: "1 onion, finely diced", amount: 1, unit: "whole"),
            ExtendedIngredient(id: 207, name: "ketchup", original: "1/2 cup ketchup, divided", amount: 0.5, unit: "cup"),
            ExtendedIngredient(id: 189, name: "mustard", original: "1 tbsp yellow mustard", amount: 1, unit: "tbsp"),
            ExtendedIngredient(id: 10, name: "salt", original: "1 tsp salt", amount: 1, unit: "tsp")
        ],
        aggregateLikes: 195, spoonacularScore: 86,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Preheat oven to 350°F (175°C). Lightly grease a 9x5 loaf pan."),
            InstructionStep(number: 2, step: "In a large bowl, combine ground beef, eggs, breadcrumbs, onion, 1/4 cup ketchup, mustard, and salt. Mix until just combined — do not overmix."),
            InstructionStep(number: 3, step: "Transfer mixture to loaf pan and shape into a loaf. Spread remaining ketchup over the top."),
            InstructionStep(number: 4, step: "Bake uncovered 55–65 minutes until internal temperature reaches 160°F."),
            InstructionStep(number: 5, step: "Let rest 10 minutes before slicing and serving.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 480, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 32, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 24, unit: "g"),
            NutrientInfo(name: "Fat", amount: 28, unit: "g")
        ])
    ),
    1023: RecipeDetail(
        id: 1023, title: "Shakshuka",
        image: "https://img.spoonacular.com/recipes/716426-556x370.jpg",
        readyInMinutes: 25, servings: 2,
        extendedIngredients: [
            ExtendedIngredient(id: 6, name: "eggs", original: "4 large eggs", amount: 4, unit: "whole"),
            ExtendedIngredient(id: 120, name: "tomato sauce", original: "1 can crushed tomatoes", amount: 1, unit: "can"),
            ExtendedIngredient(id: 107, name: "bell pepper", original: "1 red bell pepper, diced", amount: 1, unit: "whole"),
            ExtendedIngredient(id: 108, name: "onion", original: "1 onion, diced", amount: 1, unit: "whole"),
            ExtendedIngredient(id: 2, name: "garlic", original: "3 cloves garlic, minced", amount: 3, unit: "cloves"),
            ExtendedIngredient(id: 144, name: "paprika", original: "1 tsp smoked paprika", amount: 1, unit: "tsp"),
            ExtendedIngredient(id: 122, name: "cumin", original: "1 tsp cumin", amount: 1, unit: "tsp"),
            ExtendedIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch")
        ],
        aggregateLikes: 280, spoonacularScore: 92,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Heat oil in a large skillet over medium heat. Add onion and bell pepper, cook 5 minutes until softened."),
            InstructionStep(number: 2, step: "Add garlic, paprika, and cumin. Cook 1 minute until fragrant."),
            InstructionStep(number: 3, step: "Pour in crushed tomatoes and season with salt. Simmer 8–10 minutes until sauce thickens slightly."),
            InstructionStep(number: 4, step: "Use a spoon to create 4 wells in the sauce. Crack one egg into each well."),
            InstructionStep(number: 5, step: "Cover the pan and cook 5–8 minutes until egg whites are set but yolks are still runny."),
            InstructionStep(number: 6, step: "Serve directly from the pan with crusty bread for dipping.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 280, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 16, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 18, unit: "g"),
            NutrientInfo(name: "Fat", amount: 16, unit: "g")
        ])
    ),
    1024: RecipeDetail(
        id: 1024, title: "Spinach Feta Omelette",
        image: "https://img.spoonacular.com/recipes/654812-556x370.jpg",
        readyInMinutes: 10, servings: 1,
        extendedIngredients: [
            ExtendedIngredient(id: 6, name: "eggs", original: "3 large eggs", amount: 3, unit: "whole"),
            ExtendedIngredient(id: 101, name: "spinach", original: "1 cup fresh spinach", amount: 1, unit: "cup"),
            ExtendedIngredient(id: 143, name: "feta", original: "1/4 cup crumbled feta cheese", amount: 0.25, unit: "cup"),
            ExtendedIngredient(id: 3, name: "butter", original: "1 tbsp butter", amount: 1, unit: "tbsp"),
            ExtendedIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch"),
            ExtendedIngredient(id: 17, name: "black pepper", original: "black pepper to taste", amount: 1, unit: "pinch")
        ],
        aggregateLikes: 145, spoonacularScore: 88,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Whisk eggs with salt and pepper until combined."),
            InstructionStep(number: 2, step: "Melt butter in a non-stick pan over medium heat. Add spinach and wilt for 1 minute."),
            InstructionStep(number: 3, step: "Pour egg mixture over spinach. Cook undisturbed until edges set, about 1 minute."),
            InstructionStep(number: 4, step: "Scatter feta across half the omelette."),
            InstructionStep(number: 5, step: "When eggs are nearly set but still slightly glossy, fold omelette over the feta half."),
            InstructionStep(number: 6, step: "Slide onto a plate and serve immediately.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 240, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 16, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 8, unit: "g"),
            NutrientInfo(name: "Fat", amount: 16, unit: "g")
        ])
    ),
    1025: RecipeDetail(
        id: 1025, title: "Deviled Eggs",
        image: "https://img.spoonacular.com/recipes/633942-556x370.jpg",
        readyInMinutes: 20, servings: 6,
        extendedIngredients: [
            ExtendedIngredient(id: 6, name: "eggs", original: "6 large eggs", amount: 6, unit: "whole"),
            ExtendedIngredient(id: 149, name: "mayo", original: "3 tbsp mayonnaise", amount: 3, unit: "tbsp"),
            ExtendedIngredient(id: 189, name: "mustard", original: "1 tsp dijon mustard", amount: 1, unit: "tsp"),
            ExtendedIngredient(id: 144, name: "paprika", original: "paprika for garnish", amount: 1, unit: "pinch"),
            ExtendedIngredient(id: 10, name: "salt", original: "salt and pepper to taste", amount: 1, unit: "pinch")
        ],
        aggregateLikes: 165, spoonacularScore: 85,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Place eggs in a saucepan, cover with cold water. Bring to a boil, then reduce heat and simmer 10 minutes."),
            InstructionStep(number: 2, step: "Transfer to an ice bath and cool completely. Peel carefully."),
            InstructionStep(number: 3, step: "Slice eggs in half lengthwise. Pop yolks into a bowl."),
            InstructionStep(number: 4, step: "Mash yolks with mayo, dijon mustard, salt, and pepper until smooth and creamy."),
            InstructionStep(number: 5, step: "Spoon or pipe filling back into egg white halves."),
            InstructionStep(number: 6, step: "Dust with paprika and serve chilled.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 180, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 12, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 2, unit: "g"),
            NutrientInfo(name: "Fat", amount: 14, unit: "g")
        ])
    ),
    1026: RecipeDetail(
        id: 1026, title: "Cacio e Pepe",
        image: "https://img.spoonacular.com/recipes/716426-556x370.jpg",
        readyInMinutes: 20, servings: 2,
        extendedIngredients: [
            ExtendedIngredient(id: 7, name: "pasta", original: "200g spaghetti or tonnarelli", amount: 200, unit: "g"),
            ExtendedIngredient(id: 8, name: "parmesan", original: "1 cup pecorino romano, finely grated", amount: 1, unit: "cup"),
            ExtendedIngredient(id: 17, name: "black pepper", original: "2 tsp coarsely ground black pepper", amount: 2, unit: "tsp"),
            ExtendedIngredient(id: 3, name: "butter", original: "2 tbsp unsalted butter", amount: 2, unit: "tbsp"),
            ExtendedIngredient(id: 10, name: "salt", original: "salt for pasta water", amount: 1, unit: "tbsp")
        ],
        aggregateLikes: 295, spoonacularScore: 93,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Cook pasta in lightly salted boiling water until very al dente (2 minutes less than package says). Reserve 1 cup pasta water."),
            InstructionStep(number: 2, step: "Toast black pepper in a large dry pan over medium heat for 1 minute until fragrant."),
            InstructionStep(number: 3, step: "Add butter and 1/4 cup pasta water to the pan and stir."),
            InstructionStep(number: 4, step: "Add drained pasta and toss vigorously over medium heat."),
            InstructionStep(number: 5, step: "Remove from heat. Add most of the pecorino and toss, adding pasta water splash by splash until sauce is creamy."),
            InstructionStep(number: 6, step: "Plate immediately and top with remaining cheese and extra pepper.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 620, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 28, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 68, unit: "g"),
            NutrientInfo(name: "Fat", amount: 26, unit: "g")
        ])
    ),
    1027: RecipeDetail(
        id: 1027, title: "Carbonara",
        image: "https://img.spoonacular.com/recipes/642585-556x370.jpg",
        readyInMinutes: 25, servings: 2,
        extendedIngredients: [
            ExtendedIngredient(id: 7, name: "pasta", original: "200g spaghetti", amount: 200, unit: "g"),
            ExtendedIngredient(id: 225, name: "pancetta", original: "100g pancetta or guanciale, diced", amount: 100, unit: "g"),
            ExtendedIngredient(id: 6, name: "eggs", original: "3 egg yolks + 1 whole egg", amount: 3, unit: "whole"),
            ExtendedIngredient(id: 8, name: "parmesan", original: "1/2 cup pecorino romano, grated", amount: 0.5, unit: "cup"),
            ExtendedIngredient(id: 17, name: "black pepper", original: "freshly cracked black pepper, generous amount", amount: 2, unit: "tsp"),
            ExtendedIngredient(id: 10, name: "salt", original: "salt for pasta water", amount: 1, unit: "tbsp")
        ],
        aggregateLikes: 340, spoonacularScore: 94,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Whisk egg yolks, whole egg, and most of the pecorino together in a bowl. Season with black pepper. Set aside."),
            InstructionStep(number: 2, step: "Cook pasta in salted boiling water until al dente. Reserve 1 cup pasta water before draining."),
            InstructionStep(number: 3, step: "While pasta cooks, fry pancetta in a large pan over medium heat until crispy. Remove from heat."),
            InstructionStep(number: 4, step: "Add drained pasta to the pancetta pan off the heat. Toss to coat."),
            InstructionStep(number: 5, step: "Pour egg mixture over pasta, tossing constantly. Add pasta water a splash at a time until sauce is silky."),
            InstructionStep(number: 6, step: "The heat of the pasta cooks the eggs — do not put back on heat. Serve immediately with remaining cheese and pepper.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 560, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 18, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 64, unit: "g"),
            NutrientInfo(name: "Fat", amount: 26, unit: "g")
        ])
    ),
    1028: RecipeDetail(
        id: 1028, title: "Pesto Pasta",
        image: "https://img.spoonacular.com/recipes/633942-556x370.jpg",
        readyInMinutes: 20, servings: 4,
        extendedIngredients: [
            ExtendedIngredient(id: 7, name: "pasta", original: "400g penne or fusilli", amount: 400, unit: "g"),
            ExtendedIngredient(id: 217, name: "pesto", original: "1/2 cup fresh basil pesto", amount: 0.5, unit: "cup"),
            ExtendedIngredient(id: 8, name: "parmesan", original: "1/4 cup parmesan, grated", amount: 0.25, unit: "cup"),
            ExtendedIngredient(id: 105, name: "cherry tomatoes", original: "1 cup cherry tomatoes, halved", amount: 1, unit: "cup"),
            ExtendedIngredient(id: 9, name: "oil", original: "2 tbsp olive oil", amount: 2, unit: "tbsp"),
            ExtendedIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch")
        ],
        aggregateLikes: 255, spoonacularScore: 90,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Cook pasta in well-salted boiling water until al dente. Reserve 1/4 cup pasta water before draining."),
            InstructionStep(number: 2, step: "While pasta cooks, halve cherry tomatoes and set aside."),
            InstructionStep(number: 3, step: "Drain pasta and return to pot. Remove from heat."),
            InstructionStep(number: 4, step: "Add pesto and olive oil. Toss to coat, adding pasta water to loosen if needed."),
            InstructionStep(number: 5, step: "Gently fold in cherry tomatoes."),
            InstructionStep(number: 6, step: "Plate and top with grated parmesan. Serve warm or at room temperature.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 440, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 14, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 68, unit: "g"),
            NutrientInfo(name: "Fat", amount: 14, unit: "g")
        ])
    ),
    1029: RecipeDetail(
        id: 1029, title: "Lasagna",
        image: "https://img.spoonacular.com/recipes/716426-556x370.jpg",
        readyInMinutes: 90, servings: 8,
        extendedIngredients: [
            ExtendedIngredient(id: 223, name: "lasagna noodles", original: "12 lasagna noodles", amount: 12, unit: "whole"),
            ExtendedIngredient(id: 11, name: "ground beef", original: "1 lb ground beef", amount: 1, unit: "lbs"),
            ExtendedIngredient(id: 120, name: "tomato sauce", original: "2 cans tomato sauce", amount: 2, unit: "can"),
            ExtendedIngredient(id: 224, name: "ricotta", original: "2 cups ricotta cheese", amount: 2, unit: "cups"),
            ExtendedIngredient(id: 151, name: "mozzarella", original: "2 cups shredded mozzarella", amount: 2, unit: "cups"),
            ExtendedIngredient(id: 8, name: "parmesan", original: "1/2 cup parmesan, grated", amount: 0.5, unit: "cup"),
            ExtendedIngredient(id: 6, name: "eggs", original: "1 egg", amount: 1, unit: "whole"),
            ExtendedIngredient(id: 10, name: "salt", original: "salt and pepper to taste", amount: 1, unit: "pinch")
        ],
        aggregateLikes: 420, spoonacularScore: 95,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Preheat oven to 375°F (190°C). Cook lasagna noodles in salted water until al dente. Drain and lay flat."),
            InstructionStep(number: 2, step: "Brown ground beef in a skillet over medium-high heat. Drain fat. Add tomato sauce and simmer 10 minutes."),
            InstructionStep(number: 3, step: "Mix ricotta, egg, half the parmesan, salt and pepper in a bowl until combined."),
            InstructionStep(number: 4, step: "Spread a thin layer of meat sauce in the bottom of a 9x13 baking dish."),
            InstructionStep(number: 5, step: "Layer: noodles, ricotta mixture, meat sauce, mozzarella. Repeat 3 times. Top with remaining mozzarella and parmesan."),
            InstructionStep(number: 6, step: "Cover with foil and bake 25 minutes. Remove foil and bake 25 more minutes until bubbly and golden. Rest 15 minutes before cutting.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 580, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 22, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 72, unit: "g"),
            NutrientInfo(name: "Fat", amount: 22, unit: "g")
        ])
    ),
    1030: RecipeDetail(
        id: 1030, title: "Mushroom Risotto",
        image: "https://img.spoonacular.com/recipes/644826-556x370.jpg",
        readyInMinutes: 45, servings: 4,
        extendedIngredients: [
            ExtendedIngredient(id: 115, name: "arborio rice", original: "1.5 cups arborio rice", amount: 1.5, unit: "cups"),
            ExtendedIngredient(id: 116, name: "mushrooms", original: "300g cremini mushrooms, sliced", amount: 300, unit: "g"),
            ExtendedIngredient(id: 117, name: "white wine", original: "1/2 cup dry white wine", amount: 0.5, unit: "cup"),
            ExtendedIngredient(id: 14, name: "chicken broth", original: "4 cups warm chicken broth", amount: 4, unit: "cups"),
            ExtendedIngredient(id: 8, name: "parmesan", original: "1/2 cup parmesan, grated", amount: 0.5, unit: "cup"),
            ExtendedIngredient(id: 3, name: "butter", original: "2 tbsp butter", amount: 2, unit: "tbsp"),
            ExtendedIngredient(id: 2, name: "garlic", original: "2 cloves garlic, minced", amount: 2, unit: "cloves")
        ],
        aggregateLikes: 285, spoonacularScore: 93,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Warm broth in a saucepan over low heat. Keep it warm throughout cooking."),
            InstructionStep(number: 2, step: "Melt butter in a large pan over medium heat. Sauté garlic and mushrooms until tender and golden, about 6 minutes."),
            InstructionStep(number: 3, step: "Add arborio rice and stir to coat with butter. Toast 2 minutes until edges look translucent."),
            InstructionStep(number: 4, step: "Pour in white wine and stir until absorbed."),
            InstructionStep(number: 5, step: "Add warm broth one ladle at a time, stirring constantly, allowing each addition to absorb before adding more. Continue about 20 minutes until rice is creamy and al dente."),
            InstructionStep(number: 6, step: "Remove from heat, stir in parmesan, and season with salt. Serve immediately.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 420, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 12, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 58, unit: "g"),
            NutrientInfo(name: "Fat", amount: 16, unit: "g")
        ])
    ),
    1031: RecipeDetail(
        id: 1031, title: "Honey Garlic Salmon",
        image: "https://img.spoonacular.com/recipes/654812-556x370.jpg",
        readyInMinutes: 20, servings: 2,
        extendedIngredients: [
            ExtendedIngredient(id: 103, name: "salmon", original: "2 salmon fillets", amount: 2, unit: "piece"),
            ExtendedIngredient(id: 104, name: "honey", original: "3 tbsp honey", amount: 3, unit: "tbsp"),
            ExtendedIngredient(id: 2, name: "garlic", original: "4 cloves garlic, minced", amount: 4, unit: "cloves"),
            ExtendedIngredient(id: 4, name: "soy sauce", original: "2 tbsp soy sauce", amount: 2, unit: "tbsp"),
            ExtendedIngredient(id: 3, name: "butter", original: "1 tbsp butter", amount: 1, unit: "tbsp"),
            ExtendedIngredient(id: 10, name: "salt", original: "salt and pepper to taste", amount: 1, unit: "pinch")
        ],
        aggregateLikes: 265, spoonacularScore: 92,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Mix honey, soy sauce, and garlic in a small bowl. Set aside."),
            InstructionStep(number: 2, step: "Pat salmon dry and season with salt and pepper."),
            InstructionStep(number: 3, step: "Melt butter in an oven-safe skillet over medium-high heat."),
            InstructionStep(number: 4, step: "Sear salmon skin-side up for 3–4 minutes until golden. Flip."),
            InstructionStep(number: 5, step: "Pour honey garlic sauce over salmon and spoon over the top as it cooks, 2–3 more minutes."),
            InstructionStep(number: 6, step: "Salmon is done when it flakes easily with a fork. Serve with sauce spooned over top.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 340, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 38, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 2, unit: "g"),
            NutrientInfo(name: "Fat", amount: 18, unit: "g")
        ])
    ),
    1032: RecipeDetail(
        id: 1032, title: "Salmon with Asparagus",
        image: "https://img.spoonacular.com/recipes/660306-556x370.jpg",
        readyInMinutes: 25, servings: 2,
        extendedIngredients: [
            ExtendedIngredient(id: 103, name: "salmon", original: "2 salmon fillets", amount: 2, unit: "piece"),
            ExtendedIngredient(id: 169, name: "asparagus", original: "1 bunch asparagus, trimmed", amount: 1, unit: "bunch"),
            ExtendedIngredient(id: 16, name: "lemon", original: "1 lemon, sliced", amount: 1, unit: "whole"),
            ExtendedIngredient(id: 2, name: "garlic", original: "2 cloves garlic, minced", amount: 2, unit: "cloves"),
            ExtendedIngredient(id: 9, name: "oil", original: "2 tbsp olive oil", amount: 2, unit: "tbsp"),
            ExtendedIngredient(id: 10, name: "salt", original: "salt and pepper to taste", amount: 1, unit: "pinch")
        ],
        aggregateLikes: 210, spoonacularScore: 90,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Preheat oven to 400°F (200°C). Line a baking sheet with parchment."),
            InstructionStep(number: 2, step: "Arrange asparagus on one side of the baking sheet. Drizzle with oil, season with salt and pepper."),
            InstructionStep(number: 3, step: "Place salmon fillets on the other side. Brush with oil and minced garlic. Season."),
            InstructionStep(number: 4, step: "Lay lemon slices over salmon."),
            InstructionStep(number: 5, step: "Roast 12–15 minutes until salmon flakes easily and asparagus is tender with slight char."),
            InstructionStep(number: 6, step: "Serve salmon and asparagus together with remaining lemon squeezed over top.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 360, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 42, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 4, unit: "g"),
            NutrientInfo(name: "Fat", amount: 18, unit: "g")
        ])
    ),
    1033: RecipeDetail(
        id: 1033, title: "Shrimp Stir Fry",
        image: "https://img.spoonacular.com/recipes/633942-556x370.jpg",
        readyInMinutes: 20, servings: 2,
        extendedIngredients: [
            ExtendedIngredient(id: 125, name: "shrimp", original: "300g large shrimp, peeled and deveined", amount: 300, unit: "g"),
            ExtendedIngredient(id: 107, name: "bell pepper", original: "2 bell peppers, sliced", amount: 2, unit: "whole"),
            ExtendedIngredient(id: 126, name: "broccoli", original: "1 cup broccoli florets", amount: 1, unit: "cup"),
            ExtendedIngredient(id: 4, name: "soy sauce", original: "3 tbsp soy sauce", amount: 3, unit: "tbsp"),
            ExtendedIngredient(id: 2, name: "garlic", original: "3 cloves garlic, minced", amount: 3, unit: "cloves"),
            ExtendedIngredient(id: 127, name: "ginger", original: "1 tsp fresh ginger, grated", amount: 1, unit: "tsp"),
            ExtendedIngredient(id: 9, name: "oil", original: "2 tbsp oil", amount: 2, unit: "tbsp")
        ],
        aggregateLikes: 225, spoonacularScore: 88,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Mix soy sauce, garlic, and ginger in a small bowl for the sauce."),
            InstructionStep(number: 2, step: "Heat oil in a wok or large skillet over very high heat."),
            InstructionStep(number: 3, step: "Add broccoli and bell peppers. Stir-fry 3–4 minutes until tender-crisp."),
            InstructionStep(number: 4, step: "Push vegetables to the side. Add shrimp and cook 1–2 minutes per side until pink."),
            InstructionStep(number: 5, step: "Pour sauce over everything and toss to combine. Cook 1 more minute."),
            InstructionStep(number: 6, step: "Serve immediately over steamed rice.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 320, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 28, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 22, unit: "g"),
            NutrientInfo(name: "Fat", amount: 12, unit: "g")
        ])
    ),
    1034: RecipeDetail(
        id: 1034, title: "Shrimp Tacos",
        image: "https://img.spoonacular.com/recipes/632660-556x370.jpg",
        readyInMinutes: 20, servings: 4,
        extendedIngredients: [
            ExtendedIngredient(id: 125, name: "shrimp", original: "400g medium shrimp, peeled and deveined", amount: 400, unit: "g"),
            ExtendedIngredient(id: 110, name: "tortillas", original: "8 small corn tortillas", amount: 8, unit: "whole"),
            ExtendedIngredient(id: 170, name: "coleslaw", original: "1 cup coleslaw mix", amount: 1, unit: "cup"),
            ExtendedIngredient(id: 111, name: "taco seasoning", original: "1 tbsp taco seasoning", amount: 1, unit: "tbsp"),
            ExtendedIngredient(id: 16, name: "lime", original: "2 limes, juiced", amount: 2, unit: "whole"),
            ExtendedIngredient(id: 9, name: "oil", original: "1 tbsp oil", amount: 1, unit: "tbsp")
        ],
        aggregateLikes: 195, spoonacularScore: 87,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Toss shrimp with taco seasoning and half the lime juice."),
            InstructionStep(number: 2, step: "Heat oil in a skillet over medium-high heat. Cook shrimp 1–2 minutes per side until pink and cooked through."),
            InstructionStep(number: 3, step: "Warm tortillas in a dry pan or wrapped in damp paper towel in microwave."),
            InstructionStep(number: 4, step: "Toss coleslaw with remaining lime juice and a pinch of salt."),
            InstructionStep(number: 5, step: "Layer each tortilla with a spoonful of coleslaw."),
            InstructionStep(number: 6, step: "Top with 4–5 shrimp per taco. Serve with extra lime and hot sauce if desired.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 320, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 24, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 34, unit: "g"),
            NutrientInfo(name: "Fat", amount: 10, unit: "g")
        ])
    ),
    1035: RecipeDetail(
        id: 1035, title: "Pork Tenderloin with Roasted Vegetables",
        image: "https://img.spoonacular.com/recipes/633942-556x370.jpg",
        readyInMinutes: 50, servings: 4,
        extendedIngredients: [
            ExtendedIngredient(id: 168, name: "pork tenderloin", original: "1.5 lb pork tenderloin", amount: 1.5, unit: "lbs"),
            ExtendedIngredient(id: 164, name: "potatoes", original: "3 potatoes, cubed", amount: 3, unit: "whole"),
            ExtendedIngredient(id: 126, name: "broccoli", original: "2 cups broccoli florets", amount: 2, unit: "cups"),
            ExtendedIngredient(id: 107, name: "bell pepper", original: "2 bell peppers, sliced", amount: 2, unit: "whole"),
            ExtendedIngredient(id: 2, name: "garlic", original: "3 cloves garlic, minced", amount: 3, unit: "cloves"),
            ExtendedIngredient(id: 9, name: "oil", original: "3 tbsp olive oil", amount: 3, unit: "tbsp"),
            ExtendedIngredient(id: 10, name: "salt", original: "salt and pepper to taste", amount: 1, unit: "pinch")
        ],
        aggregateLikes: 240, spoonacularScore: 90,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Preheat oven to 425°F (220°C). Toss potatoes in 1 tbsp oil, salt, and pepper. Spread on a baking sheet. Roast 15 minutes."),
            InstructionStep(number: 2, step: "Season pork with garlic, remaining oil, salt, and pepper. Sear in an oven-safe skillet over high heat, 2 minutes per side until browned all over."),
            InstructionStep(number: 3, step: "Add broccoli and bell peppers to the potato sheet."),
            InstructionStep(number: 4, step: "Transfer pork skillet to oven. Roast pork and vegetables 20–25 minutes."),
            InstructionStep(number: 5, step: "Pork is done when internal temperature reaches 145°F."),
            InstructionStep(number: 6, step: "Rest pork 5 minutes before slicing. Serve with roasted vegetables.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 420, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 38, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 6, unit: "g"),
            NutrientInfo(name: "Fat", amount: 24, unit: "g")
        ])
    ),
    1036: RecipeDetail(
        id: 1036, title: "Pulled Pork",
        image: "https://img.spoonacular.com/recipes/660306-556x370.jpg",
        readyInMinutes: 240, servings: 8,
        extendedIngredients: [
            ExtendedIngredient(id: 212, name: "pork shoulder", original: "4 lbs pork shoulder", amount: 4, unit: "lbs"),
            ExtendedIngredient(id: 207, name: "bbq sauce", original: "1 cup BBQ sauce", amount: 1, unit: "cup"),
            ExtendedIngredient(id: 194, name: "brown sugar", original: "2 tbsp brown sugar", amount: 2, unit: "tbsp"),
            ExtendedIngredient(id: 144, name: "paprika", original: "1 tbsp smoked paprika", amount: 1, unit: "tbsp"),
            ExtendedIngredient(id: 10, name: "salt", original: "1 tbsp salt", amount: 1, unit: "tbsp")
        ],
        aggregateLikes: 385, spoonacularScore: 91,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Mix brown sugar, paprika, and salt into a dry rub. Pat pork shoulder dry and coat all over with rub. Refrigerate 1 hour or overnight."),
            InstructionStep(number: 2, step: "Preheat oven to 300°F (150°C)."),
            InstructionStep(number: 3, step: "Place pork fat-side up in a roasting pan. Cover tightly with foil."),
            InstructionStep(number: 4, step: "Roast 3–4 hours until pork is very tender and pulls apart easily with a fork."),
            InstructionStep(number: 5, step: "Remove from oven and let rest 15 minutes. Shred with two forks, discarding large fat pieces."),
            InstructionStep(number: 6, step: "Toss shredded pork with BBQ sauce and serve on buns with coleslaw.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 480, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 42, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 8, unit: "g"),
            NutrientInfo(name: "Fat", amount: 28, unit: "g")
        ])
    ),
    1037: RecipeDetail(
        id: 1037, title: "BBQ Ribs",
        image: "https://img.spoonacular.com/recipes/633956-556x370.jpg",
        readyInMinutes: 180, servings: 4,
        extendedIngredients: [
            ExtendedIngredient(id: 206, name: "pork ribs", original: "2 racks baby back pork ribs", amount: 2, unit: "racks"),
            ExtendedIngredient(id: 207, name: "bbq sauce", original: "1 cup BBQ sauce", amount: 1, unit: "cup"),
            ExtendedIngredient(id: 194, name: "brown sugar", original: "2 tbsp brown sugar", amount: 2, unit: "tbsp"),
            ExtendedIngredient(id: 144, name: "paprika", original: "2 tsp smoked paprika", amount: 2, unit: "tsp"),
            ExtendedIngredient(id: 2, name: "garlic", original: "1 tsp garlic powder", amount: 1, unit: "tsp"),
            ExtendedIngredient(id: 10, name: "salt", original: "1 tsp salt", amount: 1, unit: "tsp")
        ],
        aggregateLikes: 370, spoonacularScore: 92,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Preheat oven to 275°F (135°C). Remove the silverskin membrane from the back of each rack."),
            InstructionStep(number: 2, step: "Mix brown sugar, paprika, garlic powder, and salt. Rub all over ribs. Let sit 30 minutes."),
            InstructionStep(number: 3, step: "Wrap each rack tightly in foil. Place on a baking sheet."),
            InstructionStep(number: 4, step: "Bake 2.5–3 hours until meat is tender and pulling away from bones."),
            InstructionStep(number: 5, step: "Carefully unwrap ribs. Brush generously with BBQ sauce."),
            InstructionStep(number: 6, step: "Broil or grill 3–5 minutes until sauce caramelizes. Slice between bones and serve.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 680, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 48, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 14, unit: "g"),
            NutrientInfo(name: "Fat", amount: 44, unit: "g")
        ])
    ),
    1038: RecipeDetail(
        id: 1038, title: "Classic Chicken Noodle Soup",
        image: "https://img.spoonacular.com/recipes/633956-556x370.jpg",
        readyInMinutes: 45, servings: 6,
        extendedIngredients: [
            ExtendedIngredient(id: 1, name: "chicken breast", original: "2 chicken breasts", amount: 2, unit: "piece"),
            ExtendedIngredient(id: 174, name: "egg noodles", original: "2 cups egg noodles", amount: 2, unit: "cups"),
            ExtendedIngredient(id: 15, name: "carrots", original: "3 carrots, sliced", amount: 3, unit: "whole"),
            ExtendedIngredient(id: 159, name: "celery", original: "3 stalks celery, sliced", amount: 3, unit: "stalks"),
            ExtendedIngredient(id: 108, name: "onion", original: "1 onion, diced", amount: 1, unit: "whole"),
            ExtendedIngredient(id: 14, name: "chicken broth", original: "6 cups chicken broth", amount: 6, unit: "cups"),
            ExtendedIngredient(id: 10, name: "salt", original: "salt and pepper to taste", amount: 1, unit: "pinch")
        ],
        aggregateLikes: 405, spoonacularScore: 94,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Bring chicken broth to a boil in a large pot. Add onion, carrots, and celery. Cook 5 minutes."),
            InstructionStep(number: 2, step: "Add whole chicken breasts and return to a boil. Reduce heat and simmer 15–20 minutes until cooked through."),
            InstructionStep(number: 3, step: "Remove chicken, shred with two forks, and set aside."),
            InstructionStep(number: 4, step: "Add egg noodles to the broth and cook according to package instructions, about 8 minutes."),
            InstructionStep(number: 5, step: "Return shredded chicken to the pot. Season generously with salt and pepper."),
            InstructionStep(number: 6, step: "Ladle into bowls and serve hot. Great with crusty bread.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 280, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 22, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 28, unit: "g"),
            NutrientInfo(name: "Fat", amount: 6, unit: "g")
        ])
    ),
    1039: RecipeDetail(
        id: 1039, title: "Tomato Basil Soup",
        image: "https://img.spoonacular.com/recipes/654812-556x370.jpg",
        readyInMinutes: 30, servings: 4,
        extendedIngredients: [
            ExtendedIngredient(id: 120, name: "tomatoes", original: "2 cans crushed tomatoes", amount: 2, unit: "can"),
            ExtendedIngredient(id: 108, name: "onion", original: "1 large onion, diced", amount: 1, unit: "whole"),
            ExtendedIngredient(id: 2, name: "garlic", original: "4 cloves garlic, minced", amount: 4, unit: "cloves"),
            ExtendedIngredient(id: 106, name: "basil", original: "1/4 cup fresh basil, torn", amount: 0.25, unit: "cup"),
            ExtendedIngredient(id: 102, name: "heavy cream", original: "1/4 cup heavy cream", amount: 0.25, unit: "cup"),
            ExtendedIngredient(id: 9, name: "oil", original: "2 tbsp olive oil", amount: 2, unit: "tbsp"),
            ExtendedIngredient(id: 10, name: "salt", original: "salt and pepper to taste", amount: 1, unit: "pinch")
        ],
        aggregateLikes: 270, spoonacularScore: 91,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Heat olive oil in a large pot over medium heat. Add onion and cook 5–7 minutes until softened."),
            InstructionStep(number: 2, step: "Add garlic and cook 1 minute until fragrant."),
            InstructionStep(number: 3, step: "Pour in crushed tomatoes. Season with salt and pepper. Simmer 15 minutes."),
            InstructionStep(number: 4, step: "Use an immersion blender to blend until smooth. Or transfer carefully to a blender."),
            InstructionStep(number: 5, step: "Stir in heavy cream. Return to low heat and warm through. Do not boil."),
            InstructionStep(number: 6, step: "Stir in fresh basil just before serving. Taste and adjust seasoning. Serve with grilled cheese for dipping.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 180, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 4, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 24, unit: "g"),
            NutrientInfo(name: "Fat", amount: 8, unit: "g")
        ])
    ),
    1040: RecipeDetail(
        id: 1040, title: "Broccoli Cheddar Soup",
        image: "https://img.spoonacular.com/recipes/632660-556x370.jpg",
        readyInMinutes: 35, servings: 4,
        extendedIngredients: [
            ExtendedIngredient(id: 126, name: "broccoli", original: "4 cups broccoli florets", amount: 4, unit: "cups"),
            ExtendedIngredient(id: 112, name: "cheddar", original: "2 cups sharp cheddar, shredded", amount: 2, unit: "cups"),
            ExtendedIngredient(id: 162, name: "vegetable broth", original: "2 cups vegetable broth", amount: 2, unit: "cups"),
            ExtendedIngredient(id: 102, name: "heavy cream", original: "1 cup heavy cream", amount: 1, unit: "cup"),
            ExtendedIngredient(id: 108, name: "onion", original: "1 onion, diced", amount: 1, unit: "whole"),
            ExtendedIngredient(id: 3, name: "butter", original: "2 tbsp butter", amount: 2, unit: "tbsp"),
            ExtendedIngredient(id: 10, name: "salt", original: "salt and pepper to taste", amount: 1, unit: "pinch")
        ],
        aggregateLikes: 295, spoonacularScore: 90,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Melt butter in a large pot over medium heat. Add onion and cook 5 minutes until soft."),
            InstructionStep(number: 2, step: "Add broccoli florets and vegetable broth. Bring to a boil, then simmer 10 minutes until broccoli is very tender."),
            InstructionStep(number: 3, step: "Partially blend with immersion blender — leave some chunks for texture."),
            InstructionStep(number: 4, step: "Stir in heavy cream. Return to medium-low heat."),
            InstructionStep(number: 5, step: "Add shredded cheddar a handful at a time, stirring until each addition melts fully."),
            InstructionStep(number: 6, step: "Season with salt and pepper. Serve hot with crusty bread.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 380, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 14, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 22, unit: "g"),
            NutrientInfo(name: "Fat", amount: 28, unit: "g")
        ])
    ),
    1041: RecipeDetail(
        id: 1041, title: "Lentil Soup",
        image: "https://img.spoonacular.com/recipes/644826-556x370.jpg",
        readyInMinutes: 40, servings: 4,
        extendedIngredients: [
            ExtendedIngredient(id: 161, name: "lentils", original: "1.5 cups red lentils, rinsed", amount: 1.5, unit: "cups"),
            ExtendedIngredient(id: 108, name: "onion", original: "1 onion, diced", amount: 1, unit: "whole"),
            ExtendedIngredient(id: 15, name: "carrots", original: "2 carrots, diced", amount: 2, unit: "whole"),
            ExtendedIngredient(id: 2, name: "garlic", original: "3 cloves garlic, minced", amount: 3, unit: "cloves"),
            ExtendedIngredient(id: 122, name: "cumin", original: "2 tsp ground cumin", amount: 2, unit: "tsp"),
            ExtendedIngredient(id: 162, name: "vegetable broth", original: "4 cups vegetable broth", amount: 4, unit: "cups"),
            ExtendedIngredient(id: 10, name: "salt", original: "salt and pepper to taste", amount: 1, unit: "pinch")
        ],
        aggregateLikes: 235, spoonacularScore: 89,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Heat oil in a large pot over medium heat. Add onion and carrots, cook 5 minutes until softened."),
            InstructionStep(number: 2, step: "Add garlic and cumin, cook 1 minute until fragrant."),
            InstructionStep(number: 3, step: "Add rinsed lentils and vegetable broth. Bring to a boil."),
            InstructionStep(number: 4, step: "Reduce heat and simmer 20–25 minutes until lentils are completely tender."),
            InstructionStep(number: 5, step: "Use immersion blender to partially blend for a creamy texture while keeping some chunks."),
            InstructionStep(number: 6, step: "Season with salt and pepper. Serve with a squeeze of lemon and crusty bread.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 260, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 14, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 42, unit: "g"),
            NutrientInfo(name: "Fat", amount: 4, unit: "g")
        ])
    ),
    1042: RecipeDetail(
        id: 1042, title: "Spicy Black Bean Soup",
        image: "https://img.spoonacular.com/recipes/644826-556x370.jpg",
        readyInMinutes: 35, servings: 4,
        extendedIngredients: [
            ExtendedIngredient(id: 160, name: "black beans", original: "2 cans black beans, drained", amount: 2, unit: "can"),
            ExtendedIngredient(id: 162, name: "vegetable broth", original: "2 cups vegetable broth", amount: 2, unit: "cups"),
            ExtendedIngredient(id: 108, name: "onion", original: "1 onion, diced", amount: 1, unit: "whole"),
            ExtendedIngredient(id: 2, name: "garlic", original: "3 cloves garlic, minced", amount: 3, unit: "cloves"),
            ExtendedIngredient(id: 122, name: "cumin", original: "2 tsp cumin", amount: 2, unit: "tsp"),
            ExtendedIngredient(id: 119, name: "red pepper flakes", original: "1 tsp red pepper flakes", amount: 1, unit: "tsp"),
            ExtendedIngredient(id: 16, name: "lime", original: "1 lime, juiced", amount: 1, unit: "whole"),
            ExtendedIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch")
        ],
        aggregateLikes: 195, spoonacularScore: 88,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Heat oil in a pot over medium heat. Cook onion 5 minutes. Add garlic, cumin, and red pepper flakes for 1 minute."),
            InstructionStep(number: 2, step: "Add black beans and vegetable broth. Bring to a boil, then simmer 15 minutes."),
            InstructionStep(number: 3, step: "Mash roughly with a potato masher or blend half the soup for texture."),
            InstructionStep(number: 4, step: "Stir in lime juice and season with salt."),
            InstructionStep(number: 5, step: "Simmer 5 more minutes. Taste and adjust spice level."),
            InstructionStep(number: 6, step: "Serve topped with sour cream, shredded cheese, or fresh cilantro.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 220, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 10, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 34, unit: "g"),
            NutrientInfo(name: "Fat", amount: 6, unit: "g")
        ])
    ),
    1043: RecipeDetail(
        id: 1043, title: "Margherita Pizza",
        image: "https://img.spoonacular.com/recipes/660306-556x370.jpg",
        readyInMinutes: 30, servings: 2,
        extendedIngredients: [
            ExtendedIngredient(id: 219, name: "pizza dough", original: "1 ball pizza dough", amount: 1, unit: "whole"),
            ExtendedIngredient(id: 120, name: "tomato sauce", original: "1/2 cup tomato sauce", amount: 0.5, unit: "cup"),
            ExtendedIngredient(id: 151, name: "fresh mozzarella", original: "8 oz fresh mozzarella, sliced", amount: 8, unit: "oz"),
            ExtendedIngredient(id: 106, name: "basil", original: "fresh basil leaves", amount: 1, unit: "bunch"),
            ExtendedIngredient(id: 9, name: "oil", original: "2 tbsp olive oil", amount: 2, unit: "tbsp"),
            ExtendedIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch")
        ],
        aggregateLikes: 310, spoonacularScore: 91,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Preheat oven to 500°F (260°C) with a pizza stone or baking sheet inside for 30 minutes."),
            InstructionStep(number: 2, step: "On a floured surface, stretch dough to about 12 inches. Transfer to parchment paper."),
            InstructionStep(number: 3, step: "Spread tomato sauce evenly, leaving a 1-inch border. Season with salt and drizzle olive oil."),
            InstructionStep(number: 4, step: "Arrange mozzarella slices over the sauce."),
            InstructionStep(number: 5, step: "Slide pizza (with parchment) onto hot stone or baking sheet. Bake 8–10 minutes until crust is crispy and cheese is bubbling."),
            InstructionStep(number: 6, step: "Remove from oven, scatter fresh basil leaves, and drizzle with a touch more olive oil. Slice and serve.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 520, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 22, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 58, unit: "g"),
            NutrientInfo(name: "Fat", amount: 22, unit: "g")
        ])
    ),
    1044: RecipeDetail(
        id: 1044, title: "Eggplant Parmesan",
        image: "https://img.spoonacular.com/recipes/633956-556x370.jpg",
        readyInMinutes: 60, servings: 4,
        extendedIngredients: [
            ExtendedIngredient(id: 171, name: "eggplant", original: "2 large eggplants, sliced 1/2 inch thick", amount: 2, unit: "whole"),
            ExtendedIngredient(id: 120, name: "tomato sauce", original: "2 cups marinara sauce", amount: 2, unit: "cups"),
            ExtendedIngredient(id: 151, name: "mozzarella", original: "2 cups shredded mozzarella", amount: 2, unit: "cups"),
            ExtendedIngredient(id: 8, name: "parmesan", original: "1/2 cup parmesan, grated", amount: 0.5, unit: "cup"),
            ExtendedIngredient(id: 128, name: "flour", original: "1 cup flour", amount: 1, unit: "cup"),
            ExtendedIngredient(id: 6, name: "eggs", original: "2 eggs, beaten", amount: 2, unit: "whole"),
            ExtendedIngredient(id: 10, name: "salt", original: "1 tsp salt", amount: 1, unit: "tsp")
        ],
        aggregateLikes: 255, spoonacularScore: 89,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Salt eggplant slices and let sit 20 minutes. Pat dry with paper towels."),
            InstructionStep(number: 2, step: "Dredge each slice in flour, dip in egg, then coat in breadcrumbs if desired."),
            InstructionStep(number: 3, step: "Fry in hot oil in batches until golden brown on both sides. Drain on paper towels."),
            InstructionStep(number: 4, step: "Preheat oven to 375°F (190°C). Spread a thin layer of tomato sauce in a baking dish."),
            InstructionStep(number: 5, step: "Layer: eggplant, sauce, mozzarella. Repeat. Top with parmesan."),
            InstructionStep(number: 6, step: "Bake 25–30 minutes until bubbly and golden. Rest 5 minutes before serving.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 460, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 18, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 42, unit: "g"),
            NutrientInfo(name: "Fat", amount: 26, unit: "g")
        ])
    ),
    1045: RecipeDetail(
        id: 1045, title: "Black Bean Quesadilla",
        image: "https://img.spoonacular.com/recipes/632660-556x370.jpg",
        readyInMinutes: 15, servings: 2,
        extendedIngredients: [
            ExtendedIngredient(id: 110, name: "tortillas", original: "4 large flour tortillas", amount: 4, unit: "whole"),
            ExtendedIngredient(id: 160, name: "black beans", original: "1 can black beans, drained and rinsed", amount: 1, unit: "can"),
            ExtendedIngredient(id: 112, name: "cheddar", original: "1 cup shredded cheddar", amount: 1, unit: "cup"),
            ExtendedIngredient(id: 107, name: "bell pepper", original: "1 bell pepper, diced", amount: 1, unit: "whole"),
            ExtendedIngredient(id: 113, name: "salsa", original: "1/4 cup salsa for serving", amount: 0.25, unit: "cup"),
            ExtendedIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch")
        ],
        aggregateLikes: 185, spoonacularScore: 86,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Heat a skillet over medium heat. Add diced bell pepper and cook 3 minutes until tender."),
            InstructionStep(number: 2, step: "Add black beans, season with salt, and mash roughly with a fork. Cook 1 minute. Remove from pan."),
            InstructionStep(number: 3, step: "Lay one tortilla in the skillet. Spread bean mixture over half. Top with cheddar."),
            InstructionStep(number: 4, step: "Fold tortilla in half over the filling. Cook 2–3 minutes until golden and crispy."),
            InstructionStep(number: 5, step: "Flip and cook 2 more minutes until other side is golden and cheese is melted."),
            InstructionStep(number: 6, step: "Slice into wedges and serve with salsa and sour cream.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 420, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 18, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 46, unit: "g"),
            NutrientInfo(name: "Fat", amount: 18, unit: "g")
        ])
    ),
    1046: RecipeDetail(
        id: 1046, title: "Avocado Toast",
        image: "https://img.spoonacular.com/recipes/660306-556x370.jpg",
        readyInMinutes: 10, servings: 2,
        extendedIngredients: [
            ExtendedIngredient(id: 118, name: "avocado", original: "2 ripe avocados", amount: 2, unit: "whole"),
            ExtendedIngredient(id: 13, name: "bread", original: "4 thick slices sourdough or whole grain bread", amount: 4, unit: "slices"),
            ExtendedIngredient(id: 16, name: "lemon", original: "juice of 1 lemon", amount: 1, unit: "whole"),
            ExtendedIngredient(id: 10, name: "salt", original: "flaky salt to taste", amount: 1, unit: "pinch"),
            ExtendedIngredient(id: 17, name: "black pepper", original: "freshly cracked black pepper", amount: 1, unit: "pinch"),
            ExtendedIngredient(id: 119, name: "red pepper flakes", original: "pinch of red pepper flakes", amount: 1, unit: "pinch")
        ],
        aggregateLikes: 230, spoonacularScore: 85,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Toast bread slices to your desired level of crispiness."),
            InstructionStep(number: 2, step: "Halve avocados, remove pits, and scoop flesh into a bowl."),
            InstructionStep(number: 3, step: "Add lemon juice, salt, and pepper to the avocado. Mash to your preferred texture — chunky or smooth."),
            InstructionStep(number: 4, step: "Taste and adjust seasoning."),
            InstructionStep(number: 5, step: "Spread avocado generously over each slice of toast."),
            InstructionStep(number: 6, step: "Sprinkle with red pepper flakes, extra salt, and any toppings you like (poached egg, tomatoes, microgreens).")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 340, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 14, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 28, unit: "g"),
            NutrientInfo(name: "Fat", amount: 20, unit: "g")
        ])
    ),
    1047: RecipeDetail(
        id: 1047, title: "Grilled Cheese Sandwich",
        image: "https://img.spoonacular.com/recipes/633942-556x370.jpg",
        readyInMinutes: 10, servings: 1,
        extendedIngredients: [
            ExtendedIngredient(id: 13, name: "bread", original: "2 thick slices bread", amount: 2, unit: "slices"),
            ExtendedIngredient(id: 112, name: "cheddar", original: "2 slices sharp cheddar", amount: 2, unit: "slices"),
            ExtendedIngredient(id: 151, name: "mozzarella", original: "2 slices mozzarella", amount: 2, unit: "slices"),
            ExtendedIngredient(id: 3, name: "butter", original: "2 tbsp softened butter", amount: 2, unit: "tbsp")
        ],
        aggregateLikes: 175, spoonacularScore: 85,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Butter one side of each bread slice generously."),
            InstructionStep(number: 2, step: "Layer cheddar and mozzarella between the unbuttered sides."),
            InstructionStep(number: 3, step: "Heat a skillet over medium-low heat."),
            InstructionStep(number: 4, step: "Place sandwich butter-side down in the pan. Cook 3–4 minutes until golden brown."),
            InstructionStep(number: 5, step: "Carefully flip. Cook 3 more minutes until second side is golden and cheese is fully melted."),
            InstructionStep(number: 6, step: "Remove from heat, let cool 1 minute, then cut diagonally and serve.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 420, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 14, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 36, unit: "g"),
            NutrientInfo(name: "Fat", amount: 24, unit: "g")
        ])
    ),
    1048: RecipeDetail(
        id: 1048, title: "Quinoa Power Bowl",
        image: "https://img.spoonacular.com/recipes/716426-556x370.jpg",
        readyInMinutes: 25, servings: 2,
        extendedIngredients: [
            ExtendedIngredient(id: 156, name: "quinoa", original: "1 cup quinoa, rinsed", amount: 1, unit: "cup"),
            ExtendedIngredient(id: 157, name: "chickpeas", original: "1 can chickpeas, drained and rinsed", amount: 1, unit: "can"),
            ExtendedIngredient(id: 118, name: "avocado", original: "1 ripe avocado, sliced", amount: 1, unit: "whole"),
            ExtendedIngredient(id: 101, name: "spinach", original: "2 cups baby spinach", amount: 2, unit: "cups"),
            ExtendedIngredient(id: 105, name: "cherry tomatoes", original: "1 cup cherry tomatoes, halved", amount: 1, unit: "cup"),
            ExtendedIngredient(id: 16, name: "lemon", original: "juice of 1 lemon", amount: 1, unit: "whole"),
            ExtendedIngredient(id: 9, name: "oil", original: "2 tbsp olive oil", amount: 2, unit: "tbsp")
        ],
        aggregateLikes: 270, spoonacularScore: 90,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Cook quinoa: combine with 2 cups water in a saucepan. Bring to boil, reduce heat, cover and simmer 15 minutes."),
            InstructionStep(number: 2, step: "While quinoa cooks, drain and rinse chickpeas. Toss with olive oil and a pinch of salt."),
            InstructionStep(number: 3, step: "Toast chickpeas in a skillet over medium-high heat 5–6 minutes until slightly crispy."),
            InstructionStep(number: 4, step: "Fluff cooked quinoa with a fork. Season with salt and lemon juice."),
            InstructionStep(number: 5, step: "Arrange spinach as a base in bowls. Add quinoa, chickpeas, cherry tomatoes, and avocado."),
            InstructionStep(number: 6, step: "Drizzle with olive oil and extra lemon. Season to taste.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 380, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 14, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 48, unit: "g"),
            NutrientInfo(name: "Fat", amount: 16, unit: "g")
        ])
    ),
    1049: RecipeDetail(
        id: 1049, title: "Fluffy Pancakes",
        image: "https://img.spoonacular.com/recipes/660306-556x370.jpg",
        readyInMinutes: 20, servings: 4,
        extendedIngredients: [
            ExtendedIngredient(id: 128, name: "flour", original: "2 cups all-purpose flour", amount: 2, unit: "cups"),
            ExtendedIngredient(id: 141, name: "milk", original: "1.5 cups milk", amount: 1.5, unit: "cups"),
            ExtendedIngredient(id: 6, name: "eggs", original: "2 eggs", amount: 2, unit: "whole"),
            ExtendedIngredient(id: 3, name: "butter", original: "3 tbsp melted butter", amount: 3, unit: "tbsp"),
            ExtendedIngredient(id: 130, name: "sugar", original: "2 tbsp sugar", amount: 2, unit: "tbsp"),
            ExtendedIngredient(id: 131, name: "baking powder", original: "2 tsp baking powder", amount: 2, unit: "tsp"),
            ExtendedIngredient(id: 10, name: "salt", original: "1/2 tsp salt", amount: 0.5, unit: "tsp")
        ],
        aggregateLikes: 310, spoonacularScore: 88,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Whisk together flour, sugar, baking powder, and salt in a large bowl."),
            InstructionStep(number: 2, step: "In a separate bowl, whisk eggs, milk, and melted butter together."),
            InstructionStep(number: 3, step: "Pour wet ingredients into dry and stir until just combined. A few lumps are fine — do not overmix."),
            InstructionStep(number: 4, step: "Heat a non-stick pan or griddle over medium heat. Lightly grease with butter or cooking spray."),
            InstructionStep(number: 5, step: "Pour 1/4 cup batter per pancake. Cook until bubbles form and edges look set, about 2–3 minutes."),
            InstructionStep(number: 6, step: "Flip and cook 1–2 more minutes until golden. Serve warm with maple syrup and butter.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 360, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 8, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 58, unit: "g"),
            NutrientInfo(name: "Fat", amount: 10, unit: "g")
        ])
    ),
    1050: RecipeDetail(
        id: 1050, title: "French Toast",
        image: "https://img.spoonacular.com/recipes/634269-556x370.jpg",
        readyInMinutes: 15, servings: 2,
        extendedIngredients: [
            ExtendedIngredient(id: 13, name: "bread", original: "4 thick slices brioche or Texas toast", amount: 4, unit: "slices"),
            ExtendedIngredient(id: 6, name: "eggs", original: "2 large eggs", amount: 2, unit: "whole"),
            ExtendedIngredient(id: 141, name: "milk", original: "1/4 cup milk", amount: 0.25, unit: "cup"),
            ExtendedIngredient(id: 142, name: "cinnamon", original: "1 tsp ground cinnamon", amount: 1, unit: "tsp"),
            ExtendedIngredient(id: 3, name: "butter", original: "1 tbsp butter", amount: 1, unit: "tbsp"),
            ExtendedIngredient(id: 130, name: "sugar", original: "1 tbsp sugar", amount: 1, unit: "tbsp")
        ],
        aggregateLikes: 240, spoonacularScore: 87,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Whisk eggs, milk, cinnamon, and sugar in a wide shallow bowl."),
            InstructionStep(number: 2, step: "Heat butter in a skillet over medium heat."),
            InstructionStep(number: 3, step: "Dip each bread slice into egg mixture, letting it soak 15 seconds per side."),
            InstructionStep(number: 4, step: "Cook in the buttered skillet 2–3 minutes per side until golden brown."),
            InstructionStep(number: 5, step: "Repeat with remaining slices, adding butter as needed."),
            InstructionStep(number: 6, step: "Serve warm with maple syrup, powdered sugar, or fresh berries.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 340, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 12, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 44, unit: "g"),
            NutrientInfo(name: "Fat", amount: 12, unit: "g")
        ])
    ),
    1051: RecipeDetail(
        id: 1051, title: "Sheet Pan Fajitas",
        image: "https://img.spoonacular.com/recipes/633942-556x370.jpg",
        readyInMinutes: 35, servings: 4,
        extendedIngredients: [
            ExtendedIngredient(id: 1, name: "chicken breast", original: "500g chicken breast, sliced into strips", amount: 500, unit: "g"),
            ExtendedIngredient(id: 107, name: "bell pepper", original: "3 bell peppers (mixed colors), sliced", amount: 3, unit: "whole"),
            ExtendedIngredient(id: 108, name: "onion", original: "1 large onion, sliced", amount: 1, unit: "whole"),
            ExtendedIngredient(id: 109, name: "fajita seasoning", original: "2 tbsp fajita seasoning", amount: 2, unit: "tbsp"),
            ExtendedIngredient(id: 9, name: "oil", original: "2 tbsp olive oil", amount: 2, unit: "tbsp"),
            ExtendedIngredient(id: 110, name: "tortillas", original: "8 flour tortillas, warmed", amount: 8, unit: "whole")
        ],
        aggregateLikes: 275, spoonacularScore: 90,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Preheat oven to 425°F (220°C). Line a large baking sheet with parchment."),
            InstructionStep(number: 2, step: "Combine chicken strips, bell peppers, and onion on the baking sheet."),
            InstructionStep(number: 3, step: "Drizzle with olive oil, sprinkle fajita seasoning over everything, and toss to coat evenly."),
            InstructionStep(number: 4, step: "Spread in a single layer. Roast 20–25 minutes, tossing once halfway, until chicken is cooked through and vegetables have some char."),
            InstructionStep(number: 5, step: "Wrap tortillas in foil and warm in oven for the last 5 minutes."),
            InstructionStep(number: 6, step: "Serve fajita mixture in warm tortillas with salsa, sour cream, and guacamole.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 460, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 36, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 42, unit: "g"),
            NutrientInfo(name: "Fat", amount: 16, unit: "g")
        ])
    ),
    1052: RecipeDetail(
        id: 1052, title: "Chicken Enchiladas",
        image: "https://img.spoonacular.com/recipes/633956-556x370.jpg",
        readyInMinutes: 45, servings: 4,
        extendedIngredients: [
            ExtendedIngredient(id: 1, name: "chicken breast", original: "2 chicken breasts, cooked and shredded", amount: 2, unit: "piece"),
            ExtendedIngredient(id: 110, name: "tortillas", original: "8 corn tortillas", amount: 8, unit: "whole"),
            ExtendedIngredient(id: 226, name: "enchilada sauce", original: "2 cups red enchilada sauce", amount: 2, unit: "cups"),
            ExtendedIngredient(id: 112, name: "cheddar", original: "1.5 cups shredded cheddar", amount: 1.5, unit: "cups"),
            ExtendedIngredient(id: 108, name: "onion", original: "1/2 onion, finely diced", amount: 0.5, unit: "whole"),
            ExtendedIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch")
        ],
        aggregateLikes: 285, spoonacularScore: 91,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Preheat oven to 375°F (190°C). Spread 1/2 cup enchilada sauce on the bottom of a 9x13 baking dish."),
            InstructionStep(number: 2, step: "Combine shredded chicken, onion, half the cheese, and 1/2 cup enchilada sauce in a bowl."),
            InstructionStep(number: 3, step: "Warm tortillas briefly in a dry skillet to make them pliable."),
            InstructionStep(number: 4, step: "Spoon chicken mixture down the center of each tortilla, roll up tightly, and place seam-side down in the baking dish."),
            InstructionStep(number: 5, step: "Pour remaining enchilada sauce over the top. Sprinkle with remaining cheddar."),
            InstructionStep(number: 6, step: "Bake uncovered 20–25 minutes until cheese is melted and bubbling. Serve with sour cream and cilantro.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 520, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 32, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 46, unit: "g"),
            NutrientInfo(name: "Fat", amount: 22, unit: "g")
        ])
    ),
    1053: RecipeDetail(
        id: 1053, title: "Pad Thai",
        image: "https://img.spoonacular.com/recipes/716426-556x370.jpg",
        readyInMinutes: 25, servings: 2,
        extendedIngredients: [
            ExtendedIngredient(id: 179, name: "rice noodles", original: "200g flat rice noodles", amount: 200, unit: "g"),
            ExtendedIngredient(id: 125, name: "shrimp", original: "200g shrimp, peeled", amount: 200, unit: "g"),
            ExtendedIngredient(id: 6, name: "eggs", original: "2 eggs", amount: 2, unit: "whole"),
            ExtendedIngredient(id: 235, name: "pad thai sauce", original: "3 tbsp pad thai sauce", amount: 3, unit: "tbsp"),
            ExtendedIngredient(id: 181, name: "bean sprouts", original: "1 cup bean sprouts", amount: 1, unit: "cup"),
            ExtendedIngredient(id: 236, name: "peanuts", original: "1/4 cup crushed peanuts", amount: 0.25, unit: "cup"),
            ExtendedIngredient(id: 9, name: "oil", original: "2 tbsp oil", amount: 2, unit: "tbsp")
        ],
        aggregateLikes: 315, spoonacularScore: 92,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Soak rice noodles in warm water 20 minutes until pliable. Drain."),
            InstructionStep(number: 2, step: "Heat oil in a wok over high heat. Add shrimp, cook 1–2 minutes until pink. Push to the side."),
            InstructionStep(number: 3, step: "Add eggs to the center of the wok, scramble until just set."),
            InstructionStep(number: 4, step: "Add drained noodles and pad thai sauce. Toss everything together vigorously for 2–3 minutes."),
            InstructionStep(number: 5, step: "Add bean sprouts and toss 30 seconds — keep them slightly crunchy."),
            InstructionStep(number: 6, step: "Plate and top with crushed peanuts, lime wedge, and extra chili flakes if desired.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 540, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 24, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 68, unit: "g"),
            NutrientInfo(name: "Fat", amount: 18, unit: "g")
        ])
    ),
    1054: RecipeDetail(
        id: 1054, title: "Thai Green Curry",
        image: "https://img.spoonacular.com/recipes/716426-556x370.jpg",
        readyInMinutes: 30, servings: 4,
        extendedIngredients: [
            ExtendedIngredient(id: 1, name: "chicken breast", original: "600g chicken breast, cubed", amount: 600, unit: "g"),
            ExtendedIngredient(id: 205, name: "coconut milk", original: "1 can full-fat coconut milk", amount: 1, unit: "can"),
            ExtendedIngredient(id: 248, name: "green curry paste", original: "2 tbsp green curry paste", amount: 2, unit: "tbsp"),
            ExtendedIngredient(id: 126, name: "broccoli", original: "1 cup broccoli florets", amount: 1, unit: "cup"),
            ExtendedIngredient(id: 107, name: "bell pepper", original: "1 bell pepper, sliced", amount: 1, unit: "whole"),
            ExtendedIngredient(id: 4, name: "fish sauce", original: "1 tbsp fish sauce", amount: 1, unit: "tbsp"),
            ExtendedIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch")
        ],
        aggregateLikes: 295, spoonacularScore: 93,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Heat oil in a large pan over medium heat. Add green curry paste and stir-fry 1 minute until fragrant."),
            InstructionStep(number: 2, step: "Pour in coconut milk and bring to a simmer, stirring to incorporate paste."),
            InstructionStep(number: 3, step: "Add chicken cubes and cook 8–10 minutes until cooked through."),
            InstructionStep(number: 4, step: "Add broccoli and bell pepper. Simmer 4–5 minutes until tender."),
            InstructionStep(number: 5, step: "Stir in fish sauce. Taste and adjust seasoning."),
            InstructionStep(number: 6, step: "Serve over jasmine rice, garnished with fresh basil and lime wedges.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 460, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 32, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 18, unit: "g"),
            NutrientInfo(name: "Fat", amount: 30, unit: "g")
        ])
    ),
    1055: RecipeDetail(
        id: 1055, title: "Butter Chicken",
        image: "https://img.spoonacular.com/recipes/633956-556x370.jpg",
        readyInMinutes: 45, servings: 4,
        extendedIngredients: [
            ExtendedIngredient(id: 1, name: "chicken breast", original: "600g chicken breast, cubed", amount: 600, unit: "g"),
            ExtendedIngredient(id: 120, name: "tomato sauce", original: "1 can crushed tomatoes", amount: 1, unit: "can"),
            ExtendedIngredient(id: 102, name: "heavy cream", original: "1/2 cup heavy cream", amount: 0.5, unit: "cup"),
            ExtendedIngredient(id: 3, name: "butter", original: "2 tbsp butter", amount: 2, unit: "tbsp"),
            ExtendedIngredient(id: 2, name: "garlic", original: "4 cloves garlic, minced", amount: 4, unit: "cloves"),
            ExtendedIngredient(id: 121, name: "garam masala", original: "2 tsp garam masala", amount: 2, unit: "tsp"),
            ExtendedIngredient(id: 122, name: "cumin", original: "1 tsp cumin", amount: 1, unit: "tsp"),
            ExtendedIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch")
        ],
        aggregateLikes: 415, spoonacularScore: 95,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Season chicken with half the garam masala, salt, and a drizzle of oil. Cook in a hot skillet until browned. Remove."),
            InstructionStep(number: 2, step: "Melt butter in the same pan. Cook garlic 1 minute. Add remaining garam masala and cumin, cook 30 seconds."),
            InstructionStep(number: 3, step: "Pour in crushed tomatoes. Simmer 10 minutes, stirring occasionally."),
            InstructionStep(number: 4, step: "Blend the sauce smooth with an immersion blender."),
            InstructionStep(number: 5, step: "Return chicken to the sauce. Stir in heavy cream. Simmer 10 minutes."),
            InstructionStep(number: 6, step: "Taste and adjust salt. Serve over basmati rice with naan.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 460, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 36, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 16, unit: "g"),
            NutrientInfo(name: "Fat", amount: 28, unit: "g")
        ])
    ),
    1056: RecipeDetail(
        id: 1056, title: "Chana Masala",
        image: "https://img.spoonacular.com/recipes/642585-556x370.jpg",
        readyInMinutes: 35, servings: 4,
        extendedIngredients: [
            ExtendedIngredient(id: 157, name: "chickpeas", original: "2 cans chickpeas, drained and rinsed", amount: 2, unit: "can"),
            ExtendedIngredient(id: 120, name: "tomatoes", original: "1 can crushed tomatoes", amount: 1, unit: "can"),
            ExtendedIngredient(id: 108, name: "onion", original: "1 large onion, diced", amount: 1, unit: "whole"),
            ExtendedIngredient(id: 2, name: "garlic", original: "4 cloves garlic, minced", amount: 4, unit: "cloves"),
            ExtendedIngredient(id: 127, name: "ginger", original: "1 tbsp fresh ginger, grated", amount: 1, unit: "tbsp"),
            ExtendedIngredient(id: 121, name: "garam masala", original: "2 tsp garam masala", amount: 2, unit: "tsp"),
            ExtendedIngredient(id: 9, name: "oil", original: "2 tbsp oil", amount: 2, unit: "tbsp"),
            ExtendedIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch")
        ],
        aggregateLikes: 255, spoonacularScore: 91,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Heat oil in a large pan over medium heat. Cook onion 7–8 minutes until golden."),
            InstructionStep(number: 2, step: "Add garlic and ginger, cook 2 minutes. Add garam masala, cook 1 minute."),
            InstructionStep(number: 3, step: "Pour in crushed tomatoes and cook 8–10 minutes until oil separates."),
            InstructionStep(number: 4, step: "Add chickpeas and 1/2 cup water. Mash a few chickpeas to thicken the sauce."),
            InstructionStep(number: 5, step: "Simmer 10 minutes until sauce is thick and chickpeas are tender."),
            InstructionStep(number: 6, step: "Season with salt, garnish with cilantro, and serve with rice or naan.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 280, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 12, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 42, unit: "g"),
            NutrientInfo(name: "Fat", amount: 8, unit: "g")
        ])
    ),
    1057: RecipeDetail(
        id: 1057, title: "Saag Paneer",
        image: "https://img.spoonacular.com/recipes/642585-556x370.jpg",
        readyInMinutes: 40, servings: 4,
        extendedIngredients: [
            ExtendedIngredient(id: 258, name: "paneer", original: "250g paneer, cubed", amount: 250, unit: "g"),
            ExtendedIngredient(id: 101, name: "spinach", original: "500g fresh spinach", amount: 500, unit: "g"),
            ExtendedIngredient(id: 102, name: "heavy cream", original: "1/4 cup heavy cream", amount: 0.25, unit: "cup"),
            ExtendedIngredient(id: 2, name: "garlic", original: "3 cloves garlic, minced", amount: 3, unit: "cloves"),
            ExtendedIngredient(id: 127, name: "ginger", original: "1 tbsp fresh ginger, grated", amount: 1, unit: "tbsp"),
            ExtendedIngredient(id: 121, name: "garam masala", original: "1 tsp garam masala", amount: 1, unit: "tsp"),
            ExtendedIngredient(id: 9, name: "oil", original: "2 tbsp oil", amount: 2, unit: "tbsp"),
            ExtendedIngredient(id: 10, name: "salt", original: "salt to taste", amount: 1, unit: "pinch")
        ],
        aggregateLikes: 235, spoonacularScore: 90,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Blanch spinach in boiling water for 2 minutes. Drain and blend to a smooth paste with a little water."),
            InstructionStep(number: 2, step: "Fry paneer cubes in oil until golden on all sides. Remove and set aside."),
            InstructionStep(number: 3, step: "In the same pan, cook garlic and ginger 1 minute. Add garam masala, cook 30 seconds."),
            InstructionStep(number: 4, step: "Add spinach paste and simmer 5 minutes."),
            InstructionStep(number: 5, step: "Stir in heavy cream and return paneer to the pan. Simmer 5 minutes."),
            InstructionStep(number: 6, step: "Season with salt and serve with naan or rice.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 320, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 16, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 12, unit: "g"),
            NutrientInfo(name: "Fat", amount: 24, unit: "g")
        ])
    ),
    1058: RecipeDetail(
        id: 1058, title: "Banana Bread",
        image: "https://img.spoonacular.com/recipes/716426-556x370.jpg",
        readyInMinutes: 65, servings: 8,
        extendedIngredients: [
            ExtendedIngredient(id: 132, name: "bananas", original: "3 very ripe bananas, mashed", amount: 3, unit: "whole"),
            ExtendedIngredient(id: 128, name: "flour", original: "1.5 cups all-purpose flour", amount: 1.5, unit: "cups"),
            ExtendedIngredient(id: 130, name: "sugar", original: "3/4 cup sugar", amount: 0.75, unit: "cup"),
            ExtendedIngredient(id: 3, name: "butter", original: "1/3 cup butter, melted", amount: 0.33, unit: "cup"),
            ExtendedIngredient(id: 6, name: "eggs", original: "1 egg, beaten", amount: 1, unit: "whole"),
            ExtendedIngredient(id: 195, name: "vanilla extract", original: "1 tsp vanilla extract", amount: 1, unit: "tsp"),
            ExtendedIngredient(id: 131, name: "baking soda", original: "1 tsp baking soda", amount: 1, unit: "tsp"),
            ExtendedIngredient(id: 10, name: "salt", original: "1/4 tsp salt", amount: 0.25, unit: "tsp")
        ],
        aggregateLikes: 370, spoonacularScore: 92,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Preheat oven to 350°F (175°C). Grease a 9x5 loaf pan."),
            InstructionStep(number: 2, step: "Mash bananas in a large bowl until smooth. Stir in melted butter."),
            InstructionStep(number: 3, step: "Mix in sugar, beaten egg, and vanilla extract."),
            InstructionStep(number: 4, step: "Add baking soda and salt. Stir to combine."),
            InstructionStep(number: 5, step: "Fold in flour until just incorporated — do not overmix."),
            InstructionStep(number: 6, step: "Pour into loaf pan and bake 55–65 minutes until a toothpick inserted in the center comes out clean. Cool 10 minutes before slicing.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 280, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 4, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 48, unit: "g"),
            NutrientInfo(name: "Fat", amount: 8, unit: "g")
        ])
    ),
    1059: RecipeDetail(
        id: 1059, title: "Chocolate Chip Cookies",
        image: "https://img.spoonacular.com/recipes/633956-556x370.jpg",
        readyInMinutes: 30, servings: 24,
        extendedIngredients: [
            ExtendedIngredient(id: 128, name: "flour", original: "2.25 cups all-purpose flour", amount: 2.25, unit: "cups"),
            ExtendedIngredient(id: 192, name: "chocolate chips", original: "2 cups semi-sweet chocolate chips", amount: 2, unit: "cups"),
            ExtendedIngredient(id: 3, name: "butter", original: "1 cup unsalted butter, softened", amount: 1, unit: "cup"),
            ExtendedIngredient(id: 130, name: "sugar", original: "3/4 cup granulated sugar", amount: 0.75, unit: "cup"),
            ExtendedIngredient(id: 194, name: "brown sugar", original: "3/4 cup packed brown sugar", amount: 0.75, unit: "cup"),
            ExtendedIngredient(id: 6, name: "eggs", original: "2 large eggs", amount: 2, unit: "whole"),
            ExtendedIngredient(id: 195, name: "vanilla extract", original: "2 tsp vanilla extract", amount: 2, unit: "tsp"),
            ExtendedIngredient(id: 131, name: "baking soda", original: "1 tsp baking soda", amount: 1, unit: "tsp"),
            ExtendedIngredient(id: 10, name: "salt", original: "1 tsp salt", amount: 1, unit: "tsp")
        ],
        aggregateLikes: 490, spoonacularScore: 94,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Preheat oven to 375°F (190°C). Line baking sheets with parchment paper."),
            InstructionStep(number: 2, step: "Beat butter and both sugars together until light and fluffy, about 3 minutes."),
            InstructionStep(number: 3, step: "Beat in eggs one at a time, then vanilla extract."),
            InstructionStep(number: 4, step: "Mix in flour, baking soda, and salt until just combined."),
            InstructionStep(number: 5, step: "Fold in chocolate chips. Drop rounded tablespoons of dough 2 inches apart on baking sheets."),
            InstructionStep(number: 6, step: "Bake 9–11 minutes until edges are golden but centers look slightly underdone. Cool on pan 5 minutes before moving.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 180, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 2, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 24, unit: "g"),
            NutrientInfo(name: "Fat", amount: 9, unit: "g")
        ])
    ),
    1060: RecipeDetail(
        id: 1060, title: "Brownies",
        image: "https://img.spoonacular.com/recipes/633942-556x370.jpg",
        readyInMinutes: 40, servings: 16,
        extendedIngredients: [
            ExtendedIngredient(id: 197, name: "dark chocolate", original: "200g dark chocolate, chopped", amount: 200, unit: "g"),
            ExtendedIngredient(id: 3, name: "butter", original: "1/2 cup unsalted butter", amount: 0.5, unit: "cup"),
            ExtendedIngredient(id: 130, name: "sugar", original: "1 cup sugar", amount: 1, unit: "cup"),
            ExtendedIngredient(id: 6, name: "eggs", original: "3 large eggs", amount: 3, unit: "whole"),
            ExtendedIngredient(id: 128, name: "flour", original: "3/4 cup all-purpose flour", amount: 0.75, unit: "cup"),
            ExtendedIngredient(id: 198, name: "cocoa powder", original: "1/4 cup cocoa powder", amount: 0.25, unit: "cup"),
            ExtendedIngredient(id: 10, name: "salt", original: "1/4 tsp salt", amount: 0.25, unit: "tsp")
        ],
        aggregateLikes: 445, spoonacularScore: 93,
        analyzedInstructions: [AnalyzedInstruction(name: "", steps: [
            InstructionStep(number: 1, step: "Preheat oven to 350°F (175°C). Grease and line an 8x8 or 9x9 inch baking pan."),
            InstructionStep(number: 2, step: "Melt chocolate and butter together in a heatproof bowl over simmering water or in microwave in 30-second bursts. Stir until smooth. Cool slightly."),
            InstructionStep(number: 3, step: "Whisk sugar into chocolate mixture. Add eggs one at a time, whisking well after each."),
            InstructionStep(number: 4, step: "Fold in flour, cocoa powder, and salt until just combined. Do not overmix."),
            InstructionStep(number: 5, step: "Pour into prepared pan and spread evenly."),
            InstructionStep(number: 6, step: "Bake 25–30 minutes until a toothpick comes out with moist crumbs (not wet batter). Cool completely before cutting for clean squares.")
        ])],
        nutrition: RecipeNutrition(nutrients: [
            NutrientInfo(name: "Calories", amount: 220, unit: "kcal"),
            NutrientInfo(name: "Protein", amount: 3, unit: "g"),
            NutrientInfo(name: "Carbohydrates", amount: 32, unit: "g"),
            NutrientInfo(name: "Fat", amount: 10, unit: "g")
        ])
    )
]
