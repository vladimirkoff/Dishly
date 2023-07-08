//
//  AuthService.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 22.06.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

protocol AuthServiceProtocol {
    func login(email: String, password: String, completion: @escaping (Error?) -> Void)
    func register(creds: AuthCreds, completion: @escaping (Error?, UserViewModel?) -> Void)
    func logOut(completion: @escaping(Error?, Bool) -> ())
    func changeEmail(to newEmail: String)
    func checkIfUserLoggedIn(completion: @escaping(UserViewModel?, Bool) -> ())
}

class AuthService: AuthServiceProtocol {
    
    private let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    func login(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { res, err in
            completion(err)
        }
    }
    
    func checkIfUserLoggedIn(completion: @escaping(UserViewModel?, Bool) -> ()) {
        let currentUser = Auth.auth().currentUser
        
        if let _ = currentUser {
            userService.fetchUser { user in
                completion(user, true)
            }
        } else {
            completion(nil, false)
        }
    }
    
    func register(creds: AuthCreds, completion: @escaping (Error?, UserViewModel?) -> Void) {
        ImageUploader.shared.uploadImage(image: creds.profileImage!, forRecipe: false) { imageUrl in
            self.userService.checkIfUserExists(email: creds.email) { doesExist in
                if !doesExist {
                    Auth.auth().createUser(withEmail: creds.email, password: creds.password) { res, err in
                        if let error = err {
                            completion(error, nil)
                            return
                        }
                        guard let uid = res?.user.uid else { return }
                        self.userService.createUser(name: creds.fullname, email: creds.email, username: creds.username, profileUrl: imageUrl, uid: uid) { error, user in
                            completion(error, user)
                        }
                    }
                } else {
                    completion(nil, nil)
                    return
                }
            }
            
        }
    }
    
    func logOut(completion: @escaping(Error?, Bool) -> ()) {
        do {
            try Auth.auth().signOut()
            completion(nil, true)
        } catch {
            print("DEBUG: Error logging out - \(error.localizedDescription)")
            completion(error, false)
        }
    }
    
    func changeEmail(to newEmail: String) {
        guard let user = Auth.auth().currentUser else { return }
        user.updateEmail(to: newEmail) { error in
            if let error = error {
                print("Error updating email:", error.localizedDescription)
                return
            }
            print("Email updated successfully")
        }
    }
}


