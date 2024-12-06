//
//  ProfileViewModel.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 29.11.2024.
//


import Foundation
import FirebaseAuth
import StorageService
import UIKit

class ProfileViewModel {
    
    // MARK: - Properties
    var user: User?
    var avatar: UIImage?
    
    var posts: [Post] = []
    var routeToPhoto: (() -> Void)?
    var routeToLogin: (() -> Void)?
    
    var onUserUpdated: (() -> Void)?
    var onPostsUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
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
        if let uid = CurrentUser.shared.user?.id{
            PostService.shared.fetchPostsByAuthorId(authorId: uid){posts,error in
                if error != nil {
                    self.onError?("Ошибка загрузки постов")
                }
                if let posts = posts {
                    self.posts  = posts
                    self.onPostsUpdated?()
                }
            }
        }else{
            self.onError?("Ошибка авторизации")
        }
        
        
    }
    
    
    func likePost(at index: Int) {
        guard index >= 0, index < posts.count else { return }
        LikeDataManager.shared.addLikePost(post: posts[index])
    }
}
