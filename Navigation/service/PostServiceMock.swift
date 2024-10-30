//
//  PostServiceMock.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 30.10.2024.
//

import Foundation
import StorageService

class PostServiceMock: PostServiceProtocol{
    var fakeResult: Result<Post, Error>!
    func fetchPost(completion: @escaping (Result<Post, Error>) -> Void) {
        completion(fakeResult)
    }
    
    
}
