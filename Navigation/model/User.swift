//
//  User.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 20.03.2024.
//

//
//  User.swift
//  Navigation
//
//  Created by Ярослав Мартынов on 20.03.2024.
//

//
//  User.swift
//  Navigation
//
//  Created by Ярослав Мартынов on 20.03.2024.
//

import UIKit

struct User {
    let id: String
    let email: String
    let fullname: String
    let avatarURL: String?
    let status: String
    

    init(id: String, email: String, fullname: String, avatarURL: String?, status: String) {
        self.id = id
        self.email = email
        self.fullname = fullname
        self.avatarURL = avatarURL
        self.status = status
    }
    
    // Инициализация из словаря (например, полученного из Firebase)
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let email = dictionary["email"] as? String,
              let fullname = dictionary["fullname"] as? String,
              let status = dictionary["status"] as? String else {
            return nil
        }
        
        self.id = id
        self.email = email
        self.fullname = fullname
        self.status = status
        
        // Получаем строку с URL аватара, если она есть
        self.avatarURL = dictionary["avatarURL"] as? String
    }
    

    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [
            "id": id,
            "email": email,
            "fullname": fullname,
            "status": status
        ]
        

        if let avatarURL = avatarURL {
            dictionary["avatarURL"] = avatarURL
        }
        
        return dictionary
    }
}
