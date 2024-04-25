//
//  UserService.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 20.03.2024.
//

protocol UserService {
    var user: User { get }
    func getUser(login: String) throws -> User
}

extension UserService {
    func getUser(login: String) throws -> User {
        if(login == user.login){
            return user
        }else{
            throw ApiError.notFound
        }
    }
}
