

import UIKit
import JGProgressHUD

private let reuseIdentifier = "ItemCell"
private let headerReuseIdentifier = "ItemsHeader"

protocol SavedVCProtocol {
    func reload(collections: [Collection], afterDeletion: Bool)
    func addRecipe(recipe: RecipeViewModel, mealsViewModel: MealsViewModel?)
    func handleCancel()
}

class SavedViewController: UICollectionViewController {
    //MARK: - Properties
    
    var isToChoseMeal = false
    
    private lazy var noRecipesView: NoRecipesView = {
        let view = NoRecipesView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    var collection: Collection?
    
    private var recipesRealmViewModel: RecipesRealmViewModel!
    
    private var refreshControl: UIRefreshControl!
    
    private let recipesRealmService: RecipesRealmServiceProtocol!
         private let collectionService: CollectionServiceProtocol!
    private var collectionViewModel: CollectionViewModel!
    
    private let hud = JGProgressHUD(style: .dark)
    
    private var user: UserViewModel!
    
    private var collections: [Collection]? {
        didSet {
            delegate?.reload(collections: collections!, afterDeletion: false)
        }
    }
    
    
    private var recipes: [RecipeViewModel]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var delegate: SavedVCProtocol?
    var mealDelegate: SavedVCProtocol?
    
    //MARK: - Lifecycle
    
    func fetchCollections(completion: @escaping([Collection]) -> ()) {
        collectionViewModel.fetchCollections { collections in
            completion(collections)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showLoader(true)
        fetchCollections { collections in
            DispatchQueue.main.async { [weak self] in
                self?.showLoader(false)
                self?.collections = collections
            }
        }
        
    }
    
    init(collectionService: CollectionServiceProtocol, user: UserViewModel?, recipesRealmService: RecipesRealmServiceProtocol) {
        self.collectionService = collectionService
        self.user = user
        self.recipesRealmService = recipesRealmService
        recipesRealmViewModel = RecipesRealmViewModel(recipesRealmService: recipesRealmService)
        collectionViewModel = CollectionViewModel(collectionService: collectionService, collection: nil)
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        NotificationCenter.default.post(name: .selectCollection, object: nil)
        configureUI()
        configureCollectionView()
        fetchCollections()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        
        collectionViewModel = CollectionViewModel(collectionService: collectionService, collection: nil)
    }
    
    
    @objc private func handleRefresh() {
        collectionViewModel.fetchCollections { collections in
            DispatchQueue.main.async { [weak self] in
                self?.showLoader(false)
                self?.collections = collections
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    func showLoader(_ show: Bool) {
        view.endEditing(true )
        show ? hud.show(in: view) : hud.dismiss()
    }
    
    func fetchCollections() {
        showLoader(true)
        collectionViewModel.fetchCollections { collections in
            DispatchQueue.main.async { [weak self] in
                self?.showLoader(false)
                self?.collections = collections
            }
        }
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        navigationController?.navigationBar.isHidden = false
        
        view.addSubview(noRecipesView)
        NSLayoutConstraint.activate([
            noRecipesView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noRecipesView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 30),
            noRecipesView.widthAnchor.constraint(equalToConstant: 250),
            noRecipesView.heightAnchor.constraint(equalToConstant: 250),
        ])
    }
    
    func configureCollectionView() {
        collectionView.register(RecipeCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(ItemsHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
    }
    
    //MARK: - UICollectionViewDelegate & UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RecipeCell
        cell.saveButton.isHidden = isToChoseMeal ? true : false
        cell.saveView.isHidden = isToChoseMeal ? true : false

        if let recipes = recipes {
            cell.recipeViewModel = recipes[indexPath.row]
        }
        
        if isToChoseMeal {
            cell.isFromPlans = true
            cell.mealPlanDelegate = self
        } else {
            cell.isFromSaved = true
            cell.savedDelegate = self
        }
        
        cell.saveButton.setImage(UIImage(systemName: "minus.circle"), for: .normal)
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isToChoseMeal {
            guard let cell = collectionView.cellForItem(at: indexPath) as? RecipeCell else { return }
            self.dismiss(animated: true)
            cell.recipeViewModel?.recipe.imageData = cell.itemImageView.image?.pngData()
            mealDelegate?.addRecipe(recipe: cell.recipeViewModel!, mealsViewModel: MealsViewModel(mealsService: MealsService()))
        }
        
        else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? RecipeCell else { return }
            if let recipe = cell.recipeViewModel {
                if let uid = recipe.recipe.ownerId {
                    user.fetchUser(with: uid) { [weak self] userOwner in
                        guard let self = self else  {return }
                        DispatchQueue.main.async {
                            let vc = RecipeViewController(user: userOwner, recipe: recipe, recipesRealmService: self.recipesRealmService)
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! ItemsHeader
        self.delegate = header
        header.delegate = self
        if let cell = header.collectionView!.cellForItem(at: IndexPath(item: 0, section: 0)) as? CollectionCell {
            cell.isSelected = true
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
    
    func showDeleteAlert(for id: String) {
        let alertController = UIAlertController(title: "Delete Cell", message: "Are you sure you want to delete this cell?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.deleteCell(for: id)
        }
        alertController.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            self?.delegate?.handleCancel()
        }
        alertController.addAction(cancelAction)
        
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showDeleteAlert2(for id: String, collection: Collection) {
        let alertController = UIAlertController(title: "Delete Recipe", message: "Are you sure you want to remove this recipe?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.collectionViewModel.deleteRecipeFrom(collection: collection, id: id) { error in
                self?.fetchCollections(completion: { collections in
                    self?.collections = collections
                })
            }
        }
        
        alertController.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        
        present(alertController, animated: true, completion: nil)
    }
    
    func deleteCell(for id: String) {
        collectionViewModel.deleteCollection(id: id) { [weak self] collections, error in
            self?.collections = collections
            self?.collectionView.reloadData()
        }
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension SavedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: view.frame.width / 2 - 20, height: view.frame.height / 2.6)
        return size
    }
}

//MARK: - ItemsHeaderDelegate

extension SavedViewController: ItemsHeaderDelegate {
    
    func presentAlert(alert: UIAlertController) {
        present(alert, animated: true)
    }
    
    
    func fecthRecipes(with collection: Collection) {
        showLoader(true)
        self.collection = collection
        collectionViewModel.fetchRecipesWith(collection: collection) { [weak self] recipes in
            guard let self = self else { return }
            showLoader(false)
            if recipes.count == 0 {
                self.noRecipesView.isHidden = false
            } else {
                self.noRecipesView.isHidden = true
            }
            self.recipes = recipes
        }
    }
    
    func createCollection(collection: Collection, completion: @escaping (Error?) -> ()) {
        showLoader(true)
        collectionViewModel.addCollection(collection: collection) { [weak self] error in
            guard let self = self else { return }
            self.showLoader(false)
            completion(error)
        }
    }
}

//MARK: - RecipeCellDelegate

extension SavedViewController: RecipeCellDelegate {
    func addGroceries(groceries: [Ingredient]) {}
    func saveRecipe(recipe: RecipeViewModel) {}
    
    func deleteRecipe(id: String) {
        guard let collection = collection else  { return }
        showDeleteAlert2(for: id, collection: collection)
    }
}


