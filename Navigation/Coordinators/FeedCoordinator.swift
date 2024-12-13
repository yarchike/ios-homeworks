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
    var switchToLoginInterface: (() -> ()) = {}
    
    func getNavigationController() -> UINavigationController{
        return self.navigationController
    }

    
    init(switchToLoginInterface: @escaping () -> ()) {
        navigationController = UINavigationController()
        let feedViewModel = FeedViewModel()
        let feedViewController = FeedViewController(viewModel: feedViewModel)
    
        feedViewController.tabBarItem = UITabBarItem(title: "Feed".localized, image: UIImage(systemName: "doc.richtext"), tag: 0)
        self.navigationController = UINavigationController(rootViewController: feedViewController)
        
    }
    
}
