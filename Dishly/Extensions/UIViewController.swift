//
//  UIViewController.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 06.07.2023.
//

import UIKit

extension UIViewController {
    func presentAlert(title: String, message: String, completion: ( (UIAlertAction) -> Void)? ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertButton = UIAlertAction(title: "Ok", style: .default, handler: completion)
        alert.addAction(alertButton)
        self.present(alert, animated: true, completion: nil)
    }
}
