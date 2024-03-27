//
//  LoginInspector.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 25.03.2024.
//

import Foundation


struct LoginInspector :LoginViewControllerDelegate {
    func check(login: String, password: String)-> Bool{
        return Checker.shared.check(login: login, password: password)
    }
}

