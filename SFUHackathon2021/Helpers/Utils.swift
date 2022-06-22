import UIKit

enum Utils {
    
    static var isDebug: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }

    static var isRelease: Bool {
        #if RELEASE
            return true
        #else
            return false
        #endif
    }

    static var isAppStore: Bool {
        #if APPSTORE
            return true
        #else
            return false
        #endif
    }
    
    static let isProduction: Bool = Utils.isAppStore || !Utils.isDebug
    
    static func appDelegate() -> UIApplicationDelegate? {
        return UIApplication.shared.delegate
    }
    
    static func safeArea() -> UIEdgeInsets {
        if let safeArea = appDelegate()?.window??.safeAreaInsets {
            return safeArea
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    static func impactFeedback() {
        UIImpactFeedbackGenerator().impactOccurred(intensity: 0.7)
    }
    
    static func impactErrorFeedback() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
    
}
