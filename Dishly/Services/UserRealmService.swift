//
//  UserRealmService.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 02.07.2023.
//

import Foundation
import RealmSwift

protocol UserRealmServiceProtocol {
    func createUser(name: String, email: String, profileImage: Data, id: String, completion: @escaping(Bool) -> ())
    func getUser(with id: String, completion: @escaping(User) -> ())
    func updateUser(user: User, completion: @escaping(Bool) -> ())
}

class UserRealmService: UserRealmServiceProtocol {
     let realm = try! Realm()

    func createUser(name: String, email: String, profileImage: Data, id: String, completion: @escaping(Bool) -> ()) {
         let user = UserRealm()
        
         user.id = id
         user.name = name
         user.email = email
         user.imageData = profileImage

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
                            "fullName" : user.name,
        
                            "imageData" : user.imageData
                ] as [String : Any]
                let user = User(dictionary: dict)
                completion(user)
            }
        }
    }

    func updateUser(user: User, completion: @escaping(Bool) -> ()) {
        let users = realm.objects(UserRealm.self)
        for realmUser in users {
            if realmUser.id == user.uid {
                try! realm.write {
                    realmUser.name = user.fullName
                    completion(true)
                }
            }
        }
     }

     func deleteUser(id: String) {
         let users = realm.objects(UserRealm.self)
         for user in users {
             if user.id == id {
                 try! realm.write {
                     realm.delete(user)
                 }
             }
         }
     }
 }






 
