//
//  CollectionViewModel.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 07.07.2023.
//

import UIKit

class CollectionViewModel {
    private let collectionService: CollectionServiceProtocol
    
    var collection: Collection?
    
    init(collectionService: CollectionServiceProtocol, collection: Collection?) {
        self.collectionService = collectionService
        self.collection = collection
    }
    
    func fetchCollections(completion: @escaping([Collection]) -> ()) {
        collectionService.fetchCollections { collections in
            completion(collections)
        }
    }
    
    func fetchRecipesWith(collection: Collection, completion: @escaping([RecipeViewModel]) -> ()) {
        collectionService.fetchRecipesWith(collection: collection) { recipes in
            completion(recipes)
        }
    }
    
    func addCollection(collection: Collection, completion: @escaping(Error?) -> ()) {
        collectionService.addCollection(collection: collection) { error in
            completion(error)
        }
    }
    
    func saveToCollection(collection: Collection, recipe: RecipeViewModel, completion: @escaping(Error?) -> ()) {
        collectionService.saveRecipeToCollection(collection: collection, recipe: recipe) { error in
            completion(error)
        }
    }
    
    func deleteRecipeFrom(collection: Collection, id: String, completion: @escaping(Error?) -> ()) {
        collectionService.deleteRecipeFrom(collection: collection, id: id) { error in
            completion(error)
        }
    }
    
    func deleteCollection(id: String, completion: @escaping([Collection], Error?) -> ()) {
        collectionService.deleteCollection(id: id) { collectons, error in
            completion(collectons, error)
        }
    }
    
}
