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
    var switchToLoginInterface: (() -> ()) = {}
    
    
    func getNavigationController() -> UINavigationController{
        return self.navigationController
    }
    
    init(switchToLoginInterface: @escaping () -> ()) {
        navigationController = UINavigationController()
        let settingsViewModel = SettingsViewModel()
        settingsViewModel.switchToLoginInterface = switchToLoginInterface
        let settingViewController = SettingsViewController(viewModel: settingsViewModel)

        settingViewController.tabBarItem = UITabBarItem(title: "Settings".localized, image: UIImage(systemName: "gearshape"), tag: 2)
        self.navigationController = UINavigationController(rootViewController: settingViewController)
        
    }
    

}
