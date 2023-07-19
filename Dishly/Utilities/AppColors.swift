//
//  AppColors.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 09.07.2023.
//

import UIKit

let defaultRecipeImageData = UIImage(named: "foodPlaceholder")?.pngData()

enum AppColors {
    
    case customGrey
    case customLightGrey
    case customPurple
    case customLight
    case additionalColor
    case goldenColor
    
    var color: UIColor {
          switch self {
          case .customGrey:
              return #colorLiteral(red: 0.2518529296, green: 0.246892333, blue: 0.2555828691, alpha: 1)
          case .customLightGrey:
              return #colorLiteral(red: 0.3215686275, green: 0.3215686275, blue: 0.3215686275, alpha: 1)
          case .customPurple:
              return #colorLiteral(red: 0.2274509804, green: 0.5960784314, blue: 0.7254901961, alpha: 1)
          case .customLight:
              return #colorLiteral(red: 1, green: 0.9450980392, blue: 0.862745098, alpha: 1)
          case .additionalColor:
              return #colorLiteral(red: 0.9098039216, green: 0.8352941176, blue: 0.768627451, alpha: 1)
          case .goldenColor:
              return #colorLiteral(red: 0.9411764706, green: 0.8705882353, blue: 0.2117647059, alpha: 1)
          }
      }
    
}


