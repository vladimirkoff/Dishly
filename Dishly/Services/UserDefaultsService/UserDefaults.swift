//
//  UserDefaults.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 30.07.2023.
//

import Foundation

final class UserDefaultsService: UserDefaultsProtocol {
    
    func getIngredients(completion: @escaping (Result<[Ingredient], Error>) -> ()) {
        if let savedData = UserDefaults.standard.data(forKey: "customIngredients") {
            let decoder = JSONDecoder()
            do {
                let loadedIngredients = try decoder.decode([Ingredient].self, from: savedData)
                completion(.success(loadedIngredients))
            } catch {
                completion(.failure(error))
            }
        } else {
            completion(.success([]))
        }
    }

    func saveIngredients(completion: @escaping (Result<Void, Error>) -> ()) {
        let encoder = JSONEncoder()
        do {
            if let encodedData = try? encoder.encode(myGroceries) {
                UserDefaults.standard.set(encodedData, forKey: "customIngredients")
                completion(.success(())) 
            } else {
                let encodingError = NSError(domain: "MyApp", code: 1, userInfo: nil)
                completion(.failure(encodingError))
            }
        } catch {
            completion(.failure(error))
        }
    }

}


