import UIKit

final class ProfileOptionVC: UIViewController {
    
    // MARK: - Properties
    
    private var text: String
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()
    
    private let navBarAppearance = UINavigationBarAppearance()
    
    // MARK: - Lifecycle
    
    init(docTitle: String, text: String) {
        self.text = text
        super.init(nibName: nil, bundle: nil)
        self.title = docTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavBar(appear: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        configureNavBar(appear: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadPrivacyPolicy()
    }
    
    // MARK: - Helpers
    
    func configureNavBar(appear: Bool) {
        if appear {
            navBarAppearance.backgroundColor = .white
            navigationController?.navigationBar.tintColor = .black
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        } else {
            navBarAppearance.backgroundColor = isDark ? AppColors.customGrey.color : AppColors.customLight.color
            navBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: isDark ? UIColor.white : UIColor.black]
            navigationController?.navigationBar.tintColor = isDark ? .white : AppColors.customBrown.color
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        textView.backgroundColor = .white
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadPrivacyPolicy() {
        let privacyPolicyText = text
        textView.text = privacyPolicyText
    }
    
}


