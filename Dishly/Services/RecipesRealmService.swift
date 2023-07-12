//
//  RecipesRealmService.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 12.07.2023.
//

import Foundation
import RealmSwift

protocol RecipesRealmServiceProtocol {
    func addRecipeRealm(recipe: RecipeViewModel, day: String, completion: @escaping(Bool) -> ())
    func fecthRecipesRealm(completion: @escaping([RecipeViewModel]) -> ())
    func updateRecipe(id: String, rating: Float, numOfRating: Int, completion: @escaping(Bool) -> ())
    func deleteRecipeRealm(id: String, completion: @escaping(Bool) -> ())
}

class RecipesRealmService: RecipesRealmServiceProtocol {
    func addRecipeRealm(recipe: RecipeViewModel, day: String, completion: @escaping(Bool) -> ()) {
        let realm = try! Realm()
        
        let recipeRealm = RecipeRealm()
        
        
        var ingredientsRealm: List<IngredientRealm> = List<IngredientRealm>()
        var instructionsRealm: List<InstructionRealm> = List<InstructionRealm>()
        
        for ingredient in recipe.recipe.ingredients {
            let name = ingredient.name
            let volume = ingredient.volume
            let portion = ingredient.portion
            
            let ingredientRealm = IngredientRealm()
            ingredientRealm.name = name
            ingredientRealm.volume = volume
            ingredientRealm.portion = portion
            
            ingredientsRealm.append(ingredientRealm)
        }
        
        for instruction in recipe.recipe.instructions {
            let text = instruction.text
            
            let instructionRealm = InstructionRealm()
            instructionRealm.text = text
            instructionsRealm.append(instructionRealm)
        }
        
        recipeRealm.name = recipe.recipe.name!
        recipeRealm.imageData = recipe.recipe.imageData
        recipeRealm.primaryKey = UUID().uuidString
        recipeRealm.id = recipe.recipe.id!
        recipeRealm.day = day
        recipeRealm.ingredients = ingredientsRealm
        recipeRealm.category = recipe.recipe.category.rawValue
        recipeRealm.cookTime = recipe.recipe.cookTime!
        recipeRealm.rating = Double(recipe.recipe.rating!)
        recipeRealm.ratingsNum = recipe.recipe.ratingList?.count ?? 0
        
        if let existingObject = realm.object(ofType: RecipeRealm.self, forPrimaryKey: recipe.recipe.id!) {
            try! realm.write {
                realm.delete(existingObject)
            }
        }
        
        do {
            try realm.write {
                realm.add(recipeRealm)
                completion(true)
            }
        } catch {
            completion(false)
        }
        
    }

    func fecthRecipesRealm(completion: @escaping([RecipeViewModel]) -> ()) {
        let realm = try! Realm()
        
        var recipes: [RecipeViewModel] = []
        var ingredients: [Ingredient] = []
        var instructions: [Instruction] = []
        
        let recipesRealm = realm.objects(RecipeRealm.self)
        
        
        for recipeRealm in recipesRealm {
            
            for ingredientRealm in recipeRealm.ingredients {
                let name = ingredientRealm.name
                let portion = ingredientRealm.portion
                let volume = ingredientRealm.volume
                
                let ingredient = Ingredient(name: name, volume: volume, portion: portion)
                ingredients.append(ingredient)
            }
            
            for instructionRealm in recipeRealm.instructions {
                let text = instructionRealm.text
                
                let instruction = Instruction(text: text)
                instructions.append(instruction)
            }
            
            let name = recipeRealm.name
            let imageData = recipeRealm.imageData
            let id = recipeRealm.id
            let day = recipeRealm.day
            let categoryString = recipeRealm.category
            let cookTime = recipeRealm.cookTime
            let category = Recipe.Category(rawValue: categoryString)
            let serve = recipeRealm.serve
            let ownerId = recipeRealm.ownerId
            let rating = Float(recipeRealm.rating)
            let ratingNum = recipeRealm.ratingsNum
            let realmId = recipeRealm.primaryKey
            
            let recipe = Recipe(ownerId: ownerId, id: id, name: name, serve: serve, cookTime: cookTime, category: category!, ratingNum: ratingNum, realmId: realmId, ingredients: ingredients, instructions: instructions, rating: rating, imageData: imageData, day: day)
            
            let recipeViewModel = RecipeViewModel(recipe: recipe, recipeService: nil)
            recipes.append(recipeViewModel)
        }
        completion(recipes)
    }

    func updateRecipe(id: String, rating: Float, numOfRating: Int, completion: @escaping(Bool) -> ()) {
        let realm = try! Realm()
        
        let recipesRealm = realm.objects(RecipeRealm.self)
        
        for recipeRealm in recipesRealm {
            if recipeRealm.id == id {
                do {
                    try realm.write {
                        recipeRealm.rating = Double(rating)
                        recipeRealm.ratingsNum = numOfRating
                        completion(true)
                    }
                } catch {
                    completion(false)
                }
            }
        }
    }

    func deleteRecipeRealm(id: String, completion: @escaping(Bool) -> ()) {
        let realm = try! Realm()
        
        let recipesRealm = realm.objects(RecipeRealm.self)
        
        for recipeRealm in recipesRealm {
            if recipeRealm.primaryKey == id {
                do {
                    try realm.write {
                        realm.delete(recipeRealm)
                        completion(true)
                    }
                } catch {
                    completion(false)
                }
            }
        }
    }
}
