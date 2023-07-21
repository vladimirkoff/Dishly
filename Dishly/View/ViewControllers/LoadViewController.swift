import UIKit
import RealmSwift

class LoadViewController: UIViewController {
    //MARK: - Properties
    
    private var user: UserViewModel!
    
    private let authService: AuthServiceProtocol!
    private let userService: UserServiceProtocol!
    private let recipeService: RecipeServiceProtocol!
    private let collectionService: CollectionServiceProtocol!
    private let userRealmService: UserRealmServiceProtocol!
    private let googleAuthService: GoogleAuthServiceProtocol!
    private let mealsService: MealsServiceProtocol!
    private let recipesRealmService: RecipesRealmServiceProtocol!
    
    private var userViewModel: UserViewModel!
    private var authViewModel: AuthViewModel!
    private var userRealmViewModel: UserRealmViewModel!
    private var googleAuthViewModel: GoogleAuthViewModel!
    
    private let ingredientsImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "ingredients2")
        iv.contentMode = .scaleAspectFill
        iv.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 4)
        return iv
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "icon")
        iv.contentMode = .scaleAspectFill
        iv.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 4)
        iv.heightAnchor.constraint(equalToConstant: 45).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 45).isActive = true
        return iv
    }()
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Dishly"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    private let appSlogan: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Unleash Your Culinary Creativity"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    private var verticalStack = UIStackView()
    
    //MARK: - Lifecycle
    
    init(authService: AuthServiceProtocol, userService: UserServiceProtocol, recipeService: RecipeServiceProtocol, userRealmService: UserRealmServiceProtocol, googleAuthService: GoogleAuthServiceProtocol, collectionService: CollectionServiceProtocol, mealsService: MealsServiceProtocol, recipesRealmService: RecipesRealmServiceProtocol) {
        self.authService = authService
        self.userService = userService
        self.recipeService = recipeService
        self.userRealmService = userRealmService
        self.googleAuthService = googleAuthService
        self.collectionService = collectionService
        self.mealsService = mealsService
        self.recipesRealmService = recipesRealmService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        isDark = isDarkMode
        changeAppearance(isDarkMode: isDarkMode, navigationController: navigationController!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateImageView()
    }
    
    //MARK: - Helpers
    
    func checkIfLoggedInWithRealm(completion: @escaping(Bool) -> ())  {
        let realm = try! Realm()
        if let user = realm.objects(UserRealm.self).first {
            
            let dict: [String : Any] = ["fullName" : user.name,
                                        "uid" : user.id,
                                        "imageData" : user.imageData,
                                        "email" : user.email,
                                        "username" : user.username
            ]
            self.user = UserViewModel(user: User(dictionary: dict), userService: userService)
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func checkIfLoggedIn() {
        checkIfLoggedInWithRealm { isLoggedIn in
            if isLoggedIn {
                let vc = MainTabBarController(user: self.user,
                                              authService: self.authService,
                                              userService: self.userService, recipeService: self.recipeService, collectionService: self.collectionService, googleService: self.googleAuthService, mealsService: self.mealsService, recipesRealmService: self.recipesRealmService)
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = GreetViewController(authService: self.authService,
                                             userService: self.userService,
                                             recipeService: self.recipeService,
                                             userRealmService: self.userRealmService,
                                             googleAuthService: self.googleAuthService,
                                             collectionService: self.collectionService,
                                             mealsService: self.mealsService,
                                             recipesRealmService: self.recipesRealmService
                           )
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        //        let currentUser = Auth.auth().currentUser
        //        if let currentUser = currentUser {
        //            let providerID = currentUser.providerData.first?.providerID
        //            if providerID == GoogleAuthProviderID {
        //                googleAuthViewModel.checkIfUserLoggedIn { user in
        //                    DispatchQueue.main.async { [weak self] in
        //                        guard let self = self else { return }
        //                        let vc = MainTabBarController(user: user , authService: self.authService, userService: self.userService, recipeService: self.recipeService, collectionService: collectionService, googleService: self.googleAuthService, mealsService: self.mealsService)
        //                        self.navigationController?.pushViewController(vc, animated: true)
        //                    }
        //                }
        //            } else {
        //                authViewModel.checkIfUserExists { [weak self] user in
        //                    guard let self = self else { return }
        //                    DispatchQueue.main.async {
        //                        let vc = MainTabBarController(user: user , authService: self.authService, userService: self.userService, recipeService: self.recipeService, collectionService: self.collectionService, googleService: self.googleAuthService, mealsService: self.mealsService)
        //                        self.navigationController?.pushViewController(vc, animated: true)
        //                    }
        //                }
        //            }
        //        }
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(ingredientsImageView)
        NSLayoutConstraint.activate([
            ingredientsImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            ingredientsImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ingredientsImageView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            ingredientsImageView.heightAnchor.constraint(equalToConstant: 500)
        ])
        
        let horizontalStack = UIStackView(arrangedSubviews: [iconImageView, appNameLabel])
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 8
        
        verticalStack = UIStackView(arrangedSubviews: [horizontalStack, appSlogan])
        verticalStack.axis = .vertical
        verticalStack.alignment = .center
        verticalStack.spacing = 8
        
        view.addSubview(verticalStack)
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            verticalStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verticalStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            verticalStack.widthAnchor.constraint(equalToConstant: 400),
            verticalStack.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func animateImageView() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
            self.ingredientsImageView.center.x = self.view.bounds.width / 2
            self.ingredientsImageView.center.y = 200
            
            self.verticalStack.center.y = self.verticalStack.center.y - 220
        }) { success in
            self.checkIfLoggedIn()
        }
    }
}
