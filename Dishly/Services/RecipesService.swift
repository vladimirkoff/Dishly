import UIKit
import FirebaseAuth
import FirebaseFirestore

protocol RecipeServiceProtocol {
    func fetchRecipes(completion: @escaping ([RecipeViewModel]) -> Void)
    func createRecipe(recipe: RecipeViewModel, image: UIImage, completion: @escaping (Error?) -> ())
    func updateRating(with data: [String: Any],recipe: String, completion: @escaping (Error?) -> ())
    func fetchRecipesWith(category: Recipe.Category, completion: @escaping ([RecipeViewModel]) -> ())
    func fetchRecipesFor(category: String, completion: @escaping([RecipeViewModel]) -> ())
    func mealPlan(recipes: [RecipeViewModel], day: DaysOfWeek, completion: @escaping(Error?) -> ())
    func fetchRecipesForPlans(completion: @escaping ([String : [RecipeViewModel]]) -> ())}

class RecipeService: RecipeServiceProtocol {
    
    func updateRating(with data: [String: Any], recipe: String, completion: @escaping (Error?) -> ()) {
        COLLECTION_RECIPES.document(recipe).updateData(data, completion: completion)
    }
    
    func fetchRecipesFor(category: String, completion: @escaping([RecipeViewModel]) -> ()) {
        var recipesArray: [RecipeViewModel] = []
        
        Firestore.firestore().collection(category).getDocuments { snapshot, error in
            if let recipes = snapshot?.documents {
                for recipe in recipes {
                    let recipeViewModel = setRecipesConfiguration(recipe: recipe)
                    recipesArray.append(recipeViewModel)
                }
                completion(recipesArray)
            }
        }
    }
    
    
    func fetchRecipesForPlans(completion: @escaping ([String : [RecipeViewModel]]) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var recipesForPlans: [ String : [RecipeViewModel] ] = [:]
        var recipesArray: [RecipeViewModel] = []

        let dispatchGroup = DispatchGroup()
        
        for day in DaysOfWeek.allCases {
            dispatchGroup.enter()
            
            COLLECTION_USERS.document(uid).collection(day.rawValue).getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching documents for \(day.rawValue): \(error.localizedDescription)")
                    dispatchGroup.leave()
                    return
                }
                
                if let recipes = snapshot?.documents {
                    for recipe in recipes {
                        let recipeViewModel = setRecipesConfiguration(recipe: recipe)
                        recipesArray.append(recipeViewModel)
                        recipesForPlans[day.rawValue] = recipesArray
                    }
                    recipesArray = []
                }
                
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(recipesForPlans)
        }
    }

    
    func mealPlan(recipes: [RecipeViewModel], day: DaysOfWeek, completion: @escaping(Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        for recipe in recipes {
            var instructions: [String] = []
            var ingredients: [String: [String: Float]] = [:]
            
            recipe.recipe.instructions.compactMap { $0.text }.forEach { instructions.append($0) }
            
            for ingredient in recipe.recipe.ingredients {
                if let name = ingredient.name, let portion = ingredient.portion, let volume = ingredient.volume {
                    ingredients[name] = [portion: volume]
                }
            }
            
            let data: [String: Any] = [
                "name": recipe.recipe.name ?? "",
                "cookTime": recipe.recipe.cookTime ?? "",
                "recipeImageUrl": recipe.recipe.recipeImageUrl,
                "id": recipe.recipe.id ?? "",
                "ownerId": recipe.recipe.ownerId ?? "",
                "instructions": instructions,
                "ingredients": ingredients,
                "category": recipe.recipe.category.rawValue,
                "rating": 0,
                "serve": recipe.recipe.serve ?? ""
            ]
            
            let recipeDocument = COLLECTION_RECIPES.document(recipe.recipe.id ?? "")
            recipeDocument.setData(data) { error in
                if let error = error {
                    completion(error)
                    return
                }
                COLLECTION_USERS.document(uid).collection(day.rawValue).document(recipe.recipe.id!).setData(data)
            }
        }
    }
        
        func fetchRecipesWith(category: Recipe.Category, completion: @escaping ([RecipeViewModel]) -> ()) {
            COLLECTION_RECIPES.whereField("category", isEqualTo: category.rawValue).getDocuments { snapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                var recipesArray: [RecipeViewModel] = []
                
                if let recipes = snapshot?.documents {
                    for recipe in recipes {
                        let recipeViewModel = setRecipesConfiguration(recipe: recipe)
                        recipesArray.append(recipeViewModel)
                    }
                }
                
                completion(recipesArray)
            }
        }
        
        func createRecipe(recipe: RecipeViewModel, image: UIImage, completion: @escaping (Error?) -> ()) {
            ImageUploader.shared.uploadImage(image: image, isForRecipe: true) { recipeImageUrl in
                var instructions: [String] = []
                var ingredients: [String: [String: Float]] = [:]
                
                recipe.recipe.instructions.compactMap { $0.text }.forEach { instructions.append($0) }
                
                for ingredient in recipe.recipe.ingredients {
                    if let name = ingredient.name, let portion = ingredient.portion, let volume = ingredient.volume {
                        ingredients[name] = [portion: volume]
                    }
                }
                
                let data: [String: Any] = [
                    "name": recipe.recipe.name ?? "",
                    "cookTime": recipe.recipe.cookTime ?? "",
                    "recipeImageUrl": recipeImageUrl,
                    "id": recipe.recipe.id ?? "",
                    "ownerId": recipe.recipe.ownerId ?? "",
                    "instructions": instructions,
                    "ingredients": ingredients,
                    "category": recipe.recipe.category.rawValue,
                    "rating": 0,
                    "serve": recipe.recipe.serve ?? ""
                ]
                
                let recipeDocument = COLLECTION_RECIPES.document(recipe.recipe.id ?? "")
                recipeDocument.setData(data) { error in
                    if let error = error {
                        completion(error)
                        return
                    }
                    
                    COLLECTION_USERS.document(recipe.recipe.ownerId ?? "")
                        .collection("recipes")
                        .document(recipe.recipe.id ?? "")
                        .setData(data) { error in
                            if let error = error {
                                print(error.localizedDescription)
                                return
                            }
                            Firestore.firestore().collection(recipe.recipe.category.rawValue).document(recipe.recipe.id ?? "")
                                .setData(data) { error in
                                    if let error = error {
                                        print(error.localizedDescription)
                                        return
                                    }
                                }
                        }
                    
                    completion(nil)
                }
            }
        }
        
        func fetchRecipes(completion: @escaping ([RecipeViewModel]) -> ()) {
            COLLECTION_RECIPES.getDocuments { snapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                var recipesArray: [RecipeViewModel] = []
                
                if let recipes = snapshot?.documents {
                    for recipe in recipes {
                        let recipeViewModel = setRecipesConfiguration(recipe: recipe)
                        recipesArray.append(recipeViewModel)
                    }
                }
                completion(recipesArray)
            }
        }
    }

