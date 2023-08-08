//
//  RecipeViewModel.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 22.06.2023.
//

import UIKit

struct RecipeViewModel {
    //MARK: - Properties
    private let recipeService: RecipeServiceProtocol?
    
    var recipe: Recipe
    
    var recipeImage: UIImageView?
    
    //MARK: - Init
    
    init(recipe: Recipe, recipeService: RecipeServiceProtocol?) {
        self.recipe = recipe
        self.recipeService = recipeService
    }
    
    //MARK: - Computed Properties
    
    var id: String {
        return recipe.id ?? ""
    }
    
    var name: String {
        return recipe.name ?? ""
    }
    
    var serve: String {
        return recipe.serve ?? ""
    }
    
    var cookTime: String {
        return recipe.cookTime ?? ""
    }
    
    var category: Recipe.Category {
        return recipe.category
    }
    
    var sumOfRatings: Float {
        return recipe.sumOfRatings ?? 0.0
    }
    
    var user: User? {
        return recipe.user
    }
    
    var ratingNum: Int {
        return recipe.ratingNum ?? 0
    }
    
    var realmId: String? {
        return recipe.realmId
    }
    
    var ingredients: [Ingredient] {
        return recipe.ingredients
    }
    
    var instructions: [Instruction] {
        return recipe.instructions
    }
    
    var recipeImageUrl: String {
        return recipe.recipeImageUrl ?? ""
    }
    
    var ratingList: [Rating]? {
        get {
            return recipe.ratingList
        }
        set {
            ratingList = newValue
        }
    }
    
    var rating: Float {
        get {
            return recipe.rating ?? 0.0
        }
        set {
            rating = newValue
        }
    }
    
    var imageData: Data? {
        return recipe.imageData
    }
    
    var day: String? {
        return recipe.day
    }
    
    var isRated: Bool? {
        return recipe.isRated
    }
}


