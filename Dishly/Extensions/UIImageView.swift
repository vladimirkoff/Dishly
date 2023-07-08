//
//  UIImageView.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 03.07.2023.
//

import UIKit

extension UIImageView {
   static func createSNSymbol(with name: String) -> UIImageView {
        let iv = UIImageView()
        let image = UIImage(named: name)
        iv.image = image
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .white
        iv.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return iv
    }
}

extension UIImageView {
   static func generateStars() -> [UIImageView] {
       var starImageViews = [UIImageView]()
           
           for _ in 0..<5 {
               let starImageView: UIImageView = {
                   let image = UIImage(systemName: "star")
                   let imageView = UIImageView(image: image)
                   imageView.translatesAutoresizingMaskIntoConstraints = false
                   imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
                   imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
                   return imageView
               }()
               
               starImageViews.append(starImageView)
           }
           
           return starImageViews
    }
}

