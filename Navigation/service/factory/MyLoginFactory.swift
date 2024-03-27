//
//  MyLoginFactory.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 25.03.2024.
//

import Foundation

struct MyLoginFactory: LoginFactory{
    static func makeLoginInspector() -> LoginInspector {
        return LoginInspector()
    }
    
    
}
