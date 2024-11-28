//
//  FeedModel.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 08.04.2024.
//
import Foundation

class FeedModel: FeedModelProtocol {
    
    private let secretWord = "secret"
    
    func check(input: String, completion: @escaping (Result<Bool, Error>) -> Void){
        DispatchQueue.global().asyncAfter(deadline: .now() + 3, execute: { [weak self] in
            guard let self else { return }
            completion(.success(input == secretWord))
        })
       
    }

    
    
}
