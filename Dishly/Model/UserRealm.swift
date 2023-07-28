

import RealmSwift
import Foundation

class UserRealm: Object {
    @Persisted var id = ""
    @Persisted var name = ""
    @Persisted var email = ""
    @Persisted var isCurrentUser: Bool?
    @Persisted var imageData: Data?
    @Persisted var username: String?

    override static func primaryKey() -> String? {
        return "id"
    }
}
