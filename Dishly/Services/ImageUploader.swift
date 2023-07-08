import UIKit
import FirebaseStorage

class ImageUploader {
    static let shared = ImageUploader()
    private init() {}
    
    func uploadImage(image: UIImage, isForRecipe: Bool, completion: @escaping (String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let fileName = UUID().uuidString
        
        let path = isForRecipe ? "/recipes_images/\(fileName)" : "/profile_images/\(fileName)"
        
        let storageRef = Storage.storage().reference(withPath: path)
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("DEBUG: Failed to upload image - \(error.localizedDescription)")
                return
            }
            
            storageRef.downloadURL { url, error in
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
}
