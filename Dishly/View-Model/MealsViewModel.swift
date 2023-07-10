//
//  MealsViewModel.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 10.07.2023.
//

import Foundation

class MealsViewModel {
    private let mealsService: MealsServiceProtocol
    
    init(mealsService: MealsServiceProtocol) {
        self.mealsService = mealsService
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
