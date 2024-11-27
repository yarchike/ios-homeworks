//
//  FeedVMProtocol.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 10.04.2024.
//

import StorageService


protocol FeedVMProtocol {
    var state: State { get set }
    var currentState: ((State) -> Void)? { get set }
    func check(input: String)
    func fetchPost()
}

enum State:Equatable {
    static func == (lhs: State, rhs: State) -> Bool {
        switch (lhs, rhs) {
               case (.initial, .initial),
                    (.loading, .loading),
                    (.error, .error):
                   return true
               case let (.loadedCheck(lhsResult), .loadedCheck(rhsResult)):
                   return lhsResult == rhsResult
               case let (.loadedPost(lhsPost), .loadedPost(rhsPost)):
                   return lhsPost == rhsPost
               default:
                   return false
               }
    }
    
    case initial
    case loading
    case loadedCheck(Bool)
    case loadedPost(Post)
    case error
 
}

