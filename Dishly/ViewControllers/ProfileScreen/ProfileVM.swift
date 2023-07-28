//
//  ProfileVM.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 27.07.2023.
//

import Foundation

final class ProfileVM: ProfileVMProtocol {
    
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
    
    func deleteCurrentUser(completion: @escaping(Error?) -> ()) {
        userRealmService.deleteCurrentUser { error in
            completion(error)
        }
    }
    
    
    func logOut(completion: @escaping(Error?, Bool) -> ()) {
        authService.logOut { error, success in
            completion(error, success)
        }
    }
    
    func fetchUser(completion: @escaping(UserViewModel) -> ()) {
        userService.fetchUser { user in
            completion(user)
        }
    }
}
