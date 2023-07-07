

import Foundation
import UIKit

protocol Storyboardable {
    static func instantiateFromStoryboard() -> Self
}

extension Storyboardable where Self: UIViewController {
    
    static func instantiateFromStoryboard() -> Self {
        let storyboardId = String(describing: self)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: storyboardId) as? Self else { fatalError("Unable to Instantiate ViewController \(storyboardId)") }
        return vc
    }
    
}
