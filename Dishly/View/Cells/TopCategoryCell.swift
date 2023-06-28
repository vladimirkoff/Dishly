

import UIKit

class TopCategoryCell: UICollectionViewCell {
    //MARK: - Properties
    
//     var categoryImageView: UIImageView = {
//        let iv = UIImageView()
//        iv.clipsToBounds = true
//        iv.translatesAutoresizingMaskIntoConstraints = false
//        iv.layer.cornerRadius = 10
//        iv.backgroundColor = .gray
//        iv.image = UIImage(named: "coffee2")
//        return iv
//    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 10
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configureCell() {
//        addSubview(categoryImageView)
//        NSLayoutConstraint.activate([
//            categoryImageView.leftAnchor.constraint(equalTo: leftAnchor),
//            categoryImageView.rightAnchor.constraint(equalTo: rightAnchor),
//            categoryImageView.topAnchor.constraint(equalTo: topAnchor),
//            categoryImageView.heightAnchor.constraint(equalToConstant: frame.width * 3/4)
//        ])
    }
}
