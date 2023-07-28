//
//  PrepareVMProtocol.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 27.07.2023.
//

import UIKit

protocol PrepareVMProtocol {
    func createRecipe(recipe: RecipeViewModel, image: UIImage, completion: @escaping(Error?) -> ())
}
