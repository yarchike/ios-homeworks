//
//  TestUserService.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 20.03.2024.
//

import UIKit

class TestUserService: UserService {
    
    let user = User(login: "test", fullname: "Test Testovich", avatar: UIImage(named: "witcher"), status: "Testing")
    
    func getUserByLogin(login: String) -> User? {
        if(user.login == login){
            return user
        }else{
            return nil
        }
    }

    
    
}
