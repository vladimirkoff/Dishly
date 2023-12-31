
import UIKit

protocol ProfileOptionCellDelegate: AnyObject {
    func switchToggled(sender: UISwitch)
}

class ProfileOptionCell: UITableViewCell {
    //MARK: - Propeties
    
    weak var delegate: ProfileOptionCellDelegate?
    
     let accessoryImage: UIImageView = {
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
    
    var mySwitch: UISwitch = {
        let switcher = UISwitch()
        switcher.translatesAutoresizingMaskIntoConstraints = false
        switcher.isHidden = true
        switcher.isOn = false
        return switcher
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
        configureCell()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configure(index: Int) {
        switch index {
        case 0:
            let appearanceImage = UIImage(systemName: "paintbrush.fill")
            accessoryImage.isHidden = true
            accessoryImage.isUserInteractionEnabled = false
            mySwitch.isHidden = false
            mySwitch.isOn = isDark ? true : false
            isUserInteractionEnabled = true
            cellSymbol.image = appearanceImage
            optionLabel.text = "Change appearance"
        case 1:
            let lockImage = UIImage(systemName: "lock.fill")
            cellSymbol.image = lockImage
            optionLabel.text = "Privacy Policy"
        case 2:
            let infoImage = UIImage(systemName: "info.bubble.fill")
            cellSymbol.image = infoImage
            optionLabel.text = "About Us"
        case 3:
            let logOutImage = UIImage(systemName: "rectangle.portrait.and.arrow.right")
            cellSymbol.image = logOutImage
            optionLabel.text = "Log Out"
        default:
            print("Default")
        }
    }
    
    func configureCell() {
        backgroundColor = .lightGray
        selectionStyle = .none
        
        mySwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)

        contentView.addSubview(optionImage)
        NSLayoutConstraint.activate([
            optionImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 4),
            optionImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            optionImage.widthAnchor.constraint(equalToConstant: 25),
            optionImage.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        contentView.addSubview(optionLabel)
        NSLayoutConstraint.activate([
            optionLabel.leftAnchor.constraint(equalTo: optionImage.rightAnchor, constant: 8),
            optionLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        contentView.addSubview(accessoryImage)
        NSLayoutConstraint.activate([
            accessoryImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            accessoryImage.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            accessoryImage.widthAnchor.constraint(equalToConstant: 12),
            accessoryImage.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        contentView.addSubview(cellSymbol)
        NSLayoutConstraint.activate([
            cellSymbol.centerYAnchor.constraint(equalTo: centerYAnchor),
            cellSymbol.widthAnchor.constraint(equalToConstant: 30),
            cellSymbol.heightAnchor.constraint(equalToConstant: 30),
            cellSymbol.rightAnchor.constraint(equalTo: optionLabel.leftAnchor, constant: -4)
        ])
        
        contentView.addSubview(mySwitch)
        NSLayoutConstraint.activate([
            mySwitch.centerYAnchor.constraint(equalTo: centerYAnchor),
            mySwitch.rightAnchor.constraint(equalTo: rightAnchor, constant: -12)
        ])
        
        mySwitch.isUserInteractionEnabled = true
    }
    
    @objc func switchValueChanged(_ sender: UISwitch) {
        delegate?.switchToggled(sender: sender)
      }
    
}


