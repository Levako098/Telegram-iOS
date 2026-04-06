import Foundation

public enum BogramSettings {
    private static let keepDeletedMessagesKey = "bogram.keepDeletedMessages"
    private static let localPremiumKey = "bogram.localPremium"
    
    public static var keepDeletedMessages: Bool {
        get {
            return UserDefaults.standard.bool(forKey: keepDeletedMessagesKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: keepDeletedMessagesKey)
        }
    }
    
    public static var localPremium: Bool {
        get {
            return UserDefaults.standard.bool(forKey: localPremiumKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: localPremiumKey)
        }
    }
    
    public static func hasPremium(_ serverPremium: Bool) -> Bool {
        return serverPremium || localPremium
    }
}
