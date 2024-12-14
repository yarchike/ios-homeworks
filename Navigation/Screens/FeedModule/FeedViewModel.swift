//
//  FeedViewModel.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 05.12.2024.
//

import Foundation


class FeedViewModel {
    

    var posts: [Post] = []
    var onPostsUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    var onPostUpdated: ((IndexPath) -> Void)?
  
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
    
    func likePost(at indexPath: IndexPath) {
        guard indexPath.row < posts.count else { return }
        
        var post = posts[indexPath.row]
        post.likes += 1
        posts[indexPath.row] = post
        PostManager.shared.upLikes(post: post)
        onPostUpdated?(indexPath)
    }

}

