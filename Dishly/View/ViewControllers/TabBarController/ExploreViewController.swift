import UIKit

class ExploreViewController: UIViewController {
    //MARK: - Properties
    
    private let window = UIApplication.shared.windows.last!
    
    var user: UserViewModel
    
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
        
        view.backgroundColor = lightGrey
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = greyColor
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    //MARK: - Lifecycle
    
    init(user: UserViewModel, recipes: [RecipeViewModel], userService: UserServiceProtocol, recipeService: RecipeServiceProtocol, collectionService: CollectionServiceProtocol) {
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
        
        userViewModel = UserViewModel(user: nil, userService: userService)
        recipeViewModel = RecipeViewModel(recipe: Recipe(category: Recipe.Category(rawValue: "Ukraine")!, ingredients: [], instructions: []), recipeService: recipeService)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureUI()
        
        navigationItem.title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    //MARK: - Helpers
    
    func configureAttributedString() -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "Hello, ", attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.white])
        attributedText.append(NSAttributedString(string: "Vladimir\n", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.green]))
        return attributedText
    }
    
    func configureUI() {
        view.backgroundColor = greyColor
        
        collectionView.backgroundColor = view.backgroundColor
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ParentCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(SearchHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ParentCell
        cell.index = indexPath.row
        cell.delegate = self
        cell.numOfRecipes = 0
        cell.configure(index: indexPath.row)
        if indexPath.row == 0 {
            cell.numOfRecipes = recipes.count
            cell.recipes = recipes
        }
        if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3  {
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
    
    func goToCategory(category: String) {
        recipeViewModel.fetchRecipesFor(category: category) { recipes in
            DispatchQueue.main.async {
                let vc = RecipesViewController(recipes: recipes, userService: self.userService, exploreVC: self)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func popUp(recipe: RecipeViewModel) {
        windowView.recipe = recipe
        self.window.addSubview(self.backgroundView)
        self.window.addSubview(self.windowView)
        
        
        UIView.animate(withDuration: 0.6) {
            self.windowView.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.maxY - 300, width: self.view.bounds.width, height: 300)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! SearchHeaderView
            headerView.searchBar.delegate = self
            headerView.backgroundColor = greyColor
            return headerView
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let height: Double = 60
        let width: Double = view.frame.width
        return CGSize(width: width, height: height)
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

//MARK: - UISearchBarDelegate

extension ExploreViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let vc = RecipeSearchViewController(recipesService: recipeService)
        navigationController?.pushViewController(vc, animated: true)
        return false
    }
}

//MARK: - RecipeCellDelegate

extension ExploreViewController: RecipeCellDelegate {
    func addGroceries(groceries: [Ingredient]) {
        
    }
    
    func saveRecipe(recipe: RecipeViewModel) {
        popUp(recipe: recipe)
    }
    
    func deleteRecipe(id: String) {
        
    }
    
    
}
