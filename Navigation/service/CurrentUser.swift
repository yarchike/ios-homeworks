//
//  CurrentUser.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 04.12.2024.
//

final class CurrentUser {
    static let shared = CurrentUser()

    private init() {}

    var user: User? // Модель вашего пользователя
}
