//
//  UserService.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 25.06.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol UserServiceProtocol {
    func fetchUser(with uid: String, completion: @escaping (UserViewModel) -> Void)
    func fetchUser(completion: @escaping(UserViewModel) -> ())
    func updateUser(changedUser: UserViewModel, completion: @escaping(Error?) -> ())
    func checkIfUserExists(email: String, completion: @escaping(Bool) -> ())
    func createUser(name: String, email: String, username: String, profileUrl: String, uid: String, completion: @escaping(Error?, UserViewModel?) -> ())
    func getUser(by email: String, completion: @escaping(UserViewModel) -> ())
}

class UserService: UserServiceProtocol  {
    
    func checkIfUserExists(email: String, completion: @escaping(Bool) -> ()) {
        COLLECTION_USERS.getDocuments { snapshot, error in
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
    
    func getUser(by email: String, completion: @escaping(UserViewModel) -> ()) {
        COLLECTION_USERS.getDocuments { snapshot, error in
            if let users = snapshot?.documents {
                for user in users {
                    if user.data()["email"] as! String == email {
                        let dictionary = user.data()
                        let userModel = User(dictionary: dictionary)
                        completion(UserViewModel(user: userModel, userService: nil))
                        return
                    }
                }
            }
        }
    }
    
    func createUser(name: String, email: String, username: String, profileUrl: String, uid: String, completion: @escaping(Error?, UserViewModel?) -> ()) {
        let data: [String: Any] = ["email": email, "fullName": name, "profileImage": profileUrl, "uid": uid, "username": username]
        
        COLLECTION_USERS.document(uid).setData(data) { error in
            let user = User(dictionary: data)
            if let error = error {
                completion(error, nil)
                return
            }
            completion(error, UserViewModel(user: user, userService: nil))
        }
    }
    
    func fetchUser(with uid: String, completion: @escaping (UserViewModel) -> Void) {
        
    }
    
    func fetchUser(completion: @escaping(UserViewModel) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_USERS.document(uid).getDocument { snapshot, err in
            if let error = err {
                print("ERROR fetching user - \(error.localizedDescription)")
                return
            }
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(UserViewModel(user: user, userService: nil))
        }
    }
    
    func updateUser(changedUser: UserViewModel, completion: @escaping(Error?) -> ()) {
        guard let user = changedUser.user else { return }
        let userRef = COLLECTION_USERS.document(user.uid)
        userRef.updateData(["profileImage" : user.profileImage,
                            "email" : user.email,
                            "username" : user.username,
                            "fullName" : user.fullName
                           ]) { error in
            if let error = error {
                print("ERROR updating user - \(error.localizedDescription)")
                return
            }
            print("Success")
            completion(error)
        }
    }
}
