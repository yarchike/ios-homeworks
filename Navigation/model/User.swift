//
//  User.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 20.03.2024.
//

import UIKit

struct User {
    let id: String
    let login: String
    let fullname: String
    let avatar: UIImage? // изображение аватара
    let status: String
    
    // Инициализатор структуры, где avatar преобразуется в Data
    init(id: String, login: String, fullname: String, avatar: UIImage?, status: String) {
        self.id = id
        self.login = login
        self.fullname = fullname
        self.avatar = avatar
        self.status = status
    }
    
    // Инициализация из словаря (например, полученного из Firebase)
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let login = dictionary["login"] as? String,
              let fullname = dictionary["fullname"] as? String,
              let status = dictionary["status"] as? String else {
            return nil
        }
        
        self.id = id
        self.login = login
        self.fullname = fullname
        self.status = status
        
        // Получаем ссылку на изображение (если она есть)
        if let avatarURL = dictionary["avatar"] as? String {
            // В реальном приложении тут будет загрузка изображения по URL
            self.avatar = nil // В данном примере просто оставим nil
        } else {
            self.avatar = nil
        }
    }
    
    // Преобразование структуры в словарь для сохранения в Firebase
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [
            "id": id,
            "login": login,
            "fullname": fullname,
            "status": status
        ]
        
        // Если аватар есть, сохраняем ссылку на изображение
        if let avatar = avatar, let avatarData = avatar.jpegData(compressionQuality: 1.0) {
            // Преобразуем аватар в Data и загружаем его в Firebase Storage, получая URL
            // Здесь можно добавить код для загрузки аватара в Firebase Storage и получения ссылки
            // Например, ссылка будет сохранена в базе данных
            // Вместо этого, как заглушку, сохраним пустую строку
            dictionary["avatar"] = "URL_of_the_avatar_image_in_Firebase_Storage"
        }
        
        return dictionary
    }
}
