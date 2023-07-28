//
//  SignInVMProtocol.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 27.07.2023.
//

import Foundation

protocol SignInVMProtocol {
    func login(email: String, password: String, completion: @escaping (Error?) -> Void)
    func fetchUser(completion: @escaping(UserViewModel) -> ())
    func createUser(name: String, email: String, profileImage: Data, id: String, username: String, isCurrentUser: Bool)
}
