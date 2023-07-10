
import Foundation

struct User {
    let email: String
    let fullName: String
    let profileImage: String
    let uid: String
    let username: String
    
    let imageData: Data

    init(dictionary: [String: Any]) {
        self.profileImage = dictionary["profileImage"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.fullName = dictionary["fullName"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.imageData = dictionary["imageData"] as? Data ?? Data()
    }
}
