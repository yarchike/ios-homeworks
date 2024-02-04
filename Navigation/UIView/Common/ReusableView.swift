//
//  ReusableView.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 04.02.2024.
//

import UIKit

protocol ReusableView: AnyObject {
    static var identifier: String { get }
}

extension UICollectionViewCell: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
