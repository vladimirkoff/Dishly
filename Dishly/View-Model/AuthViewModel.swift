

import Foundation

class AuthenticationViewModel {
    private let authService: AuthService

    init(authService: AuthService) {
        self.authService = authService
    }

    func login(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
//        authService.login(email: email, password: password) { success, error in
//            completion(success, error)
//        }
    }

    func signUp(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
//        authService.signUp(email: email, password: password) { success, error in
//            completion(success, error)
//        }
    }
}
