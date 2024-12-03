//
//  ProfileCoordinator.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 12.04.2024.
//

import UIKit
import FirebaseAuth

class ProfileCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private var navigationController : UINavigationController
    
    func getNavigationController() -> UINavigationController{
        return self.navigationController
    }
    
    
    init(){
        self.navigationController = UINavigationController()
        var viewController: UIViewController?
        viewController = getProfileViewController()
        viewController?.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person.circle"), tag: 1)
        self.navigationController = UINavigationController(rootViewController: viewController!)
    }
    
    
    func routeToProfile(user: User){
        let profileViewController = getProfileViewController()
        profileViewController.user = user
        navigationController.pushViewController(profileViewController, animated: true)
    }
    
    
    func routeToPhoto(){
        let photosViewController = PhotosViewController()
        self.navigationController.pushViewController(photosViewController, animated: true)
        
    }
    
    
    func getProfileViewController() -> ProfileViewController{
        let profileVM = ProfileViewModel()
        let profileViewController = ProfileViewController(viewModel: profileVM)
        profileViewController.routeToPhoto = routeToPhoto
        profileViewController.routeToCreatePost = routToCreatePost
        return profileViewController
    }
    func routToCreatePost(){
        let createPostViewModel = CreatePostViewModel()
        let createPostVC = CreatePostViewController(viewModel: createPostViewModel)
        
        let navigationController = UINavigationController(rootViewController: createPostVC)
        navigationController.modalPresentationStyle = .automatic
        self.navigationController.present(navigationController, animated: true)
    }
    
    
}
