//
//  RecipeVMProtocol.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 27.07.2023.
//

import Foundation

protocol RecipeVMProtocol {
    func updateRecipe(with data: [String : Any], recipe: String, completion: @escaping(Error?) -> ())
    func updateRecipe(id: String, rating: Float, numOfRating: Int, completion: @escaping(Bool) -> ())
    func getOwnRate(recipeId: String, completion: @escaping (Int) -> ())
}
