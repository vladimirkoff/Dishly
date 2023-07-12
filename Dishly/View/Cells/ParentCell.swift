import UIKit
import SDWebImage

protocol ParentCellDelegate {
    func goToRecipe(with recipe: RecipeViewModel)
    func goToCategory(category: String)
    func popUp(recipe: RecipeViewModel)
}

class ParentCell: UICollectionViewCell {
    //MARK: - Properties
    
    var numOfRecipes: Int!
    
    var index: Int!

    var recipeViewModel: RecipeViewModel!
    var delegate: ParentCellDelegate?
    
    var recipes: [RecipeViewModel]?
    
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
        collectionView.backgroundColor = greyColor
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private lazy var categoryCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: bounds.midY - bounds.midY / 2, width: bounds.width, height: bounds.height - 60), collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = greyColor
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    //MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        horizontalCollectionView.isHidden = true
        categoryCollectionView.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = greyColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
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
    
    func configure(index: Int) {
        switch index {
        case 0:
            titleLabel.text = "Daily inspiration"
        case 1:
            titleLabel.text = "By meal"
        case 2:
            titleLabel.text = "By country"
        default:
            titleLabel.text = "Error"
        }
    }
}

//MARK: - UICollectionViewDataSource & UICollectionViewDelegateFlowLayout

extension ParentCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case horizontalCollectionView:
            return numOfRecipes
        case categoryCollectionView:
            if index == 1 {
                return  mealCategories.count
            } else {
                return countryCategories.count
            }
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == horizontalCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalCell", for: indexPath) as! RecipeCell
            cell.delegate = self
            if let recipes = recipes {
                cell.recipeViewModel = recipes[indexPath.row]
            }
            cell.backgroundColor = #colorLiteral(red: 0.3215686275, green: 0.3215686275, blue: 0.3215686275, alpha: 1)
            return cell
        } else if collectionView == categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            cell.backgroundColor = .yellow
            
            
            
            if index == 1 {
                cell.title.text = mealCategories[indexPath.row]
            } else if index == 2 {
                if indexPath.row == 0 {
                    cell.categoryImageView.image = UIImage(named: "ukraine")
                }
                cell.title.text = countryCategories[indexPath.row]
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == horizontalCollectionView {
            delegate?.goToRecipe(with: recipes![indexPath.row])
        } else {
            if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell {
                delegate?.goToCategory(category: cell.title.text!)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == horizontalCollectionView {
            collectionView.isScrollEnabled = true
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
    func deleteRecipe(id: String) {}
    
    
    func addGroceries(groceries: [Ingredient]) {
        myGroceries = groceries
    }
    
    func saveRecipe(recipe: RecipeViewModel) {
        delegate?.popUp(recipe: recipe)
    }
}

