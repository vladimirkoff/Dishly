

import UIKit

class AddViewController: UIViewController {
    //MARK: - Properties
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.2117647059, blue: 0.2745098039, alpha: 1)
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

