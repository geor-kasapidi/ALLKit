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

        adapter.set(
            boundingDimensions: CGSize(
                width: view.bounds.width - 4,
                height: .nan
            ).layoutDimensions
        )
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
                    layoutSpec: EmojiLayoutSpec(model: emoji)
                )

                listItem.boundingDimensionsModifier = { (w, h) in
                    ((w / CGFloat(n)).rounded(.down), .nan)
                }

                items.append(listItem)
            }
        }

        return items
    }
}
