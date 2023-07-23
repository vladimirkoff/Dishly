import UIKit
import RealmSwift

private let reuseIdentifier = "ProfileOptionCell"

class ProfileViewController: UIViewController, ProfileOptionCellDelegate {
    
    func switchToggled(sender: UISwitch) {
        print("Toggled")
    }
    
    //MARK: - Properties
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//         return .lightContent
//     }
    
    var userService: UserServiceProtocol!
    var collectionService: CollectionServiceProtocol!
    var googleService: GoogleAuthServiceProtocol!
    var authService: AuthServiceProtocol!
    var userRealmService: UserRealmServiceProtocol!
    var mealsService: MealsServiceProtocol!
    var recipesRealmService: RecipesRealmServiceProtocol!
    
    var userViewModel: UserViewModel!
    var authViewModel: AuthViewModel!
    var user: UserViewModel!
    
    var profileImage: UIImageView!
    
    private let tabBar: UITabBar?
    
    private let switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.translatesAutoresizingMaskIntoConstraints = false
        return switcher
    }()
    
    private var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .lightGray
        iv.layer.cornerRadius = 40
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private let versionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Version 1.0.0"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributedString = NSMutableAttributedString(string: "EDIT YOUR PROFILE")
        attributedString.addAttribute(.underlineStyle, value: 1, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: attributedString.length))
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(goToProfile), for: .touchUpInside)
        return button
    }()

    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.backgroundColor = .lightGray
        tableView.layer.cornerRadius = 10
        return tableView
    }()
    
    private let customView = CustomUIViewBackground()
    
    //MARK: - Lifecycle
    
    override func loadView() {
          view = customView
      }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        versionLabel.textColor = isDark ? .white : .black
        userViewModel.fetchUser { user in
            self.navigationItem.title = user.user!.fullName
        }
        changeEditProfileButton()
        configureNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    init(tabBar: UITabBar?, user: UserViewModel, userService: UserServiceProtocol, profileImage: UIImageView, authService: AuthServiceProtocol, userRealmService: UserRealmServiceProtocol, googleService: GoogleAuthServiceProtocol, collectionService: CollectionServiceProtocol, mealsService: MealsServiceProtocol, recipesRealmService: RecipesRealmServiceProtocol) {
        self.user = user
        self.userService = userService
        self.profileImage = profileImage
        self.authService = authService
        self.userRealmService = userRealmService
        self.googleService = googleService
        self.collectionService = collectionService
        self.mealsService = mealsService
        self.recipesRealmService = recipesRealmService
        self.tabBar = tabBar
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switcher.addTarget(self, action: #selector(switcherValueChanged(_:)), for: .valueChanged)
        configureTableView()
        configureUI()
        
        userViewModel = UserViewModel(user: nil, userService: userService)
        authViewModel = AuthViewModel(authService: authService)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = isDark ? AppColors.customGrey.color : .white
        tabBar?.standardAppearance = appearance
        tabBar?.scrollEdgeAppearance = appearance
        tabBar?.tintColor = isDark ? .white : AppColors.customPurple.color
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureProfileImage()
    }
    
    //MARK: - Helpers
    
    func configureProfileImage() {
        guard let navController = navigationController else { return }
        customView.addSubview(profileImageView)
        profileImageView.image = profileImage.image
        NSLayoutConstraint.activate([
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            profileImageView.bottomAnchor.constraint(equalTo: navController.navigationBar.bottomAnchor),
            profileImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12)
        ])
    }
    
    @objc func switcherValueChanged(_ sender: UISwitch) {
        changeAppearance(isDarkMode: sender.isOn, navigationController: navigationController!)
        customView.backgroundColor = sender.isOn ? AppColors.customGrey.color : AppColors.customLight.color
        changeEditProfileButton()
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: isDark ? UIColor.white : UIColor.black]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: isDark ? UIColor.white : UIColor.black]
        versionLabel.textColor = isDark ? .white : .black
//
//        UIApplication.shared.statusBarStyle = isDark ? .lightContent : .default
//        // Принудительно обновляем стиль статус-бара
//        setNeedsStatusBarAppearanceUpdate()
    }
    
    func changeEditProfileButton() {
        let attributedString = NSMutableAttributedString(string: "EDIT YOUR PROFILE")
        attributedString.addAttribute(.underlineStyle, value: 1, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.foregroundColor, value: isDark ? UIColor.white : UIColor.black, range: NSRange(location: 0, length: attributedString.length))
        editProfileButton.setAttributedTitle(attributedString, for: .normal)
    }
    
    func configureNavBar() {
        navigationItem.title = user.user!.fullName
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: isDark ? UIColor.white : UIColor.black]
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureUI() {        
        customView.addSubview(switcher)
        
        switcher.isOn = isDark

        NSLayoutConstraint.activate([
            switcher.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            switcher.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
        ])
        
        tabBarController?.tabBar.isHidden = true
        

        configureNavBar()
        customView.addSubview(editProfileButton)
        NSLayoutConstraint.activate([
            editProfileButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            editProfileButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16)
        ])
        
        
        
        customView.addSubview(versionLabel)
        NSLayoutConstraint.activate([
            versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            versionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
   
    }
    
    func configureTableView() {
        tableView.register(ProfileOptionCell.self, forCellReuseIdentifier: reuseIdentifier)
        customView.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            tableView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    
    
    func handleLogOut() {
        authViewModel.logOut { [weak self] error, success in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let error = error as? AuthErros {
                    let alert = createErrorAlert(error: error.localizedDescription)
                    self.present(alert, animated: true)
                    return
                }
                
                let realm = try! Realm()
                guard let user = realm.objects(UserRealm.self).first else {
                      print("User not found in Realm.")
                      return
                  }
                
                try! realm.write {
                       realm.delete(user)
                   }
                
                let recipeService = RecipeService()
                let vc = GreetViewController(authService: self.authService, userService: self.userService, recipeService: recipeService, userRealmService: self.userRealmService, googleAuthService: self.googleService, collectionService: self.collectionService, mealsService: self.mealsService, recipesRealmService: self.recipesRealmService)
                let navVC = UINavigationController(rootViewController: vc)
                navVC.modalPresentationStyle = .fullScreen
                self.present(navVC, animated: true)
            }
        }
    }
    
    //MARK: - Selectors
    
    @objc func goToProfile() {
        let vc = EditProfileViewController(user: user, userService: userService, authService: authService, userRealmService: userRealmService, profileImage: profileImageView)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Alert
    
    func showLogoutAlert() {
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let logoutAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
            self.logout()
        }
        alert.addAction(logoutAction)
        present(alert, animated: true, completion: nil)
    }
    
    func logout() {
        handleLogOut()
    }
}



//MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! ProfileOptionCell
        cell.delegate = self
        switch indexPath.row {
        case 0:
            let appearanceImage = UIImage(systemName: "paintbrush.fill")
            cell.accessoryImage.isHidden = true
            cell.accessoryImage.isUserInteractionEnabled = false
            cell.mySwitch.isHidden = false
            cell.isUserInteractionEnabled = false
            cell.cellSymbol.image = appearanceImage
            cell.optionLabel.text = "Change appearance"
        case 1:
            let lockImage = UIImage(systemName: "lock.fill")
            cell.cellSymbol.image = lockImage
            cell.optionLabel.text = "Privacy Policy"
        case 2:
            let infoImage = UIImage(systemName: "info.bubble.fill")
            cell.cellSymbol.image = infoImage
            cell.optionLabel.text = "About Us"
        case 3:
            let logOutImage = UIImage(systemName: "rectangle.portrait.and.arrow.right")
            cell.cellSymbol.image = logOutImage
            cell.optionLabel.text = "Log Out"
        default:
            print("Default")
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            showLogoutAlert()
        } else if indexPath.row == 1 {
            let vc = ProfileOptionVC(docTitle: "Privacy Policy", text: privacyPolicy)
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 2 {
            let vc = ProfileOptionVC(docTitle: "Terms and configitons", text: termsAndConditions)
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 0 {
           print("Tapped")
        }
    }
    
}
