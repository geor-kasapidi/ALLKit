import Foundation
import UIKit
import ALLKit

final class SizeConstraintsDemoViewController: ListViewController<UICollectionView, UICollectionViewCell> {
    init() {
        super.init(adapter: CollectionViewAdapter(
            scrollDirection: .vertical,
            sectionInset: UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2),
            minimumLineSpacing: 0,
            minimumInteritemSpacing: 0
        ))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        adapter.set(items: generateItems())
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        adapter.set(
            boundingDimensions: CGSize(
                width: view.bounds.width - 4,
                height: .nan
            ).layoutDimensions
        )
    }

    private func generateItems() -> [ListItem<DemoContext>] {
        var items = [ListItem<DemoContext>]()

        (0..<100).forEach { i in
            let n = Int(arc4random_uniform(5))

            (0..<n).forEach { _ in
                let id = UUID().uuidString

                let emoji = String(DemoContent.emodjiString.randomElement() ?? "💥")

                let listItem = ListItem<DemoContext>(
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
