import UIKit

class NoRecipesView: UIView {
    //MARK: - Properties
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "recipe.image")) // Make sure to replace "no_recipes_image" with the name of your image asset
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0.5
        return imageView
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "No recipes found"
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    //MARK: - Helpers

    private func setupUI() {
        backgroundColor = .clear
        layer.cornerRadius = 30
        layer.borderWidth = 2
        layer.borderColor = UIColor.lightGray.cgColor

        addSubview(imageView)
        addSubview(messageLabel)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -30),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 150),

            messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
