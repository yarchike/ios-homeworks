//
//  ResponseUser.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 08.05.2024.
//

struct ResponseUser: Codable {
    let userID, id: Int
    let title: String
    let completed: Bool

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, completed
    }
}
