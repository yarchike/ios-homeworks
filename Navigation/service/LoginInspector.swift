//
//  LoginInspector.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 25.03.2024.
//

import Foundation

let errorServer = false

struct LoginInspector :LoginViewControllerDelegate {
    
    let checkerService : CheckerServiceProtocol
    
    init(checkerService: CheckerServiceProtocol){
        self.checkerService = checkerService
    }
    
    func check(login: String, password: String, completion: @escaping (Result<String, ApiError>) -> Void) throws{
        checkerService.singIn(withEmail: login, password: password, completion: completion)
    }
}

