//
//  PrepareVM.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 27.07.2023.
//

import UIKit

final class PrepareVM: PrepareVMProtocol {
    
    private let recipeService: RecipeServiceProtocol
    
    init(
        recipeService: RecipeServiceProtocol
    ) {
        self.recipeService = recipeService
    }
    
    func createRecipe(recipe: RecipeViewModel, image: UIImage, completion: @escaping(Error?) -> ()) {
        recipeService.createRecipe(recipe: recipe, image: image) { error in
            completion(error)
        }
    }
    
}
