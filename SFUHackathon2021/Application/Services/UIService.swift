import UIKit

class UIService {
    
    private var notificationTokens: [Any] = []
    
    init() {
        addObservers()
    }

    deinit {
        notificationTokens.forEach {
            NotificationCenter.default.removeObserver($0)
        }
    }
    
    func openModule() {
        let authService: AuthService? = ServiceLocator.getService()
        
        if authService?.authStatus == .unauthorized {
            openAuth()
        } else {
            openMain()
        }
    }
    
    private func setWindowRoot(viewController: UIViewController) {
        let root = navController(viewController)
        
        UIApplication.shared.delegate?.window??.rootViewController = root
    }
    
    private func navController(_ root: UIViewController) -> UINavigationController {
        let navigationController = SwipeNavigationController(rootViewController: root)
        navigationController.isNavigationBarHidden = true
        
        return navigationController
    }
    
    private func openAuth() {
        setWindowRoot(viewController: SignInViewController())
    }
        
    private func openMain() {
        setWindowRoot(viewController: TabBarController())
    }
    
    private func addObservers() {
        let notificationNames: [Foundation.Notification.Name] = [
            AuthService.statusChangedNotifiaction
        ]

        for name in notificationNames {
            notificationTokens.append(NotificationCenter.default.addObserver(
                                        forName: name,
                                        object: nil,
                                        queue: .main,
                                        using: { [weak self] in self?.handleNotification($0) }
            ))
        }
    }
    
    private func handleNotification(_ notification: Foundation.Notification) {
        switch notification.name {
        case AuthService.statusChangedNotifiaction:
            openModule()
        default:
            break
        }
    }
    
}
