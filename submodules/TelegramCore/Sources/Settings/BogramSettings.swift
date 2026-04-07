import Foundation
import Postbox

public enum BogramSettings {
    private static let keepDeletedMessagesKey = "bogram.keepDeletedMessages"
    private static let localPremiumKey = "bogram.localPremium"
    private static let hidePhoneNumbersKey = "bogram.hidePhoneNumbers"
    private static let ghostModeKey = "bogram.ghostMode"
    private static let deletedMessageIdsKey = "bogram.deletedMessageIds"

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

    public static var hidePhoneNumbers: Bool {
        get {
            return UserDefaults.standard.bool(forKey: hidePhoneNumbersKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: hidePhoneNumbersKey)
        }
    }

    public static var ghostMode: Bool {
        get {
            return UserDefaults.standard.bool(forKey: ghostModeKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: ghostModeKey)
        }
    }

    private static func deletedMessageKeys() -> Set<String> {
        return Set(UserDefaults.standard.stringArray(forKey: deletedMessageIdsKey) ?? [])
    }

    private static func setDeletedMessageKeys(_ keys: Set<String>) {
        UserDefaults.standard.set(Array(keys), forKey: deletedMessageIdsKey)
    }

    private static func messageKey(_ id: MessageId) -> String {
        return "\(id.peerId.toInt64()):\(id.namespace):\(id.id)"
    }

    public static func markDeletedMessageIds(_ ids: [MessageId]) {
        guard !ids.isEmpty else {
            return
        }
        var keys = deletedMessageKeys()
        for id in ids {
            keys.insert(messageKey(id))
        }
        setDeletedMessageKeys(keys)
    }

    public static func isDeletedMessageId(_ id: MessageId) -> Bool {
        return deletedMessageKeys().contains(messageKey(id))
    }

    public static func developerPeerId() -> PeerId {
        return PeerId(namespace: Namespaces.Peer.CloudUser, id: PeerId.Id._internalFromInt64Value(7703200770))
    }

    public static func shouldShowDeveloperBadge(for peer: Peer?) -> Bool {
        guard let user = peer as? TelegramUser else {
            return false
        }
        if user.id == developerPeerId() {
            return true
        }
        if user.addressName == "kaliceo" {
            return true
        }
        return user.usernames.contains(where: { $0.isActive && $0.username == "ruvex" })
    }
}
