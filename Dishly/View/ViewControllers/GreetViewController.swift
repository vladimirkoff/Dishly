//
//  GreetViewController.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 29.06.2023.
//

import UIKit
import FirebaseAuth
import FacebookLogin
import GoogleSignIn
import FirebaseCore


class GreetViewController: UIViewController {
    
    //MARK: - Properties
    
    private var user: User!
    
    var authService: AuthServiceProtocol!
    var userService: UserServiceProtocol!
    var recipeService: RecipeServiceProtocol!
    
    var userViewModel: UserViewModel!
    var authViewModel: AuthViewModel!
    
    var userRealmService: UserRealmServiceProtocol!
    var userRealmViewModel: UserRealmViewModel!
    
    
    private let backGroundImage: UIImageView = {
        let image = UIImage(named: "dish")
        let iv = UIImageView(image: image)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let appTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Dishly"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    private lazy var facebookAuthButton: FBLoginButton = {
        let button = FBLoginButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: view.bounds.width / 4 + 10).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.delegate = self
        return button
    }()
    
    private lazy var appleAuthButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: view.bounds.width / 4 + 10).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.backgroundColor = .white
        button.layer.cornerRadius = 17
        
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 22)
        let symbolImage = UIImage(systemName: "apple.logo", withConfiguration: symbolConfiguration)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        button.setImage(symbolImage, for: .normal)
        
        return button
    }()
    
    private lazy var googleAuthButton: GIDSignInButton = {
        let button = GIDSignInButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: view.bounds.width / 4 + 10).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(googleAuthButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private let authWithEmailButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 22)
        let symbolImage = UIImage(systemName: "envelope", withConfiguration: symbolConfiguration)
        
        let attributedText = NSMutableAttributedString()
        
        if let symbolImage = symbolImage {
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = symbolImage
            let imageString = NSAttributedString(attachment: imageAttachment)
            attributedText.append(imageString)
            
            let spaceString = NSAttributedString(string: " ")
            attributedText.append(spaceString)
        }
        
        let titleText = NSAttributedString(string: "SIGN UP WITH EMAIL", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 22),
            .foregroundColor: UIColor.black
        ])
        attributedText.append(titleText)
        
        button.setAttributedTitle(attributedText, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 17
        
        button.addTarget(self, action: #selector(goToSignUp), for: .touchUpInside)
        
        return button
    }()
    
    
    private let alreadyHaveAnAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.attributedTitle(first: "Already have an account?  ", second: "Log in")
        button.addTarget(self, action: #selector(goToSignin), for: .touchUpInside)
        return button
    }()
    
    private lazy var privacyNoticeAndTermsOfUseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: view.bounds.width - 20).isActive = true
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "By using Dishly, you agree to our Privacy Notice and Terms of use"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    //MARK: - Lifecycle
    //
    //    func createTestUser() {
    //        userRealmService = UserRealmService()
    //        userRealmViewModel = UserRealmViewModel(userRealmService: userRealmService)
    //        userRealmViewModel.createUser(name: "Vova", email: "None", profileImage: "///.com", id: "1iwyfwei7d")
    //    }
    
    //    func fetchTestUser() {
    //        userRealmService = UserRealmService()
    //        userRealmViewModel = UserRealmViewModel(userRealmService: userRealmService)
    //        userRealmViewModel.getUser(with: "KXYZtUbg3vSu0VOTwtjFyNDAhPg1") { user in
    //            if let image = UIImage(data: user.imageData) {
    //                self.backGroundImage.image = image
    //            }
    //        }
    //    }
    //    func fetchUsers() {
    //        userRealmService = UserRealmService()
    //        userRealmViewModel = UserRealmViewModel(userRealmService: userRealmService)
    //    }
    //
    //    func updateUser() {
    //        userRealmService = UserRealmService()
    //        userRealmViewModel = UserRealmViewModel(userRealmService: userRealmService)
    //        let user = User(dictionary: ["fullName" : "Sasha",
    //                                     "uid" : "1iwyfwei7d"
    //                                    ])
    //        userRealmViewModel.updateUser(user: user) { success in
    //            print(success)
    //        }
    //    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkIfLoggedIn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        userViewModel = UserViewModel(userService: userService)
        
    }
    
    init(authService: AuthServiceProtocol, userService: UserServiceProtocol, recipeService: RecipeServiceProtocol, userRealmService: UserRealmServiceProtocol) {
        self.authService = authService
        self.userService = userService
        self.recipeService = recipeService
        self.userRealmService = userRealmService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func checkIfLoggedIn() {
        let currentUser = Auth.auth().currentUser
        if currentUser != nil {
            userViewModel.fetchUser { user in
                DispatchQueue.main.async {
                    let vc = MainTabBarController(user: user , authService: self.authService, userService: self.userService, recipeService: self.recipeService)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        } else {
            if let googleUser = GIDSignIn.sharedInstance.currentUser
            {
                AuthService().getUser(by: googleUser.profile!.email) { user in
                    DispatchQueue.main.async {
                        let vc = MainTabBarController(user: user , authService: self.authService, userService: self.userService, recipeService: self.recipeService)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            } else {
                return
            }
        }
    }
    
    func configureUI() {
        view.addSubview(backGroundImage)
        NSLayoutConstraint.activate([
            backGroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backGroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backGroundImage.leftAnchor.constraint(equalTo: view.leftAnchor),
            backGroundImage.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        
        view.addSubview(appTitleLabel)
        let distance = view.bounds.height / 4 + 20
        NSLayoutConstraint.activate([
            appTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appTitleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -distance),
        ])
        
        let authButtonsStack = UIStackView(arrangedSubviews: [appleAuthButton, facebookAuthButton, googleAuthButton])
        authButtonsStack.translatesAutoresizingMaskIntoConstraints = false
        authButtonsStack.axis = .horizontal
        authButtonsStack.distribution = .equalCentering
        authButtonsStack.spacing = 12
        
        view.addSubview(authButtonsStack)
        NSLayoutConstraint.activate([
            authButtonsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authButtonsStack.topAnchor.constraint(equalTo: appTitleLabel.bottomAnchor, constant: 16),
            authButtonsStack.heightAnchor.constraint(equalToConstant: 40),
            authButtonsStack.widthAnchor.constraint(equalToConstant: view.bounds.width - 10)
        ])
        
        view.addSubview(authWithEmailButton)
        NSLayoutConstraint.activate([
            authWithEmailButton.topAnchor.constraint(equalTo: authButtonsStack.bottomAnchor, constant: 12),
            authWithEmailButton.widthAnchor.constraint(equalToConstant: view.bounds.width - 20),
            authWithEmailButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(alreadyHaveAnAccountButton)
        NSLayoutConstraint.activate([
            alreadyHaveAnAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alreadyHaveAnAccountButton.topAnchor.constraint(equalTo: authWithEmailButton.bottomAnchor, constant: 8)
        ])
        
        view.addSubview(privacyNoticeAndTermsOfUseLabel)
        NSLayoutConstraint.activate([
            privacyNoticeAndTermsOfUseLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -6),
            privacyNoticeAndTermsOfUseLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
    
    
    //MARK: - Selectors
    
    @objc func googleAuthButtonPressed() {
        authViewModel = AuthViewModel(authService: authService)
        authViewModel.signInWithGoogle(with: self) { error, user in
            if let error = error {
                print("Error authorizing with Google - \(error.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
                if let user = user {
                    self.user = user
                    let vc = MainTabBarController(user: user, authService: self.authService, userService: self.userService, recipeService: self.recipeService)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    @objc func goToSignin() {
        guard let authService = authService else { return }
        guard let userService = userService else { return }
        guard let recipeService = recipeService else { return }
        let vc = LoginViewController(authService: authService, userService: userService, recipeService: recipeService)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func goToSignUp() {
        let vc = SignupController(authService: authService, userService: userService, recipeService: recipeService, userRealmService: userRealmService)
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - LoginButtonDelegate

extension GreetViewController: LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            print("Facebook Login error: \(error.localizedDescription)")
            return
        }
        
        guard let token = AccessToken.current?.tokenString else {
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("Firebase Auth error: \(error.localizedDescription)")
                return
            }
            
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    
}









