import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        configure()
    }
    
    private func configure() {
        let mapViewController = MapViewController()
        mapViewController.tabBarItem.image = R.image.tabBarMap()
        
        viewControllers = [SwipeNavigationController(rootViewController: mapViewController)]
        
        viewControllers?.compactMap({ $0 as? UINavigationController }).compactMap({ $0.viewControllers.first }).forEach({
            let inset: CGFloat = Utils.safeArea().bottom == 0 ? 4.0 : 10.0
            $0.tabBarItem.imageInsets = UIEdgeInsets(top: inset, left: 0.0, bottom: -inset, right: 0.0)
            $0.loadViewIfNeeded()
        })
        
        tabBar.backgroundColor = .white
        tabBar.tintColor = R.color.blue()
        tabBar.unselectedItemTintColor = R.color.lightBlue()
    }
    
}

// MARK: - UITabBarControllerDelegate
extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if tabBarController.selectedViewController === viewController {
            viewController.contentScrollView?.scrollToTopIfPossible(animated: true)
        }
        
        return true
    }
    
}
