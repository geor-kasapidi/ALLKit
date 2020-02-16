import Foundation
import UIKit
import ALLKit

final class AutoDiffViewController: ListViewController<UICollectionView, UICollectionViewCell> {
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
            let model = AdapterControlsModel(
                delayChanged: { [weak self] delay in
                    self?.delay = delay
                },
                movesEnabledChanged: { [weak self] movesEnabled in
                    self?.adapter.settings.allowMovesInBatchUpdates = movesEnabled
                }
            )

            let controlsView = AdapterControlsLayoutSpec(model: model)
                .makeLayoutWith(boundingDimensions: CGSize(width: 300, height: 40).layoutDimensions)
                .makeView()

            setToolbarItems([UIBarButtonItem(customView: controlsView)], animated: false)
        }

        generateItems()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setToolbarHidden(false, animated: animated)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        let numberOfColumns = 4

        let size = (view.bounds.width - CGFloat(numberOfColumns + 1) * Consts.spacing) / CGFloat(numberOfColumns) - 1

        adapter.set(boundingDimensions: CGSize(width: size, height: size).layoutDimensions)
    }

    private func generateItems() {
        let numbers = (0..<100).map { _ in Int(arc4random_uniform(100)) }

        let items = numbers.map { number -> ListItem<DemoContext> in
            let item = ListItem<DemoContext>(
                id: number,
                layoutSpec: NumberLayoutSpec(model: number)
            )

            item.context = DemoContext(
                willDisplay: { _ in
                    print("👆🏻", number)
                },
                didEndDisplaying: { _ in
                    print("👇🏻", number)
                }
            )

            return item
        }

        adapter.set(items: items)

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.generateItems()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        adapter.contextForItem(at: indexPath.item)?.willDisplay?(cell.contentView)
    }

    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        adapter.contextForItem(at: indexPath.item)?.didEndDisplaying?(cell.contentView)
    }

    private var delay: TimeInterval = 0.5
}
