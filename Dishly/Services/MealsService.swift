//
//  MealsService.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 10.07.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol MealsServiceProtocol {
    func fetchRecipesForPlans(completion: @escaping ([String: [RecipeViewModel]]) -> ())
    func mealPlan(recipes: [RecipeViewModel], day: DaysOfWeek, completion: @escaping(Error?) -> ())
}

class MealsService: MealsServiceProtocol {
    func fetchRecipesForPlans(completion: @escaping ([String: [RecipeViewModel]]) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var recipesForPlans: [String: [RecipeViewModel]] = [:]
        let dispatchGroup = DispatchGroup()
        
        for day in DaysOfWeek.allCases {
            dispatchGroup.enter()
            
            COLLECTION_USERS.document(uid).collection(day.rawValue).getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching documents for \(day.rawValue): \(error.localizedDescription)")
                    dispatchGroup.leave()
                    return
                }
                
                var recipesArray: [RecipeViewModel] = []
                let innerGroup = DispatchGroup()
                
                if let recipes = snapshot?.documents {
                    for recipe in recipes {
                        if let id = recipe.data()["id"] as? String {
                            innerGroup.enter()
                            COLLECTION_RECIPES.whereField("id", isEqualTo: id).getDocuments { snapshot, error in
                                if let document = snapshot?.documents.first {
                                    guard let recipeViewModel = setRecipesConfiguration(recipe: document) else { return }
                                    recipesArray.append(recipeViewModel)
                                }
                                innerGroup.leave()
                            }
                        }
                    }
                }
                
                innerGroup.notify(queue: .main) {
                    recipesForPlans[day.rawValue] = recipesArray
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(recipesForPlans)
        }
    }


    
    func mealPlan(recipes: [RecipeViewModel], day: DaysOfWeek, completion: @escaping(Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let dispatchGroup = DispatchGroup()
        var errors: [Error?] = []

        for recipe in recipes {
            dispatchGroup.enter()

            var instructions: [String] = []
            var ingredients: [String: [String: Float]] = [:]

            instructions = recipe.recipe.instructions.compactMap { $0.text }

            for ingredient in recipe.recipe.ingredients {
                if let name = ingredient.name, let portion = ingredient.portion, let volume = ingredient.volume {
                    ingredients[name] = [portion: volume]
                }
            }

            var ratingsArray: [[String: Any]] = []

            for rating in recipe.recipe.ratingList! {
                let uid = rating.uid
                let rate = rating.rating

                let ratingData: [String: Any] = [
                    "uid": uid,
                    "rating": rate
                ]

                ratingsArray.append(ratingData)
            }

            let data = generateRecipeData(for: recipe)

            COLLECTION_USERS.document(uid).collection(day.rawValue).document(recipe.recipe.id!).setData(data) { error in
                if let error = error {
                    errors.append(error)
                }

//                addRecipeRealm(recipe: recipe, day: day.rawValue) { success in
//                    print(success)
//                }


                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            let combinedError = errors.reduce(nil) { $0 ?? $1 }
            completion(combinedError)
        }
    }

}


