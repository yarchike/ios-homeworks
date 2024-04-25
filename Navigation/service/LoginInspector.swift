//
//  LoginInspector.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 25.03.2024.
//

import Foundation

let errorServer = false

struct LoginInspector :LoginViewControllerDelegate {
    func check(login: String, password: String, completion: @escaping (Result<Bool, ApiError>) -> Void) throws{
        if(errorServer){
            throw ApiError.badRequest
        }else{
            if(Checker.shared.check(login: login, password: password)){
                completion(.success(true))
            }else{
                completion(.failure(ApiError.unAuth))
            }
         
        }
    }
}

