//
//  Errors.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 10.07.2023.
//

import Foundation

// Collection errors

struct CollectionErrors: Error {
    let errorMessage: String

    init(errorMessage: String) {
        self.errorMessage = errorMessage
    }
}

enum AuthErros: Error {
    
    case failedChangeEmail
    case failedToLogout
    case userExists
    
    var localizedDescription: String {
        switch self {
        case .failedChangeEmail:
            return "Error changin email"
        case .failedToLogout:
            return "Error logging out"
        case .userExists:
            return "User already exists"
        }
    }
    
}

// User errors

struct UserErrors: Error {
    let errorMessage: String

    init(errorMessage: String = "Collection already exists") {
        self.errorMessage = errorMessage
    }
}
