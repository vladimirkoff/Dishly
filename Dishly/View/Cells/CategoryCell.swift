

import UIKit

class CategoryCell: UICollectionViewCell {
    //MARK: - Properties
    
    var categoryImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 10
        iv.backgroundColor = .gray
        return iv
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
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
        backgroundColor = .white
        layer.cornerRadius = 10
        clipsToBounds = true
        
        addSubview(categoryImageView)
        NSLayoutConstraint.activate([
            categoryImageView.leftAnchor.constraint(equalTo: leftAnchor),
            categoryImageView.rightAnchor.constraint(equalTo: rightAnchor),
            categoryImageView.topAnchor.constraint(equalTo: topAnchor),
            categoryImageView.heightAnchor.constraint(equalToConstant: frame.height)
        ])
        
        addSubview(title)
        NSLayoutConstraint.activate([
            title.leftAnchor.constraint(equalTo: leftAnchor, constant: bounds.width / 10),
            title.topAnchor.constraint(equalTo: topAnchor, constant: bounds.height / 5)
        ])

        
    }
}
