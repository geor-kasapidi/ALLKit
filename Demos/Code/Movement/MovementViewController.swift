import Foundation
import UIKit
import ALLKit

final class MovementViewController: ListViewController<UICollectionView, UICollectionViewCell> {
    private struct Consts {
        static let spacing: CGFloat = 4
    }

    init() {
        super.init(adapter: CollectionViewAdapter(
            scrollDirection: .vertical,
            sectionInset: UIEdgeInsets(top: Consts.spacing, left: Consts.spacing, bottom: Consts.spacing, right: Consts.spacing),
            minimumLineSpacing: Consts.spacing,
            minimumInteritemSpacing: Consts.spacing
        ))
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            adapter.settings.allowInteractiveMovement = true

            adapter.collectionView.all_addGestureRecognizer { [weak self] (g: UILongPressGestureRecognizer) in
                self?.adapter.handleMoveGesture(g)
            }
        }

        do {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .refresh,
                target: self,
                action: #selector(updateItems)
            )
        }

        updateItems()
    }

    @objc
    private func updateItems() {
        let items = (0..<9).map { number -> ListItem<DemoContext> in
            let listItem = ListItem<DemoContext>(
                id: number,
                layoutSpec: NumberLayoutSpec(model: number)
            )

            listItem.canMove = true

            listItem.didMove = { from, to in
                print("Did move item \"\(number)\" from \(from) to \(to)")
            }

            return listItem
        }

        adapter.set(items: items)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        let numberOfColumns = 3

        let size = (view.bounds.width - CGFloat(numberOfColumns + 1) * Consts.spacing) / CGFloat(numberOfColumns) - 1

        adapter.set(boundingDimensions: CGSize(width: size, height: size).layoutDimensions)
    }
}
