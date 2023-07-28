import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseCore
import GoogleSignIn


class AuthService: AuthServiceProtocol {
    private let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    func login(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            completion(error)
        }
    }
    
    func checkIfUserLoggedIn(completion: @escaping (UserViewModel?, Bool) -> Void) {
        if let _ = Auth.auth().currentUser {
            userService.fetchUser { user in
                completion(user, true)
            }
        } else {
            completion(nil, false)
        }
    }
    
    func register(creds: AuthCreds, completion: @escaping (Error?, UserViewModel?) -> Void) {
        ImageUploader.shared.uploadImage(image: creds.profileImage!, isForRecipe: false) { [weak self] imageUrl in
            guard let self = self else { return }
            self.userService.checkIfUserExists(email: creds.email) { doesExist in
                if !doesExist {
                    Auth.auth().createUser(withEmail: creds.email, password: creds.password) { result, error in
                        if let error = error {
                            completion(error, nil)
                            return
                        }
                        guard let uid = result?.user.uid else { return }
                        self.userService.createUser(name: creds.fullname, email: creds.email, username: creds.username, profileUrl: imageUrl, uid: uid) { error, user in
                            completion(error, user)
                        }
                    }
                } else {
                    completion(AuthErros.userExists, nil)
                }
            }
        }
    }
    
    func logOut(completion: @escaping (Error?, Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil, true)
        } catch {
            print("DEBUG: Error logging out - \(error.localizedDescription)")
            completion(AuthErros.failedToLogout, false)
        }
    }
    
    func changeEmail(to newEmail: String, completion: @escaping (Error?) -> ()) {
        if let user = Auth.auth().currentUser {
            user.updateEmail(to: newEmail) { error in
                if let error = error {
                    print("Error updating email: \(error.localizedDescription)")
                    completion(AuthErros.failedChangeEmail)
                } else {
                    completion(nil)
                }
            }
        } else {
            completion(AuthErros.failedChangeEmail)
        }
    }
}
