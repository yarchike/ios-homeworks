//
//  LoginViewControllerDelegate.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 25.03.2024.
//


protocol LoginViewControllerDelegate{
    func check(login: String, password: String)-> Bool
}
