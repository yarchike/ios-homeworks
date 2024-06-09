//
//  TextPicker.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 09.06.2024.
//

import Foundation
import UIKit

final class TextPicker {
    
    static func showMessageFilter(in viewController: UIViewController, complition: @escaping ((_ text: String) -> Void)){
        let alert = UIAlertController(title: "Filter", message: nil, preferredStyle: .alert)
        let alerOkAction = UIAlertAction(title: "Ok", style: .default){_ in
            if let text = alert.textFields?[0].text{
                complition(text)
            }
        }
        let alerCancelAction = UIAlertAction(title: "Cancel", style: .default)
        alert.addTextField{ textField in
            textField.placeholder = "Entel name folder"
        }
        alert.addAction(alerOkAction)
        alert.addAction(alerCancelAction)
        viewController.present(alert, animated: true)
    }
    
    static func showMessage(in viewController: UIViewController, title: String, message: String, complition: @escaping (() -> Void)){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alerOkAction = UIAlertAction(title: "Ok", style: .default){_ in
            complition()
        }
        alert.addAction(alerOkAction)
        viewController.present(alert, animated: true)
    }
}
