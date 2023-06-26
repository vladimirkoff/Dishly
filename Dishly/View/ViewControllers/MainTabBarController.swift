
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
    }

    
    func configureVC() {
        
        let mainVC = ExploreViewController(user: User(email: "", name: "", profileImageUrl: "", uid: "", username: ""))
        let main = templateNavController(image: UIImage(named: "home")!, rootVC: mainVC)
        
        let addVC = AddViewController()
        let add = templateNavController(image: UIImage(named: "add")!, rootVC: addVC)
        
        let savedVC = SavedViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let saved = templateNavController(image: UIImage(named: "save")!, rootVC: savedVC)
        
        let mealVC = MealPlanVC()
        let plan = templateNavController(image: UIImage(named: "list")!, rootVC: mealVC)
        
        
        viewControllers = [main,  add, saved, plan]
        
        tabBar.items?[0].title = "Home"
        tabBar.items?[1].title = "Add"
        tabBar.items?[2].title = "Saved"
        tabBar.items?[3].title = "Meal Plan"
       
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
    
}


