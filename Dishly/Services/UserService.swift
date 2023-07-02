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
}

class UserService: UserServiceProtocol  {
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
            print(dictionary)
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
}
