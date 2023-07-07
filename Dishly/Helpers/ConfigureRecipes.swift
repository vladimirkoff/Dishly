//
//  ConfigureRecipes.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 07.07.2023.
//

import Foundation
import FirebaseFirestore

func setRecipesConfiguration(recipe: QueryDocumentSnapshot) -> RecipeViewModel {
    
        let serve = recipe.data()["serve"] as? String ?? ""
        let id = recipe.data()["id"] as? String ?? ""
        let name = recipe.data()["name"] as? String ?? ""
        let cookTime = recipe.data()["cookTime"] as? String ?? ""
        let ownerId = recipe.data()["ownerId"] as? String ?? ""
        let ingredients = recipe.data()["ingredients"] as? [String] ?? []
        
        var ingredientsArray: [Ingredient] = []
        for ingredient in ingredients {
            let ingredientModel = Ingredient(name: ingredient)
            ingredientsArray.append(ingredientModel)
        }
        
        let instructions = recipe.data()["instructions"] as? [String] ?? []
        
        let rating = recipe.data()["rating"] as? Int ?? 0
        let numOfRatings = recipe.data()["numOfRatings"] as? [Int] ?? []
        let category = recipe.data()["category"] as? String ?? ""
        let recipeImageUrl = recipe.data()["recipeImageUrl"] as? String ?? ""
        
        let recipeModel = Recipe(ownerId: ownerId,
                                 id: id,
                                 name: name,
                                 serve: serve,
                                 cookTime: cookTime,
                                 category: Recipe.Category(rawValue: "Bread")!,
                                 ingredients: ingredientsArray,
                                 instructions: [],
                                 recipeImageUrl: recipeImageUrl,
                                 ratingList: numOfRatings,
                                 rating: rating)
        let recipeViewModel = RecipeViewModel(recipe: recipeModel, recipeService: nil)
        return recipeViewModel

}