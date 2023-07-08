//
//  UserViewModel.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 26.06.2023.
//

import UIKit

struct UserViewModel {
    
    private let userService: UserServiceProtocol?
    
    var user: User?
    
    init(user: User?, userService: UserServiceProtocol?) {
        self.userService = userService
        self.user = user
    }
    
    func fetchUser(completion: @escaping(UserViewModel) -> ()) {
        userService!.fetchUser { user in
            completion(user)
        }
    }
    
    func updateUser(with user: UserViewModel, completion: @escaping(Error?) -> ()) {
        userService!.updateUser(changedUser: user) { error in
            completion(error)
        }
    }
}
