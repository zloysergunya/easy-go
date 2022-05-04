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
    
    static func impactFeedback() {
        UIImpactFeedbackGenerator().impactOccurred(intensity: 0.7)
    }
    
    static func impactErrorFeedback() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
    
}
