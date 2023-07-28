//
//  ExploreVM.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 27.07.2023.
//

import Foundation
import UIKit

final class ExploreVM: ExploreVMProtocol {
  
    private let collectionService: CollectionServiceProtocol
    private let recipeService: RecipeServiceProtocol
    private let userService: UserServiceProtocol
    
    init(
        collectionService: CollectionServiceProtocol,
        recipeService: RecipeServiceProtocol,
        userService: UserServiceProtocol
    ) {
        self.collectionService = collectionService
        self.recipeService = recipeService
        self.userService = userService
    }
    
    func fetchUser(with id: String, completion: @escaping(UserViewModel) -> ()) {
        userService.fetchUser(with: id) { user in
            completion(user)
        }
    }
    
    func fetchRecipesFor(category: String, completion: @escaping([RecipeViewModel]?, Error?) -> ()) {
        recipeService.fetchRecipesFor(category: category, completion: { recipes, error in
            completion(recipes, error)
        })
    }
    
    func fetchRecipes(completion: @escaping ([RecipeViewModel]?, Error?) -> Void) {
        recipeService.fetchRecipes { recipes, error in
            completion(recipes, error)
        }
    }
    
    func saveToCollection(collection: Collection, recipe: RecipeViewModel, completion: @escaping(Error?) -> ()) {
        collectionService.saveRecipeToCollection(collection: collection, recipe: recipe) { error in
            completion(error)
        }
    }
    
    func fetchCollections(completion: @escaping([Collection]) -> ()) {
        collectionService.fetchCollections { collections in
            completion(collections)
        }
    }
    
    func addCollection(collection: Collection, completion: @escaping(Error?) -> ()) {
        collectionService.addCollection(collection: collection) { error in
            completion(error)
        }
    }
    
}
