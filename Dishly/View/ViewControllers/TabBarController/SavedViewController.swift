

import UIKit

private let reuseIdentifier = "ItemCell"
private let headerReuseIdentifier = "ItemsHeader"

protocol SavedVCProtocol {
    func reload(collections: [Collection])
    func addRecipe(recipe: RecipeViewModel)
}

class SavedViewController: UICollectionViewController {
    //MARK: - Properties
    
    var isToChoseMeal = false
    
    private var collections: [Collection]? {
        didSet {
            delegate?.reload(collections: collections!)
        }
    }
    
    private var collectionService: CollectionServiceProtocol!
    private var collectionViewModel: CollectionViewModel!
    
    private var recipes: [RecipeViewModel]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var delegate: SavedVCProtocol?
    var mealDelegate: SavedVCProtocol?
    
    //MARK: - Lifecycle
    
    init(collectionService: CollectionServiceProtocol) {
        self.collectionService = collectionService
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
    
    func fetchCollections() {
        collectionService.fetchCollections { collections in
            DispatchQueue.main.async {
                self.collections = collections
            }
        }
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        navigationController?.navigationBar.isHidden = false
        view.backgroundColor = greyColor
        
        
        navigationItem.title = "My Saved Recipes"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureCollectionView() {
        collectionView.backgroundColor = greyColor
        collectionView.register(RecipeCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(ItemsHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
    }
    
    //MARK: - UICollectionViewDelegate & UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RecipeCell
        if let recipes = recipes {
            cell.recipeViewModel = recipes[indexPath.row]
        }
        cell.layer.cornerRadius = 10
        cell.backgroundColor = .white
        cell.clipsToBounds = true
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isToChoseMeal {
            guard let cell = collectionView.cellForItem(at: indexPath) as? RecipeCell else { return }
            self.dismiss(animated: true)
            mealDelegate?.addRecipe(recipe: cell.recipeViewModel!)
        } else {
            
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
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
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
    
    func fecthRecipes(with collection: Collection) {
        collectionService.fetchRecipesWith(collection: collection) { recipes in
            self.recipes = recipes
        }
    }
    
    func createCollection(collection: Collection, completion: @escaping (Error?) -> ()) {
        collectionViewModel.saveToCollection(collection: collection) { error in
            completion(error)
        }
    }
    
    
}
