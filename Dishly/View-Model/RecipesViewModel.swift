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
    
    func fetchRecipes(completion: @escaping([RecipeViewModel]) -> ()) {
        recipeService.fetchRecipes { recipes in
            completion(recipes)
        }
    }
    
    func fetchRecipesWith(category: Recipe.Category, completion: @escaping([RecipeViewModel]) -> ()) {
        recipeService.fetchRecipesWith(category: category) { recipes in
            completion(recipes)
        }
    }
    
    func searchForRecipes(text: String, completion: @escaping([RecipeViewModel]) -> ()) {
        recipeService.searchForRecipes(text: text) { recipes in
            completion(recipes)
        }
    }
}
