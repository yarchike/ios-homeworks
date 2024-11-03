//
//  PostService.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 10.04.2024.
//

import Foundation
import StorageService

class PostService :PostServiceProtocol{
    func fetchPost(completion: @escaping (Result<Post, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 3, execute: { [weak self] in
            guard let self else {return}
            completion(.success(Post.make()[0]))
        })
    }
}
