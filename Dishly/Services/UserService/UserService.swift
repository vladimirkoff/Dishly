import Foundation
import FirebaseAuth
import FirebaseFirestore

final class UserService: UserServiceProtocol {
    
    func checkIfUserExists(email: String, completion: @escaping (Bool) -> Void) {
        COLLECTION_USERS.whereField("email", isEqualTo: email).getDocuments { snapshot, error in
            if let users = snapshot?.documents {
                completion(!users.isEmpty)
            } else {
                completion(false)
            }
        }
    }
    
    func getUser(by email: String, completion: @escaping (UserViewModel) -> Void) {
        COLLECTION_USERS.whereField("email", isEqualTo: email).getDocuments { snapshot, error in
            if let users = snapshot?.documents, let user = users.first {
                let userModel = User(dictionary: user.data())
                completion(UserViewModel(user: userModel))
            }
        }
    }
    
    func createUser(name: String, email: String, username: String, profileUrl: String, uid: String, completion: @escaping (Error?, UserViewModel?) -> Void) {
        let data: [String: Any] = [
            "email": email,
            "fullName": name,
            "profileImage": profileUrl,
            "uid": uid,
            "username": username
        ]
        
        COLLECTION_USERS.document(uid).setData(data) { error in
            let user = User(dictionary: data)
            completion(error, user != nil ? UserViewModel(user: user) : nil)
        }
    }
    
    func fetchUser(with uid: String, completion: @escaping (UserViewModel) -> Void) {
        COLLECTION_USERS.document(uid).getDocument { snapshot, err in
            if let dictionary = snapshot?.data() {
                let user = User(dictionary: dictionary)
                completion(UserViewModel(user: user))
            }
        }
    }
    
    func fetchUser(completion: @escaping (UserViewModel) -> Void) {
        if let uid = Auth.auth().currentUser?.uid {
            COLLECTION_USERS.document(uid).getDocument { snapshot, error in
                if let dictionary = snapshot?.data() {
                    let user = User(dictionary: dictionary)
                    completion(UserViewModel(user: user))
                }
            }
        }
    }
    
    func updateUser(changedUser: UserViewModel, completion: @escaping (Error?) -> Void) {
        if let user = changedUser.user {
            let userRef = COLLECTION_USERS.document(user.uid)
            userRef.updateData([
                "profileImage": user.profileImage,
                "email": user.email,
                "username": user.username,
                "fullName": user.fullName
            ], completion: completion)
        }
    }
}
