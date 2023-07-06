//
//
//import UIKit
//
//class BonusProgramView: UIView {
//    //MARK: - Properies
//    
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = .black
//        label.font = UIFont.boldSystemFont(ofSize: 18)
//        label.text = "Bonus program rules"
//        return label
//    }()
//    
//  lazy private var rulesAttributedLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = .lightGray
//        label.numberOfLines = 0
//        label.attributedText = configureAttributedString()
//        label.textAlignment = .left
//        return label
//    }()
//    
//    
//    //MARK: - Lifecycle
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        configureView()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    //MARK: - Helpers
//    
//    func configureView() {
//        self.addSubview(titleLabel)
//        NSLayoutConstraint.activate([
//            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 22),
//        ])
//        
//        self.addSubview(rulesAttributedLabel)
//        NSLayoutConstraint.activate([
//            rulesAttributedLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//            rulesAttributedLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 4),
//            rulesAttributedLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
//        ])
//    }
//    
//    func configureAttributedString() -> NSAttributedString {
//        let attributedText = NSMutableAttributedString(string: "1) How to get points?\n", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.black])
//        attributedText.append(NSAttributedString(string: "Points are earned with every gryvna you've got on your balance\n", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.black]))
//        attributedText.append(NSAttributedString(string: "\n", attributes: [.font: UIFont.systemFont(ofSize: 24), .foregroundColor: UIColor.black]))
//        attributedText.append(NSAttributedString(string: "2) How many points do I get with every order?\n", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.black]))
//        attributedText.append(NSAttributedString(string: "The amount of bonuses is meant to be 10% of the price of your order\n", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.black]))
//        attributedText.append(NSAttributedString(string: "\n", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.black]))
//        attributedText.append(NSAttributedString(string: "3) What items do I not get points for?\n", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.black]))
//        attributedText.append(NSAttributedString(string: "Points are not recieved for icecream, Coca-Cola, Fanta, Sprite\n", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.black]))
//        attributedText.append(NSAttributedString(string: "\n", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.black]))
//        attributedText.append(NSAttributedString(string: "4) How can I use my bonuses?\n", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.black]))
//        attributedText.append(NSAttributedString(string: "You can spend your points to buy any of our items, cutting from 1 to 100% of the price of the order.", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.black]))
//        return attributedText
//    }
//}
