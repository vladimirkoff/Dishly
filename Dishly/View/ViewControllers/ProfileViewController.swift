import UIKit

class ProfileViewController: UIViewController {
    //MARK: - Properties
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .lightGray
        iv.layer.cornerRadius = 40
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    private let versionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Version 12.2.0"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    private let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributedString = NSMutableAttributedString.init(string: "EDIT YOUR PROFILE")
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                      value: 1, range:
                                        NSRange.init(location: 0, length: attributedString.length)
        
        );
        button.setAttributedTitle(attributedString, for: .normal)
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .lightGray
        tableView.layer.cornerRadius = 10
        return tableView
    }()
    
    //MARK: - Lifecycle
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureProfileImage()
    }
    
    //MARK: - Helpers
    
    func configureProfileImage() {
        guard let navController = navigationController else { return }
        view.addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            profileImageView.bottomAnchor.constraint(equalTo: navController.navigationBar.bottomAnchor),
            profileImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12)
        ])
    }
    
    func configureUI() {
        view.backgroundColor = UIColor(red: 0.2235294118, green: 0.2117647059, blue: 0.2745098039, alpha: 1)
        
        tabBarController?.tabBar.isHidden = true
        
        navigationItem.title = "Vladimir"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(editProfileButton)
        NSLayoutConstraint.activate([
            editProfileButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            editProfileButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16)
        ])
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            tableView.heightAnchor.constraint(equalToConstant: 160)
        ])
        
        view.addSubview(versionLabel)
        NSLayoutConstraint.activate([
            versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            versionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }
    
    //MARK: - Selectors
    
 
    
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.accessoryType = .checkmark
        cell.backgroundColor = .lightGray
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "General Settings"
        
        cell.contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            label.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 30)
        ])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
