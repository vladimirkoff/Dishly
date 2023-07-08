
import UIKit
import FirebaseAuth

protocol RecipeServiceProtocol {
    func fetchRecipes(completion: @escaping ([RecipeViewModel]) -> Void)
    func createRecipe(recipe: RecipeViewModel, image: UIImage, completion: @escaping(Error?) -> ())
    func updateRating(with data: [String : Any], for recipe: String, completion: @escaping(Error?) -> ())
    func fecthRecipesWith(category: Recipe.Category, completion: @escaping ([RecipeViewModel]) -> Void)
}

class RecipeService: RecipeServiceProtocol {
    
    func updateRating(with data: [String : Any], for recipe: String, completion: @escaping(Error?) -> ()) {
        COLLECTION_RECIPES.document(recipe).updateData(data) { error in
            completion(error)
        }
    }
    
    func fecthRecipesWith(category: Recipe.Category, completion: @escaping ([RecipeViewModel]) -> Void) {
        COLLECTION_RECIPES.getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            var recipesArray: [RecipeViewModel] = []
            
            if let recipes = snapshot?.documents {
                for recipe in recipes {
                    if recipe.data()["category"] as! String == category.rawValue {
                        let recipeViewModel = setRecipesConfiguration(recipe: recipe)
                        recipesArray.append(recipeViewModel)
                    }
                }
                completion(recipesArray)
            }
        }
    }
    
    func createRecipe(recipe: RecipeViewModel, image: UIImage, completion: @escaping(Error?) -> ()) {
        ImageUploader.shared.uploadImage(image: image, forRecipe: true) { recipeImageUrl in
            
            var instructions: [String] = []
            
            var ingredients: [String : [String : Float]] = [:]
            
            for instruction in recipe.instructions {
                if let instr = instruction.text {
                    instructions.append(instr)
                }
            }
            for ingredient in recipe.ingredients {
                ingredients[ingredient.name!] = [ingredient.portion! : ingredient.volume!]
            }
            
             
            let data: [String: Any] = ["name": recipe.recipeName!, "cookTime": recipe.recipe.cookTime!, "recipeImageUrl": recipeImageUrl, "id": recipe.recipe.id!, "ownerId": recipe.recipe.ownerId!, "instructions": instructions, "ingredients": ingredients, "category": recipe.category, "rating": 0, "serve" : recipe.recipe.serve!]
            
            COLLECTION_RECIPES.document(recipe.recipe.id!).setData(data) { error in
                COLLECTION_USERS.document(recipe.recipe.ownerId!).collection("recipes").document(recipe.recipe.id!).setData(data)
                completion(error)
            }
        }
        
    }
    
    func fetchRecipes(completion: @escaping ([RecipeViewModel]) -> Void) {
        COLLECTION_RECIPES.getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            var recipesArray: [RecipeViewModel] = []
            if let recipes = snapshot?.documents {
                for recipe in recipes {
                    let recipeViewModel = setRecipesConfiguration(recipe: recipe)
                    recipesArray.append(recipeViewModel)
                }
                completion(recipesArray)
            }
        }
    }
}
