

import UIKit

class RecipeCell: UICollectionViewCell {
    //MARK: - Properties
    
    private var recipe: Recipe?
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "save"), for: .normal)
        button.backgroundColor = .yellow
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let starImage1: UIImageView = {
        let image = UIImage(named: "star")
        let iv = UIImageView(image: image)
        return iv
    }()
    
    private let starImage2: UIImageView = {
        let image = UIImage(named: "star")
        let iv = UIImageView(image: image)
        return iv
    }()
    
    private let starImage3: UIImageView = {
        let image = UIImage(named: "star.filled")
        let iv = UIImageView(image: image)
        return iv
    }()
    
    private let starImage4: UIImageView = {
        let image = UIImage(named: "star.half.filled")
        let iv = UIImageView(image: image)
        return iv
    }()
    
    private let starImage5: UIImageView = {
        let image = UIImage(named: "star")
        let iv = UIImageView(image: image)
        return iv
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Home made Italian carboanra"
        return label
    }()
    
    private let itemImageView: UIImageView = {
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
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 5
        button.layer.cornerRadius = 20
        button.setTitle("Add 11 ingridients", for: .normal)
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
    
}
