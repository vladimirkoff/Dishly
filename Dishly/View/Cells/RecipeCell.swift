

import UIKit
import SDWebImage

protocol RecipeCellDelegate {
    func addGroceries(groceries: [Ingredient])
    func saveRecipe(recipe: RecipeViewModel)
}

class RecipeCell: UICollectionViewCell {
    //MARK: - Properties
    
    var delegate: RecipeCellDelegate?
    
    var recipeViewModel: RecipeViewModel? {
        didSet { configure() }
    }
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "save"), for: .normal)
        button.backgroundColor = .yellow
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(saveRecipe), for: .touchUpInside)
        return button
    }()
    
    private var starImage1: UIImageView = {
        let image = UIImage(named: "star")
        let iv = UIImageView(image: image)
        return iv
    }()
    
    private var starImage2: UIImageView = {
        let image = UIImage(named: "star")
        let iv = UIImageView(image: image)
        return iv
    }()
    
    private var starImage3: UIImageView = {
        let image = UIImage(named: "star.filled")
        let iv = UIImageView(image: image)
        return iv
    }()
    
    private var starImage4: UIImageView = {
        let image = UIImage(named: "star.half.filled")
        let iv = UIImageView(image: image)
        return iv
    }()
    
    private var starImage5: UIImageView = {
        let image = UIImage(named: "star")
        let iv = UIImageView(image: image)
        return iv
    }()
    
     var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Home made Italian carboanra"
        return label
    }()
    
     var itemImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 15
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private lazy var addIngredientsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.setTitle("Add 11 ingridients", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()

    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
 
    
    func configureCell() {
        
        layer.cornerRadius = 15
        
        addSubview(itemImageView)
        NSLayoutConstraint.activate([
            itemImageView.leftAnchor.constraint(equalTo: leftAnchor),
            itemImageView.rightAnchor.constraint(equalTo: rightAnchor),
            itemImageView.heightAnchor.constraint(equalToConstant: frame.height * 3/4),
            itemImageView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        let stack = UIStackView(arrangedSubviews: [starImage1, starImage2, starImage3, starImage4, starImage5])
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 4),
            stack.leftAnchor.constraint(equalTo: leftAnchor, constant: 4),
            stack.heightAnchor.constraint(equalToConstant: 12),
            stack.widthAnchor.constraint(equalToConstant: frame.width / 4)
        ])
        
        addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 4),
            priceLabel.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 6)
        ])
        
        addSubview(addIngredientsButton)
        NSLayoutConstraint.activate([
            addIngredientsButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addIngredientsButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            addIngredientsButton.widthAnchor.constraint(equalToConstant: bounds.width - 10),
            addIngredientsButton.heightAnchor.constraint(equalToConstant: bounds.height / 12)
        ])
        
        addSubview(saveButton)
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            saveButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -8)
        ])
    }
    
    func configureRatingImages(rating: Float, imageViews: [UIImageView]) {
        let filledStarImage = UIImage(systemName: "star.fill")
        let halfFilledStarImage = UIImage(systemName: "star.lefthalf.fill")
        let emptyStarImage = UIImage(systemName: "star")

        let filledCount = Int(rating)
        let hasHalfStar = rating - Float(filledCount) >= 0.5

        for (index, imageView) in imageViews.enumerated() {
            if index < filledCount {
                imageView.image = filledStarImage
            } else if index == filledCount && hasHalfStar {
                imageView.image = halfFilledStarImage
            } else {
                imageView.image = emptyStarImage
            }
        }
    }
    
    func configure() {
        guard let recipe = recipeViewModel else { return }
        
        itemImageView.sd_setImage(with: URL(string: recipe.recipe.recipeImageUrl!)!)
        priceLabel.text = recipe.recipe.name
        addIngredientsButton.setTitle("Add \(recipe.recipe.ingredients.count) ingredients", for: .normal)
        configureRatingImages(rating: 3.5, imageViews: [starImage1, starImage2, starImage3, starImage4, starImage5 ])
    }
    
    //MARK: - Selectors
    
    @objc func addButtonTapped() {
        delegate?.addGroceries(groceries: recipeViewModel!.recipe.ingredients)
    }
    
    @objc func saveRecipe() {
        delegate?.saveRecipe(recipe: recipeViewModel!)
    }
    
}
