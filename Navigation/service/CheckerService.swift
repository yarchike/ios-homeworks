//
//  CheckerService.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 21.05.2024.
//

import Foundation
import FirebaseAuth


class CheckerService: CheckerServiceProtocol{
    func checkCredentials(withEmail: String, password: String, completion: @escaping (Result<String, ApiError>) -> Void) {
        Auth.auth().signIn(withEmail:withEmail, password:password){ authResult, error in
            
            if let error {
                let err = error as NSError
                if err.code == AuthErrorCode.invalidCredential.rawValue{
                    self.signUp(withEmail:withEmail, password:password){ result in
                        completion(result)
                    }
                }else{
                    completion(.failure(ApiError.authError(message: err.userInfo["NSLocalizedDescription"] as? String ?? "Ошибка авторизации")))
                }
            }
            if let authResult{
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
    
    
}
