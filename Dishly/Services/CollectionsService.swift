import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol CollectionServiceProtocol {
    func fetchCollections(completion: @escaping ([Collection]) -> Void)
    func fetchRecipesWith(collection: Collection, completion: @escaping ([RecipeViewModel]) -> Void)
    func saveRecipeToCollection(collection: Collection, recipe: RecipeViewModel?, completion: @escaping (Error?) -> Void)
    func deleteRecipeFrom(collection: Collection, id: String, completion: @escaping(Error?) -> ())
}

class CollectionService: CollectionServiceProtocol {
    
    func deleteRecipeFrom(collection: Collection, id: String, completion: @escaping(Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_USERS.document(uid).collection("collections").document(collection.id).collection(collection.name).document(id).delete(completion: completion)
    }
    
    func saveRecipeToCollection(collection: Collection, recipe: RecipeViewModel?, completion: @escaping (Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_USERS.document(uid).collection("collections").getDocuments { snapshot, error in
            if let collections = snapshot?.documents {
                for collectionModel in collections {
                    let name = collectionModel["name"] as? String ?? ""
                    if name == collection.name {
                        return
                    }
                }
                
                let collectionData: [String: Any] = [
                    "name": collection.name,
                    "id": collection.id,
                    "imageUrl": collection.imageUrl
                ]
                
                if let recipe = recipe {
                    let instructions = recipe.recipe.instructions.compactMap { $0.text }
                    let ingredients = recipe.recipe.ingredients.compactMap { $0.name }
                    
                    let data: [String: Any] = [
                        "name": recipe.recipe.name ?? "",
                        "cookTime": recipe.recipe.cookTime ?? "",
                        "recipeImageUrl": recipe.recipe.recipeImageUrl ?? "",
                        "id": recipe.recipe.id ?? "",
                        "ownerId": recipe.recipe.ownerId ?? "",
                        "instructions": instructions,
                        "ingredients": ingredients,
                        "category": recipe.recipe.category.rawValue,
                        "rating": 0,
                        "numOfRatings": 0,
                        "serve": recipe.recipe.serve ?? ""
                    ]
                    
                    COLLECTION_USERS.document(uid)
                        .collection("collections")
                        .document(collection.id)
                        .collection(collection.name)
                        .document(recipe.recipe.id ?? "")
                        .setData(data)
                } else {
                    COLLECTION_USERS.document(uid)
                        .collection("collections")
                        .document(collection.id)
                        .setData(collectionData)
                }
                
                completion(nil)
                
            }
        }
        
       
    }
    
    func fetchCollections(completion: @escaping ([Collection]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion([])
            return
        }
        
        COLLECTION_USERS.document(uid)
            .collection("collections")
            .getDocuments { snapshot, error in
                var collectionsArray: [Collection] = []
                
                if let collections = snapshot?.documents {
                    for collection in collections {
                        let name = collection.data()["name"] as? String ?? ""
                        let url = collection.data()["imageUrl"] as? String ?? ""
                        let id = collection.data()["id"] as? String ?? ""
                        
                        let collectionModel = Collection(name: name, imageUrl: url, id: id)
                        collectionsArray.append(collectionModel)
                    }
                }
                
                completion(collectionsArray)
            }
    }
    
    func fetchRecipesWith(collection: Collection, completion: @escaping ([RecipeViewModel]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion([])
            return
        }
        
        COLLECTION_USERS.document(uid)
            .collection("collections")
            .document(collection.id)
            .collection(collection.name)
            .getDocuments { snapshot, error in
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
