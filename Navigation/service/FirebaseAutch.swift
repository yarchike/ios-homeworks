//
//  FirebaseAutch.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 28.11.2024.
//

import Foundation


import Foundation
import FirebaseAuth


class FirebaseAutch {
    
    static let shared = FirebaseAutch()
    
    func singIn(withEmail: String, password: String, completion: @escaping (Result<String, ApiError>) -> Void) {
        Auth.auth().signIn(withEmail:withEmail, password:password){ authResult, error in
            
            if let error {
                let err = error as NSError
                completion(.failure(ApiError.authError(message: err.userInfo["NSLocalizedDescription"] as? String ?? "Ошибка авторизации")))
            }
            if let authResult{
                completion(.success(authResult.user.uid))
            }
            
        }
    }
    
    func signUp(withEmail: String, password: String, completion: @escaping (Result<String, ApiError>) -> Void) {
        
        FirebaseAuth.Auth.auth().createUser(withEmail: withEmail, password: password){ authResult, error  in
            if let error {
                let err = error as NSError
                completion(.failure(ApiError.authError(message: err.userInfo["NSLocalizedDescription"] as? String ?? "Ошибка авторизации")))
            }
            if let authResult{
                completion(.success(authResult.user.uid))
            }
        }
    }
    
    func signOut(){
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Ошибка выхода: %@", signOutError)
        }
    }
    
    func updatePassword(newPassword: String, completion: @escaping (Error?) -> Void) {
  

        guard let user = Auth.auth().currentUser else {
            completion(NSError(domain: "com.example", code: 401, userInfo: [NSLocalizedDescriptionKey: "Пользователь не найден"]))
            return
        }

        user.updatePassword(to: newPassword) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)  // Успешное обновление пароля
            }
        }
    }
    
}
