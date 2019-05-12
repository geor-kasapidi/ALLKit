import Foundation
import UIKit
import ALLKit

final class SizeConstraintsDemoViewController: UIViewController {
    private let adapter = CollectionViewAdapter(
        scrollDirection: .vertical,
        sectionInset: UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2),
        minimumLineSpacing: 0,
        minimumInteritemSpacing: 0
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            view.backgroundColor = UIColor.white

            view.addSubview(adapter.collectionView)

            adapter.collectionView.backgroundColor = UIColor.white
        }

        do {
            adapter.set(items: generateItems())
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        adapter.collectionView.frame = view.bounds

        adapter.set(sizeConstraints: SizeConstraints(width: view.bounds.width - 4))
    }

    private func generateItems() -> [ListItem] {
        var items = [ListItem]()

        (0..<100).forEach { i in
            let n = Int(arc4random_uniform(5))

            (0..<n).forEach { _ in
                let id = UUID().uuidString

                let emoji = String(DemoContent.emodjiString.randomElement() ?? "💥")

                let listItem = ListItem(
                    id: id,
                    model: id,
                    layoutSpec: EmojiLayoutSpec(model: emoji)
                )

                listItem.sizeConstraintsModifier = {
                    guard let width = $0.width else {
                        return $0
                    }

                    return SizeConstraints(width: (width / CGFloat(n)).rounded(.down))
                }

                items.append(listItem)
            }
        }

        return items
    }
}
