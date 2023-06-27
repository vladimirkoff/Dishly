//
//  AuthService.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 22.06.2023.
//

import Foundation

protocol AuthServiceProtocol {
    func login(email: String, password: String, completion: @escaping (Bool) -> Void)
    func register(email: String, password: String, completion: @escaping (Bool) -> Void)
}

class AuthService: AuthServiceProtocol {
    
    static var shared = AuthService()
    init() {}
    
    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        // Реализация логики аутентификации через Firebase
    }

    func register(email: String, password: String, completion: @escaping (Bool) -> Void) {
        // Реализация логики регистрации через Firebase
    }
}
