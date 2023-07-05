import UIKit

class AddRecipeViewController: UIViewController {
    //MARK: - Properties
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Recipe Title"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Type your recipe name here"
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 20
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textField.leftViewMode = .always
        return textField
    }()
    
    private let characterCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    private let coverImageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Add Cover Image"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupScrollView()
        setupTitleLabel()
        setupTitleTextField()
        setupCharacterCountLabel()
        setupCoverImageLabel()
        
        titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    //MARK: - Helpers
    
    private func setupNavigationBar() {
        navigationItem.title = "Add Recipe"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        let contentViewHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: 2000)
        contentViewHeightConstraint.priority = .defaultLow
        contentViewHeightConstraint.isActive = true
    }
    
    private func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        ])
    }
    
    private func setupTitleTextField() {
        contentView.addSubview(titleTextField)
        
        NSLayoutConstraint.activate([
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            titleTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -40),
            titleTextField.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupCharacterCountLabel() {
        contentView.addSubview(characterCountLabel)
        
        NSLayoutConstraint.activate([
            characterCountLabel.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            characterCountLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 5)
        ])
    }
    
    private func setupCoverImageLabel() {
        contentView.addSubview(coverImageLabel)
        
        NSLayoutConstraint.activate([
            coverImageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            coverImageLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 25)
        ])
    }
    
    //MARK: - Selectors
    
    @objc private func titleTextFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        let characterCount = text.count
        characterCountLabel.text = "\(characterCount)/50"
        
        if characterCount > 50 {
            let index = text.index(text.startIndex, offsetBy: 50)
            textField.text = String(text[..<index])
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
