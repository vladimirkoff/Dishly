//
//  GoogleAuthViewModel.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 04.07.2023.
//

import UIKit

class GoogleAuthViewModel {
    private let googleAuthService: GoogleAuthServiceProtocol
    
    init(googleAuthService: GoogleAuthServiceProtocol) {
        self.googleAuthService = googleAuthService
    }
    
    func signInWithGoogle(with vc: UIViewController, completion: @escaping(Error?, User?) -> ()) {
        googleAuthService.signInWithGoogle(with: vc) { error, user in
            completion(error, user)
        }
    }
    
    func checkIfUserLoggedIn(completion: @escaping(User) -> ()) {
        googleAuthService.checkIfUserLoggedIn { user, bool in
            if bool {
                completion(user!)
            }
        }
    }
}
