
import UIKit

class MainTabBarController: UITabBarController {
    
    //MARK: - Properties
    
    var authService: AuthServiceProtocol!
    var userService: UserServiceProtocol!
    var recipeService: RecipeServiceProtocol!
    
    var user: User!
    

    //MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedIndex = 0
        checkIfLoggedIn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "cart"), style: .plain, target: self, action: #selector(rightBarButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "profile"), style: .plain, target: self, action: #selector(leftBarButtonTapped))
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        selectedIndex = 0
    }
    
    init(user: User, authService: AuthServiceProtocol, userService: UserServiceProtocol, recipeService: RecipeServiceProtocol) {
         self.authService = authService
         self.userService = userService
         self.recipeService = recipeService
         self.user = user
        
         super.init(nibName: nil, bundle: nil)
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func checkIfLoggedIn() {
    }

    
    func configureVC() {
        
        print(user)
        
        let mainVC = ExploreViewController(user: user, userService: userService, recipeService: recipeService)
        let main = configureVC(image: UIImage(named: "home")!, vc: mainVC)
        
        let addVC = AddViewController()
        let add = configureVC(image: UIImage(named: "add")!, vc: addVC)
        
        let savedVC = SavedViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let saved = configureVC(image: UIImage(named: "save")!, vc: savedVC)
        
        let mealVC = MealPlanVC()
        let plan = configureVC(image: UIImage(named: "list")!, vc: mealVC)
        
        
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
    
    
    func configureVC(image: UIImage, vc: UIViewController) -> UIViewController {
        
        let selectedImage = UIImageView(image: image)
        selectedImage.tintColor = .white
    
        vc.tabBarItem.image = image
        vc.tabBarItem.selectedImage = image.withTintColor(UIColor.systemRed)
        vc.tabBarController?.tabBar.backgroundColor = .black
        
        return vc
    }
    
    //MARK: - Selectors
    
    @objc func rightBarButtonTapped() {
        let vc = CartViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func leftBarButtonTapped() {
        let vc = ProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


