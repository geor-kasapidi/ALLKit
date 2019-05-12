import Foundation
import UIKit

typealias CellModel = (layout: Layout, listItem: ListItem)

private extension ListItem {
    func makeLayout(_ sizeConstraints: SizeConstraints) -> Layout {
        let sc = sizeConstraintsModifier?(sizeConstraints) ?? sizeConstraints

        return layoutSpec.makeLayoutWith(sizeConstraints: sc)
    }
}

private extension Array {
    mutating func move(from sourceIndex: Index, to destinationIndex: Index) {
        insert(remove(at: sourceIndex), at: destinationIndex)
    }
}

final class ListViewDataSource {
    private let internalQueue = DispatchQueue(label: "ALLKit.ListViewDataSource.internalQueue")

    private var layoutCache: [String: Layout] = [:]
    private var sizeConstraints: SizeConstraints?
    private var items: [ListItem] = []
    private var models: [CellModel] = []

    // MARK: -

    func set(newSizeConstraints: SizeConstraints, async: Bool, completion: ((Bool) -> Void)?) {
        guard newSizeConstraints != sizeConstraints else {
            completion?(false)

            return
        }

        sizeConstraints = newSizeConstraints

        let items = self.items

        if async {
            internalQueue.async {
                self.layoutCache.removeAll()

                let models = self.makeModelsFrom(items, newSizeConstraints)

                DispatchQueue.main.async {
                    self.models = models

                    completion?(true)
                }
            }
        } else {
            models = internalQueue.sync {
                self.layoutCache.removeAll()

                return self.makeModelsFrom(items, newSizeConstraints)
            }

            completion?(true)
        }
    }

    func set(newItems: [ListItem], completion: ((DiffResult?) -> Void)?) {
        let oldItems = self.items
        self.items = newItems

        guard let sizeConstraints = sizeConstraints else {
            completion?(nil)

            return
        }

        internalQueue.async {
            let diff = Diff.between(oldItems, and: newItems)

            if diff.changesCount == 0 {
                DispatchQueue.main.async {
                    completion?(nil)
                }

                return
            }

            (diff.deletes + diff.updates.map({ $0.old })).forEach { index in
                let item = oldItems[index]

                self.layoutCache[item.diffId] = nil
            }

            let models = self.makeModelsFrom(newItems, sizeConstraints)

            DispatchQueue.main.async {
                self.models = models

                completion?(diff)
            }
        }
    }

    // MARK: -

    private func makeModelsFrom(_ listItems: [ListItem],
                                _ sizeConstraints: SizeConstraints) -> [CellModel] {
        return listItems.map { listItem -> CellModel in
            if let layout = layoutCache[listItem.diffId] {
                return (layout, listItem)
            }

            let layout = listItem.makeLayout(sizeConstraints)
            layoutCache[listItem.diffId] = layout
            return (layout, listItem)
        }
    }

    // MARK: -

    func moveItem(from sourceIndex: Int, to destinationIndex: Int) {
        models.move(from: sourceIndex, to: destinationIndex)
        items.move(from: sourceIndex, to: destinationIndex)
    }

    // MARK: -

    var modelsCount: Int {
        return models.count
    }

    func model(at index: Int) -> CellModel {
        return models[index]
    }
}
