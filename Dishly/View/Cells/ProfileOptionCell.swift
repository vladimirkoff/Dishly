
import UIKit

class ProfileOptionCell: UITableViewCell {
    //MARK: - Propeties
    
    var indexPath: Int? {
        didSet { configureElements(indexPath: indexPath!, isForMenu: isForMenu!) }
    }
    
    var isForMenu: Bool?
    
    private let accessoryImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(systemName: "chevron.right")
        iv.tintColor = .black
        return iv
    }()
    
    private let optionImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .black
        return iv
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
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
        backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9333333333, blue: 0.8784313725, alpha: 1)
        selectionStyle = .none
        
        addSubview(optionImage)
        NSLayoutConstraint.activate([
            optionImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 4),
            optionImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            optionImage.widthAnchor.constraint(equalToConstant: 25),
            optionImage.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: optionImage.rightAnchor, constant: 8),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        addSubview(accessoryImage)
        NSLayoutConstraint.activate([
            accessoryImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            accessoryImage.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            accessoryImage.widthAnchor.constraint(equalToConstant: 12),
            accessoryImage.heightAnchor.constraint(equalToConstant: 16)
        ])
        

    }
    
    func configureElements(indexPath: Int, isForMenu: Bool) {
//        if isForMenu {
//
//            optionImage.tintColor = indexPath == 5 ? .red : .lightGray
//            optionImage.image = menuOptionsImagesArray[indexPath]
//            label.text = menuOptionsNamesArray[indexPath]
//        }
    }
}
