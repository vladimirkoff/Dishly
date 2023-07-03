
import UIKit
import SDWebImage

class MainTabBarController: UITabBarController {
    
    //MARK: - Properties
    
    var authService: AuthServiceProtocol!
    var userService: UserServiceProtocol!
    var recipeService: RecipeServiceProtocol!
    
    private let userRealmService: UserRealmServiceProtocol = UserRealmService()
    
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
        configureVC()
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

    func configureVC() {
        
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
        if let exploreViewController = vc as? ExploreViewController {
               let searchController = UISearchController(searchResultsController: nil)
               searchController.searchBar.placeholder = "Search"
               
               exploreViewController.navigationItem.searchController = searchController
               
               exploreViewController.navigationItem.hidesSearchBarWhenScrolling = true
           } else {
               vc.navigationItem.searchController = nil
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

        
        let url = user.profileImage
        guard let imageUrl = URL(string: user.profileImage) else { return }
        
        // Download and set the image using SDWebImage
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
        let vc = ProfileViewController(user: user, userService: userService, profileImage: profileImageView, authService: authService, userRealmService: userRealmService )
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


