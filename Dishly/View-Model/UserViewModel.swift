//
//  UserViewModel.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 26.06.2023.
//

import UIKit

struct UserViewModel {
    private let userService: UserService
    
    func fetchUsers(completion: @escaping (User) -> Void) {
        userService.fetchUser { user in
            print(user.name)
        }
      }
}
