import UIKit
import RealmSwift

private let reuseIdentifier = "ProfileOptionCell"

final class ProfileViewController: UIViewController, ProfileOptionCellDelegate {
    
    func switchToggled(sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "isDarkMode")
        isDark = sender.isOn
        ThemeManager.applyCurrentTheme()
        
        view.backgroundColor = isDark ? AppColors.customGrey.color : AppColors.customLight.color
        changeEditProfileButton()
        
        UINavigationBar.appearance().barTintColor = isDark ? AppColors.customGrey.color : AppColors.customLight.color
        navigationController?.navigationBar.tintColor = isDark ? .white : AppColors.customBrown.color

        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: isDark ? UIColor.white : UIColor.black]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: isDark ? UIColor.white : UIColor.black]
        versionLabel.textColor = isDark ? .white : .black
        
        profileImageView.layer.borderColor = isDark ? UIColor.white.cgColor : AppColors.customBrown.color.cgColor
    }
    
    //MARK: - Properties

    var user: UserViewModel? {
        didSet {
            configureNavBar()
        }
    }
    
    var profileImage: UIImageView? {
        didSet {
            configureProfileImage()
        }
    }
        
    private var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .lightGray
        iv.layer.cornerRadius = 60
        iv.layer.borderWidth = 3
        iv.layer.borderColor = isDark ? UIColor.white.cgColor : AppColors.customBrown.color.cgColor
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
    
    
    //MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = isDark ? AppColors.customGrey.color : AppColors.customLight.color
        
        versionLabel.textColor = isDark ? .white : .black
        viewModel.fetchUser { user in
            self.user = user
            self.navigationItem.title = user.fullName
        }
        changeEditProfileButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        
    }
    
    private let viewModel: ProfileVMProtocol
    
    init(viewModel: ProfileVMProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureUI()
    }
    
    //MARK: - Helpers
    
    func configureProfileImage() {
        view.addSubview(profileImageView)
        
        profileImageView.image = profileImage!.image
        NSLayoutConstraint.activate([
            profileImageView.heightAnchor.constraint(equalToConstant: 120),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            profileImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32)
        ])
    }

    func changeEditProfileButton() {
        let attributedString = NSMutableAttributedString(string: "EDIT YOUR PROFILE")
        attributedString.addAttribute(.underlineStyle, value: 1, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.foregroundColor, value: isDark ? UIColor.white : UIColor.black, range: NSRange(location: 0, length: attributedString.length))
        editProfileButton.setAttributedTitle(attributedString, for: .normal)
    }
    
    func configureNavBar() {
        navigationItem.title = user?.fullName ?? "User not found"
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: isDark ? UIColor.white : UIColor.black]
    }
    
    func configureUI() {
        tabBarController?.tabBar.isHidden = true
        
        configureNavBar()
        view.addSubview(editProfileButton)
        NSLayoutConstraint.activate([
            editProfileButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            editProfileButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16)
        ])
        
        view.addSubview(versionLabel)
        NSLayoutConstraint.activate([
            versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            versionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
        
        let socialMediaButtons = createSocialButtons()
        let stackView = UIStackView(arrangedSubviews: socialMediaButtons)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 15
        stackView.alignment = .center
        
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 12)
        ])
        
    }
    
    func createSocialButton(imageName: String, target: Any?, action: Selector) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: imageName), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }
    
    private func createSocialButtons() -> [UIButton] {
        let instaButton = createSocialButton(imageName: "insta", target: self, action: #selector(openInsta))
        let facebookButton = createSocialButton(imageName: "facebook", target: self, action: #selector(openFacebook))
        let twitterButton = createSocialButton(imageName: "twitter", target: self, action: #selector(openTwitter))
        let pinterestButton = createSocialButton(imageName: "pinterest", target: self, action: #selector(openPinterest))
        return [instaButton, facebookButton, twitterButton, pinterestButton]
    }
    
    
    func configureTableView() {
        tableView.register(ProfileOptionCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            tableView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func handleLogOut() {
        viewModel.logOut { [weak self] error, success in
            guard let self = self else { return }
            if let error = error as? AuthErros {
                DispatchQueue.main.async {
                    let alert = Alerts.createErrorAlert(error: error.localizedDescription)
                    self.present(alert, animated: true)
                    return
                }
            } else {
                self.viewModel.deleteCurrentUser { error in
                    DispatchQueue.main.async {
                        if let error = error {
                            print(error.localizedDescription)
                            let alert = Alerts.createErrorAlert(error: error.localizedDescription)
                            self.present(alert, animated: true)
                            return
                        } else {
                            Router.showGreet(from: self)
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Selectors
    
    @objc func openInsta() {
        if let url = URL(string: "https://www.instagram.com/vladimir__.12") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @objc func openFacebook() {
        if let url = URL(string: "http://www.facebook.com") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @objc func openPinterest() {
        if let url = URL(string: "https://www.pinterest.com/kovalov280305/") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @objc func openTwitter() {
        if let url = URL(string: "https://twitter.com/vladkoFFit") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @objc func goToProfile() {
        Router.showEditProfile(from: self, for: user!, image: profileImageView)
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
        cell.configure(index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            Router.showProfileOption(from: self, title: "Privacy Policy", text: privacyPolicy)
        case 2:
            Router.showProfileOption(from: self, title: "Terms and configitons", text: termsAndConditions)
        case 3:
            showLogoutAlert()
        default:
            return
        }
    }
    
}
