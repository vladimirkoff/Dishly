import UIKit

protocol ExploreVCDelegate {
    func returnFetchedCollection(collections: [Collection])
    func appendCollection(collection: Collection)
}

class ExploreViewController: UIViewController {
    //MARK: - Properties
    
    var delegate: ExploreVCDelegate?
    
    private var user: UserViewModel
    private var collectionViewModel: CollectionViewModel!
    private var recipeViewModel: RecipeViewModel!
    var userViewModel: UserViewModel!

    private let window = UIApplication.shared.windows.last!
    private var windowView: CollectionsPopupView?
    private let customView = CustomUIViewBackground()

    private let recipeService: RecipeServiceProtocol!
    private let userService: UserServiceProtocol!
    private let recipesRealmService: RecipesRealmServiceProtocol!
    private let collectionService: CollectionServiceProtocol!

    private var refreshControl: UIRefreshControl!
    
    var recipes: [RecipeViewModel] {
        didSet {
            NotificationCenter.default.post(name: .refreshRecipes, object: nil, userInfo: ["recipes" : recipes])
            self.refreshControl.endRefreshing()
        }
    }
    
    lazy private var backgroundView: UIView = {
        let view = UIView(frame: window.bounds)
        view.backgroundColor = UIColor.black
        view.alpha = 0.5
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        view.addGestureRecognizer(gestureRecognizer)
        
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

        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    //MARK: - Lifecycle
    
    override func loadView() {
        view = customView
    }
    
    init(user: UserViewModel, recipes: [RecipeViewModel], userService: UserServiceProtocol, recipeService: RecipeServiceProtocol, collectionService: CollectionServiceProtocol, recipesRealmService: RecipesRealmServiceProtocol) {
        self.user = user
        self.userService = userService
        self.recipeService = recipeService
        self.recipes = recipes
        self.collectionService = collectionService
        self.recipesRealmService = recipesRealmService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: isDark ? UIColor.white : UIColor.black]
        title = "Explore"
        collectionViewModel = CollectionViewModel(collectionService: collectionService, collection: nil)
        userViewModel = UserViewModel(user: nil, userService: userService)
        recipeViewModel = RecipeViewModel(recipe: Recipe(category: Recipe.Category(rawValue: "Ukraine")!, ingredients: [], instructions: []), recipeService: recipeService)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureUI()

        refreshControl = UIRefreshControl()
           refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    
    //MARK: - Helpers
    
    func configureUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ParentCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(SearchHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        
        customView.addSubview(collectionView)
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
        hidePopUp()
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
        cell.backgroundColor = .clear
        cell.configure(index: indexPath.row)
        if indexPath.row == 0 {
            cell.recipes = recipes
        }
        if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3  {
            cell.categoryCollectionView.isHidden = false
            cell.isForCategories = true
        } else {
            cell.horizontalCollectionView.isHidden = false
            cell.isForCategories = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 2 {
            let cellHeight: CGFloat = 60 * 12
            return CGSize(width: collectionView.bounds.width, height: cellHeight)
        } else {
            let cellHeight = (collectionView.bounds.height - collectionView.contentInset.top - collectionView.contentInset.bottom) / 2
            return CGSize(width: collectionView.bounds.width, height: cellHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! SearchHeaderView
            headerView.searchBar.delegate = self
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

//MARK: - ParentCellDelegate

extension ExploreViewController: ParentCellDelegate {
    
    func goToRecipe(with recipe: RecipeViewModel) {
        guard let uid = recipe.recipe.ownerId else { return }
        userViewModel.fetchUser(with: uid) { [weak self] userOwner in
            guard let self = self else  {return }
            DispatchQueue.main.async {
                let vc = RecipeViewController(user: userOwner, recipe: recipe, recipesRealmService: self.recipesRealmService)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func goToCategory(category: String) {
        recipeViewModel.fetchRecipesFor(category: category) { [weak self] recipes, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let error = error {
                    let alert = createErrorAlert(error: error.localizedDescription)
                    return
                } else {
                    let vc = RecipesViewController(recipes: recipes!, userService: self.userService, exploreVC: self, recipesRealmService: self.recipesRealmService)
                    vc.categoryName = category
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func popUp(recipe: RecipeViewModel) {
        windowView  = {
            let view = CollectionsPopupView(frame: CGRect(x: view.frame.minX, y: view.frame.maxY, width: view.frame.width, height: 300))
            self.delegate = view
            collectionViewModel = CollectionViewModel(collectionService: collectionService, collection: nil)
            view.delegate = self
            view.backgroundColor = AppColors.customLightGrey.color

            view.layer.cornerRadius = 10
            
            return view
        }()
        
        windowView!.recipe = recipe
        self.window.addSubview(self.backgroundView)
        self.window.addSubview(self.windowView!)
        
        
        UIView.animate(withDuration: 0.6) { [weak self] in
            guard let self = self else { return }
            self.windowView!.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.maxY - 200, width: self.view.bounds.width, height: 300)
        }
        
    }
    
    func hidePopUp() {
        backgroundView.removeFromSuperview()
        
        UIView.animate(withDuration: 1) { [weak self] in
            guard let self = self else { return }
            
            self.windowView?.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.maxY + 100, width: self.view.frame.width, height: 300)
        }
    }
    
    @objc func refreshCollectionView() {
        recipeViewModel.fetchRecipes { recipes, error in
            DispatchQueue.main.async {
                if let error = error {
                    let alert = createErrorAlert(error: error.localizedDescription)
                    self.refreshControl.endRefreshing()
                    return
                } else {
                    self.recipes = recipes ?? []
                }
            }
        }
    }

}

//MARK: - CollectionsPopupViewDelegate

extension ExploreViewController: CollectionsPopupViewDelegate {
    
    func addCollection(collection: Collection) {
        collectionViewModel.addCollection(collection: collection) { error in
            if let error = error as? CollectionErrors {
                let alertController = createErrorAlert(error: error.errorMessage)
                return
            }
            self.delegate?.appendCollection(collection: collection)
        }
    }
    
    func saveToCollection(collection: Collection, recipe: RecipeViewModel) {
        collectionViewModel.saveToCollection(collection: collection, recipe: recipe) { [weak self] error in
            guard let self = self else { return }
            self.hidePopup()
        }
    }
    
    func presentAlert(alert: UIAlertController) {
        present(alert, animated: true)
    }
    
    func hidePopup() {
        hidePopUp()
    }
    
    func fetchCollections() {
        collectionViewModel?.fetchCollections(completion: { [weak self] collections in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.delegate?.returnFetchedCollection(collections: collections)
            }
        })
    }
    
}

//MARK: - UISearchBarDelegate

extension ExploreViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let vc = RecipeSearchViewController(recipesService: recipeService, recipesRealmService: recipesRealmService)
        navigationController?.pushViewController(vc, animated: true)
        return false
    }
}

//MARK: - RecipeCellDelegate

extension ExploreViewController: RecipeCellDelegate {
    func addGroceries(groceries: [Ingredient]) {}
    
    func saveRecipe(recipe: RecipeViewModel) {
        popUp(recipe: recipe)
    }
    
    func deleteRecipe(id: String) {
        backgroundView.removeFromSuperview()
        
        UIView.animate(withDuration: 1) { [weak self] in
            guard let self = self else { return }
            self.windowView?.removeFromSuperview()
            
            self.windowView?.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.maxY, width: self.view.frame.width, height: 300)
        }
    }
}

