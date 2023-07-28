//
//  SavedVM.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 27.07.2023.
//

import Foundation
import UIKit

final class SavedVM: SavedVMProtocol {
    
    private let collectionService: CollectionServiceProtocol
    private let userService: UserServiceProtocol
    
    init(
        collectionService: CollectionServiceProtocol,
        userService: UserServiceProtocol
    ) {
        self.collectionService = collectionService
        self.userService = userService
    }
    
    func addCollection(collection: Collection, completion: @escaping(Error?) -> ()) {
        collectionService.addCollection(collection: collection) { error in
            completion(error)
        }
    }
    
    func fetchCollections(completion: @escaping([Collection]) -> ()) {
        collectionService.fetchCollections { collections in
            completion(collections)
        }
    }
    
    func fetchUser(with id: String, completion: @escaping(UserViewModel) -> ()) {
        userService.fetchUser(with: id) { user in
            completion(user)
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
    
    func fetchRecipesWith(collection: Collection, completion: @escaping([RecipeViewModel]) -> ()) {
        collectionService.fetchRecipesWith(collection: collection) { recipes in
            completion(recipes)
        }
    }
    
}


