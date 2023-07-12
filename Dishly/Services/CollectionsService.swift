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
    
    func deleteRecipeFrom(collection: Collection, id: String, completion: @escaping (Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        
        let documentRef = COLLECTION_USERS.document(uid)
            .collection("collections")
            .document(collection.id)
            .collection(collection.name)
            .document(id)
        
        documentRef.delete(completion: completion)
    }

    
    func saveRecipeToCollection(collection: Collection, recipe: RecipeViewModel?, completion: @escaping (Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        
        COLLECTION_USERS.document(uid).collection("collections").getDocuments { snapshot, error in

            if let recipe = recipe {  // add recipe to existing collection
                let instructions = recipe.recipe.instructions.compactMap { $0.text }
                let ingredients = recipe.recipe.ingredients.compactMap { $0.name }
                
                let data = generateRecipeData(for: recipe)

                COLLECTION_USERS.document(uid)
                    .collection("collections")
                    .document(collection.id)
                    .collection(collection.name)
                    .document(recipe.recipe.id ?? "")
                    .setData(data) { error in
                        completion(error)
                    }
            } else {  // create new collection
                
                if let collections = snapshot?.documents {
                    let isCollectionExist = collections.contains { $0["name"] as? String == collection.name }

                    guard !isCollectionExist else {
                        let error = CollectionErrors(errorMessage: "Collection already exists" )
                        completion(error)            // collection already exists
                        return
                    }
                }
                
                let collectionData: [String: Any] = [
                    "name": collection.name,
                    "id": collection.id,
                    "imageUrl": collection.imageUrl
                ]
                
                COLLECTION_USERS.document(uid)
                    .collection("collections")
                    .document(collection.id)
                    .setData(collectionData) { error in
                        completion(error)
                    }
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
                let collectionsArray = self.parseCollectionsSnapshot(snapshot)
                completion(collectionsArray)
            }
    }
    
    func fetchRecipesWith(collection: Collection, completion: @escaping ([RecipeViewModel]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion([])
            return
        }
        
        let dispatchGroup = DispatchGroup()
        var recipesArray: [RecipeViewModel] = []
        
        COLLECTION_USERS.document(uid)
            .collection("collections")
            .document(collection.id)
            .collection(collection.name)
            .getDocuments { snapshot, error in
                if let recipes = snapshot?.documents {
                    for recipe in recipes {
                        if let id = recipe.data()["id"] as? String {
                            dispatchGroup.enter()
                            self.fetchRecipeFromFirestore(id: id) { recipeViewModel in
                                recipesArray.append(recipeViewModel)
                                dispatchGroup.leave()
                            }
                        }
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    completion(recipesArray)
                }
            }
    }
}

//MARK: - Helpers

extension CollectionService {
    
    func fetchRecipeFromFirestore(id: String, completion: @escaping (RecipeViewModel) -> Void) {
        COLLECTION_RECIPES.whereField("id", isEqualTo: id).getDocuments { snapshot, error in
            if let document = snapshot?.documents.first {
                let recipeViewModel = setRecipesConfiguration(recipe: document)
                completion(recipeViewModel!)
            }
        }
    }
    
    func parseCollectionsSnapshot(_ snapshot: QuerySnapshot?) -> [Collection] {
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
        
        return collectionsArray
    }
}
