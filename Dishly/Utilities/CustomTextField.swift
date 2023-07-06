
import Foundation
import UIKit

class AuthCustomTextField: UITextField {

    //MARK: - Lifecycle
     init(placeholder: String) {
        super.init(frame: .zero)

        let space = UIView()
        space.translatesAutoresizingMaskIntoConstraints = false
        space.bounds = CGRect(x: 0, y: 0, width: 12, height: 50)
        leftView = space
        leftViewMode = .always

        translatesAutoresizingMaskIntoConstraints = false
        borderStyle = .none
        textColor = .white
        keyboardAppearance = .dark
        backgroundColor = UIColor(white: 1, alpha: 0.1)
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.7)])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



@IBDesignable
class CustomView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
         get {
             return self.layer.cornerRadius
         } set {
             self.layer.cornerRadius = newValue
         }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                self.layer.shadowColor = color.cgColor
            }
         }
    }
    
    @IBInspectable var shadowOffset: CGSize {
         get {
             return self.layer.shadowOffset
         }
        set {
           self.layer.shadowOffset = newValue
         }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
         get {
             return self.layer.shadowRadius
         } set {
             self.layer.shadowRadius = newValue
         }
    }
    
    @IBInspectable var shadowOpacity: Float {
         get {
             return self.layer.shadowOpacity
         } set {
             self.layer.shadowOpacity = newValue
         }
    }
    
    @IBInspectable var maskToBounds: Bool {
         get {
             return self.layer.masksToBounds
         } set {
             self.layer.masksToBounds = newValue
         }
    }
        
    @IBInspectable var borderWidth: CGFloat {
         get {
             return self.layer.borderWidth
         } set {
             self.layer.borderWidth = newValue
         }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                self.layer.borderColor = color.cgColor
            }
         }
    }

}

@IBDesignable
class CustomTextField: UITextField {
    
    @IBInspectable var borderWidth: CGFloat {
         get {
             return self.layer.borderWidth
         } set {
             self.layer.borderWidth = newValue
         }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                self.layer.borderColor = color.cgColor
            }
         }
    }
}
