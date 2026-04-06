import Foundation

public enum BogramSettings {
    private static let keepDeletedMessagesKey = "bogram.keepDeletedMessages"
    
    public static var keepDeletedMessages: Bool {
        get {
            return UserDefaults.standard.bool(forKey: keepDeletedMessagesKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: keepDeletedMessagesKey)
        }
    }
}
