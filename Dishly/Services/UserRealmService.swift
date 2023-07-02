//
//  UserRealmService.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 02.07.2023.
//

import Foundation
import RealmSwift

protocol UserRealmServiceProtocol {
    func createUser(name: String, email: String)
}

class UserRealmService: UserRealmServiceProtocol {
    let realm = try! Realm()

     func createUser(name: String, email: String) {
         let user = UserRealm()
         user.name = name
         user.email = email

         try! realm.write {
             realm.add(user)
         }
     }

     func getUsers() -> Results<UserRealm> {
         return realm.objects(UserRealm.self)
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






 
