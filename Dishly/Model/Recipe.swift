
import Foundation

struct Recipe: Codable {
    var ownerId: String?
    var id: String?
    var name: String?
    var serve: String?
    var cookTime: String?
    var category: Category
    
    var ingredients: [Ingredient]
    var instructions: [Instruction]
    var recipeImageUrl: String?
    var ratingList: [Int]?
    var rating: Int?
        
    enum Category: String, Codable, CaseIterable {
        case mainCourse = "Main Course"
        case sideDish = "Side Dish"
        case bread = "Bread"
        case homeMeal = "Home Meal"
        case steak = "Steak"
        case chicken = "Chicken"
        case seaFood = "Sea Food"
        case pizza = "Pizza"
        case burger = "Burger"
        case pasta = "Pasta"
        case kebap = "Kebap"
        case toast = "Toast or Sandwich"
        case vegan = "Vegan"
        case salad = "Salad"
        case appetizer = "Appetizer"
        case soup = "Soup"
        case breakfast = "Breakfast"
        case bakery = "Bakery"
        case snack = "Snack"
        case dessert = "Dessert"
        case babyFood = "Baby Food"
        case otherFood = "Other Food"
        case beverage = "Beverage"
        case sauce = "Sauce"
        case marinade = "Marinade"
        case fingerfood = "Finger Food"
        case drink = "Drink"
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








