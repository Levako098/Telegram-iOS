import Foundation
import Display
import SwiftSignalKit
import TelegramCore
import TelegramPresentationData
import ItemListUI
import PresentationDataUtils
import AccountContext

private final class BogramSettingsControllerArguments {
    let toggleKeepDeletedMessages: (Bool) -> Void
    let toggleLocalPremium: (Bool) -> Void
    let togglePrivacyMode: (Bool) -> Void
    let toggleHidePhoneNumbers: (Bool) -> Void
    let toggleGhostMode: (Bool) -> Void
    let toggleCleanTelegram: (Bool) -> Void
    let toggleHideStories: (Bool) -> Void
    let toggleRemoveAds: (Bool) -> Void
    let openDeletedJournal: () -> Void
    
    init(
        toggleKeepDeletedMessages: @escaping (Bool) -> Void,
        toggleLocalPremium: @escaping (Bool) -> Void,
        togglePrivacyMode: @escaping (Bool) -> Void,
        toggleHidePhoneNumbers: @escaping (Bool) -> Void,
        toggleGhostMode: @escaping (Bool) -> Void,
        toggleCleanTelegram: @escaping (Bool) -> Void,
        toggleHideStories: @escaping (Bool) -> Void,
        toggleRemoveAds: @escaping (Bool) -> Void,
        openDeletedJournal: @escaping () -> Void
    ) {
        self.toggleKeepDeletedMessages = toggleKeepDeletedMessages
        self.toggleLocalPremium = toggleLocalPremium
        self.togglePrivacyMode = togglePrivacyMode
        self.toggleHidePhoneNumbers = toggleHidePhoneNumbers
        self.toggleGhostMode = toggleGhostMode
        self.toggleCleanTelegram = toggleCleanTelegram
        self.toggleHideStories = toggleHideStories
        self.toggleRemoveAds = toggleRemoveAds
        self.openDeletedJournal = openDeletedJournal
    }
}

private enum BogramSettingsSection: Int32 {
    case antiDelete
    case premium
    case privacy
    case interface
}

private enum BogramSettingsEntry: ItemListNodeEntry {
    case keepDeletedHeader
    case keepDeletedValue(Bool)
    case deletedJournal
    case keepDeletedInfo
    case localPremiumHeader
    case localPremiumValue(Bool)
    case localPremiumInfo
    case privacyModeHeader
    case privacyModeValue(Bool)
    case privacyModeInfo
    case hidePhoneHeader
    case hidePhoneValue(Bool)
    case hidePhoneInfo
    case ghostModeValue(Bool)
    case ghostModeInfo
    case cleanTelegramHeader
    case cleanTelegramValue(Bool)
    case cleanTelegramInfo
    case hideStoriesHeader
    case hideStoriesValue(Bool)
    case removeAdsValue(Bool)
    case interfaceInfo
    
    var section: ItemListSectionId {
        switch self {
        case .keepDeletedHeader, .keepDeletedValue, .deletedJournal, .keepDeletedInfo:
            return BogramSettingsSection.antiDelete.rawValue
        case .localPremiumHeader, .localPremiumValue, .localPremiumInfo:
            return BogramSettingsSection.premium.rawValue
        case .privacyModeHeader, .privacyModeValue, .privacyModeInfo, .hidePhoneHeader, .hidePhoneValue, .hidePhoneInfo, .ghostModeValue, .ghostModeInfo:
            return BogramSettingsSection.privacy.rawValue
        case .cleanTelegramHeader, .cleanTelegramValue, .cleanTelegramInfo, .hideStoriesHeader, .hideStoriesValue, .removeAdsValue, .interfaceInfo:
            return BogramSettingsSection.interface.rawValue
        }
    }
    
    var stableId: Int32 {
        switch self {
        case .keepDeletedHeader:
            return 0
        case .keepDeletedValue:
            return 1
        case .deletedJournal:
            return 2
        case .keepDeletedInfo:
            return 3
        case .localPremiumHeader:
            return 4
        case .localPremiumValue:
            return 5
        case .localPremiumInfo:
            return 6
        case .privacyModeHeader:
            return 7
        case .privacyModeValue:
            return 8
        case .privacyModeInfo:
            return 9
        case .hidePhoneHeader:
            return 10
        case .hidePhoneValue:
            return 11
        case .hidePhoneInfo:
            return 12
        case .ghostModeValue:
            return 13
        case .ghostModeInfo:
            return 14
        case .cleanTelegramHeader:
            return 15
        case .cleanTelegramValue:
            return 16
        case .cleanTelegramInfo:
            return 17
        case .hideStoriesHeader:
            return 18
        case .hideStoriesValue:
            return 19
        case .removeAdsValue:
            return 20
        case .interfaceInfo:
            return 21
        }
    }
    
    static func <(lhs: BogramSettingsEntry, rhs: BogramSettingsEntry) -> Bool {
        return lhs.stableId < rhs.stableId
    }
    
    func item(presentationData: ItemListPresentationData, arguments: Any) -> ListViewItem {
        let arguments = arguments as! BogramSettingsControllerArguments
        switch self {
        case .keepDeletedHeader:
            return ItemListSectionHeaderItem(
                presentationData: presentationData,
                text: "\u{421}\u{41E}\u{425}\u{420}\u{410}\u{41D}\u{415}\u{41D}\u{418}\u{415} \u{421}\u{41E}\u{41E}\u{411}\u{429}\u{415}\u{41D}\u{418}\u{419}",
                sectionId: self.section
            )
        case let .keepDeletedValue(value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                systemStyle: .glass,
                title: "\u{421}\u{43E}\u{445}\u{440}\u{430}\u{43D}\u{44F}\u{442}\u{44C} \u{443}\u{434}\u{430}\u{43B}\u{435}\u{43D}\u{43D}\u{44B}\u{435} \u{441}\u{43E}\u{43E}\u{431}\u{449}\u{435}\u{43D}\u{438}\u{44F}",
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { value in
                    arguments.toggleKeepDeletedMessages(value)
                }
            )
        case .deletedJournal:
            return ItemListDisclosureItem(
                presentationData: presentationData,
                systemStyle: .glass,
                title: "\u{416}\u{443}\u{440}\u{43D}\u{430}\u{43B} \u{443}\u{434}\u{430}\u{43B}\u{435}\u{43D}\u{43D}\u{44B}\u{445} \u{441}\u{43E}\u{43E}\u{431}\u{449}\u{435}\u{43D}\u{438}\u{439}",
                label: "",
                sectionId: self.section,
                style: .blocks,
                disclosureStyle: .arrow,
                action: {
                    arguments.openDeletedJournal()
                }
            )
        case .keepDeletedInfo:
            return ItemListTextItem(
                presentationData: presentationData,
                text: .plain("\u{415}\u{441}\u{43B}\u{438} \u{441}\u{43E}\u{431}\u{435}\u{441}\u{435}\u{434}\u{43D}\u{438}\u{43A} \u{443}\u{434}\u{430}\u{43B}\u{438}\u{442} \u{441}\u{43E}\u{43E}\u{431}\u{449}\u{435}\u{43D}\u{438}\u{435}, Bogram \u{43E}\u{441}\u{442}\u{430}\u{432}\u{438}\u{442} \u{435}\u{433}\u{43E} \u{443} \u{442}\u{435}\u{431}\u{44F} \u{43B}\u{43E}\u{43A}\u{430}\u{43B}\u{44C}\u{43D}\u{43E}. \u{41D}\u{430} \u{434}\u{440}\u{443}\u{433}\u{438}\u{445} \u{443}\u{441}\u{442}\u{440}\u{43E}\u{439}\u{441}\u{442}\u{432}\u{430}\u{445} \u{438} \u{443} \u{434}\u{440}\u{443}\u{433}\u{438}\u{445} \u{43F}\u{43E}\u{43B}\u{44C}\u{437}\u{43E}\u{432}\u{430}\u{442}\u{435}\u{43B}\u{435}\u{439} \u{44D}\u{442}\u{43E} \u{43D}\u{435} \u{43C}\u{435}\u{43D}\u{44F}\u{435}\u{442}\u{441}\u{44F}."),
                sectionId: self.section
            )
        case .localPremiumHeader:
            return ItemListSectionHeaderItem(
                presentationData: presentationData,
                text: "BOGRAM PREMIUM",
                sectionId: self.section
            )
        case let .localPremiumValue(value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                systemStyle: .glass,
                title: "\u{41B}\u{43E}\u{43A}\u{430}\u{43B}\u{44C}\u{43D}\u{44B}\u{439} Bogram Premium",
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { value in
                    arguments.toggleLocalPremium(value)
                }
            )
        case .localPremiumInfo:
            return ItemListTextItem(
                presentationData: presentationData,
                text: .plain("\u{412}\u{43A}\u{43B}\u{44E}\u{447}\u{430}\u{435}\u{442} \u{442}\u{43E}\u{43B}\u{44C}\u{43A}\u{43E} \u{43B}\u{43E}\u{43A}\u{430}\u{43B}\u{44C}\u{43D}\u{44B}\u{435} \u{43A}\u{43E}\u{441}\u{43C}\u{435}\u{442}\u{438}\u{447}\u{435}\u{441}\u{43A}\u{438}\u{435} \u{44D}\u{444}\u{444}\u{435}\u{43A}\u{442}\u{44B}: premium-\u{431}\u{435}\u{439}\u{434}\u{436} \u{432} \u{442}\u{432}\u{43E}\u{435}\u{43C} \u{43F}\u{440}\u{43E}\u{444}\u{438}\u{43B}\u{435} \u{438} \u{434}\u{43E}\u{441}\u{442}\u{443}\u{43F} \u{43A} premium app icons \u{432} \u{440}\u{430}\u{437}\u{434}\u{435}\u{43B}\u{435} Appearance. \u{414}\u{43B}\u{44F} \u{434}\u{440}\u{443}\u{433}\u{438}\u{445} \u{43F}\u{43E}\u{43B}\u{44C}\u{437}\u{43E}\u{432}\u{430}\u{442}\u{435}\u{43B}\u{435}\u{439} \u{44D}\u{442}\u{43E} \u{43D}\u{435} \u{432}\u{438}\u{434}\u{43D}\u{43E} \u{438} \u{441}\u{435}\u{440}\u{432}\u{435}\u{440}\u{43D}\u{44B}\u{439} Premium \u{43D}\u{435} \u{437}\u{430}\u{43C}\u{435}\u{43D}\u{44F}\u{435}\u{442}."),
                sectionId: self.section
            )
        case .privacyModeHeader:
            return ItemListSectionHeaderItem(
                presentationData: presentationData,
                text: "\u{41F}\u{420}\u{418}\u{412}\u{410}\u{422}\u{41D}\u{42B}\u{419} \u{420}\u{415}\u{416}\u{418}\u{41C}",
                sectionId: self.section
            )
        case let .privacyModeValue(value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                systemStyle: .glass,
                title: "\u{41F}\u{440}\u{438}\u{432}\u{430}\u{442}\u{43D}\u{44B}\u{439} \u{440}\u{435}\u{436}\u{438}\u{43C}",
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { value in
                    arguments.togglePrivacyMode(value)
                }
            )
        case .privacyModeInfo:
            return ItemListTextItem(
                presentationData: presentationData,
                text: .plain("\u{41E}\u{434}\u{43D}\u{438}\u{43C} \u{442}\u{443}\u{43C}\u{431}\u{43B}\u{435}\u{440}\u{43E}\u{43C} \u{432}\u{43A}\u{43B}\u{44E}\u{447}\u{430}\u{435}\u{442} Ghost Mode \u{438} \u{441}\u{43A}\u{440}\u{44B}\u{442}\u{438}\u{435} \u{43D}\u{43E}\u{43C}\u{435}\u{440}\u{430}. \u{41E}\u{442}\u{434}\u{435}\u{43B}\u{44C}\u{43D}\u{44B}\u{435} \u{442}\u{443}\u{43C}\u{431}\u{43B}\u{435}\u{440}\u{44B} \u{43D}\u{438}\u{436}\u{435} \u{43C}\u{43E}\u{436}\u{43D}\u{43E} \u{438}\u{441}\u{43F}\u{43E}\u{43B}\u{44C}\u{437}\u{43E}\u{432}\u{430}\u{442}\u{44C} \u{434}\u{43B}\u{44F} \u{442}\u{43E}\u{43D}\u{43A}\u{43E}\u{439} \u{43D}\u{430}\u{441}\u{442}\u{440}\u{43E}\u{439}\u{43A}\u{438}."),
                sectionId: self.section
            )
        case .hidePhoneHeader:
            return ItemListSectionHeaderItem(
                presentationData: presentationData,
                text: "\u{41F}\u{420}\u{418}\u{412}\u{410}\u{422}\u{41D}\u{41E}\u{421}\u{422}\u{42C}",
                sectionId: self.section
            )
        case let .hidePhoneValue(value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                systemStyle: .glass,
                title: "\u{421}\u{43A}\u{440}\u{44B}\u{442}\u{44C} \u{43D}\u{43E}\u{43C}\u{435}\u{440}",
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { value in
                    arguments.toggleHidePhoneNumbers(value)
                }
            )
        case .hidePhoneInfo:
            return ItemListTextItem(
                presentationData: presentationData,
                text: .plain("\u{421}\u{43A}\u{440}\u{44B}\u{432}\u{430}\u{435}\u{442} \u{43D}\u{43E}\u{43C}\u{435}\u{440}\u{430} \u{432} \u{43F}\u{440}\u{43E}\u{444}\u{438}\u{43B}\u{435} \u{438} \u{432} \u{43E}\u{441}\u{43D}\u{43E}\u{432}\u{43D}\u{44B}\u{445} \u{43C}\u{435}\u{43D}\u{44E} \u{43A}\u{43B}\u{438}\u{435}\u{43D}\u{442}\u{430}."),
                sectionId: self.section
            )
        case let .ghostModeValue(value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                systemStyle: .glass,
                title: "Ghost Mode",
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { value in
                    arguments.toggleGhostMode(value)
                }
            )
        case .ghostModeInfo:
            return ItemListTextItem(
                presentationData: presentationData,
                text: .plain("\u{41B}\u{43E}\u{43A}\u{430}\u{43B}\u{44C}\u{43D}\u{43E} \u{441}\u{43A}\u{440}\u{44B}\u{432}\u{430}\u{435}\u{442} \u{43F}\u{440}\u{43E}\u{447}\u{442}\u{435}\u{43D}\u{438}\u{435} \u{441}\u{43E}\u{43E}\u{431}\u{449}\u{435}\u{43D}\u{438}\u{439} \u{438} \u{43D}\u{435} \u{434}\u{435}\u{440}\u{436}\u{438}\u{442} \u{43E}\u{43D}\u{43B}\u{430}\u{439}\u{43D} \u{441}\u{442}\u{430}\u{442}\u{443}\u{441}, \u{43F}\u{43E}\u{43A}\u{430} \u{442}\u{44B} \u{43F}\u{440}\u{43E}\u{441}\u{43C}\u{430}\u{442}\u{440}\u{438}\u{432}\u{430}\u{435}\u{448}\u{44C} \u{447}\u{430}\u{442}\u{44B}. \u{41F}\u{440}\u{438} \u{43E}\u{442}\u{43F}\u{440}\u{430}\u{432}\u{43A}\u{435} \u{441}\u{43E}\u{43E}\u{431}\u{449}\u{435}\u{43D}\u{438}\u{439} \u{438}\u{43B}\u{438} \u{434}\u{440}\u{443}\u{433}\u{438}\u{445} \u{441}\u{435}\u{442}\u{435}\u{432}\u{44B}\u{445} \u{434}\u{435}\u{439}\u{441}\u{442}\u{432}\u{438}\u{44F}\u{445} \u{441}\u{435}\u{440}\u{432}\u{435}\u{440} \u{432}\u{441}\u{451} \u{440}\u{430}\u{432}\u{43D}\u{43E} \u{43C}\u{43E}\u{436}\u{435}\u{442} \u{43A}\u{440}\u{430}\u{442}\u{43A}\u{43E} \u{43F}\u{43E}\u{43A}\u{430}\u{437}\u{430}\u{442}\u{44C} \u{430}\u{43A}\u{442}\u{438}\u{432}\u{43D}\u{43E}\u{441}\u{442}\u{44C}."),
                sectionId: self.section
            )
        case .cleanTelegramHeader:
            return ItemListSectionHeaderItem(
                presentationData: presentationData,
                text: "\u{427}\u{418}\u{421}\u{422}\u{42B}\u{419} TELEGRAM",
                sectionId: self.section
            )
        case let .cleanTelegramValue(value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                systemStyle: .glass,
                title: "\u{427}\u{438}\u{441}\u{442}\u{44B}\u{439} Telegram",
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { value in
                    arguments.toggleCleanTelegram(value)
                }
            )
        case .cleanTelegramInfo:
            return ItemListTextItem(
                presentationData: presentationData,
                text: .plain("\u{41F}\u{43E} \u{443}\u{43C}\u{43E}\u{43B}\u{447}\u{430}\u{43D}\u{438}\u{44E} \u{43F}\u{440}\u{44F}\u{447}\u{435}\u{442} \u{438}\u{441}\u{442}\u{43E}\u{440}\u{438}\u{438} \u{438} \u{440}\u{435}\u{43A}\u{43B}\u{430}\u{43C}\u{443}, \u{447}\u{442}\u{43E}\u{431}\u{44B} \u{43A}\u{43B}\u{438}\u{435}\u{43D}\u{442} \u{432}\u{44B}\u{433}\u{43B}\u{44F}\u{434}\u{435}\u{43B} \u{447}\u{438}\u{449}\u{435}. \u{41F}\u{440}\u{438} \u{432}\u{44B}\u{43A}\u{43B}\u{44E}\u{447}\u{435}\u{43D}\u{438}\u{438} \u{43C}\u{43E}\u{436}\u{43D}\u{43E} \u{438}\u{441}\u{43F}\u{43E}\u{43B}\u{44C}\u{437}\u{43E}\u{432}\u{430}\u{442}\u{44C} \u{43D}\u{438}\u{436}\u{435} \u{43E}\u{442}\u{434}\u{435}\u{43B}\u{44C}\u{43D}\u{44B}\u{435} \u{442}\u{443}\u{43C}\u{431}\u{43B}\u{435}\u{440}\u{44B}."),
                sectionId: self.section
            )
        case .hideStoriesHeader:
            return ItemListSectionHeaderItem(
                presentationData: presentationData,
                text: "\u{418}\u{41D}\u{422}\u{415}\u{420}\u{424}\u{415}\u{419}\u{421}",
                sectionId: self.section
            )
        case let .hideStoriesValue(value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                systemStyle: .glass,
                title: "\u{421}\u{43A}\u{440}\u{44B}\u{442}\u{44C} \u{438}\u{441}\u{442}\u{43E}\u{440}\u{438}\u{438}",
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { value in
                    arguments.toggleHideStories(value)
                }
            )
        case let .removeAdsValue(value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                systemStyle: .glass,
                title: "\u{423}\u{431}\u{440}\u{430}\u{442}\u{44C} \u{440}\u{435}\u{43A}\u{43B}\u{430}\u{43C}\u{443}",
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { value in
                    arguments.toggleRemoveAds(value)
                }
            )
        case .interfaceInfo:
            return ItemListTextItem(
                presentationData: presentationData,
                text: .plain("\u{421}\u{43A}\u{440}\u{44B}\u{432}\u{430}\u{435}\u{442} \u{438}\u{441}\u{442}\u{43E}\u{440}\u{438}\u{438} \u{432} \u{441}\u{43F}\u{438}\u{441}\u{43A}\u{435} \u{447}\u{430}\u{442}\u{43E}\u{432} \u{438} \u{43E}\u{442}\u{43A}\u{43B}\u{44E}\u{447}\u{430}\u{435}\u{442} \u{43B}\u{43E}\u{43A}\u{430}\u{43B}\u{44C}\u{43D}\u{44B}\u{435} \u{440}\u{435}\u{43A}\u{43B}\u{430}\u{43C}\u{43D}\u{44B}\u{435} \u{43F}\u{440}\u{43E}\u{43C}\u{43E}-\u{431}\u{43B}\u{43E}\u{43A}\u{438} \u{438} \u{43F}\u{43E}\u{434}\u{441}\u{43A}\u{430}\u{437}\u{43A}\u{438}."),
                sectionId: self.section
            )
        }
    }
}

private struct BogramSettingsControllerState: Equatable {
    var keepDeletedMessages: Bool
    var localPremium: Bool
    var privacyMode: Bool
    var hidePhoneNumbers: Bool
    var ghostMode: Bool
    var cleanTelegram: Bool
    var hideStories: Bool
    var removeAds: Bool
}

private func bogramSettingsEntries(state: BogramSettingsControllerState) -> [BogramSettingsEntry] {
    return [
        .keepDeletedHeader,
        .keepDeletedValue(state.keepDeletedMessages),
        .deletedJournal,
        .keepDeletedInfo,
        .localPremiumHeader,
        .localPremiumValue(state.localPremium),
        .localPremiumInfo,
        .privacyModeHeader,
        .privacyModeValue(state.privacyMode),
        .privacyModeInfo,
        .hidePhoneHeader,
        .hidePhoneValue(state.hidePhoneNumbers),
        .hidePhoneInfo,
        .ghostModeValue(state.ghostMode),
        .ghostModeInfo,
        .cleanTelegramHeader,
        .cleanTelegramValue(state.cleanTelegram),
        .cleanTelegramInfo,
        .hideStoriesHeader,
        .hideStoriesValue(state.hideStories),
        .removeAdsValue(state.removeAds),
        .interfaceInfo
    ]
}

public func bogramSettingsController(context: AccountContext) -> ViewController {
    let initialState = BogramSettingsControllerState(
        keepDeletedMessages: BogramSettings.keepDeletedMessages,
        localPremium: BogramSettings.localPremium,
        privacyMode: BogramSettings.privacyMode,
        hidePhoneNumbers: BogramSettings.hidePhoneNumbers,
        ghostMode: BogramSettings.ghostMode,
        cleanTelegram: BogramSettings.cleanTelegram,
        hideStories: BogramSettings.hideStories,
        removeAds: BogramSettings.removeAds
    )
    let statePromise = ValuePromise(initialState, ignoreRepeated: true)
    let stateValue = Atomic(value: initialState)
    let updateState: ((BogramSettingsControllerState) -> BogramSettingsControllerState) -> Void = { f in
        statePromise.set(stateValue.modify(f))
    }
    
    var pushControllerImpl: ((ViewController) -> Void)?

    let arguments = BogramSettingsControllerArguments(
        toggleKeepDeletedMessages: { value in
            BogramSettings.keepDeletedMessages = value
            updateState { state in
                var state = state
                state.keepDeletedMessages = value
                return state
            }
        },
        toggleLocalPremium: { value in
            BogramSettings.localPremium = value
            updateState { state in
                var state = state
                state.localPremium = value
                return state
            }
        },
        togglePrivacyMode: { value in
            BogramSettings.privacyMode = value
            if value {
                context.account.shouldKeepOnlinePresence.set(.single(false))
            }
            updateState { state in
                var state = state
                state.privacyMode = value
                state.hidePhoneNumbers = BogramSettings.hidePhoneNumbers
                state.ghostMode = BogramSettings.ghostMode
                return state
            }
        },
        toggleHidePhoneNumbers: { value in
            BogramSettings.hidePhoneNumbers = value
            updateState { state in
                var state = state
                state.hidePhoneNumbers = value
                return state
            }
        },
        toggleGhostMode: { value in
            BogramSettings.ghostMode = value
            if value {
                context.account.shouldKeepOnlinePresence.set(.single(false))
            }
            updateState { state in
                var state = state
                state.ghostMode = value
                return state
            }
        },
        toggleCleanTelegram: { value in
            BogramSettings.cleanTelegram = value
            updateState { state in
                var state = state
                state.cleanTelegram = value
                state.hideStories = BogramSettings.hideStories
                state.removeAds = BogramSettings.removeAds
                return state
            }
        },
        toggleHideStories: { value in
            BogramSettings.hideStories = value
            updateState { state in
                var state = state
                state.hideStories = value
                return state
            }
        },
        toggleRemoveAds: { value in
            BogramSettings.removeAds = value
            updateState { state in
                var state = state
                state.removeAds = value
                return state
            }
        },
        openDeletedJournal: {
            let controller = bogramDeletedMessagesController(context: context)
            pushControllerImpl?(controller)
        }
    )
    
    let signal = combineLatest(queue: .mainQueue(),
        context.sharedContext.presentationData,
        statePromise.get()
    )
    |> map { presentationData, state -> (ItemListControllerState, (ItemListNodeState, Any)) in
        let controllerState = ItemListControllerState(
            presentationData: ItemListPresentationData(presentationData),
            title: .text("\u{41D}\u{430}\u{441}\u{442}\u{440}\u{43E}\u{439}\u{43A}\u{438} Bogram"),
            leftNavigationButton: nil,
            rightNavigationButton: nil,
            backNavigationButton: ItemListBackButton(title: presentationData.strings.Common_Back)
        )
        let listState = ItemListNodeState(
            presentationData: ItemListPresentationData(presentationData),
            entries: bogramSettingsEntries(state: state),
            style: .blocks,
            animateChanges: true
        )
        return (controllerState, (listState, arguments))
    }
    
    let controller = ItemListController(context: context, state: signal)
    pushControllerImpl = { [weak controller] c in
        (controller?.navigationController as? NavigationController)?.pushViewController(c)
    }
    return controller
}
