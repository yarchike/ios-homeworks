//
//  SettingsViewModel.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 06.12.2024.
//

import UIKit

class SettingsViewModel {
    var avatar: UIImage?
    var fullName: String?

    var onSettingsUpdated: (() -> Void)?
    var onError: ((String) -> Void)?

    func fetchCurrentSettings() {
        // Загрузка данных из сети или локального хранилища
        // Пример данных
        self.avatar = UIImage(named: "defaultAvatar")
        self.fullName = "Текущее Полное Имя"

        // Обновляем UI
        onSettingsUpdated?()
    }

    func updateAvatar(_ newAvatar: UIImage) {
        // Обновить аватарку
        self.avatar = newAvatar
        // Сохранить аватарку где-нибудь (например, на сервере)
        onSettingsUpdated?()
    }

    func updateFullName(_ newFullName: String) {
        // Обновить полное имя
        self.fullName = newFullName
        // Сохранить полное имя
        onSettingsUpdated?()
    }

    func updatePassword(_ newPassword: String, confirmPassword: String, completion: @escaping (Error?) -> Void) {
        // Проверка на совпадение паролей
        if newPassword != confirmPassword {
            completion(NSError(domain: "SettingsViewModel", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Пароли не совпадают."]))
            return
        }

        // Обновить пароль
        // Сохранить пароль (например, на сервере)
        // В реальном приложении здесь можно будет отправить запрос на сервер или сохранить данные в локальном хранилище.
        
        completion(nil) // Если все прошло успешно, вызываем completion без ошибки
    }
}
