import Foundation
import UIKit
import ALLKit

final class FeedViewController: UIViewController {
    private let adapter = CollectionViewAdapter()

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            view.backgroundColor = UIColor.white

            view.addSubview(adapter.collectionView)

            adapter.collectionView.backgroundColor = UIColor.white
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

        adapter.collectionView.frame = view.bounds

        adapter.set(sizeConstraints: SizeConstraints(width: view.bounds.width))
    }

    private func generateItems() -> [ListItem] {
        return (0..<100).flatMap { _ -> [ListItem] in
            let item = FeedItem(
                avatar: URL(string: "https://picsum.photos/100/100?random&q=\(Int.random(in: 1..<1000))"),
                title: UUID().uuidString,
                date: Date(),
                image: URL(string: "https://picsum.photos/600/600?random&q=\(Int.random(in: 1..<1000))"),
                likesCount: UInt.random(in: 1..<100),
                viewsCount: UInt.random(in: 1..<1000)
            )

            let listItem = ListItem(
                id: item.id,
                model: item,
                layoutSpec: FeedItemLayoutSpec(model: item)
            )

            let sep = item.id + "_sep"

            let sepListItem = ListItem(
                id: sep,
                model: sep,
                layoutSpec: FeedItemSeparatorLayoutSpec()
            )

            return [listItem, sepListItem]
        }
    }
}
