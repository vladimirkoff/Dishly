
import UIKit
import SDWebImage

final class MainTabBarController: UITabBarController {
    
    //MARK: - Properties
    
    private var recipes: [RecipeViewModel]? 
    
    var user: UserViewModel!
    
    private let profileContainerView: UIView = {
        let profileContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        return profileContainerView
    }()
    
    private lazy var profileImageView: UIImageView = {
        let profileImageView = UIImageView(frame: profileContainerView.bounds)
        profileImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        profileImageView.addGestureRecognizer(gestureRecognizer)
        profileImageView.backgroundColor = .lightGray
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.layer.masksToBounds = true
        return profileImageView
    }()
    
    private let viewModel: MainTabBarVMProtocol
    
    //MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.topItem?.hidesBackButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavBar()
        fecthRecipes()
    }
    
    init(viewModel: MainTabBarVMProtocol, user: UserViewModel) {
        self.viewModel = viewModel
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func fecthRecipes() {
        viewModel.fetchRecipes { recipes, error in
            DispatchQueue.main.async { [weak self] in
                if let error = error {
                    let alert = Alerts.createErrorAlert(error: error.localizedDescription)
                    return
                }
                self?.recipes = recipes
                self?.configureVC()
            }
        }
    }
    
    func configureVC() {
        self.delegate = self
        
        let mainVC = Router.createExploreVC(user: user)
        let main = configureVC(image: UIImage(named: "home")!, vc: mainVC)
        
        let addVC = UIViewController()
        let add = configureVC(image: UIImage(named: "add")!, vc: addVC)
        
        let savedVC = Router.createSavedVC()
        let saved = configureVC(image: UIImage(named: "save")!, vc: savedVC)
        
        let mealVC = Router.createMealPlanVC()
        let plan = configureVC(image: UIImage(named: "list")!, vc: mealVC)
        
        viewControllers = [main,  add, saved, plan]
        
        tabBar.items?[0].title = "Home"
        tabBar.items?[1].title = "Add"
        tabBar.items?[2].title = "Saved"
        tabBar.items?[3].title = "Meal Plan"
        
        tabBar.barStyle = .default
        tabBar.inputViewController?.hidesBottomBarWhenPushed = false
        
    }
    
    func configureVC(image: UIImage, vc: UIViewController) -> UIViewController {
        let selectedImage = UIImageView(image: image)
        selectedImage.tintColor = .white
  
        
        vc.tabBarItem.image = image
        vc.tabBarItem.selectedImage = image.withTintColor(UIColor.systemRed)
        
        return vc
    }
    
    func configureNavBar() {
        
        guard let imageUrl = URL(string: user.profileImage) else {
            guard let imageData = user.imageData else { return }
            guard let image = UIImage(data: imageData) else { return }
               
            self.profileImageView.image = image
            self.profileContainerView.addSubview(self.profileImageView)
            let leftBarButton = UIBarButtonItem(customView: self.profileContainerView)
            self.navigationItem.leftBarButtonItem = leftBarButton

            let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "cart.fill"), style: .plain, target: self, action: #selector(self.cartTapped))
            rightBarButtonItem.tintColor = isDark ? .white : AppColors.customBrown.color

            
            self.navigationItem.rightBarButtonItem = rightBarButtonItem
            return
        }
        
        SDWebImageManager.shared.loadImage(with: imageUrl, options: [], progress: nil) { (image, _, _, _, _, _) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.profileImageView.image = image
                let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "cart.fill"), style: .plain, target: self, action: #selector(self.cartTapped))
                rightBarButtonItem.tintColor = isDark ? .white : AppColors.customBrown.color
                self.profileContainerView.addSubview(self.profileImageView)
                let leftBarButton = UIBarButtonItem(customView: self.profileContainerView)
                self.navigationItem.leftBarButtonItem = leftBarButton
                self.navigationItem.rightBarButtonItem = rightBarButtonItem
            }
        }
    }
    
    //MARK: - Selectors
    
    @objc func cartTapped() {
        Router.showCart(from: self)
    }
    
    @objc func profileTapped() {
        Router.showProfile(from: self,
                           with: user,
                           image: profileImageView
        )
    }
    
}

//MARK: - UITabBarControllerDelegate

extension MainTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController) else {
            return true
        }
        if selectedIndex == 1 {
            Router.showAddRecipe(from: self, for: user)
            return false
        }
        return true
    }
}


