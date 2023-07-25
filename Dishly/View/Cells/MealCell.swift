import UIKit

protocol MealCellDelegate: AnyObject {
    func addRecipe(cell: MealCell)
    func goToRecipe(recipe: RecipeViewModel)
}

class MealCell: UICollectionViewCell {
    // MARK: - Properties
    
    weak var delegate: MealCellDelegate?
    
    var recipes: [RecipeViewModel]? {
        didSet {
            horizontalCollectionView.reloadData()
        }
    }
    
    var day: DaysOfWeek?
    
    let dayLabel: TableLabel = {
        let label = TableLabel()
        label.setFont(name: "GillSans-SemiBold", size: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.setTitle("Add meal", for: .normal)
        button.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 24)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var horizontalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RecipeCell.self, forCellWithReuseIdentifier: "HorizontalCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let customView = CustomUIViewBackground()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundView = customView
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func setupSubviews() {
        addSubview(dayLabel)
        addSubview(addButton)
        addSubview(separatorView)
        addSubview(horizontalCollectionView)
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
    
    // MARK: - Selectors
    
    @objc private func addButtonTapped() {
        delegate?.addRecipe(cell: self)
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegateFlowLayout

extension MealCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalCell", for: indexPath) as! RecipeCell
        cell.addIngredientsButton.isHidden = true
        cell.isFromPlans = true
        cell.saveButton.setImage(UIImage(systemName: "minus.circle"), for: .normal)
        cell.recipeViewModel = recipes?[indexPath.row]
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
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}

// MARK: - SavedVCProtocol

extension MealCell: SavedVCProtocol {
    func handleCancel() {}
    func reload(collections: [Collection], afterDeletion: Bool) {}
    
    func addRecipe(recipe: RecipeViewModel, mealsViewModel: MealsViewModel?) {
        guard let mealsViewModel = mealsViewModel else { return }
        NotificationCenter.default.post(name: .addTriggered, object: nil, userInfo: ["recipe": recipe, "day": day?.rawValue ?? ""])
    }
}
