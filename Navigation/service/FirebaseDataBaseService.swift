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
        let databaseRef = Database.database(url: databaseURL).reference()
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
        let databaseRef = Database.database(url:databaseURL).reference()
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
        let databaseRef = Database.database(url:databaseURL).reference()
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
            print("s-----------------")
            print(photos)
            print("-----------------")
            completion(photos)
        }
    }

    
    
    
    
    
}
