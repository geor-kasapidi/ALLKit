import Foundation
import UIKit
import ALLKit

final class MovementViewController: UIViewController {
    private struct Consts {
        static let spacing: CGFloat = 4
    }

    private let adapter = CollectionViewAdapter(
        scrollDirection: .vertical,
        sectionInset: UIEdgeInsets(top: Consts.spacing, left: Consts.spacing, bottom: Consts.spacing, right: Consts.spacing),
        minimumLineSpacing: Consts.spacing,
        minimumInteritemSpacing: Consts.spacing
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            view.backgroundColor = UIColor.white

            view.addSubview(adapter.collectionView)

            adapter.collectionView.alwaysBounceVertical = true

            adapter.collectionView.backgroundColor = UIColor.white
        }

        do {
            adapter.settings.allowInteractiveMovement = true

            adapter.setupGestureForInteractiveMovement()
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
        let items = (0..<9).map { number -> ListItem in
            let listItem = ListItem(
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

        adapter.collectionView.frame = view.bounds

        let numberOfColumns = 3

        let size = (view.bounds.width - CGFloat(numberOfColumns + 1) * Consts.spacing) / CGFloat(numberOfColumns) - 1

        adapter.set(sizeConstraints: SizeConstraints(width: size, height: size))
    }
}
