import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.overrideUserInterfaceStyle = .light
        window?.makeKeyAndVisible()
        
        let authService = AuthService()
        ServiceLocator.shared.add(service: authService)
        
        let loggerService = LoggerService()
        LoggerService.setup()
        ServiceLocator.shared.add(service: loggerService)
                
        let uiService = UIService()
        uiService.openModule()
        ServiceLocator.shared.add(service: uiService)
        
        setupKeyboardManager()
        
        return true
    }
    
    private func setupKeyboardManager() {
        let manager = IQKeyboardManager.shared
        manager.enable = true
        manager.toolbarTintColor = .black
        manager.toolbarDoneBarButtonItemText = "Скрыть"
        manager.placeholderColor = .black
        manager.toolbarBarTintColor = R.color.backgoundContrast()
    }
        
}
