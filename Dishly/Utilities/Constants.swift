//
//  Constants.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 02.07.2023.
//

import Foundation
import FirebaseFirestore

let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_RECIPES = Firestore.firestore().collection("recipes")

let mealCategories = ["Breakfast", "Lunch", "Dinner", "Dessert", "Drinks", "Appetizer"]
let countryCategories = ["Ukraine", "Italiy", "Mexico", "Austria", "Columbia", "Asia", "Australia", "France", "Belgium", "Germany", "Canada"]

enum DaysOfWeek: String, CaseIterable {
    case mon = "Monday"
    case tue = "Tuesday"
    case wed = "Wednesday"
    case thu = "Thursday"
    case fri = "Friday"
    case sat = "Saturday"
    case sun = "Sunday"
}
