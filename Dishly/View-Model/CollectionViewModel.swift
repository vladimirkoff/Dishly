//
//  CollectionViewModel.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 07.07.2023.
//

import UIKit

class CollectionViewModel {
    private let collectionService: CollectionServiceProtocol
    
    var collection: Collection?
    
    init(collectionService: CollectionServiceProtocol, collection: Collection?) {
        self.collectionService = collectionService
        self.collection = collection
    }
    
    func fecthCollections(completion: @escaping([Collection]) -> ()) {
        collectionService.fetchCollections { collections in
            completion(collections)
        }
    }

}
