//
//  CollectionServiceProtocol.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 26.07.2023.
//

import Foundation

protocol CollectionServiceProtocol {
    func fetchCollections(completion: @escaping ([Collection]) -> Void)
    func fetchRecipesWith(collection: Collection, completion: @escaping ([RecipeViewModel]) -> Void)
    func saveRecipeToCollection(collection: Collection, recipe: RecipeViewModel, completion: @escaping (Error?) -> Void)
    func deleteRecipeFrom(collection: Collection, id: String, completion: @escaping(Error?) -> ())
    func deleteCollection(id: String, completion: @escaping([Collection], Error?) -> ())
    func addCollection(collection: Collection, completion: @escaping(Error?) -> ())
}
