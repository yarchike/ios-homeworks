//
//  PostService.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 10.04.2024.
//

import FirebaseDatabaseInternal


class PostService {
    
    static let shared = PostService()
    
    

    private init() {}

    /// Сохраняет пост в базу данных
    func saveToDataBase(post: Post, completion: @escaping (Error?) -> Void) {
        let ref = Database.database(url: databaseURL).reference().child("posts").childByAutoId()
        let postDict: [String: Any] = [
            "author": [
                "id": post.author.id,
                "name": post.author.name,
                "urlImage": post.author.urlImage
            ],
            "postDescription": post.postDescription,
            "urlImage": post.urlImage,
            "likes": post.likes
        ]
        ref.setValue(postDict) { error, _ in
            completion(error)
        }
    }

    /// Извлекает все посты из базы данных
    func fetchAll(completion: @escaping ([Post]?, Error?) -> Void) {
        let ref = Database.database(url: databaseURL).reference().child("posts")

        ref.observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: [String: Any]] else {
                completion([], nil) // Пустой массив, если данных нет
                return
            }

            var posts: [Post] = [] // Массив для хранения корректных постов

            // Перебираем каждый пост
            for (_, data) in value {
                guard
                    let authorData = data["author"] as? [String: Any],
                    let authorId = authorData["id"] as? String,
                    let authorName = authorData["name"] as? String,
                    let authorUrlImage = authorData["urlImage"] as? String,
                    let postDescription = data["postDescription"] as? String,
                    let urlImage = data["urlImage"] as? String,
                    let likes = data["likes"] as? Int
                else {
                    // Если данные не соответствуют, пропускаем этот пост
                    continue
                }

                // Создаём объект Author
                let author = Author(
                    id: authorId,
                    name: authorName,
                    urlImage: authorUrlImage
                )

                // Создаём объект Post и добавляем его в массив
                let post = Post(
                    author: author,
                    postDescription: postDescription,
                    urlImage: urlImage,
                    likes: likes
                )

                posts.append(post) // Добавляем валидный пост в список
            }

            // Возвращаем результат
            completion(posts, nil)
        } withCancel: { error in
            completion(nil, error)
        }
    }



    /// Извлекает посты по идентификатору автора
    func fetchPostsByAuthorId(authorId: String, completion: @escaping ([Post]?, Error?) -> Void) {
        let ref = Database.database(url: databaseURL).reference().child("posts")
        
        // Фильтрация данных на сервере
        let query = ref.queryOrdered(byChild: "author/id").queryEqual(toValue: authorId)
        
        query.observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: [String: Any]] else {
                completion([], nil) // Пустой массив, если данных нет
                return
            }

            // Маппируем данные на объекты Post
            let posts: [Post] = value.compactMap { (_, data) in
                guard
                    let authorData = data["author"] as? [String: Any],
                    let id = authorData["id"] as? String,
                    let authorName = authorData["name"] as? String,
                    let authorUrlImage = authorData["urlImage"] as? String,
                    let postDescription = data["postDescription"] as? String,
                    let urlImage = data["urlImage"] as? String,
                    let likes = data["likes"] as? Int
                else {
                    return nil
                }

                let author = Author(
                    id: id,
                    name: authorName,
                    urlImage: authorUrlImage
                )

                return Post(
                    author: author,
                    postDescription: postDescription,
                    urlImage: urlImage,
                    likes: likes
                )
            }

            completion(posts, nil)
        } withCancel: { error in
            completion(nil, error)
        }
    }


}
