

import UIKit

class AuthViewModel {
    private let authService: AuthServiceProtocol

    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }

    func login(email: String, password: String, completion: @escaping (Error?) -> Void) {
        authService.login(email: email, password: password) { error in
            completion(error)
        }
    }
    
    func register(creds: AuthCreds, completion: @escaping (Error?, User?) -> Void) {
        authService.register(creds: creds) { error, user in
            completion(error, user)
        }
    }
    
    func changeEmail(to newEmail: String) {
        authService.changeEmail(to: newEmail)
    }
    
    func logOut(completion: @escaping(Error?, Bool) -> ()) {
        authService.logOut { error, success in
            completion(error, success)
        }
    }
    
    func signInWithGoogle(with vc: UIViewController, completion: @escaping(Error?, User?) -> ()) {
        authService.signInWithGoogle(with: vc) { error, user in
            completion(error, user)
        }
    }
    
    func logOutWithGoogle() {
        authService.logoutWithGoogle()
    }
}
