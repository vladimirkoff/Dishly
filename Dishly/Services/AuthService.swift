import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

protocol AuthServiceProtocol {
    func login(email: String, password: String, completion: @escaping (Error?) -> Void)
    func register(creds: AuthCreds, completion: @escaping (Error?, UserViewModel?) -> Void)
    func logOut(completion: @escaping (Error?, Bool) -> Void)
    func changeEmail(to newEmail: String)
    func checkIfUserLoggedIn(completion: @escaping (UserViewModel?, Bool) -> Void)
}

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
        if let currentUser = Auth.auth().currentUser {
            userService.fetchUser { user in
                completion(user, true)
            }
        } else {
            completion(nil, false)
        }
    }
    
    func register(creds: AuthCreds, completion: @escaping (Error?, UserViewModel?) -> Void) {
        ImageUploader.shared.uploadImage(image: creds.profileImage!, isForRecipe: false) { imageUrl in
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
                    completion(nil, nil)
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
            completion(error, false)
        }
    }
    
    func changeEmail(to newEmail: String) {
        if let user = Auth.auth().currentUser {
            user.updateEmail(to: newEmail) { error in
                if let error = error {
                    print("Error updating email: \(error.localizedDescription)")
                    return
                }
                print("Email updated successfully")
            }
        }
    }
}
