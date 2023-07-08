import UIKit
import FirebaseAuth

protocol RecipeServiceProtocol {
    func fetchRecipes(completion: @escaping ([RecipeViewModel]) -> Void)
    func createRecipe(recipe: RecipeViewModel, image: UIImage, completion: @escaping (Error?) -> Void)
    func updateRating(with data: [String: Any], for recipe: String, completion: @escaping (Error?) -> Void)
    func fetchRecipesWith(category: Recipe.Category, completion: @escaping ([RecipeViewModel]) -> Void)
}

class RecipeService: RecipeServiceProtocol {
    
    func updateRating(with data: [String: Any], for recipe: String, completion: @escaping (Error?) -> Void) {
        COLLECTION_RECIPES.document(recipe).updateData(data, completion: completion)
    }
    
    func fetchRecipesWith(category: Recipe.Category, completion: @escaping ([RecipeViewModel]) -> Void) {
        COLLECTION_RECIPES.whereField("category", isEqualTo: category.rawValue).getDocuments { snapshot, error in
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
            }
            
            completion(recipesArray)
        }
    }
    
    func createRecipe(recipe: RecipeViewModel, image: UIImage, completion: @escaping (Error?) -> Void) {
        ImageUploader.shared.uploadImage(image: image, isForRecipe: true) { recipeImageUrl in
            var instructions: [String] = []
            var ingredients: [String: [String: Float]] = [:]
            
            recipe.instructions.compactMap { $0.text }.forEach { instructions.append($0) }
            
            for ingredient in recipe.ingredients {
                if let name = ingredient.name, let portion = ingredient.portion, let volume = ingredient.volume {
                    ingredients[name] = [portion: volume]
                }
            }
            
            let data: [String: Any] = [
                "name": recipe.recipeName ?? "",
                "cookTime": recipe.recipe.cookTime ?? "",
                "recipeImageUrl": recipeImageUrl,
                "id": recipe.recipe.id ?? "",
                "ownerId": recipe.recipe.ownerId ?? "",
                "instructions": instructions,
                "ingredients": ingredients,
                "category": recipe.category,
                "rating": 0,
                "serve": recipe.recipe.serve ?? ""
            ]
            
            let recipeDocument = COLLECTION_RECIPES.document(recipe.recipe.id ?? "")
            recipeDocument.setData(data) { error in
                if let error = error {
                    completion(error)
                    return
                }
                
                COLLECTION_USERS.document(recipe.recipe.ownerId ?? "")
                    .collection("recipes")
                    .document(recipe.recipe.id ?? "")
                    .setData(data)
                
                completion(nil)
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
            }
            
            completion(recipesArray)
        }
    }
}
