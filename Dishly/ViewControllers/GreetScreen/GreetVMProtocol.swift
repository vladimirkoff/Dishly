//
//  GreetVMProtocol.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 27.07.2023.
//

import UIKit

protocol GreetVMProtocol {
    func signInWithGoogle(with vc: UIViewController, completion: @escaping(Error?, UserViewModel?) -> ())
    func createUser(name: String, email: String, profileImage: Data, id: String, username: String, isCurrentUser: Bool)
}
