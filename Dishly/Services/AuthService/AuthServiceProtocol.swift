//
//  AuthServiceProtocol.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 26.07.2023.
//

import Foundation

protocol AuthServiceProtocol {
    func login(email: String, password: String, completion: @escaping (Error?) -> Void)
    func register(creds: AuthCreds, completion: @escaping (Error?, UserViewModel?) -> Void)
    func logOut(completion: @escaping (Error?, Bool) -> Void)
    func changeEmail(to newEmail: String, completion: @escaping(Error?) -> ())
    func checkIfUserLoggedIn(completion: @escaping (UserViewModel?, Bool) -> Void)
}
