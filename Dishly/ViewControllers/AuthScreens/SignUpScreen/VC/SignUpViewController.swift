

import UIKit

final class SignupController: UIViewController {
    
    //MARK: - Properies


    
    private let profilePicButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "profile_picture"), for: .normal)
        button.addTarget(self, action: #selector(chooseImage), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 140).isActive = true
        button.widthAnchor.constraint(equalToConstant: 140).isActive = true
        return button
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Create an account"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    private let emailField: AuthCustomTextField = {
        let tf = AuthCustomTextField(placeholder: "Email")
        tf.autocorrectionType = .no
        return tf
    }()
    
    private let passwordField: AuthCustomTextField = {
        let tf = AuthCustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        tf.autocorrectionType = .no
        return tf
    }()
    
    private let usernameField: AuthCustomTextField = {
        let tf = AuthCustomTextField(placeholder: "Username")
        tf.autocorrectionType = .no
        return tf
    }()
    
    private let fullnameField: AuthCustomTextField = {
        let tf = AuthCustomTextField(placeholder: "Fullname")
        tf.autocorrectionType = .no
        return tf
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign up", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(registerUser), for: .touchUpInside)
        return button
    }()
    
    private let viewModel: SignUpVMProtocol
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationsObservers()
    }
    
    init(viewModel: SignUpVMProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = AppColors.customGrey.color

        
        view.addSubview(welcomeLabel)
        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12)
        ])
        
        view.addSubview(profilePicButton)
        profilePicButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 12).isActive = true
        profilePicButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [emailField, passwordField, fullnameField, usernameField, signUpButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.topAnchor.constraint(equalTo: profilePicButton.bottomAnchor, constant: 15).isActive = true
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        
    }
    
    func configureNotificationsObservers() {
        emailField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        usernameField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullnameField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    func createRealmUser(email: String, name: String, uid: String, profileImage: Data, username: String, isCurrentUser: Bool) {
        viewModel.createUser(name: name, email: email, profileImage: profileImage, id: uid, username: username, isCurrentUser: isCurrentUser)
    }
    
    //MARK: - Selectors
    
    @objc func registerUser() {
        guard let email = emailField.text?.lowercased() else { return }
        guard let password = passwordField.text else { return }
        guard let fullname = fullnameField.text else { return }
        guard let username = usernameField.text else { return }
        
        let userCreds = AuthCreds(email: email, password: password, fullname: fullname, username: username, profileImage: profilePicButton.imageView?.image ?? UIImage(named: "profile_selected"))
        viewModel.register(creds: userCreds) { [weak self] error, user in
            guard let self = self else { return }
            
            if let error = error {
                let alert = Alerts.createErrorAlert(error: error.localizedDescription)
                self.present(alert, animated: true)
                print("DEBUG: Error registering user - \(error.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let profileImage = self.profilePicButton.imageView?.image?.pngData()
                self.createRealmUser(email: email, name: fullname, uid: user!.user!.uid, profileImage: profileImage!, username: username, isCurrentUser: true)
                if let user = user {
                    Router.showMainTabBar(from: self, with: user)
                }
            }
        }
        
    }
    
    @objc func chooseImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailField {
            emailField.text = emailField.text?.lowercased()
        } else if sender == usernameField {
            usernameField.text = usernameField.text?.lowercased()
        }
    }
}

//MARK: - UIImageControllerDelegate

extension SignupController: UIImagePickerControllerDelegate & UINavigationControllerDelegate   {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        
        
        profilePicButton.layer.cornerRadius = profilePicButton.frame.width / 2
        profilePicButton.layer.masksToBounds = true
        profilePicButton.layer.borderColor = UIColor.white.cgColor
        profilePicButton.layer.borderWidth = 2
        
        profilePicButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        picker.dismiss(animated: true)
    }
    
}





