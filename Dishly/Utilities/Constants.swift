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

let portionsMesures: [Float] = [0.3, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6, 6.5, 7, 7.5, 8, 8.5, 9, 9.5, 10]

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
