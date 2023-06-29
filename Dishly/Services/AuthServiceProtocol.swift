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
    func login(email: String, password: String, completion: @escaping (Bool) -> Void)
    func register(creds: AuthCreds, completion: @escaping (Error?) -> Void)
}

class AuthService: AuthServiceProtocol {
    
    static var shared = AuthService()
    private init() {}
    
    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        // Реализация логики аутентификации через Firebase
    }

    func register(creds: AuthCreds, completion: @escaping (Error?) -> Void) {
        ImageUploader.uploadImage(image: creds.profileImage!) { imageUrl in
            Auth.auth().createUser(withEmail: creds.email, password: creds.password) { res, err in
                if let error = err {
                    completion(error)
                    return
                }
                guard let uid = res?.user.uid else { return }
                
                let data: [String: Any] = ["email": creds.email, "fullName": creds.fullname, "profileImageUrl": imageUrl, "uid": uid, "username": creds.username]
                
                Firestore.firestore().collection("users").document(uid).setData(data, completion: completion)
            }
        }
    }
}
