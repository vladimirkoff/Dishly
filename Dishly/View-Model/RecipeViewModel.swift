//
//  RecipeViewModel.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 22.06.2023.
//

import UIKit

import UIKit

struct RecipeViewModel {
    //MARK: - Properties
    private let recipeService: RecipeServiceProtocol?
    
    var recipe: Recipe
    
    var recipeImage: UIImageView?
    
    //MARK: - Init
    
    init(recipe: Recipe, recipeService: RecipeServiceProtocol?) {
        self.recipe = recipe
        self.recipeService = recipeService
    }
    
    //MARK: - Methods
    
    func getOwnRate(recipeId: String, completion: @escaping (Int) -> ()) {
        guard let recipeService = recipeService else { return }
        recipeService.getOwnRate(recipeId: recipeId) { rate in
            completion(rate)
        }
    }
    
    func createRecipe(image: UIImage, completion: @escaping(Error?) -> ()) {
        guard let recipeService = recipeService else { return }
        recipeService.createRecipe(recipe: self, image: image) { error in
            completion(error)
        }
    }
    
    func fetchRecipes(completion: @escaping ([RecipeViewModel]?, Error?) -> Void) {
        guard let recipeService = recipeService else { return }
        recipeService.fetchRecipes { recipes, error in
            completion(recipes, error)
        }
    }
    
    func updateRecipe(with data: [String : Any], recipe: String, completion: @escaping(Error?) -> ()) {
        guard let recipeService = recipeService else { return }
        recipeService.updateRating(with: data, recipe: recipe, completion: { error in
            completion(error)
        })
    }
    
    func fetchRecipesFor(category: String, completion: @escaping([RecipeViewModel]?, Error?) -> ()) {
        guard let recipeService = recipeService else { return }
        recipeService.fetchRecipesFor(category: category, completion: { recipes, error in
            completion(recipes, error)
        })
    }
}

