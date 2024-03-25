//
//  Checker.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 25.03.2024.
//

import Foundation

class Checker  {
    
    private let login = "user"
    private let password = "123456"
    
    static let shared: Checker = {
        let instance = Checker()
        return instance
    }()
    private init() {}
    
    func check(login: String, password: String)-> Bool{
        if(login == self.login && password == self.password){
            return true
        }
        return false
    }
}

extension Checker: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}



