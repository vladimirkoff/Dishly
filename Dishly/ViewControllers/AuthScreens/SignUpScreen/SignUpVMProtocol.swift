//
//  SignUpVMProtocol.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 27.07.2023.
//

import Foundation

protocol SignUpVMProtocol {
    func fetchUser(completion: @escaping(UserViewModel) -> ())
    func createUser(name: String, email: String, profileImage: Data, id: String, username: String, isCurrentUser: Bool)
    func register(creds: AuthCreds, completion: @escaping (Error?, UserViewModel?) -> Void)
}
