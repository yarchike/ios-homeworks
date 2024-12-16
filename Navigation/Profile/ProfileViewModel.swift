//
//  ProfileViewModel.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 29.11.2024.
//


import Foundation
import FirebaseAuth
import UIKit

class ProfileViewModel {
    
    // MARK: - Properties
    var user: User?
    var avatar: UIImage?
    var photos: [Photo] = []
    
    var posts: [Post] = []
    var routeToPhoto: (() -> Void)?
    var routeToLogin: (() -> Void)?
    
    var onUserUpdated: (() -> Void)?
    var onPostsUpdated: (() -> Void)?
    var onPhotoUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    var onPostUpdated: ((IndexPath) -> Void)?
    
    init() {
        posts = []
    }
    
    // MARK: - Public Methods
    func checkAuth() {
        if Auth.auth().currentUser == nil {
            routeToLogin?()
        }
        if let id = Auth.auth().currentUser?.uid{
            FirebaseDataBaseService.shared.getUser(byId: id){user, error in
                self.user = user
                self.onUserUpdated?()
            }
        }
        
    }
    
    func loadPosts() {
        if (CurrentUser.shared.user?.id) != nil{
            PostManager.shared.fetchPostsByAuthor{posts,error in
                if error != nil {
                    self.onError?("Error loading posts".localized)
                }
                if let posts = posts {
                    self.posts  = posts
                    self.onPostsUpdated?()
                }
            }
        }else{
            self.onError?("Authorization error".localized)
        }
        
        
    }
    
    func loadPhoto(){
        PhotosManager.shared.fetchPhotosByAuthor{resutl in 
            self.photos =  Array(resutl.prefix(4))
            self.onPhotoUpdated?()
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
