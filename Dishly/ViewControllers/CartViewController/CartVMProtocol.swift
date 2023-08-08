//
//  CartVMProtocol.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 30.07.2023.
//

import Foundation

protocol CartVMProtocol {
    func saveIngredients(completion: @escaping (Result<Void, Error>) -> ())
}
