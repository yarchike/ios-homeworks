//
//  PostServiceProtocol.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 30.10.2024.
//

import Foundation
import StorageService


protocol PostServiceProtocol {
    func fetchPost(completion: @escaping (Result<Post, Error>) -> Void)
}
