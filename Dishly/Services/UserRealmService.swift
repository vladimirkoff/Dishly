//
//  UserRealmService.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 02.07.2023.
//

import Foundation
import RealmSwift

protocol UserRealmServiceProtocol {
    func createUser(name: String, email: String, profileImageUrl: String, id: String, completion: @escaping(Bool) -> ())
    func getUser(with id: String, completion: @escaping(User) -> ())
}

class UserRealmService: UserRealmServiceProtocol {
     let realm = try! Realm()

    func createUser(name: String, email: String, profileImageUrl: String, id: String, completion: @escaping(Bool) -> ()) {
         let user = UserRealm()
        
         user.id = id
         user.name = name
         user.email = email
         user.url = profileImageUrl

         try! realm.write {
             realm.add(user)
             completion(true)
         }
     }

     func getUsers() -> Results<UserRealm> {
         return realm.objects(UserRealm.self)
     }
    
    func getUser(with id: String, completion: @escaping(User) -> ())  {
        let users = realm.objects(UserRealm.self)
        for user in users {
            if user.id == id {
                let dict = ["uid" : id,
                            "email": user.email,
                            "fullName" : user.name
                ]
                let user = User(dictionary: dict)
                completion(user)
            }
        }
    }

     func updateUser(user: UserRealm, newName: String) {
         try! realm.write {
             user.name = newName
         }
     }

     func deleteUser(user: UserRealm) {
         try! realm.write {
             realm.delete(user)
         }
     }
 }






 
