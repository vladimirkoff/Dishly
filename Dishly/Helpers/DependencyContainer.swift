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
    
    func getAuthService(userService: UserServiceProtocol) -> AuthServiceProtocol {
        return AuthService(userService: userService)
    }
    
    func getUserService() -> UserServiceProtocol {
        return UserService()
    }
    
    func getRecipeService() -> RecipeServiceProtocol {
        return RecipeService()
    }
    
    func getUserRealmService() -> UserRealmServiceProtocol {
        return UserRealmService()
    }
    
    func getGoogleAuthService(userService: UserServiceProtocol) -> GoogleAuthServiceProtocol {
        return GoogleAuthService(userService: userService)
    }
    
    func getCollectionService() -> CollectionServiceProtocol {
        return CollectionService()
    }
    
}
