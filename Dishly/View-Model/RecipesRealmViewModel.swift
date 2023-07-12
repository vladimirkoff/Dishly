//
//  RecipesRealmViewModel.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 12.07.2023.
//

import Foundation

class RecipesRealmViewModel {
    private let recipesRealmService: RecipesRealmServiceProtocol!
    
    init(recipesRealmService: RecipesRealmServiceProtocol) {
        self.recipesRealmService = recipesRealmService
    }
    
    func fecthRecipesRealm(completion: @escaping([RecipeViewModel]) -> ()) {
        recipesRealmService.fecthRecipesRealm { recipes in
            completion(recipes)
        }
    }
    
    func addRecipeRealm(recipe: RecipeViewModel, day: String, completion: @escaping(Bool) -> ()) {
        recipesRealmService.addRecipeRealm(recipe: recipe, day: day) { success in
            completion(success)
        }
    }
    
    func updateRecipe(id: String, rating: Float, numOfRating: Int, completion: @escaping(Bool) -> ()) {
        recipesRealmService.updateRecipe(id: id, rating: rating, numOfRating: numOfRating) { success in
            completion(success)
        }
    }
    
    func deleteRecipeRealm(id: String, completion: @escaping(Bool) -> ()) {
        recipesRealmService.deleteRecipeRealm(id: id) { success in
            completion(success)
        }
    }

}
