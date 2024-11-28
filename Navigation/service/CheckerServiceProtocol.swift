//
//  CheckerServiceProtocol.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 21.05.2024.
//

import Foundation

protocol CheckerServiceProtocol{
    
    func singIn(withEmail: String, password: String ,completion: @escaping (Result<String, ApiError>) -> Void)
    
    func signUp(withEmail: String, password: String ,completion: @escaping (Result<String, ApiError>) -> Void)
    
    func signOut()
}
