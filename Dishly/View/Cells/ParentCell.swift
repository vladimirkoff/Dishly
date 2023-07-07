import UIKit
import SDWebImage

protocol ParentCellDelegate {
    func goToRecipe(with recipe: RecipeViewModel)
    func goToCategory()
    func popUp(recipe: RecipeViewModel)
}

class ParentCell: UICollectionViewCell {
    //MARK: - Properties
    
    var numOfRecipes: Int!
    
    var recipeViewModel: RecipeViewModel!
    var delegate: ParentCellDelegate?
    var recipes: [RecipeViewModel]!
    
    var isForCategories: Bool? {
        didSet {
            if let isForCategories = isForCategories {
                isForCategories ? configureCellForCategories() : configureCell()
            }
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: bounds.width - 20, height: 30))
        label.text = "Daily inspiration"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    private lazy var horizontalCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: titleLabel.frame.maxY, width: bounds.width, height: bounds.height - 40), collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.2117647059, blue: 0.2745098039, alpha: 1)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private lazy var categoryCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: bounds.midY - bounds.midY / 2, width: bounds.width, height: bounds.height - 60), collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.2117647059, blue: 0.2745098039, alpha: 1)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.2117647059, blue: 0.2745098039, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    override func prepareForReuse() {
        super.prepareForReuse()
        horizontalCollectionView.isHidden = true
        categoryCollectionView.isHidden = true
    }
    
    func configureCell() {
        horizontalCollectionView.isHidden = false
        contentView.addSubview(titleLabel)
        contentView.addSubview(horizontalCollectionView)
        horizontalCollectionView.register(RecipeCell.self, forCellWithReuseIdentifier: "HorizontalCell")
    }
    
    func configureCellForCategories() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(categoryCollectionView)
        categoryCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        categoryCollectionView.isHidden = false
    }
}

//MARK: - UICollectionViewDataSource & UICollectionViewDelegateFlowLayout

extension ParentCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case horizontalCollectionView:
            return numOfRecipes
        case categoryCollectionView:
            return 6
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == horizontalCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalCell", for: indexPath) as! RecipeCell
            cell.delegate = self
            cell.recipeViewModel = recipes[indexPath.row]
            cell.backgroundColor = .white
            return cell
        } else if collectionView == categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            cell.backgroundColor = .yellow
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == horizontalCollectionView {
            delegate?.goToRecipe(with: recipes[indexPath.row])
        } else {
            delegate?.goToCategory()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == horizontalCollectionView {
            let width = collectionView.bounds.width * 3/4
            let height = collectionView.bounds.height - 10
            return CGSize(width: width, height: height)
        } else if collectionView == categoryCollectionView {
            let width = bounds.width / 2.2
            let height: CGFloat = 80
            return CGSize(width: width, height: height)
        }
        return CGSize.zero
    }
}

//MARK: - RecipeCellDelegate

extension ParentCell: RecipeCellDelegate {
    
    func addGroceries(groceries: [Ingredient]) {
        myGroceries = groceries
    }
    
    func saveRecipe(recipe: RecipeViewModel) {
//        let collection = Collection(name: "favorites", imageUrl: "", id: "dfwefs")
//        RecipeService().saveRecipeToCollection(collection: collection , recipe: recipe) { error in
//            print("SUCCESS")
//        }
        delegate?.popUp(recipe: recipe)
    }
}

