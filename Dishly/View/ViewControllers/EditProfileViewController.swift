import UIKit

class EditProfileViewController: UIViewController {
    
    //MARK: - Properties
    
    private let tableView: UITableView = {
          let tableView = UITableView()
          tableView.translatesAutoresizingMaskIntoConstraints = false
          tableView.backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.2117647059, blue: 0.2745098039, alpha: 1)
          tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
          return tableView
      }()
    
    private let profileImageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.addTarget(self, action: #selector(chooseImage), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 140).isActive = true
        button.widthAnchor.constraint(equalToConstant: 140).isActive = true
        return button
    }()
    
    private let smallProfileImageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(chooseImage), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.2117647059, blue: 0.2745098039, alpha: 1)
        view.addSubview(tableView)
        setupTableViewConstraints()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: - Helpers
    
    
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
    
    //MARK: - Selectors
    
    @objc func chooseImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
}

//MARK: - UITableViewDelegate & UITableViewDataSource

extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.2117647059, blue: 0.2745098039, alpha: 1)
        
        let separator = UIView(frame: CGRect(x: 16, y: cell.frame.height - 1, width: cell.frame.width - 32, height: 1)) // Add separator view
        separator.backgroundColor = .white
        cell.addSubview(separator)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height: CGFloat = view.bounds.height / 5
        return height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        configureHeader(headerView: headerView )
        headerView.backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.2117647059, blue: 0.2745098039, alpha: 1)
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
        
        profileImageButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        picker.dismiss(animated: true)
    }
}
