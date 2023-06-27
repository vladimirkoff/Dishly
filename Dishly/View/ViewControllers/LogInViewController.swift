

import UIKit

class LoginController: UIViewController {
 
    
    //MARK: - Proeprties
    
    var authViewModel: AuthenticationViewModel!
    var authService: AuthService!

    private let logo = UIImageView(image: UIImage(named: "Instagram_logo_white"))
    
    private let dontHaveAndAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.attributedTitle(first: "Don't have an account?  ", second: "Sign up")
        button.addTarget(self, action: #selector(goToSignup), for: .touchUpInside)
        return button
    }()
    
    private let forgottenPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.attributedTitle(first: "Forgotten the password? ", second: "Restore your password")
        return button
    }()
    
    private let emailField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Email")
        tf.autocorrectionType = .no
        return tf
    }()
    
    private let passwordField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
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
        button.isEnabled = false
        button.addTarget(self, action: #selector(logIn), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationsObservers()
        
        authService = AuthService.shared
        authViewModel = AuthenticationViewModel(authService: authService)
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        navigationController?.navigationBar.barStyle = .black
        
       
        
        view.addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(dontHaveAndAccountButton)
        dontHaveAndAccountButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        dontHaveAndAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [emailField, passwordField, loginButton, forgottenPasswordButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 32).isActive = true
        stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
    }
    
    func configureNotificationsObservers() {
//        emailField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
//        passwordField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    //MARK: - Selectors
    
    @objc func goToSignup() {
//        let vc = SignupController(scene: self.scene)
//        vc.delegate = delegate
//        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func textDidChange(sender: UITextField) {
//        if sender == emailField {
//            emailField.text = emailField.text?.lowercased()
//            viewModel.email = sender.text
//        } else {
//            viewModel.password = sender.text
//        }
    }
    
    @objc func logIn() {
        guard let email = emailField.text else { return }
        guard let password = passwordField.text else { return }
        
//        Auth.auth().signIn(withEmail: email, password: password) { res, err in
//            if let error = err {
//                print("Error logging in - \(error.localizedDescription)")
//                return
//            }
//            self.delegate?.authComplete()
            
//
//            let nav = UINavigationController(rootViewController: MainTabController(scene: self.scene))
//            nav.navigationBar.isHidden = true
//            self.window?.rootViewController = nav
//            self.window?.makeKeyAndVisible()
//
            
//            let nav = UINavigationController(rootViewController: MainTabController())
//            nav.navigationBar.isHidden = true
//            self.navigationController?.pushViewController(nav, animated: true)
        }
    }



