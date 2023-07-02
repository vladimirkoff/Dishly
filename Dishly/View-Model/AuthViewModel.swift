

import Foundation

class AuthenticationViewModel {
    private let authService: AuthServiceProtocol

    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }

    func login(email: String, password: String, completion: @escaping (Error?) -> Void) {
        authService.login(email: email, password: password) { error in
            completion(error)
        }
    }
    

    func register(creds: AuthCreds, completion: @escaping (Error?) -> Void) {
        authService.register(creds: creds) { error in
            completion(error)
        }
    }
}
