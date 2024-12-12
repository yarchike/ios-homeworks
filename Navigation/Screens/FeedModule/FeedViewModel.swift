//
//  FeedViewModel.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 05.12.2024.
//

import Foundation


class FeedViewModel: FeedVMProtocol {
    

    var posts: [Post] = []
    var onPostsUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
  
    func fetchPosts() {
        PostManager.shared.fetchAll{posts,error in
            if let error = error {
                self.onError?(error.localizedDescription)
            }
            if let posts = posts {
                self.posts = posts
                self.onPostsUpdated?()
            }
        }
    
    }
    
    func likePost(at index: Int) {
        guard index < posts.count else { return }
        
        var post = posts[index]
        post.likes += 1
        posts[index] = post
        PostManager.shared.upLikes(post: post)
        onPostsUpdated?() 
    }

}

