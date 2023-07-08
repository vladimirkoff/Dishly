

import UIKit

class LoginViewController: UIViewController {
 
    //MARK: - Proeprties
    
    private let authService: AuthServiceProtocol!
    private let userService: UserServiceProtocol!
    private let recipeService: RecipeServiceProtocol!
    private let googleService: GoogleAuthServiceProtocol!
    private let collectionService: CollectionServiceProtocol!
    
    private var authViewModel: AuthViewModel!
    private var userViewModel: UserViewModel!

    private let logo = UIImageView(image: UIImage(named: "Instagram_logo_white"))
    
    private let emailField: AuthCustomTextField = {
        let tf = AuthCustomTextField(placeholder: "Email")
        tf.autocorrectionType = .no
        tf.text = "kovalov280305@gmail.com"
        return tf
    }()

    private let passwordField: AuthCustomTextField = {
        let tf = AuthCustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        tf.text = "123456789"
        tf.autocorrectionType = .no
        return tf
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Log in", for: .normal)
        button.setTitleColor(UIColor(white: 1, alpha: 0.7), for: .normal)
        button.backgroundColor = .purple.withAlphaComponent(0.7)
        button.layer.cornerRadius = 5
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(logIn), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationsObservers()
        
        authViewModel = AuthViewModel(authService: authService)
        userViewModel = UserViewModel(user: nil, userService: userService)
    }
    
    init(authService: AuthServiceProtocol, userService: UserServiceProtocol, recipeService: RecipeServiceProtocol, googleService: GoogleAuthServiceProtocol, collectionService: CollectionServiceProtocol) {
         self.authService = authService
         self.recipeService = recipeService
         self.userService = userService
        self.googleService = googleService
        self.collectionService = collectionService
         super.init(nibName: nil, bundle: nil)
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        navigationController?.navigationBar.barStyle = .black
    
        view.addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [emailField, passwordField, loginButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20

        view.addSubview(stack)
        stack.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 32).isActive = true
        stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
    }
    
    func configureNotificationsObservers() {
        emailField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    //MARK: - Selectors
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailField {
            emailField.text = emailField.text?.lowercased()
        }
    }
    
    @objc func logIn() {
        guard let email = emailField.text else { return }
        guard let password = passwordField.text else { return }

        authViewModel.login(email: email, password: password) { error in
            if let error = error {
                print("DEBUG: Error signing in - \(error)")
                return
            }
            self.userViewModel.fetchUser { user in
                DispatchQueue.main.async {
                    let vc = MainTabBarController(user: user, authService: self.authService, userService: self.userService, recipeService: self.recipeService, collectionService: self.collectionService, googleService: self.googleService)
                    self.navigationController?.pushViewController(vc, animated: true)
                }

            }
        }
    }
}


