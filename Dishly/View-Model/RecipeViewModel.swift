//
//  RecipeViewModel.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 22.06.2023.
//

import UIKit

struct RecipeViewModel {
    let recipe: Recipe
    
    func fetchRecipe(with id: String) {
        // here we call functions in RecipesServices to get the particular recipe by its id in Firebase
    }
}
