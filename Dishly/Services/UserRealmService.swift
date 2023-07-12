import Foundation
import RealmSwift

protocol UserRealmServiceProtocol {
    func createUser(name: String, email: String, profileImage: Data, id: String, username: String, completion: @escaping (Bool) -> Void)
    func getUser(with id: String, completion: @escaping (User) -> Void)
    func updateUser(user: User, completion: @escaping (Bool) -> Void)
    func deleteUser(id: String)
}

class UserRealmService: UserRealmServiceProtocol {
    private let realm: Realm
    
    init(realm: Realm = try! Realm()) {
        self.realm = realm
    }
    
    func createUser(name: String, email: String, profileImage: Data, id: String, username: String, completion: @escaping (Bool) -> Void) {
        let user = UserRealm()
        user.id = id
        user.name = name
        user.email = email
        user.imageData = profileImage
        user.username = username
        
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
