//
//  GreetVM.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 27.07.2023.
//

import Foundation
import UIKit

final class GreetVM: GreetVMProtocol {
    
    private let googleAuthService: GoogleAuthServiceProtocol
    private let userRealmService: UserRealmServiceProtocol
    
    init(
        googleAuthService: GoogleAuthServiceProtocol,
        userRealmService: UserRealmServiceProtocol
    ) {
        self.googleAuthService = googleAuthService
        self.userRealmService = userRealmService
    }
    
    func signInWithGoogle(with vc: UIViewController, completion: @escaping(Error?, UserViewModel?) -> ()) {
        googleAuthService.signInWithGoogle(with: vc) { error, user in
            completion(error, user)
        }
    }
    
    func createUser(name: String, email: String, profileImage: Data, id: String, username: String, isCurrentUser: Bool) {
        userRealmService.createUser(name: name, email: email, profileImage: profileImage, id: id, username: username, isCurrentUser: isCurrentUser) { success in
            print(success)
        }
    }
}
