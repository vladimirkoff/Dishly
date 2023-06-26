//
//  Recipe.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 22.06.2023.
//

import Foundation

struct Recipe {
    let title: String
    let description: String
    let rating: Float
    let author: User
    let uid: String
    let recipeImage: String
    let videoUrl: String?
    let time: String
    let instructions: String
    let nutritions: [Int]?
}

