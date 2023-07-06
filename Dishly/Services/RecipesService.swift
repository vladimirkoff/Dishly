
import UIKit
import FirebaseAuth

protocol RecipeServiceProtocol {
    func fetchRecipes(completion: @escaping ([Recipe]) -> Void)
    func createRecipe(recipe: RecipeViewModel, image: UIImage, completion: @escaping(Error?) -> ())
    func updateRating(for recipe: RecipeViewModel, newRating: Int, completion: @escaping(Error?) -> ())
    func fecthRecipesWith(category: Recipe.Category, completion: @escaping ([Recipe]) -> Void)
    func saveRecipeToCollection(collection: String, recipe: RecipeViewModel, completion: @escaping(Error?) -> ())
}

class RecipeService: RecipeServiceProtocol {
    
    func updateRating(for recipe: RecipeViewModel, newRating: Int , completion: @escaping(Error?) -> ()) {
    }
    
    func saveRecipeToCollection(collection: String, recipe: RecipeViewModel, completion: @escaping(Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var instructions: [String] = []
        var ingredients: [String] = []

        for instruction in recipe.instructions {
            if let instr = instruction.text {
                instructions.append(instr)
            }
        }
        for ingredient in recipe.ingredients {
            if let ingr = ingredient.name {
                ingredients.append(ingr)
            }
        }
        
        let data: [String: Any] = ["name": recipe.recipeName!, "cookTime": recipe.recipe.cookTime!, "recipeImageUrl": recipe.recipe.recipeImageUrl!, "id": recipe.recipe.id!, "ownerId": recipe.recipe.ownerId!, "instructions": instructions, "ingredients": ingredients, "category": recipe.category, "rating": 0, "numOfRatings": 0]
        
        COLLECTION_USERS.document(uid).collection(collection).addDocument(data: data)
    }
    
    func fecthRecipesWith(category: Recipe.Category, completion: @escaping ([Recipe]) -> Void) {
        
        COLLECTION_RECIPES.getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            var recipesArray: [Recipe] = []
            if let recipes = snapshot?.documents {
                for recipe in recipes {
                    if recipe.data()["category"] as! String == category.rawValue {
                        let serve = recipe.data()["serve"] as? String ?? ""
                        let id = recipe.data()["id"] as? String ?? ""
                        let name = recipe.data()["name"] as? String ?? ""
                        let cookTime = recipe.data()["cookTime"] as? String ?? ""
                        let ownerId = recipe.data()["ownerId"] as? String ?? ""
                        let ingredients = recipe.data()["ingredients"] as? [String] ?? []
                        var ingredientsArray: [Ingredient] = []
                        for ingredient in ingredients {
                            let ingredientModel = Ingredient(name: ingredient)
                            ingredientsArray.append(ingredientModel)
                        }
                        
                        var instructions = recipe.data()["instructions"] as? [String] ?? []
                        var rating = recipe.data()["rating"] as? Int ?? 0
                        var numOfRatings = recipe.data()["numOfRatings"] as? [Int] ?? []
                        var category = recipe.data()["category"] as? String ?? ""
                        var recipeImageUrl = recipe.data()["recipeImageUrl"] as? String ?? ""
                        var recipeModel = Recipe(ownerId: ownerId, id: id, name: name, serve: serve, cookTime: cookTime,  category: Recipe.Category(rawValue: "Bread")!, ingredients: ingredientsArray, instructions: [], recipeImageUrl: recipeImageUrl)
                        recipesArray.append(recipeModel)
                    }
                }
                completion(recipesArray)
            }
        }
    }
    
    func createRecipe(recipe: RecipeViewModel, image: UIImage, completion: @escaping(Error?) -> ()) {
        ImageUploader.shared.uploadImage(image: image, forRecipe: true) { recipeImageUrl in
            var instructions: [String] = []
            var ingredients: [String] = []

            for instruction in recipe.instructions {
                if let instr = instruction.text {
                    instructions.append(instr)
                }
            }
            for ingredient in recipe.ingredients {
                if let ingr = ingredient.name {
                    ingredients.append(ingr)
                }
            }
            
            let data: [String: Any] = ["name": recipe.recipeName!, "cookTime": recipe.recipe.cookTime!, "recipeImageUrl": recipeImageUrl, "id": recipe.recipe.id!, "ownerId": recipe.recipe.ownerId!, "instructions": instructions, "ingredients": ingredients, "category": recipe.category, "rating": 0, "numOfRatings": 0]

            COLLECTION_RECIPES.document(recipe.recipe.id!).setData(data) { error in
                COLLECTION_USERS.document(recipe.recipe.ownerId!).collection("recipes").document(recipe.recipe.id!).setData(data)
                completion(error)
            }
        }
        
    }
    
    func fetchRecipes(completion: @escaping ([Recipe]) -> Void) {
        COLLECTION_RECIPES.getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            var recipesArray: [Recipe] = []
            if let recipes = snapshot?.documents {
                for recipe in recipes {
                    let serve = recipe.data()["serve"] as? String ?? ""
                    let id = recipe.data()["id"] as? String ?? ""
                    let name = recipe.data()["name"] as? String ?? ""
                    let cookTime = recipe.data()["cookTime"] as? String ?? ""
                    let ownerId = recipe.data()["ownerId"] as? String ?? ""
                    let ingredients = recipe.data()["ingredients"] as? [String] ?? []
                    var ingredientsArray: [Ingredient] = []
                    for ingredient in ingredients {
                        let ingredientModel = Ingredient(name: ingredient)
                        ingredientsArray.append(ingredientModel)
                    }
                    
                    let instructions = recipe.data()["instructions"] as? [String] ?? []
                    let rating = recipe.data()["rating"] as? Int ?? 0
                    let numOfRatings = recipe.data()["numOfRatings"] as? [Int] ?? []
                    let category = recipe.data()["category"] as? String ?? ""
                    let recipeImageUrl = recipe.data()["recipeImageUrl"] as? String ?? ""
                    let recipeModel = Recipe(ownerId: ownerId, id: id, name: name, serve: serve, cookTime: cookTime,  category: Recipe.Category(rawValue: "Bread")!, ingredients: ingredientsArray, instructions: [], recipeImageUrl: recipeImageUrl)
                    recipesArray.append(recipeModel)
                }
                completion(recipesArray)
            }
        }
    }
}
