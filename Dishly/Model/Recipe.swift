//
//  Recipe.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 22.06.2023.
//

import Foundation

struct Recipe {
    let title: String
    let discription: String
    let rating: Float
    let author: User
    let uid: String
    let time: String
    let instructions: String
    let nutritions: [Int]?
}

