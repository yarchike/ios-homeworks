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

enum State {
    case initial
    case loading
    case loadedCheck(Bool)
    case loadedPost(Post)
    case error
}

