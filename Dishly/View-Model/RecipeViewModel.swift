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
    
    var recipeName: String? { return recipe.name }
    var category: String { return self.recipe.category.rawValue }
    var ingredients: [Ingredient] { return recipe.ingredients }
    var instructions: [Instruction] { return recipe.instructions }
    
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

    func fetchRecipes(completion: @escaping ([Recipe]) -> Void) {
        guard let recipeService = recipeService else { return }
        recipeService.fetchRecipes { recipes in
            completion(recipes)
        }
    }
    
    func fetchRecipe(with id: String) {
        
    }
}

