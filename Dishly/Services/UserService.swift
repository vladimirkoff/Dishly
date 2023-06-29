//
//  UserService.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 25.06.2023.
//

import Foundation

protocol UserServiceProtocol {
    func fetchUser(completion: @escaping (User) -> Void)
}

class UserService: UserServiceProtocol  {
    
    static var shared = UserService()
    private init() {}
    
    func fetchUser(completion: @escaping (User) -> Void) {
        
    }
    
    
    
}
