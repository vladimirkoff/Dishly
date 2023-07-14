

import UIKit
import SDWebImage

protocol RecipeCellDelegate {
    func addGroceries(groceries: [Ingredient])
    func saveRecipe(recipe: RecipeViewModel)
    func deleteRecipe(id: String)
}

class RecipeCell: UICollectionViewCell {
    //MARK: - Properties
    
    var isFromSaved: Bool?
    
    var delegate: RecipeCellDelegate?
    var savedDelegate: RecipeCellDelegate?
    
    var mealPlanDelegate: RecipeCellDelegate?

    var isFromPlans: Bool?
    
    var recipeViewModel: RecipeViewModel? {
        didSet { configure() }
    }
    
    var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "save"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = greyColor
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(saveRecipe), for: .touchUpInside)
        return button
    }()
    
    private var starImage1: UIImageView = {
        let image = UIImage(named: "star")
        let iv = UIImageView(image: image)
        iv.tintColor = .yellow
        return iv
    }()
    
    private var starImage2: UIImageView = {
        let image = UIImage(named: "star")
        let iv = UIImageView(image: image)
        iv.tintColor = .yellow
        
        return iv
    }()
    
    private var starImage3: UIImageView = {
        let image = UIImage(named: "star.filled")
        let iv = UIImageView(image: image)
        iv.tintColor = .yellow
        
        return iv
    }()
    
    private var starImage4: UIImageView = {
        let image = UIImage(named: "star.half.filled")
        let iv = UIImageView(image: image)
        iv.tintColor = .yellow
        
        return iv
    }()
    
    private var starImage5: UIImageView = {
        let image = UIImage(named: "star")
        let iv = UIImageView(image: image)
        iv.tintColor = .yellow
        
        return iv
    }()
    
    var recipeNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Home made Italian carboanra"
        return label
    }()
    
    var itemImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 15
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    lazy var addIngredientsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 15
        
        
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
        
        addSubview(recipeNameLabel)
        NSLayoutConstraint.activate([
            recipeNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 4),
            recipeNameLabel.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 6)
        ])
        
        addSubview(addIngredientsButton)
        NSLayoutConstraint.activate([
            addIngredientsButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addIngredientsButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            addIngredientsButton.widthAnchor.constraint(equalToConstant: bounds.width - 30),
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
        if let urlString = recipe.recipe.recipeImageUrl {
            if let url = URL(string: urlString) {
                itemImageView.sd_setImage(with: url)
            }
        } else {
            if let imageData = recipe.recipe.imageData {
                let image = UIImage(data: imageData)
                itemImageView.image = image
            }
        }
        recipeNameLabel.text = recipe.recipe.name
        
        let cartSymbol = UIImage(systemName: "cart.fill")
        let title = "ADD \(recipe.recipe.ingredients.count) INGREDIENTS"
        let attributedTitle = NSMutableAttributedString()
        attributedTitle.append(NSAttributedString(attachment: NSTextAttachment(image: cartSymbol!)))
        attributedTitle.append(NSAttributedString(string: " " + title))
        
        addIngredientsButton.setAttributedTitle(attributedTitle, for: .normal)
        addIngredientsButton.setTitleColor(.white, for: .normal)
        
        configureRatingImages(rating: Float(recipe.recipe.rating ?? 0), imageViews: [starImage1, starImage2, starImage3, starImage4, starImage5 ])
    }
    
    //MARK: - Selectors
    
    @objc func addButtonTapped() {
        delegate?.addGroceries(groceries: recipeViewModel!.recipe.ingredients)
    }
    
    @objc func saveRecipe() {
        if let isFromSaved = isFromSaved {
            savedDelegate?.deleteRecipe(id: recipeViewModel!.recipe.id!)
        } else if let isFromPlans {
            RecipesRealmService().deleteRecipeRealm(id: recipeViewModel!.recipe.realmId!) { success in
                NotificationCenter.default.post(name: .savedVCTriggered, object: nil)
                print(success)
            }
        } else {
            delegate?.saveRecipe(recipe: recipeViewModel!)
        }
    }
    
}
