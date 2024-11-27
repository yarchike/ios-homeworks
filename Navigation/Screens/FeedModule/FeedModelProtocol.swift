//
//  FeedModelProtocol.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 30.10.2024.
//

import Foundation


protocol FeedModelProtocol {
    func check(input: String, completion:@escaping  (Result<Bool, Error>) -> Void)
}
