//
//  UserViewModel.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 26.06.2023.
//

import UIKit

struct UserViewModel {
    var user: User?
    
    init(user: User?) {
        self.user = user
    }
    
    var email: String {
        return user?.email ?? ""
    }
    
    var fullName: String {
        return user?.fullName ?? ""
    }
    
    var profileImage: String {
        return user?.profileImage ?? ""
    }
    
    var uid: String {
        return user?.uid ?? ""
    }
    
    var username: String {
        return user?.username ?? ""
    }
    
    var imageData: Data? {
        return user?.imageData
    }
    
}
