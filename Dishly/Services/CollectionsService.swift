//
//  CollectionsService.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 07.07.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol CollectionServiceProtocol {
    
}
 
class CollectionService: CollectionServiceProtocol {
    static let shared = CollectionService()
    private init() {}
    
    func fetchCollections(completion: @escaping([Collection]) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var collectionsArray: [Collection] = []
        
        COLLECTION_USERS.document(uid).collection("collections").getDocuments { snapshot, error in
            if let collections = snapshot?.documents {
                for collection in collections {
                    let name = collection.data()["name"] as? String ?? ""
                    let url = collection.data()["imageUrl"] as? String ?? ""
                    let id = collection.data()["id"] as? String ?? ""
                    
                    let collectionModel = Collection(name: name, imageUrl: url, id: id)
                    collectionsArray.append(collectionModel)
                }
                completion(collectionsArray)
            }
        }
    }
}
