//
//  FeedVM.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 10.04.2024.
//

final class FeedVM: FeedVMProtocol {
    
  
    private let feedModel: FeedModel
    
    private let postService: PostService
    
    var state: State = .initial {
        didSet {
            print(state)
            currentState?(state)
        }
    }
    
    init(feedModel: FeedModel, postService: PostService) {
        self.feedModel = feedModel
        self.postService = postService
    }
    
    var currentState: ((State) -> Void)?
    
    func fetchPost() {
        state = .loading
        postService.fetchPost { [weak self] result in
            guard let self else { return }
            switch result {
                case .success(let post):
                    state = .loadedPost(post)
                case .failure(_):
                    state = .error
            }
        }
    }
    
    func check(input: String) {
            state = .loading
            feedModel.check(input: input) { [weak self] result in
                guard let self else { return }
                switch result {
                    case .success(let isSuccess):
                        state = .loadedCheck(isSuccess)
                    case .failure(_):
                        state = .error
                }
            }
    }
    
    
    
}
