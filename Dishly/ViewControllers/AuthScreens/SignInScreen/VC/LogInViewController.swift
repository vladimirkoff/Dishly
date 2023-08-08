

import UIKit
import SDWebImage

final class LoginViewController: UIViewController {
 
    //MARK: - Proeprties

    private var userViewModel: UserViewModel!
    
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
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(logIn), for: .touchUpInside)
        return button
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome To Dishly 🥘"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    private let viewModel: SignInVMProtocol
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationsObservers()
    }
    
    init(viewModel: SignInVMProtocol) {
         self.viewModel = viewModel
         super.init(nibName: nil, bundle: nil)
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func createRealmUser(email: String, name: String, uid: String, profileImage: Data, username: String, isCurrentUser: Bool) {
        viewModel.createUser(name: name, email: email, profileImage: profileImage, id: uid, username: username, isCurrentUser: true)
    }
    
    func configureUI() {
        navigationController?.navigationBar.barStyle = .black
        view.backgroundColor = AppColors.customGrey.color

        view.addSubview(welcomeLabel)
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22),
            welcomeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 14)
        ])
        
        let stack = UIStackView(arrangedSubviews: [emailField, passwordField, loginButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20

        view.addSubview(stack)
        stack.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 32).isActive = true
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
    
    func getImageFromURL(url: URL, completion: @escaping (UIImage?) -> Void) {
        SDWebImageManager.shared.loadImage(with: url, options: [], progress: nil) { (image, _, _, _, _, _) in
            completion(image)
        }
    }
    
    @objc func logIn() {
        guard let email = emailField.text else { return }
        guard let password = passwordField.text else { return }

        viewModel.login(email: email, password: password) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                let alert = Alerts.createErrorAlert(error: error.localizedDescription)
                self.present(alert, animated: true)
                print("DEBUG: Error signing in - \(error)")
                return
            }
            
            self.viewModel.fetchUser {  user in
                guard let userModel = user.user else { return }
                guard let url = URL(string: userModel.profileImage) else { return }
                self.getImageFromURL(url: url) { image in
                    guard let image = image else { return }
                    if let imageData = image.pngData() {
                        self.createRealmUser(email: userModel.email, name: userModel.fullName, uid: userModel.uid, profileImage: imageData, username: userModel.username, isCurrentUser: true)
                        
                        DispatchQueue.main.async {  
                            Router.showMainTabBar(from: self, with: user)
                        }
                    }
                    
                }
                
                
            }
        }
    }
}



