import Foundation
import Postbox

public enum BogramSettings {
    public struct DeletedMessageLogEntry: Codable, Equatable {
        public let id: String
        public let peerTitle: String
        public let authorTitle: String
        public let text: String
        public let timestamp: Int32
    }

    private static let keepDeletedMessagesKey = "bogram.keepDeletedMessages"
    private static let localPremiumKey = "bogram.localPremium"
    private static let hidePhoneNumbersKey = "bogram.hidePhoneNumbers"
    private static let ghostModeKey = "bogram.ghostMode"
    private static let privacyModeKey = "bogram.privacyMode"
    private static let hideStoriesKey = "bogram.hideStories"
    private static let removeAdsKey = "bogram.removeAds"
    private static let cleanTelegramKey = "bogram.cleanTelegram"
    private static let deletedMessageIdsKey = "bogram.deletedMessageIds"
    private static let deletedMessagesJournalKey = "bogram.deletedMessagesJournal"

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
            return UserDefaults.standard.bool(forKey: hidePhoneNumbersKey) || privacyMode
        }
        set {
            UserDefaults.standard.set(newValue, forKey: hidePhoneNumbersKey)
        }
    }

    public static var ghostMode: Bool {
        get {
            return UserDefaults.standard.bool(forKey: ghostModeKey) || privacyMode
        }
        set {
            UserDefaults.standard.set(newValue, forKey: ghostModeKey)
        }
    }

    public static var privacyMode: Bool {
        get {
            return UserDefaults.standard.bool(forKey: privacyModeKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: privacyModeKey)
        }
    }

    public static var hideStories: Bool {
        get {
            return UserDefaults.standard.bool(forKey: hideStoriesKey) || cleanTelegram
        }
        set {
            UserDefaults.standard.set(newValue, forKey: hideStoriesKey)
        }
    }

    public static var removeAds: Bool {
        get {
            return UserDefaults.standard.bool(forKey: removeAdsKey) || cleanTelegram
        }
        set {
            UserDefaults.standard.set(newValue, forKey: removeAdsKey)
        }
    }

    public static var cleanTelegram: Bool {
        get {
            if UserDefaults.standard.object(forKey: cleanTelegramKey) == nil {
                return true
            }
            return UserDefaults.standard.bool(forKey: cleanTelegramKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: cleanTelegramKey)
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

    public static func deletedMessagesJournal() -> [DeletedMessageLogEntry] {
        guard let data = UserDefaults.standard.data(forKey: deletedMessagesJournalKey),
              let entries = try? JSONDecoder().decode([DeletedMessageLogEntry].self, from: data) else {
            return []
        }
        return entries
    }

    public static func clearDeletedMessagesJournal() {
        UserDefaults.standard.removeObject(forKey: deletedMessagesJournalKey)
    }

    public static func logDeletedMessages(transaction: Transaction, ids: [MessageId]) {
        guard !ids.isEmpty else {
            return
        }
        var entries = deletedMessagesJournal()
        let now = Int32(Date().timeIntervalSince1970)
        for id in ids {
            guard let message = transaction.getMessage(id) else {
                continue
            }
            let entry = DeletedMessageLogEntry(
                id: messageKey(id),
                peerTitle: peerTitle(transaction.getPeer(id.peerId)),
                authorTitle: peerTitle(message.author),
                text: previewText(for: message),
                timestamp: now
            )
            entries.removeAll(where: { $0.id == entry.id })
            entries.insert(entry, at: 0)
        }
        if entries.count > 250 {
            entries = Array(entries.prefix(250))
        }
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: deletedMessagesJournalKey)
        }
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

    private static func peerTitle(_ peer: Peer?) -> String {
        guard let peer else {
            return "Unknown Chat"
        }
        if let user = peer as? TelegramUser {
            let fullName = [user.firstName ?? "", user.lastName ?? ""].filter { !$0.isEmpty }.joined(separator: " ")
            if !fullName.isEmpty {
                return fullName
            }
            if let username = user.addressName, !username.isEmpty {
                return "@\(username)"
            }
            return "User \(user.id.toInt64())"
        }
        if let group = peer as? TelegramGroup {
            return group.title
        }
        if let channel = peer as? TelegramChannel {
            return channel.title
        }
        return "Chat \(peer.id.toInt64())"
    }

    private static func previewText(for message: Message) -> String {
        let trimmedText = message.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedText.isEmpty {
            return trimmedText
        }
        if !message.media.isEmpty {
            return "[Media]"
        }
        return "[Empty message]"
    }
}
