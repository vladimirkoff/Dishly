
import UIKit
//import FirebaseAuth

class MainTabBarController: UITabBarController {
    
    //MARK: - Properties
    

    //MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedIndex = 0
        checkIfLoggedIn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        selectedIndex = 0
    }
    
    //MARK: - Helpers
    
    func checkIfLoggedIn() {
//        if Auth.auth().currentUser == nil {
//            DispatchQueue.main.async {
//                let controller = LoginController()
//                let nav = UINavigationController(rootViewController: controller)
//                nav.modalPresentationStyle = .fullScreen
//                self.present(nav, animated: true, completion: nil)
//            }
//        }
    }

    
    func configureVC() {
        
        let mainVC = MainViewController(user: User(name: "Vlad", points: 2, email: "", lastName: "", phone: "", uid: ""))
        let main = templateNavController(image: UIImage(named: "home")!, rootVC: mainVC)
        
        let addVC = AddViewController()
        let add = templateNavController(image: UIImage(named: "add")!, rootVC: addVC)
        
//        let savedVC = SavedViewController(collectionViewLayout: UICollectionViewFlowLayout())
//        let saved = templateNavController(image: UIImage(named: "save")!, rootVC: savedVC)
        
        let profileVC = ProfileViewController()
        let profile = templateNavController(image: UIImage(named: "profile")!, rootVC: profileVC)
        
        
        viewControllers = [main,  add, profile]
        
        tabBar.items?[0].title = "Home"
        tabBar.items?[1].title = "Add"
        tabBar.items?[2].title = "Profile"
       
        tabBar.tintColor = .black
        
        tabBar.barStyle = .default
        tabBar.inputViewController?.hidesBottomBarWhenPushed = false
        
        tabBar.backgroundColor = .white
        
        
    }
    
    func templateNavController(image: UIImage, rootVC: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootVC)
        
        let selectedImage = UIImageView(image: image)
        selectedImage.tintColor = .white
    
        nav.tabBarItem.image = image
        nav.tabBarItem.selectedImage = image.withTintColor(UIColor.systemRed)
        nav.tabBarController?.tabBar.backgroundColor = .black
        
        return nav
    }
    
    //MARK: - Selectors
    
    @objc func rightBarButtonTapped() {
        print("Cart tapepd")
    }
    
    @objc func qrCodeButtonPressed() {
//
//        let vc = UINavigationController(rootViewController: QRCodeViewController())
//        vc.modalPresentationStyle = .formSheet
//
//
//        present(vc, animated: true)
    }
    
}


