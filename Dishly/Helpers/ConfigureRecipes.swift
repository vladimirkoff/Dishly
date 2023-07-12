//
//  ConfigureRecipes.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 07.07.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

func sumRatings(_ ratings: [[String: Any]]) -> Float {
    ratings.reduce(0.0) { $0 + ($1["rating"] as? Float ?? 0.0) }
}


func setRecipesConfiguration(recipe: QueryDocumentSnapshot) -> RecipeViewModel? {
    guard let uid = Auth.auth().currentUser?.uid else { return nil }
    
    let serve = recipe.data()["serve"] as? String ?? ""
    let id = recipe.data()["id"] as? String ?? ""
    let name = recipe.data()["name"] as? String ?? ""
    let cookTime = recipe.data()["cookTime"] as? String ?? ""
    let ownerId = recipe.data()["ownerId"] as? String ?? ""
    let ingredients = recipe.data()["ingredients"] as? [String : [String : Float]] ?? [:]
    let instructions = recipe.data()["instructions"] as? [String] ?? []
    let recipeImageUrl = recipe.data()["recipeImageUrl"] as? String ?? ""
    var numOfRatings = recipe.data()["numOfRatings"] as? [[String: Any]]
    let category = recipe.data()["category"] as? String ?? ""

    var currentRating = recipe.data()["rating"] as? Float ?? 0.0
    
    var ratingList: [Rating] = []
    var instructionsList: [Instruction] = []
    
    for instruction in instructions {
        let instructionModel = Instruction(text: instruction)
        instructionsList.append(instructionModel)
    }
    
    let ingredientsArray = ingredients.flatMap { (ingredient, portion) in
           portion.map { (name, volume) in
               Ingredient(name: ingredient, volume: volume, portion: name)
           }
       }
    
    var isRated = false

    var sumOfRatings: Float = 0.0
    
    if let numOfRatings = recipe.data()["numOfRatings"] as? [[String: Any]] {
          sumOfRatings = sumRatings(numOfRatings)
          for rate in numOfRatings {
              if rate["uid"] as? String == uid {
                  isRated = true
              }
              
              let uid = rate["uid"] as? String ?? ""
              let ratingNum = rate["rating"] as? Float ?? 0.0
              let rating = Rating(uid: uid, rating: ratingNum)
              ratingList.append(rating)
          }
      }
    
    let recipeModel = Recipe(ownerId: ownerId,
                             id: id,
                             name: name,
                             serve: serve,
                             cookTime: cookTime,
                             category: Recipe.Category(rawValue: category)!,
                             sumOfRatings: sumOfRatings,
                             ingredients: ingredientsArray,
                             instructions: instructionsList,
                             recipeImageUrl: recipeImageUrl,
                             ratingList: ratingList,
                             rating: currentRating,
                             isRated: isRated
    )
    let recipeViewModel = RecipeViewModel(recipe: recipeModel, recipeService: RecipeService())
    return recipeViewModel
}

func generateRecipeData(for recipe: RecipeViewModel) -> [String: Any] {
    var data: [String: Any] = [
        "name": recipe.recipe.name ?? "",
        "cookTime": recipe.recipe.cookTime ?? "",
        "recipeImageUrl": recipe.recipe.recipeImageUrl ?? "",
        "id": recipe.recipe.id ?? "",
        "ownerId": recipe.recipe.ownerId ?? "",
        "instructions": recipe.recipe.instructions.compactMap { $0.text },
        "ingredients": recipe.recipe.ingredients.reduce(into: [String: [String: Float]]()) { result, ingredient in
            if let name = ingredient.name, let portion = ingredient.portion, let volume = ingredient.volume {
                result[name] = [portion: volume]
            }
        },
        "category": recipe.recipe.category.rawValue,
        "rating": recipe.recipe.rating ?? 0.0,
        "serve": recipe.recipe.serve ?? ""
    ]
    
    if let ratingList = recipe.recipe.ratingList {
        data["numOfRatings"] = ratingList.map { ["uid": $0.uid, "rating": $0.rating] }
    }
    
    return data
}
