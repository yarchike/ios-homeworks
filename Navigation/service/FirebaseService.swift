import FirebaseDatabase

class FirebaseService {
    
    static let shared = FirebaseService()
    
    private let databaseRef: DatabaseReference

    init() {
        // Инициализируем ссылку на корень базы данных Firebase
        self.databaseRef = Database.database().reference()
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
}
