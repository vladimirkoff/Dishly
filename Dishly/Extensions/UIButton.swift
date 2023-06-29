import UIKit

extension UIButton {
    func attributedTitle(first: String, second: String) {
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 18)]
        let attributedTitle = NSMutableAttributedString(string: "\(first) ", attributes: atts)
        let boldAtts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 18)]
        attributedTitle.append(NSAttributedString(string: second, attributes: boldAtts))
        setAttributedTitle(attributedTitle, for: .normal)
    }
}


