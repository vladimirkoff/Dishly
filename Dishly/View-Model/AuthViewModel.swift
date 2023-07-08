

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
    
    func register(creds: AuthCreds, completion: @escaping (Error?, UserViewModel?) -> Void) {
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
    
    func checkIfUserExists(completion: @escaping(UserViewModel) -> ()) {
        authService.checkIfUserLoggedIn { user, bool in
            if bool {
                completion(user!)
            }
        }
    }
    
    
}
