

import UIKit
import JGProgressHUD

private let reuseIdentifier = "ItemCell"
private let headerReuseIdentifier = "ItemsHeader"

protocol SavedVCProtocol {
    func reload(collections: [Collection], afterDeletion: Bool)
    func addRecipe(recipe: RecipeViewModel, mealsViewModel: MealsViewModel?)
}

class SavedViewController: UICollectionViewController {
    //MARK: - Properties
    
    var isToChoseMeal = false
    
    var collection: Collection?
    
    private let hud = JGProgressHUD(style: .dark)
    
    private var user: UserViewModel?
    
    private var collections: [Collection]? {
        didSet {
            delegate?.reload(collections: collections!, afterDeletion: false)
        }
    }
    
    private let collectionService: CollectionServiceProtocol!
    private var collectionViewModel: CollectionViewModel!
    
    
    private var recipes: [RecipeViewModel]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var delegate: SavedVCProtocol?
    var mealDelegate: SavedVCProtocol?
    
    //MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    init(collectionService: CollectionServiceProtocol, user: UserViewModel?) {
        self.collectionService = collectionService
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureCollectionView()
        fetchCollections()
        
        collectionViewModel = CollectionViewModel(collectionService: collectionService, collection: nil)
    }
    
    func showLoader(_ show: Bool) {
        view.endEditing(true )
        show ? hud.show(in: view) : hud.dismiss()
    }
    
    func fetchCollections() {
        showLoader(true)
        collectionService.fetchCollections { collections in
            DispatchQueue.main.async { [weak self] in
                self?.showLoader(false)
                self?.collections = collections
            }
        }
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        navigationController?.navigationBar.isHidden = false
        view.backgroundColor = AppColors.customGrey.color

        
        
        navigationItem.title = "My Saved Recipes"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureCollectionView() {
//        collectionView.backgroundColor = AppColors.customGrey.color

        collectionView.register(RecipeCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(ItemsHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
    }
    
    //MARK: - UICollectionViewDelegate & UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RecipeCell
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
                    UserService().fetchUser(with: uid) { [weak self] userOwner in
                        guard let self = self else  {return }
                        DispatchQueue.main.async {
                            let vc = RecipeViewController(user: userOwner, recipe: recipe)
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
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func deleteCell(for id: String) {
        collectionViewModel.deleteCollection(id: id) { collections, error in
            self.delegate?.reload(collections: collections, afterDeletion: true)
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
        collectionService.fetchRecipesWith(collection: collection) { [weak self] recipes in
            guard let self = self else { return }
            showLoader(false)
            self.recipes = recipes
        }
    }
    
    func createCollection(collection: Collection, completion: @escaping (Error?) -> ()) {
        collectionViewModel.saveToCollection(collection: collection) { error in
            completion(error)
        }
    }
    
    
}

//MARK: - RecipeCellDelegate

extension SavedViewController: RecipeCellDelegate {
    func addGroceries(groceries: [Ingredient]) {}
    func saveRecipe(recipe: RecipeViewModel) {}
    
    func deleteRecipe(id: String) {
        if isToChoseMeal {
            RecipesRealmService().deleteRecipeRealm(id: id) { success in
                print(success)
            }
        } else {
            collectionService.deleteRecipeFrom(collection: collection! , id: id) { error in
                print("DEBUG: recipe deleted")
            }
        }
    }
}
