

import UIKit

class SignupController: UIViewController {
    
    //MARK: - Properies
    
    var authViewModel: AuthenticationViewModel!
    var authService: AuthServiceProtocol!
    
    var userService: UserServiceProtocol!
    var recipeService: RecipeServiceProtocol!
        
    private let plusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "profile_picture"), for: .normal)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(chooseImage), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 140).isActive = true
        button.widthAnchor.constraint(equalToConstant: 140).isActive = true
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
    
    private let usernameField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Username")
        tf.autocorrectionType = .no
        return tf
    }()
    
    private let fullnameField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Fullname")
        tf.autocorrectionType = .no
        return tf
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign up", for: .normal)
        button.setTitleColor(UIColor(white: 1, alpha: 0.7), for: .normal)
        button.backgroundColor = .purple.withAlphaComponent(0.7)
        button.layer.cornerRadius = 5
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(registerUser), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationsObservers()
        authViewModel = AuthenticationViewModel(authService: authService)
    }
    
    init(authService: AuthServiceProtocol, userService: UserServiceProtocol, recipeService: RecipeServiceProtocol) {
         self.userService = userService
         self.recipeService = recipeService
         self.authService = authService
         super.init(nibName: nil, bundle: nil)
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        
        view.addSubview(plusButton)
        plusButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4).isActive = true
        plusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [emailField, passwordField, fullnameField, usernameField, signUpButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 15).isActive = true
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        
    }
    
    func configureNotificationsObservers() {
        emailField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        usernameField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullnameField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    func updateForm() {
        //        signUpButton.backgroundColor = viewModel.buttonColor
        //        signUpButton.titleLabel?.textColor = viewModel.buttonTitleColor
        //        signUpButton.isEnabled = viewModel.buttonIsEnabled
    }
    
    //MARK: - Selectors
    
    @objc func registerUser() {
        guard let email = emailField.text?.lowercased() else { return }
        guard let password = passwordField.text else { return }
        guard let fullname = fullnameField.text else { return }
        guard let username = usernameField.text else { return }
        
        let userCreds = AuthCreds(email: email, password: password, fullname: fullname, username: username, profileImage: plusButton.imageView?.image ?? UIImage(named: "profile_selected"))
        authViewModel.register(creds: userCreds) { error in
            if let error = error {
                print("DEBUG: Error registering user - \(error.localizedDescription)")
                return
            }
//            let vc = MainTabBarController(authService: self.authService, userService: self.userService, recipeService: self.recipeService)
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    

    
    @objc func chooseImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    
    @objc func textDidChange(sender: UITextField) {
        //        if sender == emailField {
        //            emailField.text = emailField.text?.lowercased()
        //            viewModel.email = sender.text
        //        } else if sender == passwordField {
        //            viewModel.password = sender.text
        //        } else if sender == fullnameField {
        //            viewModel.fullname = sender.text
        //        } else {
        //            usernameField.text = usernameField.text?.lowercased()
        //            viewModel.username = sender.text
        //        }
        
        updateForm()
        
    }
}

//MARK: - UIImageControllerDelegate

extension SignupController: UIImagePickerControllerDelegate & UINavigationControllerDelegate   {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        
        
        plusButton.layer.cornerRadius = plusButton.frame.width / 2
        plusButton.layer.masksToBounds = true
        plusButton.layer.borderColor = UIColor.white.cgColor
        plusButton.layer.borderWidth = 2
        
        plusButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        picker.dismiss(animated: true)
    }
    
}





