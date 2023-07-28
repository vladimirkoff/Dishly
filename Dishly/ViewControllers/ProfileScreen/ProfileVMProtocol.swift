//
//  ProfileVMProtocol.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 27.07.2023.
//

import Foundation

protocol ProfileVMProtocol {
    func logOut(completion: @escaping(Error?, Bool) -> ())
    func fetchUser(completion: @escaping(UserViewModel) -> ())
    func deleteCurrentUser(completion: @escaping(Error?) -> ())
}
