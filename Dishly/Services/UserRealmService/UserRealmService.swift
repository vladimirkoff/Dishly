import Foundation
import RealmSwift


final class UserRealmService: UserRealmServiceProtocol {
    private let realm: Realm
    
    init(realm: Realm = try! Realm()) {
        self.realm = realm
    }
    
    func checkIfLoggedIn(completion: @escaping(UserViewModel?) -> ()) {
        let realm = try! Realm()
        
        if let user = realm.objects(UserRealm.self).filter("isCurrentUser == %@", true).first {
            let dict: [String : Any] = ["fullName" : user.name,
                                        "uid" : user.id,
                                        "imageData" : user.imageData,
                                        "email" : user.email,
                                        "username" : user.username
            ]
            completion(UserViewModel(user: User(dictionary: dict)))
        } else {
            completion(nil)
        }
    }
    
    func createUser(name: String, email: String, profileImage: Data, id: String, username: String, isCurrentUser: Bool, completion: @escaping (Bool) -> Void) {
        
        let user = UserRealm()
        
        user.id = id
        user.name = name
        user.email = email
        user.imageData = profileImage
        user.username = username
        user.isCurrentUser = isCurrentUser
        
        do {
            try realm.write {
                realm.add(user)
                completion(true)
            }
        } catch {
            completion(false)
        }
    }
    
    func getUsers() -> Results<UserRealm> {
        return realm.objects(UserRealm.self)
    }
    
    func getUser(with id: String, completion: @escaping (User) -> Void) {
        let users = realm.objects(UserRealm.self).filter("id == %@", id)
        
        print(id)
        print(users)
        
        if let user = users.first {
            let dict: [String: Any] = [
                "uid": id,
                "email": user.email,
                "fullName": user.name,
                "imageData": user.imageData
            ]
            
            let user = User(dictionary: dict)
            completion(user)
        }
    }
    
    func updateUser(user: User, completion: @escaping (Bool) -> Void) {
        let users = realm.objects(UserRealm.self).filter("id == %@", user.uid)
        if let realmUser = users.first {
            do {
                try realm.write {
                    realmUser.name = user.fullName
                    realmUser.email = user.email
                    realmUser.imageData = user.imageData
                    completion(true)
                }
            } catch {
                completion(false)
            }
        }
    }
    
    func deleteCurrentUser(completion: @escaping(Error?) -> ()) {
        guard let user = realm.objects(UserRealm.self).filter("isCurrentUser == %@", true).first else {
              print("User not found in Realm.")
             completion(RealmErrors.userNotFound)
              return
          }
        
        try! realm.write {
               realm.delete(user)
               completion(nil)
        }
    }
    
    func deleteUser(id: String) {
        let users = realm.objects(UserRealm.self).filter("id == %@", id)
        if let user = users.first {
            do {
                try realm.write {
                    realm.delete(user)
                }
            } catch {
                print("Error deleting user: \(error.localizedDescription)")
            }
        }
    }
}
