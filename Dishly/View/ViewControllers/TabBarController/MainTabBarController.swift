
import UIKit
import SDWebImage

class MainTabBarController: UITabBarController {
    
    //MARK: - Properties
    
    private let authService: AuthServiceProtocol!
    private let userService: UserServiceProtocol!
    private let recipeService: RecipeServiceProtocol!
    private let mealsService: MealsServiceProtocol
    private let googleService: GoogleAuthServiceProtocol!
    private let collectionService: CollectionServiceProtocol!
    private let recipesRealmService: RecipesRealmServiceProtocol!
    
    private var recipesViewModel: RecipesViewModel!
    
    private let userRealmService: UserRealmServiceProtocol = UserRealmService()
    
    private var recipes: [RecipeViewModel]? {
        didSet {
            
        }
    }
    
    var user: UserViewModel!
    
    private let profileContainerView: UIView = {
        let profileContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        return profileContainerView
    }()
    
    private lazy var profileImageView: UIImageView = {
        let profileImageView = UIImageView(frame: profileContainerView.bounds)
        profileImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(leftBarButtonTapped))
        profileImageView.addGestureRecognizer(gestureRecognizer)
        profileImageView.backgroundColor = .lightGray
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.layer.masksToBounds = true
        return profileImageView
    }()
    
    //MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.topItem?.hidesBackButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = AppColors.customGrey.color

        configureNavBar()
        recipesViewModel = RecipesViewModel(recipeService: recipeService)
        fecthRecipes()
    }
    
    init(user: UserViewModel, authService: AuthServiceProtocol, userService: UserServiceProtocol, recipeService: RecipeServiceProtocol, collectionService: CollectionServiceProtocol, googleService: GoogleAuthServiceProtocol, mealsService: MealsServiceProtocol, recipesRealmService: RecipesRealmServiceProtocol) {
        self.authService = authService
        self.userService = userService
        self.recipeService = recipeService
        self.user = user
        self.collectionService = collectionService
        self.googleService = googleService
        self.mealsService = mealsService
        self.recipesRealmService = recipesRealmService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func fecthRecipes() {
        recipesViewModel.fetchRecipes { recipes, error in
            DispatchQueue.main.async { [weak self] in
                if let error = error {
                    let alert = createErrorAlert(error: error.localizedDescription)
                    return
                }
                self?.recipes = recipes
                self?.configureVC()
            }
        }
    }
    
    func configureVC() {
        self.delegate = self
        
        let mainVC = ExploreViewController(user: user, recipes: recipes!, userService: userService, recipeService: recipeService, collectionService: collectionService)
        let main = configureVC(image: UIImage(named: "home")!, vc: mainVC)
        
        let addVC = UIViewController()
        let add = configureVC(image: UIImage(named: "add")!, vc: addVC)
        
        let savedVC = SavedViewController(collectionService: collectionService, user: user)
        let saved = configureVC(image: UIImage(named: "save")!, vc: savedVC)
        
        let mealVC = MealPlanVC(mealsService: mealsService, recipesRealmService: recipesRealmService)
        let plan = configureVC(image: UIImage(named: "list")!, vc: mealVC)
        
        viewControllers = [main,  add, saved, plan]
        
        tabBar.items?[0].title = "Home"
        tabBar.items?[1].title = "Add"
        tabBar.items?[2].title = "Saved"
        tabBar.items?[3].title = "Meal Plan"
        
        tabBar.tintColor = .white
        
        tabBar.barStyle = .default
        tabBar.inputViewController?.hidesBottomBarWhenPushed = false
        
        
    }
    
    func configureVC(image: UIImage, vc: UIViewController) -> UIViewController {
        let selectedImage = UIImageView(image: image)
        selectedImage.tintColor = .white
        
        vc.tabBarItem.image = image
        vc.tabBarItem.selectedImage = image.withTintColor(UIColor.systemRed)
        vc.tabBarController?.tabBar.backgroundColor = .black
        
        return vc
    }
    
    func configureNavBar() {
        
        guard let imageUrl = URL(string: user.user!.profileImage) else {
            guard let imageData = user.user?.imageData else { return }
            guard let image = UIImage(data: imageData) else { return }
               
            self.profileImageView.image = image
            self.profileContainerView.addSubview(self.profileImageView)
            let leftBarButton = UIBarButtonItem(customView: self.profileContainerView)
            self.navigationItem.leftBarButtonItem = leftBarButton

            let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "cart.fill"), style: .plain, target: self, action: #selector(self.rightBarButtonTapped))
            rightBarButtonItem.tintColor = isDark ? .white : AppColors.customPurple.color

            
            self.navigationItem.rightBarButtonItem = rightBarButtonItem
            return
        }
        
        SDWebImageManager.shared.loadImage(with: imageUrl, options: [], progress: nil) { (image, _, _, _, _, _) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.profileImageView.image = image
                self.profileContainerView.addSubview(self.profileImageView)
                let leftBarButton = UIBarButtonItem(customView: self.profileContainerView)
                self.navigationItem.leftBarButtonItem = leftBarButton
                
                let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "cart.fill"), style: .plain, target: self, action: #selector(self.rightBarButtonTapped))
                rightBarButtonItem.tintColor = .white

                self.navigationItem.rightBarButtonItem = rightBarButtonItem
            }
        }
    }
    
    //MARK: - Selectors
    
    @objc func rightBarButtonTapped() {
        let vc = CartViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func leftBarButtonTapped() {
        let vc = ProfileViewController(user: user, userService: userService, profileImage: profileImageView, authService: authService, userRealmService: userRealmService, googleService: googleService, collectionService: collectionService, mealsService: mealsService, recipesRealmService: recipesRealmService)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: - UITabBarControllerDelegate

extension MainTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController) else {
            return true
        }
        if selectedIndex == 1 {
            let vc = AddRecipeViewController.instantiateFromStoryboard()
            vc.recipeService = recipeService
            vc.user = user
            let nav = UINavigationController(rootViewController: vc)
            navigationController?.modalPresentationStyle = .fullScreen
            navigationController?.present(nav, animated: true)
            return false
        }
        return true
    }
}

extension MainTabBarController {
    

    
}
