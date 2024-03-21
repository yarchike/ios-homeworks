//
//  UserService.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 20.03.2024.
//

protocol UserService {
    var user: User { get }
    func getUser(login: String) -> User?
}

extension UserService {
    func getUser(login: String) -> User? {
        return login == user.login ? user : nil
    }
}
