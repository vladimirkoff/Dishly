//
//  RecipesVMProtocol.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 27.07.2023.
//

import Foundation

protocol RecipesVMProtocol {
    func fetchUser(with id: String, completion: @escaping(UserViewModel) -> ())
}
