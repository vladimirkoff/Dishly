//
//  UserRealmViewModel.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 02.07.2023.
//

import Foundation


struct UserRealmViewModel {
    
    private let userRealmService: UserRealmServiceProtocol
    
    init(userRealmService: UserRealmServiceProtocol) {
        self.userRealmService = userRealmService
    }
    
    func createUser(name: String, email: String, profileImage: Data, id: String) {
        userRealmService.createUser(name: name, email: email, profileImage: profileImage, id: id) { success in
            print(success)
        }
    }
    
    func getUser(with id: String, completion: @escaping(User) -> ()) {
        userRealmService.getUser(with: id) { user in
            completion(user)
        }
    }
    
    func updateUser(user: User, completion: @escaping(Bool) -> ()) {
        userRealmService.updateUser(user: user) { success in
            completion(success)
        }
    }
}
