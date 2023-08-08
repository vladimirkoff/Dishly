import UIKit
import SDWebImage

private let horizontalCellId = "HorizontalCell"
private let categoryCellId = "CategoryCell"

protocol ParentCellDelegate {
    func goToRecipe(with recipe: RecipeViewModel)
    func goToCategory(category: String)
    func popUp(recipe: RecipeViewModel)
}

class ParentCell: UICollectionViewCell {
    //MARK: - Properties
        
    var index: Int! {
        didSet {
            if index == 0 {
                NotificationCenter.default.addObserver(self, selector: #selector(refresh(_ :)), name: .refreshRecipes, object: nil)
            }
        }
    }

    var recipeViewModel: RecipeViewModel!
    var delegate: ParentCellDelegate?
    
    var recipes: [RecipeViewModel]? {
        didSet { horizontalCollectionView.reloadData() }
    }
    
    var isForCategories: Bool? {
        didSet {
            if let isForCategories = isForCategories {
                isForCategories ? configureCellForCategories() : configureCell()
            }
        }
    }
    
    private lazy var titleLabel: TableLabel = {
        let label = TableLabel(frame: CGRect(x: 10, y: 10, width: bounds.width - 20, height: 30))
        label.text = "Daily inspiration"
        label.setFont(name: "GillSans-SemiBold", size: 24)
        return label
    }()
    
     lazy var horizontalCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: titleLabel.frame.maxY, width: bounds.width, height: bounds.height - 40), collectionViewLayout: collectionViewLayout)

        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
     lazy var categoryCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: titleLabel.frame.maxY + 32, width: bounds.width, height: bounds.height - 60), collectionViewLayout: collectionViewLayout)

        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    //MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        horizontalCollectionView.isHidden = true
        categoryCollectionView.isHidden = true
        recipes = nil
        index = nil
        isForCategories = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    @objc func refresh(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let recieps = userInfo["recipes"] as? [RecipeViewModel] {
                self.recipes = recieps
                horizontalCollectionView.reloadData()
            }
        }
    }
    
 
    func configureCell() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)
        ])

        addSubview(horizontalCollectionView)
        NSLayoutConstraint.activate([
            horizontalCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            horizontalCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            horizontalCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        horizontalCollectionView.register(RecipeCell.self, forCellWithReuseIdentifier: horizontalCellId)
    }

    func configureCellForCategories() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)
        ])

        addSubview(categoryCollectionView)
        NSLayoutConstraint.activate([
            categoryCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            categoryCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            categoryCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        categoryCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: categoryCellId)
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
            if let numOfRecipes = recipes?.count {
                return numOfRecipes
            } else { return 0 }
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return inset
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == horizontalCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: horizontalCellId, for: indexPath) as! RecipeCell
            cell.delegate = self
            if let recipes = recipes {
                cell.recipeViewModel = recipes[indexPath.row]
            }
            return cell
        } else if collectionView == categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCellId, for: indexPath) as! CategoryCell
            if index == 1 {
                cell.configure(categories: mealCategories, index: indexPath.row)
            } else if index == 2 {
                cell.configure(categories: countryCategories, index: indexPath.row)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == horizontalCollectionView {
            if let recipes = recipes {
                delegate?.goToRecipe(with: recipes[indexPath.row])
            }
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
        myGroceries += groceries
        
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(myGroceries) {
            UserDefaults.standard.set(encodedData, forKey: "customIngredients")
        }
    }
    
    func saveRecipe(recipe: RecipeViewModel) {
        delegate?.popUp(recipe: recipe)
    }
}

extension Notification.Name {
    static let refreshRecipes = Notification.Name("RefreshRecipesTriggered")
}
