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
    let toggleHidePhoneNumbers: (Bool) -> Void
    let toggleGhostMode: (Bool) -> Void
    
    init(
        toggleKeepDeletedMessages: @escaping (Bool) -> Void,
        toggleLocalPremium: @escaping (Bool) -> Void,
        toggleHidePhoneNumbers: @escaping (Bool) -> Void,
        toggleGhostMode: @escaping (Bool) -> Void
    ) {
        self.toggleKeepDeletedMessages = toggleKeepDeletedMessages
        self.toggleLocalPremium = toggleLocalPremium
        self.toggleHidePhoneNumbers = toggleHidePhoneNumbers
        self.toggleGhostMode = toggleGhostMode
    }
}

private enum BogramSettingsSection: Int32 {
    case antiDelete
    case premium
    case privacy
}

private enum BogramSettingsEntry: ItemListNodeEntry {
    case keepDeletedHeader
    case keepDeletedValue(Bool)
    case keepDeletedInfo
    case localPremiumHeader
    case localPremiumValue(Bool)
    case localPremiumInfo
    case hidePhoneHeader
    case hidePhoneValue(Bool)
    case hidePhoneInfo
    case ghostModeValue(Bool)
    case ghostModeInfo
    
    var section: ItemListSectionId {
        switch self {
        case .keepDeletedHeader, .keepDeletedValue, .keepDeletedInfo:
            return BogramSettingsSection.antiDelete.rawValue
        case .localPremiumHeader, .localPremiumValue, .localPremiumInfo:
            return BogramSettingsSection.premium.rawValue
        case .hidePhoneHeader, .hidePhoneValue, .hidePhoneInfo, .ghostModeValue, .ghostModeInfo:
            return BogramSettingsSection.privacy.rawValue
        }
    }
    
    var stableId: Int32 {
        switch self {
        case .keepDeletedHeader:
            return 0
        case .keepDeletedValue:
            return 1
        case .keepDeletedInfo:
            return 2
        case .localPremiumHeader:
            return 3
        case .localPremiumValue:
            return 4
        case .localPremiumInfo:
            return 5
        case .hidePhoneHeader:
            return 6
        case .hidePhoneValue:
            return 7
        case .hidePhoneInfo:
            return 8
        case .ghostModeValue:
            return 9
        case .ghostModeInfo:
            return 10
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
        }
    }
}

private struct BogramSettingsControllerState: Equatable {
    var keepDeletedMessages: Bool
    var localPremium: Bool
    var hidePhoneNumbers: Bool
    var ghostMode: Bool
}

private func bogramSettingsEntries(state: BogramSettingsControllerState) -> [BogramSettingsEntry] {
    return [
        .keepDeletedHeader,
        .keepDeletedValue(state.keepDeletedMessages),
        .keepDeletedInfo,
        .localPremiumHeader,
        .localPremiumValue(state.localPremium),
        .localPremiumInfo,
        .hidePhoneHeader,
        .hidePhoneValue(state.hidePhoneNumbers),
        .hidePhoneInfo,
        .ghostModeValue(state.ghostMode),
        .ghostModeInfo
    ]
}

public func bogramSettingsController(context: AccountContext) -> ViewController {
    let initialState = BogramSettingsControllerState(
        keepDeletedMessages: BogramSettings.keepDeletedMessages,
        localPremium: BogramSettings.localPremium,
        hidePhoneNumbers: BogramSettings.hidePhoneNumbers,
        ghostMode: BogramSettings.ghostMode
    )
    let statePromise = ValuePromise(initialState, ignoreRepeated: true)
    let stateValue = Atomic(value: initialState)
    let updateState: ((BogramSettingsControllerState) -> BogramSettingsControllerState) -> Void = { f in
        statePromise.set(stateValue.modify(f))
    }
    
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
    
    return ItemListController(context: context, state: signal)
}
