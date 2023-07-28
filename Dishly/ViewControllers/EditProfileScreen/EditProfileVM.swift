//
//  EditProfileVM.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 27.07.2023.
//

import Foundation

final class EditProfileVM: EditProfileVMProtocol {
    
    private let userService: UserServiceProtocol
    private let userRealmService: UserRealmServiceProtocol
    private let authService: AuthServiceProtocol
    
    init(
        userService: UserServiceProtocol,
        userRealmService: UserRealmServiceProtocol,
        authService: AuthServiceProtocol
    ) {
        self.userService = userService
        self.userRealmService = userRealmService
        self.authService = authService
    }
    
    func updateUser(with user: UserViewModel, completion: @escaping(Error?) -> ()) {
        userService.updateUser(changedUser: user) { error in
            completion(error)
        }
    }
    
    func updateUser(user: User, completion: @escaping(Bool) -> ()) {
        userRealmService.updateUser(user: user) { success in
            completion(success)
        }
    }
    
    func changeEmail(to newEmail: String, completion: @escaping(Error?) -> ()) {
        authService.changeEmail(to: newEmail) { error in
            completion(error)
        }
    }
}
