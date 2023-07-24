//
//  RecipesViewModel.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 06.07.2023.
//

import Foundation

class RecipesViewModel {
    private let recipeService: RecipeServiceProtocol
    
    init(recipeService: RecipeServiceProtocol) {
        self.recipeService = recipeService
    }
    
    func fetchRecipes(completion: @escaping([RecipeViewModel]?, Error?) -> ()) {
        recipeService.fetchRecipes { recipes, error in
            completion(recipes, error)
        }
    }
    
    func searchForRecipes(text: String, completion: @escaping([RecipeViewModel]?, Error?) -> ()) {
        recipeService.searchForRecipes(text: text) { recipes, error in
            completion(recipes, error)
        }
    }
    

}
