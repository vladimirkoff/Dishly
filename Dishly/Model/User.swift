
import Foundation

struct User {
    let email: String
    let fullName: String
    let profileImage: String
    let uid: String
    let username: String
    
//    var isCurrentUser: Bool {
//        return Auth.auth().currentUser?.uid == uid ? true : false
//    }

    init(dictionary: [String: Any]) {
        self.profileImage = dictionary["profileImage"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.fullName = dictionary["fullName"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
    }
}
