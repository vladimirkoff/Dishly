

import RealmSwift
import Foundation

class UserRealm: Object {
    @Persisted var id = ""
    @Persisted var name = ""
    @Persisted var email = ""
    @Persisted var imageData: Data?

    override static func primaryKey() -> String? {
        return "id"
    }
}
