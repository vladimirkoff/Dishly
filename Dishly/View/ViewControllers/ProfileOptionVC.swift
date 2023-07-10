import UIKit

class ProfileOptionVC: UIViewController {
    
    // MARK: - Properties
    
    private var text: String
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()
    
    // MARK: - Lifecycle
    
    init(docTitle: String, text: String) {
        self.text = text
        super.init(nibName: nil, bundle: nil)
        self.title = docTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadPrivacyPolicy()
    }
    
    // MARK: - Helpers
    
    func configureNavBar(title: String) {
       navigationItem.title = title
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
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


