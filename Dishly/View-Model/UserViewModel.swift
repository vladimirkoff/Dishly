//
//  UserViewModel.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 26.06.2023.
//

import UIKit

struct UserViewModel {
    
    private let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    func fetchUser(completion: @escaping(User) -> ()) {
        userService.fetchUser { user in
            completion(user)
        }
    }
    
    func updateUser(with user: User, completion: @escaping(Error?) -> ()) {
        userService.updateUser(changedUser: user) { error in
            print("Success")
            completion(error)
        }
    }
}
