

import Foundation

class AuthenticationViewModel {
    private let authService: AuthServiceProtocol

    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }

    func login(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
//        authService.login(email: email, password: password) { success, error in
//            completion(success, error)
//        }
    }

    func register(creds: AuthCreds, completion: @escaping (Error?) -> Void) {
        authService.register(creds: creds) { error in
            completion(error)
        }
    }
}
