//
//  UserDefaultsProtocol.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 30.07.2023.
//

import Foundation

protocol UserDefaultsProtocol {
    func getIngredients(completion: @escaping (Result<[Ingredient], Error>) -> ())
    func saveIngredients(completion: @escaping (Result<Void, Error>) -> ())
}
