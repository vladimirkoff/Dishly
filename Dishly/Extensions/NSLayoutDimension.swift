//
//  CGFloatRetriever.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 08.07.2023.
//

import UIKit

extension NSLayoutDimension {
    func retrieveCGFloat(from view: UIView) -> CGFloat? {
        if let constraint = view.constraints.first(where: { $0.firstAnchor == self }) {
            let heightConstant = constraint.constant
            return heightConstant
        } else {
            print("No constraint found for the height anchor.")
            return nil
        }
    }
}
