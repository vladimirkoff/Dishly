//
//  RecipesRealmServiceProtocol.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 26.07.2023.
//

import Foundation

protocol RecipesRealmServiceProtocol {
    func addRecipeRealm(recipe: RecipeViewModel, day: String, completion: @escaping(Bool) -> ())
    func fecthRecipesRealm(completion: @escaping([RecipeViewModel]) -> ())
    func updateRecipe(id: String, rating: Float, numOfRating: Int, completion: @escaping(Bool) -> ())
    func deleteRecipeRealm(id: String, completion: @escaping(Bool) -> ())
}
