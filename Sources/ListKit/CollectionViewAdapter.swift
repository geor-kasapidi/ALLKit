import Foundation
import UIKit

public final class CollectionViewAdapter<CollectionViewType: UICollectionView, CellType: UICollectionViewCell, ContextType>: NSObject, UICollectionViewDataSource {
    public struct Settings {
        public var allowInteractiveMovement: Bool
        public var allowMovesInBatchUpdates: Bool
    }

    public let collectionView: CollectionViewType
    let dataSource = ListViewDataSource<ContextType>()
    private let cellId = UUID().uuidString

    public required init(layout: UICollectionViewLayout) {
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

        collectionView.dataSource = self

        collectionView.register(CellType.self, forCellWithReuseIdentifier: cellId)
    }

    deinit {
        collectionView.delegate = nil
        collectionView.dataSource = nil
    }

    // MARK: - Public API

    public var settings: Settings {
        willSet {
            assert(Thread.isMainThread)
        }
    }

    public func contextForItem(at index: Int) -> ContextType? {
        assert(Thread.isMainThread)

        return dataSource.models[safe: index]?.item.context
    }

    public func sizeForItem(at index: Int) -> CGSize? {
        assert(Thread.isMainThread)

        return dataSource.models[safe: index]?.layout.size
    }

    public func set(boundingDimensions: LayoutDimensions<CGFloat>, async: Bool = false, completion: ((Bool) -> Void)? = nil) {
        assert(Thread.isMainThread)

        dataSource.set(boundingDimensions: boundingDimensions, async: async) { [weak self] updateType in
            self?.update(type: updateType, completion)
        }
    }

    public func set(items: [ListItem<ContextType>], animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
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

    public func handleMoveGesture<T: UIGestureRecognizer>(_ g: T) {
        guard settings.allowInteractiveMovement else { return }

        switch(g.state) {
        case .began:
            if let indexPath = collectionView.indexPathForItem(at: g.location(in: collectionView)) {
                collectionView.beginInteractiveMovementForItem(at: indexPath)
            }
        case .changed:
            let location = g.location(in: collectionView)

            collectionView.updateInteractiveMovementTargetPosition(location)
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }

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

    // MARK: - UICollectionViewDataSource

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.models.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CellType = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CellType

        let index = indexPath.item

        let view: UIView?

        if let model = dataSource.models[safe: index] {
            view = model.item.makeView?(model.layout, index) ?? model.layout.makeView()
        } else {
            view = nil
        }

        UIView.performWithoutAnimation {
            cell.contentView.subviews.forEach({ $0.removeFromSuperview() })
            view.flatMap(cell.contentView.addSubview(_:))
        }

        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        settings.allowInteractiveMovement && dataSource.models[safe: indexPath.item]?.item.canMove ?? false
    }

    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceIndex = sourceIndexPath.item
        let destinationIndex = destinationIndexPath.item

        dataSource.moveItem(from: sourceIndex, to: destinationIndex)

        dataSource.models[safe: destinationIndex]?.item.didMove?(sourceIndex, destinationIndex)
    }
}
