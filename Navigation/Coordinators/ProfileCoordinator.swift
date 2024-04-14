//
//  ProfileCoordinator.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 12.04.2024.
//

import UIKit

class ProfileCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let navigatorController : UINavigationController
    
    init() {
        var userService: UserService = CurrentUserService()

        #if DEBUG
        userService = TestUserService()
        #endif
        
        
        let profileController = ProfileViewController()
        //let profileController = LogInViewController(userService: userService, delegate: MyLoginFactory.makeLoginInspector())
        
        profileController.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person.circle"), tag: 1)
    
        self.navigatorController = UINavigationController(rootViewController: profileController)
    }
    
}
