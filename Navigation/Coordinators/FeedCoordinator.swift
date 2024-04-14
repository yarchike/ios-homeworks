//
//  FeedCoordinator.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 12.04.2024.
//

import UIKit

class FeedCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let navigatorController : UINavigationController
    
    init() {
        let feedModel = FeedModel()
        let postService = PostService()
        let feedViewModel = FeedVM(feedModel: feedModel, postService: postService)
        let feedViewController = FeedViewController(viewModel: feedViewModel)
        feedViewController.tabBarItem = UITabBarItem(title: "Лента", image: UIImage(systemName: "doc.richtext"), tag: 0)
        self.navigatorController = UINavigationController(rootViewController: feedViewController)
    }
    
}
