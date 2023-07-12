
import UIKit

protocol PrepareCellDelegate: AnyObject {
    func updateCell(textView: String?, cell: PrepareTableCell)

}

class PrepareTableCell: UITableViewCell {

    static let identifier = "PrepareTableCell"
    
    var instruction: Instruction? {
        didSet {
            textView.text = instruction!.text
        }
    }
    
    @IBOutlet  weak var textView: UITextView!
    
    weak var delegate: PrepareCellDelegate?
    
    override func layoutSubviews() {
        textView.delegate = self

        textView.layer.cornerRadius = 20.0
        textView.layer.borderWidth = 2.0
        textView.layer.borderColor = UIColor(named:"Dark Red")?.cgColor
        textView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
    
    override func prepareForReuse() {
        textView.text = nil
    }
    
    func configure(instruction: Instruction?) {
        guard let instruction = instruction else {return}
        textView.text = instruction.text
    }
}

//MARK: - UITextViewDelegate

extension PrepareTableCell: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print(textView.text)
        self.delegate?.updateCell(textView: textView.text, cell: self)
    }
    
}


