
import UIKit

class ProfileViewController: UIViewController {
    //MARK: - Properties
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        configureUI()
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "cart"), style: .plain, target: self, action: #selector(rightBarButtonTapped))
            
            // Set the right bar button item
            navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    //MARK: - Selectors
    
    @objc func rightBarButtonTapped() {
        
    }
}
