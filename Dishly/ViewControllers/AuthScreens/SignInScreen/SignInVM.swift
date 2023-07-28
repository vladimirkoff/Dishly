//
//  SignInVM.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 27.07.2023.
//

import Foundation
import UIKit

final class SignInVM: SignInVMProtocol {
    
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
    
    func login(email: String, password: String, completion: @escaping (Error?) -> Void) {
        authService.login(email: email, password: password) { error in
            completion(error)
        }
    }
    
    func createUser(name: String, email: String, profileImage: Data, id: String, username: String, isCurrentUser: Bool) {
        userRealmService.createUser(name: name, email: email, profileImage: profileImage, id: id, username: username, isCurrentUser: isCurrentUser) { success in
            print(success)
        }
    }
    
}
