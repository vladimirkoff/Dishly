//
//  MealsServiceProtocol.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 26.07.2023.
//

import Foundation

protocol MealsServiceProtocol {
    func fetchRecipesForPlans(completion: @escaping ([String: [RecipeViewModel]]) -> ())
    func mealPlan(recipes: [RecipeViewModel], day: DaysOfWeek, completion: @escaping(Error?) -> ())
}
