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
    
        feedViewController.tabBarItem = UITabBarItem(title: "Лента", image: UIImage(systemName: "doc.richtext"), tag: 0)
        self.navigationController = UINavigationController(rootViewController: feedViewController)
        
    }
    
    func routeToPostViewController(post: Post) {
        let postViewController = PostViewController()
        postViewController.postTitle = post.author.name
        postViewController.routeToInfo = routeToInfoViewController
        navigationController.pushViewController(postViewController, animated: true)
    }
    
    func routeToInfoViewController(){
        let infoViewController = InfoViewController()
        navigationController.pushViewController(infoViewController, animated: true)
    }
    
    func routeToAudioViewController(){
        let audioViewController = AudioViewController()
        navigationController.pushViewController(audioViewController, animated: true)
    }
    func routeToVideoViewController(){
        let videoViewController = VideoViewController()
        navigationController.pushViewController(videoViewController, animated: true)
    }
    func routeToRecordViewController(){
        let recordViewController = RecordViewController()
        navigationController.pushViewController(recordViewController, animated: true)
    }
    func routeToMapiewController(){
        let mapViewController = MapViewController()
        navigationController.pushViewController(mapViewController, animated: true)
    }
}
