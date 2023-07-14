import Foundation
import UIKit

class CustomTableView: UITableView {
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return self.contentSize
    }
    
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
}
