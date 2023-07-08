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
        guard let userService = userService else { return }
        userService.fetchUser { user in
            completion(user)
        }
    }
    
    func fetchUser(with id: String, completion: @escaping(UserViewModel) -> ()) {
        guard let userService = userService else { return }
        userService.fetchUser(with: id) { user in
            completion(user)
        }
    }
    
    func updateUser(with user: UserViewModel, completion: @escaping(Error?) -> ()) {
        guard let userService = userService else { return }
        userService.updateUser(changedUser: user) { error in
            completion(error)
        }
    }
}
