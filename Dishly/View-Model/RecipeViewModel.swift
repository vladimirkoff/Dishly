//
//  RecipeViewModel.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 22.06.2023.
//

import UIKit

import Foundation

struct RecipeViewModel {
    //MARK: - Properties
    private let recipeService: RecipeServiceProtocol?
    
    var recipe: Recipe
    
    //MARK: - Init
    
    init(recipe: Recipe, recipeService: RecipeServiceProtocol?) {
        self.recipe = recipe
        self.recipeService = recipeService
    }
    
    //MARK: - Methods
    
    func createRecipe(image: UIImage, completion: @escaping(Error?) -> ()) {
        guard let recipeService = recipeService else { return }
        recipeService.createRecipe(recipe: self, image: image) { error in
            completion(error)
        }
    }
    
    func fetchRecipes(completion: @escaping ([RecipeViewModel]) -> Void) {
        guard let recipeService = recipeService else { return }
        recipeService.fetchRecipes { recipes in
            completion(recipes)
        }
    }
    
    func updateRecipe(with data: [String : Any], recipe: String, completion: @escaping(Error?) -> ()) {
        guard let recipeService = recipeService else { return }
        recipeService.updateRating(with: data, recipe: recipe, completion: { error in
            completion(error)
        })
    }
    
    func fetchRecipesFor(category: String, completion: @escaping([RecipeViewModel]) -> ()) {
        guard let recipeService = recipeService else { return }
        recipeService.fetchRecipesFor(category: category, completion: { recipes in
            completion(recipes)
        })
    }
}

