
import UIKit
import FirebaseAuth

protocol RecipeServiceProtocol {
    func fetchRecipes(completion: @escaping ([RecipeViewModel]) -> Void)
    func createRecipe(recipe: RecipeViewModel, image: UIImage, completion: @escaping(Error?) -> ())
    func updateRating(for recipe: RecipeViewModel, newRating: Int, completion: @escaping(Error?) -> ())
    func fecthRecipesWith(category: Recipe.Category, completion: @escaping ([RecipeViewModel]) -> Void)
    func saveRecipeToCollection(collection: Collection, recipe: RecipeViewModel?, completion: @escaping(Error?) -> ())
}

class RecipeService: RecipeServiceProtocol {
    
    func updateRating(for recipe: RecipeViewModel, newRating: Int , completion: @escaping(Error?) -> ()) {
    }
    
    func saveRecipeToCollection(collection: Collection, recipe: RecipeViewModel?, completion: @escaping(Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        
        let collectionData: [String : Any] = ["name" : collection.name, "id" : collection.id, "imageUrl" : collection.imageUrl]
        
        if let recipe = recipe {
            
            
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
            
            COLLECTION_USERS.document(uid).collection("collections").document(collection.id).collection(collection.name).document(recipe.recipe.id!).setData(data)
        } else {
            
            COLLECTION_USERS.document(uid).collection("collections").document(collection.id).setData(collectionData)
            
            completion(nil)
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
            
            let data: [String: Any] = ["name": recipe.recipeName!, "cookTime": recipe.recipe.cookTime!, "recipeImageUrl": recipeImageUrl, "id": recipe.recipe.id!, "ownerId": recipe.recipe.ownerId!, "instructions": instructions, "ingredients": ingredients, "category": recipe.category, "rating": 0, "numOfRatings": 0]
            
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
