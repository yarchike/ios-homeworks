//
//  PostDto.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 05.12.2024.
//

import Foundation



public struct PostDto:Equatable {
    public  let authorId: String
    public let postDescription: String
    public let urlImage: String
    public let likes: Int
    
    
    public init(authorId: String, postDescription: String, urlImage: String, likes: Int, views: Int) {
        self.authorId = authorId
        self.postDescription = postDescription
        self.urlImage = urlImage
        self.likes = likes
    }
}
