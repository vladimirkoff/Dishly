import UIKit

class ExploreViewController: UIViewController {
    //MARK: - Properties
    
    var user: User
    
    var recipeViewModel: RecipeViewModel!
    var recipeService: RecipeServiceProtocol!
    
    var userViewModel: UserViewModel!
    var userService: UserServiceProtocol!
  
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        return searchController
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.2117647059, blue: 0.2745098039, alpha: 1)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    
    //MARK: - Lifecycle
    
    init(user: User, userService: UserServiceProtocol, recipeService: RecipeServiceProtocol) {
        self.user = user
        self.userService = userService
        self.recipeService = recipeService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureUI()
        
        recipeViewModel = RecipeViewModel(recipeService: recipeService)
        
        userViewModel = UserViewModel(userService: userService)
    }
    
    //MARK: - Helpers
    
    func configureAttributedString() -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "Hello, ", attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.white])
        attributedText.append(NSAttributedString(string: "Vladimir\n", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.green]))
        return attributedText
    }
    
    func configureNavBar() {
        
        navigationItem.searchController = searchController
        navigationItem.setHidesBackButton(true, animated: false)
        definesPresentationContext = true
        
        navigationItem.title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    func configureUI() {
        view.backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.2117647059, blue: 0.2745098039, alpha: 1)

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        collectionView.register(ParentCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    //MARK: - Selectors
    
}

//MARK: - UISearchResultsUpdating

extension ExploreViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
    }
}

//MARK: - UICollectionViewDataSource & UICollectionViewDelegateFlowLayout

extension ExploreViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ParentCell
        cell.delegate = self
        if indexPath.row == 3 {
            cell.isForCategories = true
        } else {
            cell.isForCategories = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight = (collectionView.bounds.height - collectionView.contentInset.top - collectionView.contentInset.bottom) / 2
        return CGSize(width: collectionView.bounds.width, height: cellHeight)
    }

}

//MARK: - ParentCellDelegate

extension ExploreViewController: ParentCellDelegate {
    func goToCategory() {
        print("DEBUG: Go to category")
    }
    
    func goToRecipe() {
        let vc = RecipeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
