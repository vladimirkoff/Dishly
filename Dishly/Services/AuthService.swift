//
//  AuthService.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 22.06.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol AuthServiceProtocol {
    func login(email: String, password: String, completion: @escaping (Error?) -> Void)
    func register(creds: AuthCreds, completion: @escaping (Error?, User?) -> Void)
    func logOut(completion: @escaping(Error?, Bool) -> ())
    func changeEmail(to newEmail: String)
}

class AuthService: AuthServiceProtocol {
    
    func login(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { res, err in
            completion(err)
        }
    }

    func register(creds: AuthCreds, completion: @escaping (Error?, User?) -> Void) {
        ImageUploader.uploadImage(image: creds.profileImage!) { imageUrl in
            Auth.auth().createUser(withEmail: creds.email, password: creds.password) { res, err in
                if let error = err {
                    completion(error, nil)
                    return
                }
                guard let uid = res?.user.uid else { return }
                
                let data: [String: Any] = ["email": creds.email, "fullName": creds.fullname, "profileImage": imageUrl, "uid": uid, "username": creds.username]
                
                Firestore.firestore().collection("users").document(uid).setData(data) { error in
                    let user = User(dictionary: data)
                    if let error = err {
                        completion(error, nil)
                        return
                    }
                    completion(error, user)
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
                // An error occurred while updating the email
                print("Error updating email:", error.localizedDescription)
                return
            }
            // Email updated successfully
            print("Email updated successfully")
        }
    }
}


