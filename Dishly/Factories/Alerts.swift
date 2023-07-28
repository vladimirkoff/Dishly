//
//  Alerts.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 12.07.2023.
//

import UIKit

func createErrorAlert(error: String) -> UIAlertController {
    let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(okAction)
    return alertController
}

