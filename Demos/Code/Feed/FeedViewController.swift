import Foundation
import UIKit
import ALLKit

final class FeedViewController: ListViewController<UICollectionView, UICollectionViewCell> {
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.global().async {
            let items = self.generateItems()

            DispatchQueue.main.async {
                self.adapter.set(items: items)
            }
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        adapter.set(boundingDimensions: CGSize(width: view.bounds.width, height: .nan).layoutDimensions)
    }

    private func generateItems() -> [ListItem<DemoContext>] {
        return (0..<100).flatMap { _ -> [ListItem<DemoContext>] in
            let item = FeedItem(
                avatar: URL(string: "https://picsum.photos/100/100?random&q=\(Int.random(in: 1..<1000))"),
                title: UUID().uuidString,
                date: Date(),
                image: URL(string: "https://picsum.photos/600/600?random&q=\(Int.random(in: 1..<1000))"),
                likesCount: UInt.random(in: 1..<100),
                viewsCount: UInt.random(in: 1..<1000)
            )

            let listItem = ListItem<DemoContext>(
                id: item.id,
                layoutSpec: FeedItemLayoutSpec(model: item)
            )

            let sep = item.id + "_sep"

            let sepListItem = ListItem<DemoContext>(
                id: sep,
                layoutSpec: FeedItemSeparatorLayoutSpec()
            )

            return [listItem, sepListItem]
        }
    }
}
