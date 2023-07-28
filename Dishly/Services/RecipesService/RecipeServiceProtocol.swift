//
//  RecipeServiceProtocol.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 26.07.2023.
//

import UIKit

protocol RecipeServiceProtocol {
    func fetchRecipes(completion: @escaping ([RecipeViewModel]?, Error?) -> Void)
    func createRecipe(recipe: RecipeViewModel, image: UIImage, completion: @escaping (Error?) -> ())
    func updateRating(with data: [String: Any],recipe: String, completion: @escaping (Error?) -> ())
    func fetchRecipesFor(category: String, completion: @escaping([RecipeViewModel]?, Error?) -> ())
    func searchForRecipes(text: String, completion: @escaping([RecipeViewModel]?, Error?) -> ())
    func getOwnRate(recipeId: String, completion: @escaping(Int) -> ())
}
