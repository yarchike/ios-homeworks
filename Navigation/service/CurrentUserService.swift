//
//  CurrentUserService.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 20.03.2024.
//

import UIKit

class CurrentUserService: UserService {
    
    let user = User(login: "user", fullname: "Djeki Rassel", avatar: UIImage(named: "cat"), status: "Where")
    
    func getUserByLogin(login: String) -> User? {
        if(user.login == login){
            return user
        }else{
            return nil
        }
    }

    
    
}
