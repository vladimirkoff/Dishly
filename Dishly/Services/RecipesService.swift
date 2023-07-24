import UIKit
import FirebaseAuth
import FirebaseFirestore

protocol RecipeServiceProtocol {
    func fetchRecipes(completion: @escaping ([RecipeViewModel]?, Error?) -> Void)
    func createRecipe(recipe: RecipeViewModel, image: UIImage, completion: @escaping (Error?) -> ())
    func updateRating(with data: [String: Any],recipe: String, completion: @escaping (Error?) -> ())
    func fetchRecipesFor(category: String, completion: @escaping([RecipeViewModel]?, Error?) -> ())
    func searchForRecipes(text: String, completion: @escaping([RecipeViewModel]?, Error?) -> ())
    func getOwnRate(recipeId: String, completion: @escaping(Int) -> ())
}
class RecipeService: RecipeServiceProtocol {
    
    func searchForRecipes(text: String, completion: @escaping([RecipeViewModel]?, Error?) -> ()) {
        COLLECTION_RECIPES.getDocuments { snapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }
            var recipesArray: [RecipeViewModel] = []
            if let recipes = snapshot?.documents {
                for recipe in recipes {
                    let name = recipe.data()["name"] as? String ?? ""
                    
                    if name.starts(with: text) {
                        guard let recipeViewModel =  setRecipesConfiguration(recipe: recipe) else { return }
                        recipesArray.append(recipeViewModel)
                    }
                }
                completion(recipesArray, nil)
            }
        }
    }
    
    func updateRating(with data: [String: Any], recipe: String, completion: @escaping (Error?) -> ()) {
        COLLECTION_RECIPES.document(recipe).updateData(data) { error in
            if let error = error {
                completion(error)
                return
            }
            COLLECTION_RECIPES.document(recipe).addSnapshotListener { snapshot, error in
                if let error = error {
                    completion(error)
                    return
                }
                if let category = snapshot?.data()?["category"] as? String, let ownerId = snapshot?.data()?["ownerId"] as? String {
                    Firestore.firestore().collection(category).document(recipe).updateData(data) { error in
                        if let error = error {
                            completion(error)
                            return
                        }
                        COLLECTION_USERS.document(ownerId).collection("recipes").document(recipe).updateData(data)
                    }
                }
            }
        }
        
    }
    
    func fetchRecipesFor(category: String, completion: @escaping([RecipeViewModel]?, Error?) -> ()) {
        var recipesArray: [RecipeViewModel] = []
        
        Firestore.firestore().collection(category).getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error)
                return
            }
            if let recipes = snapshot?.documents {
                for recipe in recipes {
                    guard let recipeViewModel = setRecipesConfiguration(recipe: recipe) else { return }
                    recipesArray.append(recipeViewModel)
                }
                completion(recipesArray, nil)
            }
        }
    }
    
    func createRecipe(recipe: RecipeViewModel, image: UIImage, completion: @escaping (Error?) -> ()) {
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
                            completion(error)
                            return
                        }
                        Firestore.firestore().collection(recipe.recipe.category.rawValue).document(recipe.recipe.id ?? "")
                            .setData(data) { error in
                                if let error = error {
                                    print(error.localizedDescription)
                                    completion(error)
                                    return
                                }
                            }
                    }
                
                completion(nil)
            }
        }
    }
    
    func getOwnRate(recipeId: String, completion: @escaping (Int) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(0)
            return
        }

        COLLECTION_RECIPES.getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                completion(0)
                return
            }

            if let documents = snapshot?.documents {
                for document in documents {
                    if let documentId = document.data()["id"] as? String, documentId == recipeId {
                        if let rates = document.data()["numOfRatings"] as? [[String: Any]] {
                            for rate in rates {
                                if let rateUid = rate["uid"] as? String, rateUid == uid {
                                    if let rating = rate["rating"] as? Int {
                                        completion(rating)
                                        return
                                    }
                                }
                            }
                        }
                    }
                }
            }

            completion(0)
        }
    }

    
    func fetchRecipes(completion: @escaping ([RecipeViewModel]?, Error?) -> ()) {
        COLLECTION_RECIPES.getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error)
                return
            }
            
            var recipesArray: [RecipeViewModel] = []
            
            if let recipes = snapshot?.documents {
                for recipe in recipes {
                    guard let recipeViewModel = setRecipesConfiguration(recipe: recipe) else { return }
                    recipesArray.append(recipeViewModel)
                }
            }
            completion(recipesArray, nil)
        }
    }
}

