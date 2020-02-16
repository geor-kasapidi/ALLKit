import Foundation
import UIKit
import ALLKit

struct ChatColors {
    static let incoming = #colorLiteral(red: 0.9214877486, green: 0.9216202497, blue: 0.9214588404, alpha: 1)
    static let outgoing = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
}

struct ChatMessage: Hashable {
    let id = UUID().uuidString
    let text: String
    let date: Date
}

final class ChatViewController: ListViewController<UICollectionView, UICollectionViewCell> {
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            if #available(iOS 11.0, *) {
                adapter.collectionView.contentInsetAdjustmentBehavior = .never
            } else {
                automaticallyAdjustsScrollViewInsets = false
            }

            adapter.collectionView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }

        do {
            DispatchQueue.global().async {
                let items = self.generateItems()

                DispatchQueue.main.async {
                    self.adapter.set(items: items)
                }
            }
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        adapter.set(
            boundingDimensions: CGSize(
                width: view.bounds.width,
                height: .nan
            ).layoutDimensions
        )
    }

    private func generateItems() -> [ListItem<DemoContext>] {
        let sentences = DemoContent.loremIpsum
        let emodji = DemoContent.emodjiString

        return (0..<100).flatMap { n -> [ListItem<DemoContext>] in
            let firstMessageItem: ListItem<DemoContext>

            do {
                let text = sentences.randomElement()!
                let message = ChatMessage(text: text, date: Date())

                if n % 2 == 0 {
                    firstMessageItem = ListItem(
                        id: message,
                        layoutSpec: IncomingTextMessageLayoutSpec(model: message)
                    )
                } else {
                    firstMessageItem = ListItem(
                        id: message,
                        layoutSpec: OutgoingTextMessageLayoutSpec(model: message)
                    )
                }
            }

            let secondMessageItem: ListItem<DemoContext>

            do {
                let text = String(emodji.prefix(Int.random(in: 1..<emodji.count)))
                let message = ChatMessage(text: text, date: Date())

                if n % 2 == 0 {
                    secondMessageItem = ListItem(
                        id: message,
                        layoutSpec: IncomingTextMessageLayoutSpec(model: message)
                    )
                } else {
                    secondMessageItem = ListItem(
                        id: message,
                        layoutSpec: OutgoingTextMessageLayoutSpec(model: message)
                    )
                }
            }

            return [firstMessageItem, secondMessageItem]
        }
    }

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        UIView.performWithoutAnimation {
            cell.contentView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
    }
}
