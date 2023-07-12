import Foundation
import RealmSwift

class RecipeRealm: Object {
    @Persisted var id = ""
    @Persisted var primaryKey = ""
    @Persisted var name = ""
    @Persisted var day = ""
    @Persisted var serve = ""
    @Persisted var ownerId = ""
    @Persisted var category = ""
    @Persisted var cookTime = ""
    @Persisted var imageData: Data?
    @Persisted var rating = 0.0
    @Persisted var ratingsNum = 0
    @Persisted var ingredients = List<IngredientRealm>()
    @Persisted var instructions = List<InstructionRealm>()

    override static func primaryKey() -> String? {
        return "primaryKey"
    }
}

class IngredientRealm: Object {
    @Persisted var name: String?
    @Persisted var volume: Float?
    @Persisted var portion: String?
}

class InstructionRealm: Object {
    @Persisted var text: String?
}


