//
//  ConfigureRecipes.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 07.07.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

func setRecipesConfiguration(recipe: QueryDocumentSnapshot) -> RecipeViewModel {
    let uid = Auth.auth().currentUser!.uid
    
    let serve = recipe.data()["serve"] as? String ?? ""
    let id = recipe.data()["id"] as? String ?? ""
    let name = recipe.data()["name"] as? String ?? ""
    let cookTime = recipe.data()["cookTime"] as? String ?? ""
    let ownerId = recipe.data()["ownerId"] as? String ?? ""
    let ingredients = recipe.data()["ingredients"] as? [String : [String : Float]] ?? [:]
    
    let test = recipe.data()["rating"] as? Float ?? 0.0
    
    var ingredientsArray: [Ingredient] = []
    
    let instructions = recipe.data()["instructions"] as? [String] ?? []
    
    for (ingredient, portion) in ingredients {
        for (name, volume) in portion {
            let ingredientModel = Ingredient(name: ingredient, volume: volume, portion: name )
            ingredientsArray.append(ingredientModel)
        }
    }
    
    var isRated = false
    
    
    let numOfRatings = recipe.data()["numOfRatings"] as? [[String: Any]] ?? [[:]]
    
    
    
    let category = recipe.data()["category"] as? String ?? ""
    let recipeImageUrl = recipe.data()["recipeImageUrl"] as? String ?? ""
    
    var testArray: [Rating] = []
    
    for rate in numOfRatings {
        if rate["uid"] as? String ?? "" == uid {
            isRated = true
        }
        let uid = rate["uid"] as? String ?? ""
        let ratingNum = rate["rating"] as? Float ?? 0.0
        let rating = Rating(uid: uid, rating: ratingNum)
        testArray.append(rating)
    }
    
    let recipeModel = Recipe(ownerId: ownerId,
                             id: id,
                             name: name,
                             serve: serve,
                             cookTime: cookTime,
                             category: Recipe.Category(rawValue: "Bread")!,
                             ingredients: ingredientsArray,
                             instructions: [],
                             recipeImageUrl: recipeImageUrl,
                             ratingList: testArray,
                             rating: test,
                             isRated: isRated
    )
    let recipeViewModel = RecipeViewModel(recipe: recipeModel, recipeService: nil)
    return recipeViewModel
    
}
