//
//  PostService.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 10.04.2024.
//

import FirebaseDatabaseInternal


class PostManager {
    
    static let shared = PostManager()
    
    

    private init() {}
    
    
    func savePost(post: Post, completion: @escaping (Error?) -> Void) {
        FirebaseDataBaseService.shared.savePostToDataBase(post: post, completion: completion)
    }
   

    func fetchAll(completion: @escaping ([Post]?, Error?) -> Void) {
        FirebaseDataBaseService.shared.fetchAllPost(completion: completion)
    }
    
    func fetchPostsByAuthor(completion: @escaping ([Post]?, Error?) -> Void) {
        if let user = CurrentUser.shared.user{
            FirebaseDataBaseService.shared.fetchPostsByAuthorId(authorId: user.id, completion: completion)
        }
    }
    
    func upLikes(){
        //FirebaseDataBaseService.shared.
    }
}
