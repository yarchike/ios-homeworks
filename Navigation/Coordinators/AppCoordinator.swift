//
//  AppCoordinator.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 12.04.2024.
//

import UIKit

class AppCoordinator: Coordinator{
    
    var childCoordinators: [Coordinator] = []
    let tabBarController:UITabBarController;
    
    init() {
        self.tabBarController =  UITabBarController()

        let feedCoordinator = FeedCoordinator()
        let profileCoordinator = ProfileCoordinator()
        let likeCoordinator = LikeCoordinator()
        self.add(coordinator: feedCoordinator)
        self.add(coordinator: profileCoordinator)
        self.add(coordinator: likeCoordinator)
        
        let controllers = [feedCoordinator.getNavigationController(), profileCoordinator.getNavigationController(), likeCoordinator.getNavigationController()]
        tabBarController.viewControllers = controllers
        tabBarController.selectedIndex = 0
        //tabBarController.selectedIndex = 1
        UITabBar.appearance().backgroundColor = .customBackgroundColor
    }
    
}
