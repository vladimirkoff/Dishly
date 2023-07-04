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
    func fetchUser(with uid: String, completion: @escaping (User) -> Void)
    func fetchUser(completion: @escaping(User) -> ())
    func updateUser(changedUser: User, completion: @escaping(Error?) -> ())
    func checkIfUserExists(email: String, completion: @escaping(Bool) -> ())
    func createUser(name: String, email: String, username: String, profileUrl: String, uid: String, completion: @escaping(Error?, User?) -> ())
    func getUser(by email: String, completion: @escaping(User) -> ())
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
    
    func getUser(by email: String, completion: @escaping(User) -> ()) {
        COLLECTION_USERS.getDocuments { snapshot, error in
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
    
    func createUser(name: String, email: String, username: String, profileUrl: String, uid: String, completion: @escaping(Error?, User?) -> ()) {
        let data: [String: Any] = ["email": email, "fullName": name, "profileImage": profileUrl, "uid": uid, "username": username]
        
        COLLECTION_USERS.document(uid).setData(data) { error in
            let user = User(dictionary: data)
            if let error = error {
                completion(error, nil)
                return
            }
            completion(error, user)
        }
    }
    
    func fetchUser(with uid: String, completion: @escaping (User) -> Void) {
        
    }
    
    func fetchUser(completion: @escaping(User) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_USERS.document(uid).getDocument { snapshot, err in
            if let error = err {
                print("ERROR fetching user - \(error.localizedDescription)")
                return
            }
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
   func updateUser(changedUser: User, completion: @escaping(Error?) -> ()) {
       let userRef = COLLECTION_USERS.document(changedUser.uid)
       userRef.updateData(["profileImage" : changedUser.profileImage,
                           "email" : changedUser.email,
                           "username" : changedUser.username,
                           "fullName" : changedUser.fullName
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
