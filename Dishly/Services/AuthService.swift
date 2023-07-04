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
    func register(creds: AuthCreds, completion: @escaping (Error?, User?) -> Void)
    func logOut(completion: @escaping(Error?, Bool) -> ())
    func changeEmail(to newEmail: String)
    func signInWithGoogle(with vc: UIViewController, completion: @escaping(Error?, User?) -> ())
    func logoutWithGoogle()
}

class AuthService: AuthServiceProtocol {
    
    func signInWithGoogle(with vc: UIViewController, completion: @escaping(Error?, User?) -> ()) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: vc) { result, error in
            guard error == nil else { return }
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            if let email = user.profile?.email, let name = user.profile?.name, let profileImageUrl = user.profile?.imageURL(withDimension: 200) {
                self.checkIfUserExists(email: email) { doesExist in
                    if !doesExist {
                        let urlString = profileImageUrl.absoluteString
                        let username = generateRandomUsername()
                        self.createUserWithGoogle(name: name, email: email, username: username, profileUrl: urlString, uid: UUID().uuidString) { error, user in
                            completion(error, user)
                        }
                        return
                    } else {
                        self.getUser(by: email) { user in
                            let urlString = profileImageUrl.absoluteString
                            let username = generateRandomUsername()
                            self.createUserWithGoogle(name: name, email: email, username: username, profileUrl: urlString, uid: UUID().uuidString) { error, user in
                                completion(error, user)
                            }
                            return
                        }
                    }
                }

                
            }
        }
    }
    
    func logoutWithGoogle() {
        
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
    func getUser(by email: String, completion: @escaping(User) -> ()) {
        Firestore.firestore().collection("users").getDocuments { snapshot, error in
            if let users = snapshot?.documents {
                for user in users {
                    if user.data()["email"] as! String == email {
                        let dictionary = user.data()
                        let userModel = User(dictionary: dictionary)
                        completion(userModel)
                        return
                    }
                }
            }
        }
    }
    
    func checkIfUserExists(email: String, completion: @escaping(Bool) -> ()) {
        Firestore.firestore().collection("users").getDocuments { snapshot, error in
            if let users = snapshot?.documents {
                for user in users {
                    if user.data()["email"] as! String == email {
                        completion(true)
                        return
                    }
                }
                completion(false)
                return
            }
        }
    }

    func login(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { res, err in
            completion(err)
        }
    }
    
    func createUserWithGoogle(name: String, email: String, username: String, profileUrl: String, uid: String, completion: @escaping(Error?, User?) -> ()) {
        let data: [String: Any] = ["email": email, "fullName": name, "profileImage": profileUrl, "uid": uid, "username": username]
        
        Firestore.firestore().collection("users").document(uid).setData(data) { error in
            let user = User(dictionary: data)
            if let error = error {
                completion(error, nil)
                return
            }
            completion(error, user)
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
                print("Error updating email:", error.localizedDescription)
                return
            }
            print("Email updated successfully")
        }
    }
}


