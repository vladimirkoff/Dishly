//
//  MealPlanVM.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 27.07.2023.
//

import Foundation

final class MealPlanVM: MealPlanVMProtocol {
    
    private let recipesRealmService: RecipesRealmServiceProtocol
    private let mealsService: MealsServiceProtocol
    
    
    init(
        recipesRealmService: RecipesRealmServiceProtocol,
        mealsService: MealsServiceProtocol
    ) {
        self.recipesRealmService = recipesRealmService
        self.mealsService = mealsService
    }
    
    func addRecipeRealm(recipe: RecipeViewModel, day: String, completion: @escaping(Bool) -> ()) {
        recipesRealmService.addRecipeRealm(recipe: recipe, day: day) { success in
            completion(success)
        }
    }
    
    func deleteRecipeRealm(id: String, completion: @escaping(Bool) -> ()) {
        recipesRealmService.deleteRecipeRealm(id: id) { success in
            completion(success)
        }
    }
    
    func fecthRecipesRealm(completion: @escaping([RecipeViewModel]) -> ()) {
        recipesRealmService.fecthRecipesRealm { recipes in
            completion(recipes)
        }
    }
    
    func mealPlan(recipes: [RecipeViewModel], day: DaysOfWeek, completion: @escaping(Error?) -> ()) {
        mealsService.mealPlan(recipes: recipes, day: day) { error in
            completion(error)
        }
    }
    
    func fetchRecipesForPlans(completion: @escaping([String : [RecipeViewModel]]) -> ()) {
        mealsService.fetchRecipesForPlans { recipes in
            completion(recipes)
        }
    }
}
