import UIKit
import FirebaseAuth
class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    lazy var rootControiller: UIViewController = {
            return self.getLoginViewController()
        }()
    
    init() {
        if Auth.auth().currentUser != nil {
            self.rootControiller = getLoginViewController()
        }else{
            self.rootControiller = getTabBarController()
        }
    }
    
    func getLoginViewController() -> LogInViewController {
        let userService: UserService = CurrentUserService()
        let loginViewController = LogInViewController(userService: userService, delegate: MyLoginFactory.makeLoginInspector())
        return loginViewController
    }
    
    func getTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        // Инициализация коордиаторов
        let feedCoordinator = FeedCoordinator()
        let profileCoordinator = ProfileCoordinator()
        let likeCoordinator = LikeCoordinator()
        
        // Добавление коордиаторов
        self.add(coordinator: feedCoordinator)
        self.add(coordinator: profileCoordinator)
        self.add(coordinator: likeCoordinator)
        
        // Настройка контроллеров для вкладок
        let controllers = [
            feedCoordinator.getNavigationController(),
            profileCoordinator.getNavigationController(),
            likeCoordinator.getNavigationController()
        ]
        
        // Присваиваем контроллеры вкладок
        tabBarController.viewControllers = controllers
        tabBarController.selectedIndex = 0
        
        // Настройка внешнего вида таб-бара
        UITabBar.appearance().backgroundColor = .customBackgroundColor
        
        return tabBarController
    }
}
