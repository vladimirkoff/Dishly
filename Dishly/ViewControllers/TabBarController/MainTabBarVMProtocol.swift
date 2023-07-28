//
//  MainTabBarVMProtocol.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 27.07.2023.
//

import Foundation

protocol MainTabBarVMProtocol {
    func fetchRecipes(completion: @escaping([RecipeViewModel]?, Error?) -> ())
}
