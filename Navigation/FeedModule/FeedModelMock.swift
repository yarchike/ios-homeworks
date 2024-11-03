//
//  FeedModelMock.swift
//  NavigationTests
//
//  Created by Ярослав  Мартынов on 30.10.2024.
//

import Foundation

class FeedModelMock: FeedModelProtocol {
    var fakeResult: Result<Bool, Error>!
    func check(input: String, completion: @escaping(Result<Bool, Error>) -> Void) {
        completion(fakeResult)
    }
}
