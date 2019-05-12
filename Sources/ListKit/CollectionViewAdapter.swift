import Foundation
import UIKit

public final class CollectionViewAdapter<CollectionViewType: UICollectionView, CellType: UICollectionViewCell>: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public struct Settings {
        public var allowInteractiveMovement: Bool
        public var allowMovesInBatchUpdates: Bool
    }

    // MARK: -

    public let collectionView: CollectionViewType
    let dataSource = ListViewDataSource()
    private let cellId = UUID().uuidString

    public init(layout: UICollectionViewLayout) {
        collectionView = CollectionViewType(frame: .zero, collectionViewLayout: layout)

        if #available(iOS 10.0, *) {
            collectionView.isPrefetchingEnabled = false
        }

        if #available(iOS 11.0, *) {
            collectionView.dragInteractionEnabled = false
        }

        settings = Settings(
            allowInteractiveMovement: false,
            allowMovesInBatchUpdates: true
        )

        super.init()

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(CellType.self, forCellWithReuseIdentifier: cellId)
    }

    public convenience init(scrollDirection: UICollectionView.ScrollDirection = .vertical,
                            sectionInset: UIEdgeInsets = .zero,
                            minimumLineSpacing: CGFloat = 0,
                            minimumInteritemSpacing: CGFloat = 0) {
        let flowLayout = UICollectionViewFlowLayout()

        do {
            flowLayout.scrollDirection = scrollDirection
            flowLayout.sectionInset = sectionInset
            flowLayout.minimumLineSpacing = minimumLineSpacing
            flowLayout.minimumInteritemSpacing = minimumInteritemSpacing
            flowLayout.headerReferenceSize = .zero
            flowLayout.footerReferenceSize = .zero
        }

        self.init(layout: flowLayout)
    }

    deinit {
        collectionView.delegate = nil
        collectionView.dataSource = nil
    }

    // MARK: -

    public var settings: Settings {
        willSet {
            assert(Thread.isMainThread)
        }
    }

    public var scrollEvents = ScrollEvents() {
        willSet {
            assert(Thread.isMainThread)
        }
    }

    // MARK: -

    public func set(sizeConstraints: SizeConstraints, async: Bool = false, completion: ((Bool) -> Void)? = nil) {
        assert(Thread.isMainThread)

        dataSource.set(newSizeConstraints: sizeConstraints, async: async) { [weak self] success in
            if success {
                self?.reloadData(completion: completion)
            } else {
                completion?(false)
            }
        }
    }

    public func set(items: [ListItem], animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        assert(Thread.isMainThread)

        dataSource.set(newItems: items) { [weak self] diff in
            if let diff = diff {
                if animated {
                    self?.apply(diff: diff, completion: completion)
                } else {
                    UIView.performWithoutAnimation {
                        self?.apply(diff: diff, completion: completion)
                    }
                }
            } else {
                completion?(false)
            }
        }
    }

    // MARK: -

    private func apply(diff: DiffResult, completion: ((Bool) -> Void)?) {
        if diff.oldCount == 0 || diff.newCount == 0 {
            reloadData(completion: completion)

            return
        }

        let deletes: Set<DiffResult.Index>
        let inserts: Set<DiffResult.Index>
        let moves: [DiffResult.Move]

        if #available(iOS 11.0, *), settings.allowMovesInBatchUpdates {
            deletes = Set(diff.deletes + diff.updates.map({ $0.old }))
            inserts = Set(diff.inserts + diff.updates.map({ $0.new }))
            moves = diff.moves.filter {
                !deletes.contains($0.from) && !inserts.contains($0.to)
            }
        } else {
            deletes = Set(diff.deletes + diff.updates.map({ $0.old }) + diff.moves.map({ $0.from }))
            inserts = Set(diff.inserts + diff.updates.map({ $0.new }) + diff.moves.map({ $0.to }))
            moves = []
        }

        performBatchUpdates(deletes: deletes,
                            inserts: inserts,
                            moves: moves,
                            completion: completion)
    }

    private func reloadData(completion: ((Bool) -> Void)?) {
        collectionView.performBatchUpdates({
            collectionView.deleteSections(IndexSet(integer: 0))
            collectionView.insertSections(IndexSet(integer: 0))
        }, completion: completion)
    }

    private func performBatchUpdates(deletes: Set<DiffResult.Index>,
                                     inserts: Set<DiffResult.Index>,
                                     moves: [DiffResult.Move],
                                     completion: ((Bool) -> Void)?) {
        collectionView.performBatchUpdates({
            collectionView.deleteItems(at: deletes.map({
                IndexPath(item: $0, section: 0)
            }))

            collectionView.insertItems(at: inserts.map({
                IndexPath(item: $0, section: 0)
            }))

            moves.forEach({
                collectionView.moveItem(
                    at: IndexPath(item: $0.from, section: 0),
                    to: IndexPath(item: $0.to, section: 0)
                )
            })
        }, completion: completion)
    }

    // MARK: -

    @discardableResult
    public func setupGestureForInteractiveMovement() -> UILongPressGestureRecognizer {
        assert(Thread.isMainThread)

        return collectionView.all_addGestureRecognizer { [weak self] gesture in
            self?.handleMove(gesture)
        }
    }

    private func handleMove(_ gesture: UILongPressGestureRecognizer) {
        guard settings.allowInteractiveMovement else { return }

        switch(gesture.state) {
        case .began:
            if let indexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) {
                collectionView.beginInteractiveMovementForItem(at: indexPath)
            }
        case .changed:
            let location = gesture.location(in: collectionView)

            collectionView.updateInteractiveMovementTargetPosition(location)
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }

    // MARK: -

    public func sizeForItem(at index: Int) -> CGSize {
        assert(Thread.isMainThread)

        return dataSource.model(at: index).layout.size
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeForItem(at: indexPath.item)
    }

    // MARK: - UICollectionViewDataSource

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.modelsCount
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CellType = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CellType

        let index = indexPath.item

        let model = dataSource.model(at: index)

        let viewToAdd: UIView

        if let swipeActions = model.listItem.swipeActions {
            viewToAdd = SwipeView(contentLayout: model.layout, actions: swipeActions)
        } else {
            viewToAdd = model.layout.makeView()
        }

        if let didTap = model.listItem.didTap {
            viewToAdd.all_addGestureRecognizer { [weak viewToAdd] (_: UITapGestureRecognizer) in
                viewToAdd.flatMap({
                    didTap($0, index)
                })
            }
        }

        UIView.performWithoutAnimation {
            cell.contentView.subviews.forEach({ $0.removeFromSuperview() })
            cell.contentView.addSubview(viewToAdd)
        }

        model.listItem.willShow?(viewToAdd, index)

        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return settings.allowInteractiveMovement && dataSource.model(at: indexPath.item).listItem.canMove
    }

    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceIndex = sourceIndexPath.item
        let destinationIndex = destinationIndexPath.item

        dataSource.moveItem(from: sourceIndex, to: destinationIndex)

        dataSource.model(at: destinationIndex).listItem.didMove?(sourceIndex, destinationIndex)
    }

    // MARK: - UIScrollViewDelegate

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollEvents.didScroll?(scrollView)
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollEvents.willBeginDragging?(scrollView)
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollEvents.willEndDragging?(ScrollEvents.WillEndDraggingContext(
            scrollView: scrollView,
            velocity: velocity,
            targetContentOffset: targetContentOffset
        ))
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollEvents.didEndDragging?(ScrollEvents.DidEndDraggingContext(
            scrollView: scrollView,
            willDecelerate: decelerate
        ))
    }

    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollEvents.willBeginDecelerating?(scrollView)
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollEvents.didEndDecelerating?(scrollView)
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollEvents.didEndScrollingAnimation?(scrollView)
    }

    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        scrollEvents.didScrollToTop?(scrollView)
    }

    public func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        scrollEvents.didChangeAdjustedContentInset?(scrollView)
    }
}
