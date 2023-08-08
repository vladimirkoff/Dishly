//
//  UserRealmServiceProtocol.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 26.07.2023.
//

import Foundation

protocol UserRealmServiceProtocol {
    func createUser(name: String, email: String, profileImage: Data, id: String, username: String, isCurrentUser: Bool, completion: @escaping (Bool) -> Void)
    func getUser(with id: String, completion: @escaping (User) -> Void)
    func updateUser(user: User, completion: @escaping (Bool) -> Void)
    func deleteUser(id: String)
    func deleteCurrentUser(completion: @escaping(Error?) -> ())
    func checkIfLoggedIn(completion: @escaping(UserViewModel?) -> ())
}
