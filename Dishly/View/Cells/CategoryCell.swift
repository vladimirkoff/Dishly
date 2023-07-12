

import UIKit

class CategoryCell: UICollectionViewCell {
    //MARK: - Properties

    var categoryImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 10
        iv.backgroundColor = .gray
        iv.contentMode = .scaleAspectFill
        return iv
    }()

     let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Breakfast"
        return label
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
        layer.cornerRadius = 10
        clipsToBounds = true

        
        addSubview(categoryImageView)
        NSLayoutConstraint.activate([
            categoryImageView.leftAnchor.constraint(equalTo: leftAnchor),
            categoryImageView.topAnchor.constraint(equalTo: topAnchor),
            categoryImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            categoryImageView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
        
        categoryImageView.addSubview(title)
        NSLayoutConstraint.activate([
            title.leftAnchor.constraint(equalTo: categoryImageView.leftAnchor, constant: 12),
            title.topAnchor.constraint(equalTo: categoryImageView.topAnchor, constant: 6 )
        ])
 

    }
}
