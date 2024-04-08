//
//  FeedModel.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 08.04.2024.
//

class FeedModel {
    private let secretWord = "secret"
    
    func check(input: String) -> Bool{
       return input == secretWord
    }
}
