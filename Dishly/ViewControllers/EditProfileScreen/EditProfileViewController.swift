import UIKit
import JGProgressHUD

final class EditProfileViewController: UIViewController {
    
    //MARK: - Properties
    
    private var profileImage: UIImageView!
    
    private var user: UserViewModel
    
    private let hud = JGProgressHUD(style: .dark)

    
    private var userViewModel: UserViewModel!
    
    
    lazy var changedUser = user
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = AppColors.customGrey.color
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfileInfoCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    private lazy var profileImageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 70
        button.clipsToBounds = true
        button.setImage(profileImage.image, for: .normal)
        button.addTarget(self, action: #selector(chooseImage), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 140).isActive = true
        button.widthAnchor.constraint(equalToConstant: 140).isActive = true
        return button
    }()
    
    private let smallProfileImageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(chooseImage), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        return button
    }()
    
    private let viewModel: EditProfileVMProtocol
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupTableViewConstraints()
    }
    
    
    init(user: UserViewModel, viewModel: EditProfileVMProtocol, profileImage: UIImageView) {
        self.user = user
        self.profileImage = profileImage
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        tableView.backgroundColor = isDark ? AppColors.customGrey.color : AppColors.customLight.color
    }
    
    //MARK: - Helpers
    
    func showLoader(_ show: Bool) {
        view.endEditing(true )
        show ? hud.show(in: view) : hud.dismiss()
    }
    
    func configureUI() {
        view.backgroundColor = AppColors.customGrey.color
        
        view.addSubview(tableView)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        doneButton.isEnabled = false
        navigationItem.rightBarButtonItem = doneButton
    }
    
    
    private func setupTableViewConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureHeader(headerView: UIView) {
        headerView.addSubview(profileImageButton)
        NSLayoutConstraint.activate([
            profileImageButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            profileImageButton.topAnchor.constraint(equalTo: headerView.topAnchor),
        ])
    }
    
    func configureCell(_ cell: ProfileInfoCell, for indexPath: IndexPath) {
        cell.delegate = self
        
        switch indexPath.row {
        case 0:
            cell.configureFields(email: nil, password: nil, name: user.fullName)
        case 1:
            cell.configureFields(email: user.email, password: nil, name: nil)
        default:
            cell.configureFields(email: nil, password: user.username, name: nil)
        }
    }
    
    func addSeparator(to cell: UITableViewCell) {
        let separator = UIView(frame: CGRect(x: 16, y: cell.frame.height - 1, width: cell.frame.width - 32, height: 1))
        separator.backgroundColor = .white
        cell.addSubview(separator)
    }
    
    //MARK: - Selectors
    
    @objc func chooseImage() {
        navigationItem.rightBarButtonItem?.isEnabled = true
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func updateUser(updatedUserViewModel: UserViewModel, updatedUser: User) {
        viewModel.updateUser(with: updatedUserViewModel) {  error in
            self.viewModel.updateUser(user: updatedUser) {  success in
                DispatchQueue.main.async {
                    self.showLoader(false)
                    self.navigationController?.navigationBar.topItem?.hidesBackButton = false
                }
            }
        }
    }
    
    @objc func doneButtonTapped() {
        showLoader(true)
        navigationController?.navigationBar.topItem?.hidesBackButton = true
        
        ImageUploader.shared.uploadImage(image: profileImage.image!, isForRecipe: false) { [weak self] imageURL in
            guard let self = self else { return }
            
            let dict: [String : Any] = [
                "fullName": self.changedUser.fullName,
                "profileImage": imageURL,
                "username": self.changedUser.username,
                "email": self.changedUser.email,
                "uid": self.user.uid,
                "imageData" : profileImage.image!.pngData()
            ]
            
            let updatedUser = User(dictionary: dict)
            let updatedUserViewModel = UserViewModel(user: updatedUser)
            
            if user.email != self.changedUser.username {
                self.viewModel.changeEmail(to: self.changedUser.email) { error in
                    if let error = error as? AuthErros {
                        DispatchQueue.main.async {
                            let alert = Alerts.createErrorAlert(error: error.localizedDescription)
                            self.present(alert, animated: true)
                            self.showLoader(false)
                            self.navigationController?.navigationBar.topItem?.hidesBackButton = false
                        }
                    } else {
                        self.updateUser(updatedUserViewModel: updatedUserViewModel, updatedUser: updatedUser)
                    }
                }
            } else {
                self.updateUser(updatedUserViewModel: updatedUserViewModel, updatedUser: updatedUser)
            }
        }
    }
}

//MARK: - UITableViewDelegate & UITableViewDataSource

extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProfileInfoCell
        
        configureCell(cell, for: indexPath)
        addSeparator(to: cell)
        cell.backgroundColor = .clear
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height: CGFloat = 140
        return height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        configureHeader(headerView: headerView )
        headerView.backgroundColor = isDark ? AppColors.customGrey.color : AppColors.customLight.color

        return headerView
    }
}

//MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate 

extension EditProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate   {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        
        profileImageButton.layer.cornerRadius = profileImageButton.frame.width / 2
        profileImageButton.layer.masksToBounds = true
        profileImageButton.layer.borderColor = UIColor.white.cgColor
        profileImageButton.layer.borderWidth = 2
        
        profileImage.image = selectedImage
        profileImageButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        picker.dismiss(animated: true)
    }
}

//MARK: - ProfileInfoCellDelegate

extension EditProfileViewController: ProfileInfoCellDelegate {
    func disableDoneButton() {
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func infoDidChange(text: String, fieldIndex: Int) {
        navigationItem.rightBarButtonItem?.isEnabled = true
        var propertiesArray: [String] = []
        for index in 0...2 {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? ProfileInfoCell {
                propertiesArray.append(cell.textView.text)
            }
        }
        let dict = ["fullName" : propertiesArray[0],
                    "email" : propertiesArray[1],
                    "username" : propertiesArray[2]
        ]
        changedUser = UserViewModel(user: User(dictionary: dict))
    }
}
