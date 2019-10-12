import Foundation
import UIKit

private extension ListItem {
    func makeLayout(_ sizeConstraints: SizeConstraints) -> Layout {
        return layoutSpec.makeLayoutWith(sizeConstraints: sizeConstraintsModifier?(sizeConstraints) ?? sizeConstraints)
    }
}

private extension Array {
    mutating func move(from i: Index, to j: Index) {
        insert(remove(at: i), at: j)
    }
}

private func onMainThread(_ closure: @escaping () -> Void) {
    if Thread.isMainThread {
        closure()
    } else {
        DispatchQueue.main.async(execute: closure)
    }
}

typealias CellModel = (item: ListItem, layout: Layout)

private enum MakeModels {
    static func from(sizeConstraints: SizeConstraints,
                     items: [ListItem],
                     async: Bool,
                     queue: DispatchQueue,
                     completion: (([CellModel]) -> Void)?) {
        if async {
            queue.async {
                let models = items.map {
                    ($0, $0.makeLayout(sizeConstraints))
                }

                completion?(models)
            }
        } else {
            let models = queue.sync {
                return items.map {
                    ($0, $0.makeLayout(sizeConstraints))
                }
            }

            completion?(models)
        }
    }

    static func from(sizeConstraints: SizeConstraints,
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
                ($0, layouts[$0] ?? $0.makeLayout(sizeConstraints))
            }

            completion?(newModels, changes)
        }
    }
}

final class ListViewDataSource {
    private let queue = DispatchQueue(label: "ALLKit.ListViewDataSource.queue")

    private var generation: UInt64 = 0
    private var sizeConstraints = SizeConstraints()
    private var items: [ListItem] = []

    private(set) var models: [CellModel] = []

    // MARK: -

    func set(newSizeConstraints: SizeConstraints, async: Bool, completion: ((Bool) -> Void)?) {
        guard !newSizeConstraints.isEmpty, newSizeConstraints != sizeConstraints else {
            completion?(false)

            return
        }

        sizeConstraints = newSizeConstraints

        generation += 1
        let g = generation

        MakeModels.from(sizeConstraints: sizeConstraints, items: items, async: async, queue: queue) { [weak self] models in
            onMainThread {
                self.flatMap {
                    guard $0.generation == g else {
                        return
                    }

                    $0.models = models

                    completion?(true)
                }
            }
        }
    }

    func set(newItems: [ListItem], completion: ((Diff.Changes) -> Void)?) {
        let oldItems: [ListItem]

        (oldItems, items) = (items, newItems)

        guard !sizeConstraints.isEmpty else {
            completion?([])

            return
        }

        generation += 1
        let g = generation

        MakeModels.from(sizeConstraints: sizeConstraints, newItems: newItems, oldItems: oldItems, oldModels: models, queue: queue) { [weak self] (models, changes) in
            onMainThread {
                self.flatMap {
                    guard $0.generation == g else {
                        return
                    }

                    if !changes.isEmpty {
                        $0.models = models
                    }

                    completion?(changes)
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
