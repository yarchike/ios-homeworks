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
        self.add(coordinator: feedCoordinator)
        self.add(coordinator: profileCoordinator)
        
        let controllers = [feedCoordinator.navigatorController, profileCoordinator.navigatorController]
        tabBarController.viewControllers = controllers
        tabBarController.selectedIndex = 0
        //tabBarController.selectedIndex = 1
        UITabBar.appearance().backgroundColor = .white
    }
    
    
    
}
