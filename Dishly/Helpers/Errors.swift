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

// User errors

struct UserErrors: Error {
    let errorMessage: String

    init(errorMessage: String = "Collection already exists") {
        self.errorMessage = errorMessage
    }
}
