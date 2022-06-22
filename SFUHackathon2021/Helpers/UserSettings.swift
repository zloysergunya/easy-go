import Foundation

@objc class UserSettings: NSObject {

    static let defaults = UserDefaults.standard

    fileprivate enum Keys: String {
        case specific
        case restrictionName
    }
    
    static var specific: Int? {
        get {
            return defaults.integer(forKey: Keys.specific.rawValue)
        }
        set {
            defaults.set(newValue, forKey: Keys.specific.rawValue)
        }
    }
    
    static var restrictionName: String? {
        get {
            return defaults.string(forKey: Keys.restrictionName.rawValue)
        }
        set {
            defaults.set(newValue, forKey: Keys.restrictionName.rawValue)
        }
    }
    
    static var undesirablePoints: [Feature] {
        get {
            if let undesirablePoints = try? defaults.get(objectType: [Feature].self, forKey: #function) {
                return undesirablePoints
            }
            
            return []
        }
        set {
            try? defaults.set(object: newValue, forKey: #function)
        }
    }

    @objc static func clear() {
        let domain = Bundle.main.bundleIdentifier!
        defaults.removePersistentDomain(forName: domain)
        defaults.synchronize()
    }
        
}
