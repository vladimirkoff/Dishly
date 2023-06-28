import UIKit

class ProfileInfoCell: UITableViewCell, UITextViewDelegate {
    
    // MARK: - Properties
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.text = "Password"
        label.backgroundColor = .red
        return label
    }()
    
    private let clearButton: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textColor = .black
        textView.backgroundColor = .red
        textView.font = UIFont.systemFont(ofSize: 22)
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        contentView.backgroundColor = .white
        contentView.addSubview(nameLabel)
        contentView.addSubview(textView)
        
        contentView.addSubview(clearButton)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            clearButton.centerYAnchor.constraint(equalTo: textView.centerYAnchor),
            clearButton.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -8),
            clearButton.widthAnchor.constraint(equalToConstant: 24),
            clearButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        clearButton.layer.cornerRadius = 12
        clearButton.layer.masksToBounds = true
        clearButton.backgroundColor = .systemGray
        clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        clearButton.tintColor = .white
    }


    @objc private func clearButtonTapped() {
        textView.text = ""
        textViewDidChange(textView) // Notify the delegate (cell) about the text change
    }
    
    func textViewDidChange(_ textView: UITextView) {
           // Adjust the cell's height based on the text view's content size
           let contentSize = textView.contentSize
           let textViewHeight = contentSize.height
           
           // Update the frame of the text view
           textView.frame.size.height = textViewHeight
           
           // Update the frame of the clear button
           let clearButtonY = textView.frame.origin.y + textViewHeight - clearButton.frame.size.height
           clearButton.frame.origin.y = clearButtonY
           
           // Notify the table view about the cell's height change
           if let tableView = superview as? UITableView, let indexPath = tableView.indexPath(for: self) {
               tableView.beginUpdates()
               tableView.endUpdates()
               
               // Scroll to the cell if needed
               tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
           }
       }
    
    // MARK: - Configuration
    
    func configure(with name: String, text: String) {
        nameLabel.text = name
        textView.text = text
    }
}
