import Foundation

final class AuthService: NSObject {
    static let statusChangedNotifiaction = Foundation.Notification.Name("AuthService.statusChanged")
    
    enum Status {
        case unauthorized, authorized
    }
    
    var authStatus: AuthService.Status {
        guard UserSettings.specific != 0 else { return .unauthorized }
        
        return .authorized
    }

    func authorize(with specific: Int) {
        UserSettings.specific = specific
        
        NotificationCenter.default.post(name: AuthService.statusChangedNotifiaction, object: self)
    }

    func deauthorize() {
        if UserSettings.specific != nil {
            UserSettings.clear()
        }
        
        NotificationCenter.default.post(name: AuthService.statusChangedNotifiaction, object: self)
    }
    
}
