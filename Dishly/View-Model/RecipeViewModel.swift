//
//  RecipeViewModel.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 22.06.2023.
//

import UIKit

import Foundation

struct RecipeViewModel {
    private let recipeService: RecipeServiceProtocol

    init(recipeService: RecipeServiceProtocol) {
        self.recipeService = recipeService
    }

    func fetchRecipes(completion: @escaping ([Recipe]) -> Void) {
        recipeService.fetchRecipes { recipes in
            completion(recipes)
        }
    }
}

