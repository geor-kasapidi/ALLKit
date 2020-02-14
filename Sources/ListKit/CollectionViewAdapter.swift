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

    public func set(boundingDimensions: LayoutDimensions<CGFloat>, async: Bool = false, completion: ((Bool) -> Void)? = nil) {
        assert(Thread.isMainThread)

        dataSource.set(boundingDimensions: boundingDimensions, async: async) { [weak self] updateType in
            self?.update(type: updateType, completion)
        }
    }

    public func set(items: [ListItem], animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        assert(Thread.isMainThread)

        dataSource.set(newItems: items) { [weak self] updateType in
            if animated {
                self?.update(type: updateType, completion)
            } else {
                UIView.performWithoutAnimation {
                    self?.update(type: updateType, completion)
                }
            }
        }
    }

    // MARK: -

    private func update(type: UpdateType?, _ completion: ((Bool) -> Void)?) {
        switch type {
        case .reload:
            collectionView.performBatchUpdates({
                collectionView.deleteSections([0])
                collectionView.insertSections([0])
            }, completion: completion)
        case let .patch(changes):
            let allowMoves: Bool

            if #available(iOS 11.0, *), settings.allowMovesInBatchUpdates {
                allowMoves = true
            } else {
                allowMoves = false
            }

            var deletes: [IndexPath] = []
            var inserts: [IndexPath] = []
            var moves: [(IndexPath, IndexPath)] = []

            changes.forEach {
                switch $0 {
                case let .delete(index):
                    deletes.append([0, index])
                case let .insert(index):
                    inserts.append([0, index])
                case let .update(oldIndex, newIndex):
                    deletes.append([0, oldIndex])
                    inserts.append([0, newIndex])
                case let .move(fromIndex, toIndex):
                    if allowMoves {
                        moves.append(([0, fromIndex], [0, toIndex]))
                    } else {
                        deletes.append([0, fromIndex])
                        inserts.append([0, toIndex])
                    }
                }
            }

            collectionView.performBatchUpdates({
                collectionView.deleteItems(at: deletes)
                collectionView.insertItems(at: inserts)
                moves.forEach(collectionView.moveItem)
            }, completion: completion)
        case .none:
            completion?(false)
        }
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

    public func sizeForItem(at index: Int) -> CGSize? {
        assert(Thread.isMainThread)

        return dataSource.models[safe: index]?.layout.size
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeForItem(at: indexPath.item) ?? .zero
    }

    // MARK: - UICollectionViewDataSource

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.models.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CellType = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CellType

        let index = indexPath.item

        if let model = dataSource.models[safe: index] {
            let view: UIView

            if let swipeActions = model.item.swipeActions {
                view = SwipeView(contentLayout: model.layout, actions: swipeActions)
            } else {
                view = model.layout.makeView()
            }

            model.item.setup?(view, index)

            UIView.performWithoutAnimation {
                cell.contentView.subviews.forEach({ $0.removeFromSuperview() })
                cell.contentView.addSubview(view)
            }
        } else {
            UIView.performWithoutAnimation {
                cell.contentView.subviews.forEach({ $0.removeFromSuperview() })
            }
        }

        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        dataSource.models[safe: indexPath.item]?.item.willDisplay?(cell.contentView.subviews.first, indexPath.item)
    }

    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        dataSource.models[safe: indexPath.item]?.item.didEndDisplaying?(cell.contentView.subviews.first, indexPath.item)
    }

    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return settings.allowInteractiveMovement && dataSource.models[safe: indexPath.item]?.item.canMove ?? false
    }

    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceIndex = sourceIndexPath.item
        let destinationIndex = destinationIndexPath.item

        dataSource.moveItem(from: sourceIndex, to: destinationIndex)

        dataSource.models[safe: destinationIndex]?.item.didMove?(sourceIndex, destinationIndex)
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
