
import Foundation

struct Recipe {
    var ownerId: String?
    var id: String?
    var name: String?
    var serve: String?
    var cookTime: String?
    var category: Category
    var sumOfRatings: Float?
    
    var user: User?
    
    var ratingNum: Int?
    
    var realmId: String?
    
    var ingredients: [Ingredient]
    var instructions: [Instruction]
    var recipeImageUrl: String?
    var ratingList: [Rating]?
    var rating: Float?
    
    var imageData: Data?
    var day: String?
    
    var isRated: Bool?
    
    enum Category: String, Codable, CaseIterable {
        case france = "France"
        case appetizer = "Appetizer"
        case breakfast = "Breakfast"
        case drinks = "Drinks"
        case belgium = "Belgium"
        case germany = "Germany"
        case ukraine = "Ukraine"
        case asia = "Asia"
        case columbia = "Columbia"
        case lunch = "Lunch"
        case mexico = "Mexico"
        case italy = "Italiy"
        case canada = "Canada"
        case austria = "Austria"
        case america = "America"
        case belarus = "Belarus"
        case india = "India"
        case dessert = "Dessert"
    }
    
    enum Portion: String, Codable, CaseIterable {
        case tube
        case tbsp
        case bag
        case bar
        case block
        case box
        case bottle
        case can
        case carton
        case cup
        case glass
        case liter
        case gallon
        case gram
        case kg
        case loaf
        case mililiter
        case piece
        case scoop
        case slice
        case tsp
        case toTaste
        case jar
        case item
    }
}

struct PortionModel {
    var name: String
    var volume: Float
}

struct Ingredient: Codable {
    var name: String?
    var volume: Float?
    var portion: String? 
}

struct Instruction: Codable {
    var text: String?
}

struct Rating {
    var uid: String
    var rating: Float
}








