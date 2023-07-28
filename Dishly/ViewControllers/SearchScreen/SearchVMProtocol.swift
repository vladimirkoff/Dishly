//
//  SearchVMProtocol.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 27.07.2023.
//

import Foundation

protocol SearchVMProtocol {
    func searchForRecipes(text: String, completion: @escaping([RecipeViewModel]?, Error?) -> ())
}
