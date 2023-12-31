//
//  UILabel.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 19.07.2023.
//

import UIKit

extension UILabel {
    func setFont(name: String, size: Int) {
        if let font = UIFont(name: name, size: CGFloat(size)) {
            self.font = font
        }
    }
}
