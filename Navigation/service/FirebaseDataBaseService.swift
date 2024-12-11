import FirebaseDatabase

class FirebaseDataBaseService {
    
    static let shared = FirebaseDataBaseService()
    
    private let databaseRef: DatabaseReference

    init() {
        // Инициализируем ссылку на корень базы данных Firebase
        self.databaseRef = Database.database(url: databaseURL).reference()

    }

    // Метод для сохранения нового пользователя
    func saveUser(user: User, completion: @escaping (Error?) -> Void) {
        let userRef = databaseRef.child("users").child(user.id)
        userRef.setValue(user.toDictionary()) { error, _ in
            completion(error)
            
        }
    }

    // Метод для получения данных пользователя по его id
    func getUser(byId userId: String, completion: @escaping (User?, Error?) -> Void) {
        let userRef = databaseRef.child("users").child(userId)
        userRef.observeSingleEvent(of: .value) { snapshot in
            if let userDict = snapshot.value as? [String: Any] {
                let user = User(dictionary: userDict)
                completion(user, nil)
            } else {
                completion(nil, NSError(domain: "FirebaseService", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"]))
            }
        } withCancel: { error in
            completion(nil, error)
        }
    }

    // Метод для обновления данных пользователя
    func updateUser(user: User, completion: @escaping (Error?) -> Void) {
        let userRef = databaseRef.child("users").child(user.id)
        userRef.updateChildValues(user.toDictionary()) { error, _ in
            completion(error)
        }
    }

    // Метод для удаления пользователя
    func deleteUser(userId: String, completion: @escaping (Error?) -> Void) {
        let userRef = databaseRef.child("users").child(userId)
        userRef.removeValue { error, _ in
            completion(error)
        }
    }
    
    func addPhotoToDatabase(photo: Photo) {
        let photosRef = databaseRef.child("photos")
        
        // Генерируем уникальный ключ для записи
        let newPhotoRef = photosRef.childByAutoId()
        newPhotoRef.setValue(photo.toDictionary()) { error, _ in
            if let error = error {
                print("Ошибка при добавлении фото: \(error.localizedDescription)")
            } else {
                print("Фото успешно добавлено!")
            }
        }
    }
    
    func fetchPhotos(completion: @escaping ([Photo]) -> Void) {
        let photosRef = databaseRef.child("photos")
        
        photosRef.observeSingleEvent(of: .value) { snapshot,_  in
            var photos: [Photo] = []
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let data = childSnapshot.value as? [String: Any],
                   let id = data["id"] as? String,
                   let image = data["image"] as? String,
                   let authorId = data["authorId"] as? String {
                    let photo = Photo(id: id, imageURL: image, authorId: authorId)
                    photos.append(photo)
                }
            }
            completion(photos)
        }
    }
    
    func fetchPhotosByAuthorId(authorId: String, completion: @escaping ([Photo]) -> Void) {
        let photosRef = databaseRef.child("photos")
        
        // Фильтруем записи по authorId
        let query = photosRef.queryOrdered(byChild: "authorId").queryEqual(toValue: authorId)
        
        query.observeSingleEvent(of: .value) { snapshot, _ in
            var photos: [Photo] = []
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let data = childSnapshot.value as? [String: Any],
                   let id = data["id"] as? String,
                   let image = data["imageURL"] as? String,
                   let authorId = data["authorId"] as? String {
                    let photo = Photo(id: id, imageURL: image, authorId: authorId)
                    photos.append(photo)
                }
            }
            completion(photos)
        }
    }
    func savePostToDataBase(post: Post, completion: @escaping (Error?) -> Void) {
        let ref = databaseRef.child("posts").childByAutoId()
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

    func fetchAllPost(completion: @escaping ([Post]?, Error?) -> Void) {
        let ref = databaseRef.child("posts")

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



    func fetchPostsByAuthorId(authorId: String, completion: @escaping ([Post]?, Error?) -> Void) {
        let ref = databaseRef.child("posts")
        
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
