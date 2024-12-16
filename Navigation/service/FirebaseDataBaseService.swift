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
    
    func getAllUsers(completion: @escaping ([User]?, Error?) -> Void) {
        let usersRef = databaseRef.child("users")
        usersRef.observeSingleEvent(of: .value) { snapshot in
            var users: [User] = []
            
            if let usersDict = snapshot.value as? [String: [String: Any]] {
                for (_, userDict) in usersDict {
                    if let user = User(dictionary: userDict) {
                        users.append(user)
                    }
                }
                completion(users, nil)
            } else {
                completion(nil, NSError(domain: "FirebaseService", code: 404, userInfo: [NSLocalizedDescriptionKey: "No users found"]))
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
    func savePostToDatabase(post: Post, completion: @escaping (Error?) -> Void) {
        let ref = databaseRef.child("posts").child(post.id)
        ref.setValue(post.toDictionary()) { error, _ in
            completion(error)
        }
    }

    func fetchAllPosts(completion: @escaping ([Post]?, Error?) -> Void) {
        getAllUsers{users ,error in
            if error != nil{
                completion(nil, error)
                return
            }
            
            let ref = self.databaseRef.child("posts")

            ref.observeSingleEvent(of: .value) { snapshot in
                var posts: [Post] = []

                for child in snapshot.children {
                    if let childSnapshot = child as? DataSnapshot,
                       let postDict = childSnapshot.value as? [String: Any],
                       let post = Post(dictionary: postDict) {
                        posts.append(post)
                    }
                }
                var postsUpdateAuthor:[Post] = []
                posts.forEach{post in
                    var updateUset = users?.first{$0.id == post.author.id}
                    let updateAutchor = if let updateUset = updateUset {
                        Author(id: updateUset.id, name: updateUset.fullname, urlImage: updateUset.avatarURL)
                    }else{
                        post.author
                    }
                    let postUpdate = Post(id: post.id, author: updateAutchor, postDescription: post.postDescription, urlImage: post.urlImage, likes: post.likes, createdAt: post.createdAt)
                    postsUpdateAuthor.append(postUpdate)
                }
                completion(postsUpdateAuthor, nil)
            } withCancel: { error in
                completion(nil, error)
            }
        }

    }



    func fetchPostsByAuthorId(authorId: String, completion: @escaping ([Post]?, Error?) -> Void) {
        let ref = databaseRef.child("posts")
        let query = ref.queryOrdered(byChild: "author/id").queryEqual(toValue: authorId)

        query.observeSingleEvent(of: .value) { snapshot in
            var posts: [Post] = []

            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let postDict = childSnapshot.value as? [String: Any],
                   let post = Post(dictionary: postDict) {
                    posts.append(post)
                }
            }
            var postsUpdateAuthor:[Post] = []
            posts.forEach{post in
                let updateUset = CurrentUser.shared.user
                let updateAutchor = if let updateUset = updateUset {
                    Author(id: updateUset.id, name: updateUset.fullname, urlImage: updateUset.avatarURL)
                }else{
                    post.author
                }
                let postUpdate = Post(id: post.id, author: updateAutchor, postDescription: post.postDescription, urlImage: post.urlImage, likes: post.likes, createdAt: post.createdAt)
                postsUpdateAuthor.append(postUpdate)
            }
            completion(postsUpdateAuthor, nil)
        } withCancel: { error in
            completion(nil, error)
        }
    }
    
    func updatePost(post: Post, completion: @escaping (Error?) -> Void) {
         let ref = databaseRef.child("posts").child(post.id)
         ref.updateChildValues(post.toDictionary()) { error, _ in
             completion(error)
         }
     }

    
    
    
    
    
}
