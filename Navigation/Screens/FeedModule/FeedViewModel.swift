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
    
//    func fetchPosts() {
//        // Для примера добавим несколько постов. В реальной жизни это будет запрос к серверу.
//        let samplePosts = [
//            Post(author: Author(id: "1", name: "John Doe", urlImage: "https://example.com/john.jpg"),
//                 postDescription: "This is a description for post 1",
//                 urlImage: "https://example.com/post1.jpg", likes: 120),
//            Post(author: Author(id: "2", name: "Jane Doe", urlImage: "https://example.com/jane.jpg"),
//                 postDescription: "This is a description for post 2",
//                 urlImage: "https://example.com/post2.jpg", likes: 300),
//            Post(author: Author(id: "3", name: "Jim Beam", urlImage: "https://example.com/jim.jpg"),
//                 postDescription: "This is a description for post 3",
//                 urlImage: "https://example.com/post3.jpg", likes: 56)
//        ]
//        
//        allPosts = samplePosts
//        posts = allPosts // Изначально показываем все посты
//        onPostsUpdated?() // Сообщаем представлению, что данные обновились
//    }    
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
        
        let post = posts[index]
       // post.likes += 1 // Увеличиваем количество лайков
        posts[index] = post
        onPostsUpdated?() // Обновляем UI
    }
}

