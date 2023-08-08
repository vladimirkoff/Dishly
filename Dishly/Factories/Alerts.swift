//
//  Alerts.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 12.07.2023.
//

import UIKit

struct Alerts {
    
    static func createErrorAlert(error: String) -> UIAlertController {
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        return alertController
    }
    
    static func showDeleteAlertTest(for id: String?,
                         in vc: UIViewController,
                         onDelete: (() -> Void)? = nil, onCancel: (() -> Void)? = nil,
                         message: String?,
                         title: String
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let deleteAction = UIAlertAction(title: message != nil ? "Delete" : "OK", style: .destructive) { _ in
            onDelete?()
        }
        alertController.addAction(deleteAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            onCancel?()
        }
        alertController.addAction(cancelAction)

        vc.present(alertController, animated: true, completion: nil)
    }
}






