import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
    
    private func configure() {
        let mapViewController = MapViewController()
        mapViewController.tabBarItem.title = "Карта"
        
        viewControllers = [SwipeNavigationController(rootViewController: mapViewController)]
        
        tabBar.backgroundColor = .white
        tabBar.isTranslucent = false
    }
    
}
