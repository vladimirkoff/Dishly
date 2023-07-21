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

let mealCategories = ["Breakfast" : "breakfast", "Lunch" : "lunch", "Dinner" : "dinner", "Dessert" : "dessert", "Drinks" : "drinks", "Appetizer" : "appetizer"]
let countryCategories = ["Ukraine" : "ukraine", "Italy" : "italy", "Mexico" : "mexico", "Austria" : "austria", "Columbia" : "columbia", "Asia" : "asia", "Belarus" : "belarus", "France" : "france", "Belgium" : "belgium", "Germany" : "germany", "India" : "india", "America" : "america"]

enum DaysOfWeek: String, CaseIterable {
    case mon = "Monday"
    case tue = "Tuesday"
    case wed = "Wednesday"
    case thu = "Thursday"
    case fri = "Friday"
    case sat = "Saturday"
    case sun = "Sunday"
}
