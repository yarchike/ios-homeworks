//
//  LikeCoordinator.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 03.06.2024.
//

import Foundation
import UIKit


class LikeCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private var navigationController : UINavigationController
    
    
    func getNavigationController() -> UINavigationController{
        return self.navigationController
    }
    
    init() {
        navigationController = UINavigationController()
        let likeViewController = LikeTableViewController()

        likeViewController.tabBarItem = UITabBarItem(title: "Лайк", image: UIImage(systemName: "heart.fill"), tag: 2)
        self.navigationController = UINavigationController(rootViewController: likeViewController)
        
    }
    

}
