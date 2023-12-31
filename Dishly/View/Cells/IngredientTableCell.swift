
import UIKit

protocol IngredientCellDelegate: AnyObject {
    func updateCell(itemName: String?, portion: PortionModel, cell: IngredientTableCell)
    func deleteCell(cell: IngredientTableCell)
    func portionButtonTapped(cell: IngredientTableCell)
}

class IngredientTableCell: UITableViewCell {
    
    //MARK: - Properties

    @IBOutlet weak var mealPortionButton: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var item: UITextField!
    
    private var portionModel: PortionModel?
    
    static let identifier = "IngredientTableCell"
    weak var delegate: IngredientCellDelegate?
    
    private let protionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        protionLabel.text = nil
        item.text = nil
        portionModel = nil
    }
    
    //MARK: - Helpers
    
    func configureAttributedString(volume: Float, portion: String) -> NSAttributedString {
        let font = UIFont(name: "GillSans-SemiBold", size: 14)!

        let attributedText = NSMutableAttributedString(string: "\(volume)\n", attributes: [.font: font, .foregroundColor: UIColor.black])
        attributedText.append(NSAttributedString(string: portion, attributes: [.font: font, .foregroundColor: UIColor.black]))
        return attributedText
    }
    
    func configureCell() {
        
        deleteButton.tintColor = .black
        item.textColor = .black
        
        addSubview(protionLabel)
        NSLayoutConstraint.activate([
            protionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            protionLabel.rightAnchor.constraint(equalTo: mealPortionButton.leftAnchor, constant: -8)
        ])
    }
    
    
    func configure(ingredient: Ingredient?) {
        guard let ingredient = ingredient else {return}
        if let volume = ingredient.volume, let portion = ingredient.portion {
            protionLabel.attributedText =  configureAttributedString(volume: volume, portion: portion)
        } else {
            protionLabel.text = ""
        }
        item.text = ingredient.name
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        delegate?.deleteCell(cell: self)
    }
    
    override func layoutSubviews() {
        configureCell()
        
        mealPortionButton.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(mealPortionButtonTapped))
        mealPortionButton.addGestureRecognizer(gestureRecognizer)
        item.delegate = self
    }
}

//MARK: - UITextFieldDelegate

extension IngredientTableCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let _ = protionLabel.text, let item = item.text, let portion = portionModel {
            delegate?.updateCell(itemName: item, portion: portion,
                                 cell: self)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let stringLenght = textField.text?.count ?? 0
        if range.length + range.location > stringLenght { return false }
        let maxLenght = stringLenght + string.count - range.length
        
        return maxLenght <= 25
    }
    
    @objc func mealPortionButtonTapped() {
        delegate?.portionButtonTapped(cell: self)
    }
}

//MARK: - AddRecipeViewControllerProtocol

extension IngredientTableCell: AddRecipeViewControllerProtocol {
    func setPortion(portion: PortionModel) {
        portionModel = portion
        protionLabel.attributedText = configureAttributedString(volume: portion.volume, portion: portion.name)
        if let _ = protionLabel.text, let item = item.text, let portion = portionModel {
            delegate?.updateCell(itemName: item, portion: portion,
                                 cell: self)
        }
    }
}
