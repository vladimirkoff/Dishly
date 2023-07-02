

import RealmSwift

class UserRealm: Object {
    @Persisted var id = ""
    @Persisted var name = ""
    @Persisted var email = ""

    override static func primaryKey() -> String? {
        return "id"
    }
}
