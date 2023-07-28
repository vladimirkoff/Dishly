//
//  SavedVCProtocol.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 27.07.2023.
//

import Foundation

protocol SavedVMProtocol {
    func addCollection(collection: Collection, completion: @escaping(Error?) -> ())
    func fetchCollections(completion: @escaping([Collection]) -> ())
    func fetchUser(with id: String, completion: @escaping(UserViewModel) -> ())
    func deleteRecipeFrom(collection: Collection, id: String, completion: @escaping(Error?) -> ())
    func deleteCollection(id: String, completion: @escaping([Collection], Error?) -> ())
    func fetchRecipesWith(collection: Collection, completion: @escaping([RecipeViewModel]) -> ())
}
