
import Foundation

struct Recipe {
    var ownerId: String?
    var id: String?
    var name: String?
    var serve: String?
    var cookTime: String?
    var category: Category
    var sumOfRatings: Float?
    
    var ingredients: [Ingredient]
    var instructions: [Instruction]
    var recipeImageUrl: String?
    var ratingList: [Rating]?
    var rating: Float?
    
    var isRated: Bool?
    
    enum Category: String, Codable, CaseIterable {
        case france = "France"
        case australia = "Australia"
        case chicken = "Chicken"
        case seaFood = "Sea Food"
        case pizza = "Pizza"
        case burger = "Burger"
        case pasta = "Pasta"
        case toast = "Toast or Sandwich"
        case vegan = "Vegan"
        case appetizer = "Appetizer"
        case breakfast = "Breakfast"
        case bakery = "Bakery"
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








