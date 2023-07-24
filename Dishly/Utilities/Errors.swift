//
//  Errors.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 10.07.2023.
//

import Foundation

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
            return "Error changin email. Operation requires recent login."
        case .failedToLogout:
            return "Error logging out"
        case .userExists:
            return "User already exists"
        }
    }
    
}


