//
//  LoadVM.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 27.07.2023.
//

import Foundation
import RealmSwift

final class LoadVM: LoadVMProtocol {
    
    private let userRealmService: UserRealmServiceProtocol
    
    init(userRealmService: UserRealmServiceProtocol
    ) {
        self.userRealmService = userRealmService
    }
    
    func checkIfLoggedIn(completion: @escaping(UserViewModel?) -> ()) {
        userRealmService.checkIfLoggedIn { user in
            completion(user)
        }
    }
}
