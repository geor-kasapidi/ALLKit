import Foundation
import UIKit

typealias CellModel = (item: ListItem, layout: Layout)

private enum MakeModels {
    static func from(boundingDimensions: LayoutDimensions<CGFloat>,
                     items: [ListItem],
                     async: Bool,
                     queue: DispatchQueue,
                     completion: (([CellModel]) -> Void)?) {
        if async {
            queue.async {
                let models = items.map {
                    ($0, $0.makeLayoutWith(boundingDimensions))
                }

                completion?(models)
            }
        } else {
            let models = queue.sync {
                return items.map {
                    ($0, $0.makeLayoutWith(boundingDimensions))
                }
            }

            completion?(models)
        }
    }

    static func from(boundingDimensions: LayoutDimensions<CGFloat>,
                     newItems: [ListItem],
                     oldItems: [ListItem],
                     oldModels: [CellModel],
                     queue: DispatchQueue,
                     completion: (([CellModel], Diff.Changes) -> Void)?) {
        queue.async {
            let changes = Diff.between(oldItems, and: newItems)

            if changes.isEmpty {
                completion?([], [])

                return
            }

            var layouts = oldModels.reduce(into: [ListItem: Layout]()) {
                $0[$1.item] = $1.layout
            }

            changes.forEach {
                switch $0 {
                case let .delete(index):
                    layouts[oldItems[index]] = nil
                case let .update(index, _):
                    layouts[oldItems[index]] = nil
                case .insert, .move:
                    break
                }
            }

            let newModels = newItems.map {
                ($0, layouts[$0] ?? $0.makeLayoutWith(boundingDimensions))
            }

            completion?(newModels, changes)
        }
    }
}

enum UpdateType {
    case reload
    case patch(Diff.Changes)
}

final class ListViewDataSource {
    private let queue = DispatchQueue(label: "ALLKit.ListViewDataSource.queue")

    private var generation: UInt64 = 0
    private var boundingDimensions: LayoutDimensions<CGFloat>?
    private var items: [ListItem] = []

    private(set) var models: [CellModel] = []

    // MARK: -

    func set(boundingDimensions: LayoutDimensions<CGFloat>, async: Bool, completion: ((UpdateType?) -> Void)?) {
        guard boundingDimensions != self.boundingDimensions else {
            completion?(nil)

            return
        }

        self.boundingDimensions = boundingDimensions

        generation += 1
        let g = generation

        MakeModels.from(boundingDimensions: boundingDimensions, items: items, async: async, queue: queue) { [weak self] models in
            onMainThread {
                guard let self = self else { return }

                guard self.generation == g else {
                    completion?(nil)

                    return
                }

                self.models = models

                completion?(.reload)
            }
        }
    }

    func set(newItems: [ListItem], completion: ((UpdateType?) -> Void)?) {
        let oldItems: [ListItem]

        (oldItems, items) = (items, newItems)

        guard let boundingDimensions = boundingDimensions else {
            completion?(nil)

            return
        }

        generation += 1
        let g = generation

        MakeModels.from(boundingDimensions: boundingDimensions, newItems: newItems, oldItems: oldItems, oldModels: models, queue: queue) { [weak self] (models, changes) in
            onMainThread {
                guard let self = self else { return }

                guard self.generation == g, !changes.isEmpty else {
                    completion?(nil)

                    return
                }

                let wasEmpty = self.models.isEmpty

                self.models = models

                if wasEmpty || models.isEmpty {
                    completion?(.reload)
                } else {
                    completion?(.patch(changes))
                }
            }
        }
    }

    func moveItem(from i: Int, to j: Int) {
        guard items.count == models.count else {
            return
        }

        models.move(from: i, to: j)
        items.move(from: i, to: j)
    }
}
