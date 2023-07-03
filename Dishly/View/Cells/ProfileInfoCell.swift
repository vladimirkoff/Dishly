import UIKit

protocol ProfileInfoCellDelegate {
    func infoDidChange(text: String, fieldIndex: Int)
}

class ProfileInfoCell: UITableViewCell, UITextViewDelegate {
    
    // MARK: - Properties
    
    var delegate: ProfileInfoCellDelegate?
    var fieldIndex: Int!
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.text = "Password"
        return label
    }()
    
    private let clearButton: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()
    
     let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textColor = .white
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
        textView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        contentView.backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.2117647059, blue: 0.2745098039, alpha: 1)
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
        
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
    }
    
    @objc private func clearButtonTapped() {
        textView.text = ""
        textViewDidChange(textView)
    }
    
    func textViewDidChange(_ textView: UITextView) {
           let contentSize = textView.contentSize
           let textViewHeight = contentSize.height
           
           textView.frame.size.height = textViewHeight
           
           let clearButtonY = textView.frame.origin.y + textViewHeight - clearButton.frame.size.height
           clearButton.frame.origin.y = clearButtonY
           
           if let tableView = superview as? UITableView, let indexPath = tableView.indexPath(for: self) {
               tableView.beginUpdates()
               tableView.endUpdates()
               
               tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
           }
        delegate?.infoDidChange(text: textView.text, fieldIndex: 0)
       }
    
    // MARK: - Configuration
    
    func configure(with name: String, text: String) {
        nameLabel.text = name
        textView.text = text
    }
    
    func configureFields(email: String?, password: String?, name: String?) {
        if let email = email {
            nameLabel.text = "Email"
            textView.text = email
        } else if let password = password {
            nameLabel.text = "Username"
            textView.text = password
        } else if let name = name {
            nameLabel.text = "Name"
            textView.text = name
        } 
    }
}
