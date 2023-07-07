
import UIKit
import SDWebImage

class MainTabBarController: UITabBarController {
    
    //MARK: - Properties
    
    var authService: AuthServiceProtocol!
    var userService: UserServiceProtocol!
    var recipeService: RecipeServiceProtocol!
    
    var googleService: GoogleAuthServiceProtocol!
    
    private var collectionService: CollectionServiceProtocol!
    
    var recipesViewModel: RecipesViewModel!
    
    private let userRealmService: UserRealmServiceProtocol = UserRealmService()
    
    private var recipes: [RecipeViewModel]? {
        didSet {
            
        }
    }
    
    var user: User!
    
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
        selectedIndex = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        recipesViewModel = RecipesViewModel(recipeService: recipeService)
        fecthRecipes()
    }
    
    init(user: User, authService: AuthServiceProtocol, userService: UserServiceProtocol, recipeService: RecipeServiceProtocol, collectionService: CollectionServiceProtocol, googleService: GoogleAuthServiceProtocol) {
        self.authService = authService
        self.userService = userService
        self.recipeService = recipeService
        self.user = user
        self.collectionService = collectionService
        self.googleService = googleService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func fecthRecipes() {
        recipesViewModel.fetchRecipes { recipes in
            DispatchQueue.main.async {
                self.recipes = recipes
                self.configureVC()
            }
        }
    }
    
    func configureVC() {
        self.delegate = self
        
        let mainVC = ExploreViewController(user: user, recipes: recipes!, userService: userService, recipeService: recipeService, collectionService: collectionService)
        let main = configureVC(image: UIImage(named: "home")!, vc: mainVC)
        
        let addVC = UIViewController()
        let add = configureVC(image: UIImage(named: "add")!, vc: addVC)
        
        let savedVC = SavedViewController(collectionService: collectionService)
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
        if let exploreViewController = vc as? ExploreViewController {
            let searchController = UISearchController(searchResultsController: nil)
            searchController.searchBar.placeholder = "Search"
            
            exploreViewController.navigationItem.searchController = searchController
            
            exploreViewController.navigationItem.searchController?.searchBar.showsCancelButton = true
            
            exploreViewController.navigationItem.hidesSearchBarWhenScrolling = true
        } else {
            vc.navigationItem.searchController = nil
            vc.navigationItem.searchController?.searchBar.isHidden = true
            vc.navigationItem.searchController?.searchBar.isEnabled = false
            vc.navigationItem.searchController?.searchBar.isTranslucent = true
            
        }
        
        let selectedImage = UIImageView(image: image)
        selectedImage.tintColor = .white
        
        vc.tabBarItem.image = image
        vc.tabBarItem.selectedImage = image.withTintColor(UIColor.systemRed)
        vc.tabBarController?.tabBar.backgroundColor = .black
        
        return vc
    }
    
    func configureNavBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Search"
        
        guard let imageUrl = URL(string: user.profileImage) else { return }
        
        SDWebImageManager.shared.loadImage(with: imageUrl, options: [], progress: nil) { (image, _, _, _, _, _) in
            DispatchQueue.main.async {
                self.profileImageView.image = image
                self.profileContainerView.addSubview(self.profileImageView)
                let leftBarButton = UIBarButtonItem(customView: self.profileContainerView)
                self.navigationItem.leftBarButtonItem = leftBarButton
                
                let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "cart"), style: .plain, target: self, action: #selector(self.rightBarButtonTapped))
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
        let vc = ProfileViewController(user: user, userService: userService, profileImage: profileImageView, authService: authService, userRealmService: userRealmService, googleService: googleService, collectionService: collectionService )
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
