//
//  CollectionsService.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 07.07.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol CollectionServiceProtocol {
    func fetchCollections(completion: @escaping([Collection]) -> ())
    func fetchRecipesWith(collection: Collection, completion: @escaping([RecipeViewModel]) -> ())
    func saveRecipeToCollection(collection: Collection, recipe: RecipeViewModel?, completion: @escaping(Error?) -> ())
}

class CollectionService: CollectionServiceProtocol {
    
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
                
                let data: [String: Any] = ["name": recipe.recipeName!, "cookTime": recipe.recipe.cookTime!, "recipeImageUrl": recipe.recipe.recipeImageUrl!, "id": recipe.recipe.id!, "ownerId": recipe.recipe.ownerId!, "instructions": instructions, "ingredients": ingredients, "category": recipe.category, "rating": 0, "numOfRatings": 0, "serve" : recipe.recipe.serve!]
                
                COLLECTION_USERS.document(uid).collection("collections").document(collection.id).collection(collection.name).document(recipe.recipe.id!).setData(data)
            } else {
                
                COLLECTION_USERS.document(uid).collection("collections").document(collection.id).setData(collectionData)
                
                completion(nil)
            }
            
        }
    
    func fetchCollections(completion: @escaping([Collection]) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var collectionsArray: [Collection] = []
        
        COLLECTION_USERS.document(uid).collection("collections").getDocuments { snapshot, error in
            if let collections = snapshot?.documents {
                for collection in collections {
                    let name = collection.data()["name"] as? String ?? ""
                    let url = collection.data()["imageUrl"] as? String ?? ""
                    let id = collection.data()["id"] as? String ?? ""
                    
                    let collectionModel = Collection(name: name, imageUrl: url, id: id)
                    collectionsArray.append(collectionModel)
                }
                completion(collectionsArray)
            }
        }
    }
    
    func fetchRecipesWith(collection: Collection, completion: @escaping([RecipeViewModel]) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var recipesArray: [RecipeViewModel] = []
        
        COLLECTION_USERS.document(uid).collection("collections").document(collection.id).collection(collection.name).getDocuments { snapshot, error in
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
