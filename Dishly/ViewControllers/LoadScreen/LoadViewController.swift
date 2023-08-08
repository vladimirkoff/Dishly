import UIKit
import RealmSwift

final class LoadViewController: UIViewController {
    //MARK: - Properties
    
    private var user: UserViewModel!
    
    private let ingredientsImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "ingredients2")
        iv.contentMode = .scaleAspectFill
        iv.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 4)
        return iv
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "icon")
        iv.contentMode = .scaleAspectFill
        iv.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 4)
        iv.heightAnchor.constraint(equalToConstant: 45).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 45).isActive = true
        return iv
    }()
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Dishly"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    private let appSlogan: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Unleash Your Culinary Creativity"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    private var verticalStack = UIStackView()
    
    private let viewModel: LoadVMProtocol
    
    //MARK: - Lifecycle
    
    init(viewModel: LoadVMProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        isDark = isDarkMode
        navigationController?.navigationBar.tintColor = isDark ? .white : AppColors.customBrown.color
        ThemeManager.applyCurrentTheme()
        navigationController?.navigationBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateImageView()

    }
    
    //MARK: - Helpers
    
    func checkIfLoggedInWithRealm(completion: @escaping(Bool) -> ())  {
        viewModel.checkIfLoggedIn { user in
            if let user = user {
                self.user = user
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func checkIfLoggedIn() {
        checkIfLoggedInWithRealm { isLoggedIn in
            isLoggedIn ?
            Router.showMainTabBar(from: self, with: self.user) :
            Router.showGreet(from: self)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(ingredientsImageView)
        NSLayoutConstraint.activate([
            ingredientsImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            ingredientsImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ingredientsImageView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            ingredientsImageView.heightAnchor.constraint(equalToConstant: 500)
        ])
        
        let horizontalStack = UIStackView(arrangedSubviews: [iconImageView, appNameLabel])
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 8
        
        verticalStack = UIStackView(arrangedSubviews: [horizontalStack, appSlogan])
        verticalStack.axis = .vertical
        verticalStack.alignment = .center
        verticalStack.spacing = 8
        
        view.addSubview(verticalStack)
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            verticalStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verticalStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            verticalStack.widthAnchor.constraint(equalToConstant: 400),
            verticalStack.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func animateImageView() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
            self.ingredientsImageView.center.x = self.view.bounds.width / 2
            self.ingredientsImageView.center.y = 200
            
            self.verticalStack.center.y = self.verticalStack.center.y - 220
        }) { success in
            self.checkIfLoggedIn()
        }
    }
}
