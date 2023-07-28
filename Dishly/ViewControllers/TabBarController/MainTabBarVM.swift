//
//  MainTabBarVM.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 27.07.2023.
//

import Foundation

final class MainTabBarVM: MainTabBarVMProtocol {
    
    private let recipeService: RecipeServiceProtocol
    
    init(
        recipeService: RecipeServiceProtocol
    ) {
        self.recipeService = recipeService
    }
    
    func fetchRecipes(completion: @escaping([RecipeViewModel]?, Error?) -> ()) {
        recipeService.fetchRecipes { recipes, error in
            completion(recipes, error)
        }
    }
}
