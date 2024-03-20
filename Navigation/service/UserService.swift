//
//  UserService.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 20.03.2024.
//


protocol UserService {
    func getUserByLogin(login: String) -> User?
}
