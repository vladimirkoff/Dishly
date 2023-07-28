//
//  RecipeVm.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 27.07.2023.
//

import Foundation

final class RecipeVMP: RecipeVMProtocol {
    
    private let recipeService: RecipeServiceProtocol
    private let recipesRealmService: RecipesRealmServiceProtocol
    
    init(
        recipeService: RecipeServiceProtocol,
        recipesRealmService: RecipesRealmServiceProtocol
    ) {
        self.recipeService = recipeService
        self.recipesRealmService = recipesRealmService
    }
    
    func updateRecipe(with data: [String : Any], recipe: String, completion: @escaping(Error?) -> ()) {
        recipeService.updateRating(with: data, recipe: recipe, completion: { error in
            completion(error)
        })
    }
    
    func updateRecipe(id: String, rating: Float, numOfRating: Int, completion: @escaping(Bool) -> ()) {
        recipesRealmService.updateRecipe(id: id, rating: rating, numOfRating: numOfRating) { success in
            completion(success)
        }
    }
    
    func getOwnRate(recipeId: String, completion: @escaping (Int) -> ()) {
        recipeService.getOwnRate(recipeId: recipeId) { rate in
            completion(rate)
        }
    }
}
