//
//  SearchVM.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 27.07.2023.
//

import Foundation

final class SearchVM: SearchVMProtocol {
    
    private let recipeService: RecipeServiceProtocol
    
    init(
        recipeService: RecipeServiceProtocol
    ) {
        self.recipeService = recipeService
    }
    
    func searchForRecipes(text: String, completion: @escaping([RecipeViewModel]?, Error?) -> ()) {
        recipeService.searchForRecipes(text: text) { recipes, error in
            completion(recipes, error)
        }
    }
}
