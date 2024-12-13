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
        FirebaseDataBaseService.shared.savePostToDatabase(post: post, completion: completion)
    }
   

    func fetchAll(completion: @escaping ([Post]?, Error?) -> Void) {
        FirebaseDataBaseService.shared.fetchAllPosts(completion: completion)
    }
    
    func fetchPostsByAuthor(completion: @escaping ([Post]?, Error?) -> Void) {
        if let user = CurrentUser.shared.user{
            FirebaseDataBaseService.shared.fetchPostsByAuthorId(authorId: user.id, completion: completion)
        }
    }
    
    func upLikes(post:Post){
        let newLikes = post.likes + 1
        let updatedPost = Post(
               id: post.id,
               author: post.author,
               postDescription: post.postDescription,
               urlImage: post.urlImage,
               likes: newLikes,
               createdAt: post.createdAt
           )
        FirebaseDataBaseService.shared.updatePost(post: updatedPost){error in
            if error != nil {
                print(error ?? "")
            }
        }
    }
    

}
