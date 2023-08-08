//
//  SignUpVM.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 27.07.2023.

import Foundation
import UIKit

final class SignUpVM: SignUpVMProtocol {
    
    private let authService: AuthServiceProtocol
    private let userService: UserServiceProtocol
    private let userRealmService: UserRealmServiceProtocol
    
    init(
        authService: AuthServiceProtocol,
        userService: UserServiceProtocol,
        userRealmService: UserRealmServiceProtocol
    ) {
        self.authService = authService
        self.userService = userService
        self.userRealmService = userRealmService
    }
    
    func fetchUser(completion: @escaping(UserViewModel) -> ()) {
        userService.fetchUser { user in
            completion(user)
        }
    }
    
    func createUser(name: String, email: String, profileImage: Data, id: String, username: String, isCurrentUser: Bool) {
        userRealmService.createUser(name: name, email: email, profileImage: profileImage, id: id, username: username, isCurrentUser: isCurrentUser) { success in
            
        }
    }
    
    func register(creds: AuthCreds, completion: @escaping (Error?, UserViewModel?) -> Void) {
        authService.register(creds: creds) { error, user in
            completion(error, user)
        }
    }
    
}
