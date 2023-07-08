import UIKit
import FirebaseAuth
import FirebaseFirestore

protocol RecipeServiceProtocol {
    func fetchRecipes(completion: @escaping ([RecipeViewModel]) -> Void)
    func createRecipe(recipe: RecipeViewModel, image: UIImage, completion: @escaping (Error?) -> Void)
    func updateRating(with data: [String: Any],recipe: String, completion: @escaping (Error?) -> Void)
    func fetchRecipesWith(category: Recipe.Category, completion: @escaping ([RecipeViewModel]) -> Void)
    func fetchRecipesFor(category: String, completion: @escaping([RecipeViewModel]) -> ())
}

class RecipeService: RecipeServiceProtocol {
    
    func updateRating(with data: [String: Any], recipe: String, completion: @escaping (Error?) -> Void) {
        COLLECTION_RECIPES.document(recipe).updateData(data, completion: completion)
    }
    
    func fetchRecipesFor(category: String, completion: @escaping([RecipeViewModel]) -> ()) {
        var recipesArray: [RecipeViewModel] = []

        Firestore.firestore().collection(category).getDocuments { snapshot, error in
            if let recipes = snapshot?.documents {
                for recipe in recipes {
                    let recipeViewModel = setRecipesConfiguration(recipe: recipe)
                    recipesArray.append(recipeViewModel)
                }
                completion(recipesArray)
            }
        }
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
            
            recipe.recipe.instructions.compactMap { $0.text }.forEach { instructions.append($0) }
            
            for ingredient in recipe.recipe.ingredients {
                if let name = ingredient.name, let portion = ingredient.portion, let volume = ingredient.volume {
                    ingredients[name] = [portion: volume]
                }
            }
            
            let data: [String: Any] = [
                "name": recipe.recipe.name ?? "",
                "cookTime": recipe.recipe.cookTime ?? "",
                "recipeImageUrl": recipeImageUrl,
                "id": recipe.recipe.id ?? "",
                "ownerId": recipe.recipe.ownerId ?? "",
                "instructions": instructions,
                "ingredients": ingredients,
                "category": recipe.recipe.category.rawValue,
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
                    .setData(data) { error in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                        Firestore.firestore().collection(recipe.recipe.category.rawValue).document(recipe.recipe.id ?? "")
                            .setData(data) { error in
                                if let error = error {
                                    print(error.localizedDescription)
                                    return
                                }
                            }
                    }
                
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
