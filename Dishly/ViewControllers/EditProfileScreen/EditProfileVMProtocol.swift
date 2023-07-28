//
//  EditProfileVMProtocol.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 27.07.2023.
//

import Foundation

protocol EditProfileVMProtocol {
    func updateUser(with user: UserViewModel, completion: @escaping(Error?) -> ())
    func updateUser(user: User, completion: @escaping(Bool) -> ())
    func changeEmail(to newEmail: String, completion: @escaping(Error?) -> ())
}
