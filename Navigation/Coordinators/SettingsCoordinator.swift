//
//  LikeCoordinator.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 03.06.2024.
//

import Foundation
import UIKit


class SettingsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private var navigationController : UINavigationController
    
    
    func getNavigationController() -> UINavigationController{
        return self.navigationController
    }
    
    init() {
        navigationController = UINavigationController()
        let settingsViewModel = SettingsViewModel()
        let settingViewController = SettingsViewController(viewModel: settingsViewModel)

        settingViewController.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(systemName: "gearshape"), tag: 2)
        self.navigationController = UINavigationController(rootViewController: settingViewController)
        
    }
    

}
