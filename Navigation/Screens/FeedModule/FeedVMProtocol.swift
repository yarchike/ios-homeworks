//
//  FeedVMProtocol.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 10.04.2024.
//


import Foundation

import Foundation

protocol FeedVMProtocol {
    var posts: [Post] { get }
    var onPostsUpdated: (() -> Void)? { get set }
    var onError: ((String) -> Void)?  { get set }
    func fetchPosts()
    func likePost(at index: Int)
}

