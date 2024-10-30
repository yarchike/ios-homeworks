//
//  UIColor.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 29.10.2024.
//

import Foundation
import UIKit

extension UIColor {
    static let customBackgroundColor: UIColor = {
          return UIColor { (traitCollection: UITraitCollection) -> UIColor in
              return traitCollection.userInterfaceStyle == .dark ? .black : .white
          }
      }()
    
    static let customTextColor: UIColor = {
          return UIColor { (traitCollection: UITraitCollection) -> UIColor in
              return traitCollection.userInterfaceStyle == .dark ? .white : .black
          }
      }()
    
    static let customPhotoBackgroundColor: UIColor = {
          return UIColor { (traitCollection: UITraitCollection) -> UIColor in
              return traitCollection.userInterfaceStyle == .dark ? .white : .black
          }
      }()
    

}
