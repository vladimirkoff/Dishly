
import UIKit

class ProfileOptionCell: UITableViewCell {
    //MARK: - Propeties
    
    private let accessoryImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(systemName: "chevron.right")
        iv.tintColor = .black
        return iv
    }()
    
     var optionImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .black
        return iv
    }()
    
     var optionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Log out"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let cellSymbol: UIImageView = {
         let imageView = UIImageView()
         imageView.translatesAutoresizingMaskIntoConstraints = false
         imageView.tintColor = .white
         return imageView
     }()
   
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isUserInteractionEnabled = true
        configureCell()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configureCell() {
        backgroundColor = .lightGray
        selectionStyle = .none
        
        addSubview(optionImage)
        NSLayoutConstraint.activate([
            optionImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 4),
            optionImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            optionImage.widthAnchor.constraint(equalToConstant: 25),
            optionImage.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        addSubview(optionLabel)
        NSLayoutConstraint.activate([
            optionLabel.leftAnchor.constraint(equalTo: optionImage.rightAnchor, constant: 8),
            optionLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        addSubview(accessoryImage)
        NSLayoutConstraint.activate([
            accessoryImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            accessoryImage.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            accessoryImage.widthAnchor.constraint(equalToConstant: 12),
            accessoryImage.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        addSubview(cellSymbol)
        NSLayoutConstraint.activate([
            cellSymbol.centerYAnchor.constraint(equalTo: centerYAnchor),
            cellSymbol.widthAnchor.constraint(equalToConstant: 30),
            cellSymbol.heightAnchor.constraint(equalToConstant: 30),
            cellSymbol.rightAnchor.constraint(equalTo: optionLabel.leftAnchor, constant: -4)
        ])
    }
}
