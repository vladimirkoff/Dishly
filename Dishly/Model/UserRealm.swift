

import RealmSwift

class UserRealm: Object {
    @Persisted var id = ""
    @Persisted var name = ""
    @Persisted var email = ""
    @Persisted var url = ""

    override static func primaryKey() -> String? {
        return "id"
    }
}
