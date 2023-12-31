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
import JGProgressHUD
import RealmSwift
import SDWebImage


final class GreetViewController: UIViewController {
    
    //MARK: - Properties
    
    private var user: UserViewModel!
    
    private let hud = JGProgressHUD(style: .dark)
    
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
        button.layer.cornerRadius = 17
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
        button.layer.cornerRadius = 17
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
    
    private let viewModel: GreetVMProtocol
    
    //MARK: - Lifecycle
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    init(viewModel: GreetVMProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func showLoader(_ show: Bool) {
        view.endEditing(true )
        show ? hud.show(in: view) : hud.dismiss()
    }
    
    func configureUI() {
        navigationController?.navigationBar.isHidden = true
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.barStyle = .black 
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: isDark ? UIColor.white : UIColor.black]
        

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
    
    func createRealmUser(email: String, name: String, uid: String, profileImage: Data, username: String, isCurrentUser: Bool) {
        viewModel.createUser(name: name, email: email, profileImage: profileImage, id: uid, username: username, isCurrentUser: isCurrentUser)
    }
    
    
    func createImageData(from url: URL, completion: @escaping (Data?) -> Void) {
        let downloader = SDWebImageDownloader.shared
        downloader.downloadImage(with: url) { (image, _, _, _) in
            guard let image = image else {
                completion(nil)
                return
            }
            
            if let imageData = image.pngData() {
                completion(imageData)
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK: - Selectors
    
    @objc func googleAuthButtonPressed() {
        viewModel.signInWithGoogle(with: self) { error, user in
            if let error = error {
                let alert = Alerts.createErrorAlert(error: error.localizedDescription)
                return
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.showLoader(true)
                if let error = error {
                    print("Error authorizing with Google - \(error.localizedDescription)")
                    return
                }
                guard let userModel = user?.user else { return }
                let stringUrl = userModel.profileImage
                if let url = URL(string: stringUrl) {
                    self.createImageData(from: url) { data in
                        if let data = data {
                            self.createRealmUser(email: userModel.email, name: userModel.fullName, uid: userModel.uid, profileImage: data, username: userModel.username, isCurrentUser: true)
                            self.showLoader(false)
                            if let user = user {
                                self.user = user
                                Router.showMainTabBar(from: self, with: user)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func goToSignin() {
        Router.showSignIn(from: self)
    }
    
    @objc func goToSignUp() {
        Router.showSignUp(from: self)
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
        print("DEBUG: login with facebook")
    }
    
}









