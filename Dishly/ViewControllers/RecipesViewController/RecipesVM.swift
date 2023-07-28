//
//  RecipesVM.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 27.07.2023.
//

import Foundation

final class RecipesVM: RecipesVMProtocol {
    
    private let userService: UserServiceProtocol
    
    init(
        userService: UserServiceProtocol
    ) {
        self.userService = userService
    }
    
    func fetchUser(with id: String, completion: @escaping(UserViewModel) -> ()) {
        userService.fetchUser(with: id) { user in
            completion(user)
        }
    }
}
