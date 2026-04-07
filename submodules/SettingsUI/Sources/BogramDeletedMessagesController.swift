import Foundation
import Display
import SwiftSignalKit
import TelegramCore
import TelegramPresentationData
import ItemListUI
import PresentationDataUtils
import AccountContext

private final class BogramDeletedMessagesControllerArguments {
}

private enum BogramDeletedMessagesSection: Int32 {
    case logs
}

private enum BogramDeletedMessagesEntry: ItemListNodeEntry {
    case info(String)
    case item(Int32, BogramSettings.DeletedMessageLogEntry)

    var section: ItemListSectionId {
        return BogramDeletedMessagesSection.logs.rawValue
    }

    var stableId: Int32 {
        switch self {
        case .info:
            return 0
        case let .item(index, _):
            return index + 1
        }
    }

    static func <(lhs: BogramDeletedMessagesEntry, rhs: BogramDeletedMessagesEntry) -> Bool {
        return lhs.stableId < rhs.stableId
    }

    func item(presentationData: ItemListPresentationData, arguments: Any) -> ListViewItem {
        switch self {
        case let .info(text):
            return ItemListTextItem(
                presentationData: presentationData,
                text: .plain(text),
                sectionId: self.section
            )
        case let .item(_, entry):
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            let dateText = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(entry.timestamp)))
            let separator = "\u{2022}"
            let label: String
            if entry.authorTitle == entry.peerTitle {
                label = "\(entry.peerTitle) \(separator) \(dateText)"
            } else {
                label = "\(entry.peerTitle) \(separator) \(entry.authorTitle) \(separator) \(dateText)"
            }
            return ItemListTextWithLabelItem(
                presentationData: presentationData,
                label: label,
                text: entry.text,
                style: .blocks,
                labelColor: .secondary,
                textColor: .primary,
                enabledEntityTypes: [.url],
                multiline: true,
                sectionId: self.section,
                action: nil
            )
        }
    }
}

public func bogramDeletedMessagesController(context: AccountContext) -> ViewController {
    let signal = context.sharedContext.presentationData
    |> map { presentationData -> (ItemListControllerState, (ItemListNodeState, Any)) in
        let logs = BogramSettings.deletedMessagesJournal()
        var entries: [BogramDeletedMessagesEntry] = []
        if logs.isEmpty {
            entries.append(.info("\u{416}\u{443}\u{440}\u{43D}\u{430}\u{43B} \u{43F}\u{43E}\u{43A}\u{430} \u{43F}\u{443}\u{441}\u{442}. \u{417}\u{434}\u{435}\u{441}\u{44C} \u{431}\u{443}\u{434}\u{443}\u{442} \u{43F}\u{43E}\u{44F}\u{432}\u{43B}\u{44F}\u{442}\u{44C}\u{441}\u{44F} \u{441}\u{43E}\u{43E}\u{431}\u{449}\u{435}\u{43D}\u{438}\u{44F}, \u{43A}\u{43E}\u{442}\u{43E}\u{440}\u{44B}\u{435} \u{443}\u{434}\u{430}\u{43B}\u{438}\u{43B}\u{438} \u{443} \u{442}\u{435}\u{431}\u{44F} \u{432} \u{447}\u{430}\u{442}\u{430}\u{445}."))
        } else {
            for (index, entry) in logs.enumerated() {
                entries.append(.item(Int32(index), entry))
            }
        }

        let controllerState = ItemListControllerState(
            presentationData: ItemListPresentationData(presentationData),
            title: .text("\u{416}\u{443}\u{440}\u{43D}\u{430}\u{43B} \u{443}\u{434}\u{430}\u{43B}\u{435}\u{43D}\u{43D}\u{44B}\u{445}"),
            leftNavigationButton: nil,
            rightNavigationButton: nil,
            backNavigationButton: ItemListBackButton(title: presentationData.strings.Common_Back)
        )
        let listState = ItemListNodeState(
            presentationData: ItemListPresentationData(presentationData),
            entries: entries,
            style: .blocks,
            animateChanges: true
        )
        return (controllerState, (listState, BogramDeletedMessagesControllerArguments()))
    }

    return ItemListController(context: context, state: signal)
}
