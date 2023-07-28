//
//  GoogleAuthServiceProtocol.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 26.07.2023.
//

import UIKit

protocol GoogleAuthServiceProtocol {
    func signInWithGoogle(with vc: UIViewController, completion: @escaping (Error?, UserViewModel?) -> Void)
    func checkIfUserLoggedIn(completion: @escaping (UserViewModel?, Bool) -> Void)
}
