//
//  FeedCoordinator.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 12.04.2024.
//

import UIKit
import StorageService

class FeedCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private var navigationController : UINavigationController
    
    func getNavigationController() -> UINavigationController{
        return self.navigationController
    }
    
    init() {
        navigationController = UINavigationController()
        let feedModel = FeedModel()
        let postService = PostService()
        let feedViewModel = FeedVM(feedModel: feedModel, postService: postService)
        let feedViewController = FeedViewController(viewModel: feedViewModel)
        feedViewController.routeToPost = routeToPostViewController
        feedViewController.tabBarItem = UITabBarItem(title: "Лента", image: UIImage(systemName: "doc.richtext"), tag: 0)
        self.navigationController = UINavigationController(rootViewController: feedViewController)
        
    }
    
    func routeToPostViewController(post: Post) {
        let postViewController = PostViewController()
        postViewController.postTitle = post.author
        postViewController.routeToInfo = routeToInfoViewController
        navigationController.pushViewController(postViewController, animated: true)
    }
    
    func routeToInfoViewController(){
        let infoViewController = InfoViewController()
        navigationController.pushViewController(infoViewController, animated: true)
    }
    
}
