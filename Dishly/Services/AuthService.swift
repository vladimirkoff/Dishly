//
//  AuthService.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 22.06.2023.
//

import Foundation

protocol AuthService {
    func login(email: String, password: String, completion: @escaping (Bool) -> Void)
    func register(email: String, password: String, completion: @escaping (Bool) -> Void)
}

class FirebaseAuthService: AuthService {
    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        // Реализация логики аутентификации через Firebase
        // Вызовите completion с результатом успешного или неуспешного входа
    }

    func register(email: String, password: String, completion: @escaping (Bool) -> Void) {
        // Реализация логики регистрации через Firebase
        // Вызовите completion с результатом успешной или неуспешной регистрации
    }
}
