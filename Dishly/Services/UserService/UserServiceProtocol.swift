//
//  UserServiceProtocol.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 26.07.2023.
//

import Foundation

protocol UserServiceProtocol {
    func fetchUser(with uid: String, completion: @escaping (UserViewModel) -> Void)
    func fetchUser(completion: @escaping (UserViewModel) -> Void)
    func updateUser(changedUser: UserViewModel, completion: @escaping (Error?) -> Void)
    func checkIfUserExists(email: String, completion: @escaping (Bool) -> Void)
    func createUser(name: String, email: String, username: String, profileUrl: String, uid: String, completion: @escaping (Error?, UserViewModel?) -> Void)
    func getUser(by email: String, completion: @escaping (UserViewModel) -> Void)
}
