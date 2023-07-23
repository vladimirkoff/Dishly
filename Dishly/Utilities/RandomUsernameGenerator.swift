//
//  RandomUsernameGenerator.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 04.07.2023.
//

import Foundation

func generateRandomUsername() -> String {
    let alphanumeric = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let usernameLength = 10
    var randomUsername = ""
    
    for _ in 0..<usernameLength {
        let randomIndex = alphanumeric.index(alphanumeric.startIndex, offsetBy: Int.random(in: 0..<alphanumeric.count))
        let character = alphanumeric[randomIndex]
        randomUsername.append(character)
    }
    
    return randomUsername
}

