//
//  CartVM.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 30.07.2023.
//

import Foundation

final class CartViewModel {
    private let userDefaultsService: UserDefaultsProtocol
    
    init(userDefaultsService: UserDefaultsProtocol) {
        self.userDefaultsService = userDefaultsService
    }
    
    func getIngredients(completion: @escaping(Result<[Ingredient], Error>) -> ()) {
        userDefaultsService.getIngredients { result in
            completion(result)
        }
    }
    
    func saveIngredients(completion: @escaping (Result<Void, Error>) -> ()) {
        userDefaultsService.saveIngredients { result in
            completion(result)
        }
    }
}
