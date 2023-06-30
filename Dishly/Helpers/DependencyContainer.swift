//
//  DependencyContainer.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 30.06.2023.
//

import Foundation

class DependencyContainer {
    static let shared = DependencyContainer()
    
    private init() {}
    
    func getAuthService() -> AuthServiceProtocol {
        return AuthService()
    }
    
    func getUserService() -> UserServiceProtocol {
        return UserService()
    }
    
    func getRecipeService() -> RecipeServiceProtocol {
        return RecipeService()
    }
    
    
}
