//
//  ImageUploader.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 29.06.2023.
//

import UIKit
import FirebaseStorage

class ImageUploader {
    
    static let shared = ImageUploader()
    private init() {}
    
    func uploadImage(image: UIImage, forRecipe: Bool, completion: @escaping(String) -> ()) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let fileName = UUID().uuidString

        var path = ""
        if forRecipe {
            path = "/recipes_images/\(fileName)"
        } else {
            path = "/profile_images/\(fileName)"
        }
        
        let ref = Storage.storage().reference(withPath: path)
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let error = err {
                print("DEBUG: failed to upload image - \(error.localizedDescription)")
                return
            }
            ref.downloadURL { url, err in
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
}
