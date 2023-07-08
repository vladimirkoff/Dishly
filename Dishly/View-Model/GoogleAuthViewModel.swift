

import UIKit

class GoogleAuthViewModel {
    private let googleAuthService: GoogleAuthServiceProtocol
    
    init(googleAuthService: GoogleAuthServiceProtocol) {
        self.googleAuthService = googleAuthService
    }
    
    func signInWithGoogle(with vc: UIViewController, completion: @escaping(Error?, UserViewModel?) -> ()) {
        googleAuthService.signInWithGoogle(with: vc) { error, user in
            completion(error, user)
        }
    }
    
    func checkIfUserLoggedIn(completion: @escaping(UserViewModel) -> ()) {
        googleAuthService.checkIfUserLoggedIn { user, bool in
            if bool {
                completion(user!)
            }
        }
    }
}
