import UIKit

class ExploreViewController: UIViewController {
    //MARK: - Properties
    
    private let window = UIApplication.shared.windows.last!
    
    var user: User
    
    var recipeService: RecipeServiceProtocol!
    var userService: UserServiceProtocol!
    
    var collectionService: CollectionServiceProtocol!
    
    var userViewModel: UserViewModel!
    var recipeViewModel: RecipeViewModel!
    
    var collectionViewModel: CollectionViewModel!
    
    var recipes: [RecipeViewModel]
    
    lazy private var backgroundView: UIView = {
        let view = UIView(frame: window.bounds)
        view.backgroundColor = UIColor.black
        view.alpha = 0.5
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        view.addGestureRecognizer(gestureRecognizer)
        
        return view
    }()
    
    lazy private var windowView: CollectionsPopupView = {
        let view = CollectionsPopupView(frame: CGRect(x: view.frame.minX, y: view.frame.maxY, width: view.frame.width, height: 300))
        
        collectionViewModel = CollectionViewModel(collectionService: collectionService, collection: nil)
        view.collectionViewModel = collectionViewModel
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        
        return view
    }()
    
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
    
    init(user: User, recipes: [RecipeViewModel], userService: UserServiceProtocol, recipeService: RecipeServiceProtocol, collectionService: CollectionServiceProtocol) {
        self.user = user
        self.userService = userService
        self.recipeService = recipeService
        self.recipes = recipes
        self.collectionService = collectionService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureUI()
        
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
    
    @objc func dismissView() {
        backgroundView.removeFromSuperview()
        
        UIView.animate(withDuration: 1) {
            self.windowView.removeFromSuperview()
            
            self.windowView.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.maxY, width: self.view.frame.width, height: 300)
        }
    }
    
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
        cell.numOfRecipes = recipes.count
        cell.recipes = recipes
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
    
    
    func goToRecipe(with recipe: RecipeViewModel) {
        let vc = RecipeViewController(user: user, recipe: recipe)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToCategory() {
        print("DEBUG: Go to category")
    }
    
    func popUp(recipe: RecipeViewModel) {
        windowView.recipe = recipe
        self.window.addSubview(self.backgroundView)
        self.window.addSubview(self.windowView)
        
        
        UIView.animate(withDuration: 0.6) {
            self.windowView.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.maxY - 300, width: self.view.bounds.width, height: 300)
        }
        
    }
}

//MARK: - CollectionsPopupViewDelegate

extension ExploreViewController: CollectionsPopupViewDelegate {
    
    func fetchCollections() {
        
    }
    
    func createCollection() {
        
    }
    
    func saveToCollection() {
        
    }
    
    
}
