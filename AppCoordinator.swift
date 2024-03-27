import UIKit

// MARK - Coordinator
protocol Coordinator {
    var childCoordinators: [Coordinator] { get }
    var navigationController: UINavigationController { get }
    func start()
}

class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
         
    func start() {
        let initialViewController = DependencyProvider.converterViewController
        navigationController.pushViewController(initialViewController, animated: false)
    }
}

