//
//  FirebaseAutch.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 28.11.2024.
//

import Foundation


import Foundation
import FirebaseAuth


class FirebaseAutch: CheckerServiceProtocol{
    
    static let shared = FirebaseAutch()
    
    func singIn(withEmail: String, password: String, completion: @escaping (Result<String, ApiError>) -> Void) {
        Auth.auth().signIn(withEmail:withEmail, password:password){ authResult, error in
            
            if let error {
                let err = error as NSError
                completion(.failure(ApiError.authError(message: err.userInfo["NSLocalizedDescription"] as? String ?? "Ошибка авторизации")))
            }
            if let authResult{
                print(authResult.user.uid)
                completion(.success(authResult.user.displayName ?? ""))
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
                completion(.success(authResult.user.displayName ?? ""))
            }
        }
    }
    
    func signOut(){
        do {
            try Auth.auth().signOut()
            print("Выход выполнен успешно")
            // Здесь вы можете перенаправить пользователя, например, на экран входа
        } catch let signOutError as NSError {
            print("Ошибка выхода: %@", signOutError)
            // Обработайте ошибку, если необходимо
        }
    }
    
}
