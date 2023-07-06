
import UIKit

protocol IngredientCellDelegate: AnyObject {
    func updateCell(itemName: String?, cell: IngredientTableCell)
    func deleteCell(cell: IngredientTableCell)
    func choosePortion()
}

class IngredientTableCell: UITableViewCell {
    
    //MARK: - Properties

    @IBOutlet weak var mealPortionButton: UIImageView!
    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet weak var item: UITextField!
    
    static let identifier = "IngredientTableCell"
    weak var delegate: IngredientCellDelegate?
    
    //MARK: - Helpers
    
    func configure(ingredient: Ingredient?) {
        guard let ingredient = ingredient else {return}
        item.text = ingredient.name
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        delegate?.deleteCell(cell: self)
    }
    
    override func layoutSubviews() {
        mealPortionButton.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(mealPortionButtonTapped))
        mealPortionButton.addGestureRecognizer(gestureRecognizer)
        item.delegate = self
    }
}

//MARK: - UITextFieldDelegate

extension IngredientTableCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.updateCell(itemName: item.text,
                             cell: self)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let stringLenght = textField.text?.count ?? 0
        if range.length + range.location > stringLenght { return false }
        let maxLenght = stringLenght + string.count - range.length
        return maxLenght <= 25
    }
    
    @objc func mealPortionButtonTapped() {
        delegate?.choosePortion()
    }
}


