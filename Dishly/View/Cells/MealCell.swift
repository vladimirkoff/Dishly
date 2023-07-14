import UIKit

protocol MealCellDelegate {
    func addRecipe(cell: MealCell)
    func goToRecipe(recipe: RecipeViewModel)
}

class MealCell: UICollectionViewCell {
    //MARK: - Properties
     
    var delegate: MealCellDelegate?
    
    var recipes: [RecipeViewModel]? {
        didSet {
            horizontalCollectionView.reloadData()
        }
    }
    
    var day: DaysOfWeek?
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.setTitle("Add meal", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.tintColor = .white
        button.addTarget(self, action: #selector(addButtonTaped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let horizontalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .orange
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    private func setupSubviews() {
        addSubview(dayLabel)
        addSubview(addButton)
        addSubview(separatorView)
        addSubview(horizontalCollectionView)

        horizontalCollectionView.dataSource = self
        horizontalCollectionView.delegate = self
        horizontalCollectionView.register(RecipeCell.self, forCellWithReuseIdentifier: "HorizontalCell")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            addButton.centerYAnchor.constraint(equalTo: dayLabel.centerYAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 24),
            
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 8),
            separatorView.heightAnchor.constraint(equalToConstant: 2),
            
            horizontalCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            horizontalCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            horizontalCollectionView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 4),
            horizontalCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    //MARK: - Selectors
    
    @objc func addButtonTaped() {
        delegate?.addRecipe(cell: self)
    }
}

//MARK: - UICollectionViewDataSource & UICollectionViewDelegateFlowLayout

extension MealCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = recipes?.count else { return 1 }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalCell", for: indexPath) as! RecipeCell
        cell.backgroundColor = lightGrey
        cell.addIngredientsButton.isHidden = true
        cell.isFromPlans = true
        cell.saveButton.setImage(UIImage(systemName: "minus.circle"), for: .normal)
        if let recipes = recipes {
            cell.recipeViewModel = recipes[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? RecipeCell else { return }
        delegate?.goToRecipe(recipe: cell.recipeViewModel!)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2
        let height = collectionView.frame.height - 30
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return inset
    }
}

//MARK: - SavedVCProtocol

extension MealCell: SavedVCProtocol {
    func reload(collections: [Collection]) {}
    
    func addRecipe(recipe: RecipeViewModel, mealsViewModel: MealsViewModel?) {
        guard let mealsViewModel = mealsViewModel else { return }
        RecipesRealmService().addRecipeRealm(recipe: recipe, day: day!.rawValue) { success in
            NotificationCenter.default.post(name: .savedVCTriggered, object: nil)
            print(success)
        }
    }
    
}
