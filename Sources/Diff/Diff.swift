public protocol Diffable: Equatable {
    associatedtype IdType: Hashable

    var diffId: IdType { get }
}

public enum Diff {
    public enum Change: Hashable {
        public typealias Index = Int

        case delete(Index)
        case insert(Index)
        case update(Index, Index)
        case move(Index, Index)
    }

    public typealias Changes = [Change]

    public static func between<T: Diffable>(_ oldItems: [T], and newItems: [T]) -> Changes {
        between(
            oldItems: oldItems,
            newItems: newItems,
            getId: { $0.diffId },
            isEqual: { $0 == $1 }
        )
    }

    public static func between<T: Hashable>(_ oldItems: [T], and newItems: [T]) -> Changes {
        between(
            oldItems: oldItems,
            newItems: newItems,
            getId: { $0 },
            isEqual: { $0 == $1 }
        )
    }

    // MARK: - Private

    private final class Entry {
        var newCount: Int = 0
        var oldIndices: ArraySlice<Int> = []
    }

    private struct Record {
        let entry: Entry
        var reference: Int?
    }

    private static func between<IdType: Hashable, ModelType>(oldItems: [ModelType],
                                                             newItems: [ModelType],
                                                             getId: (ModelType) -> IdType,
                                                             isEqual: (ModelType, ModelType) -> Bool) -> Changes {
        if oldItems.isEmpty && newItems.isEmpty {
            return []
        }

        if oldItems.isEmpty {
            return newItems.indices.map(Change.insert)
        }

        if newItems.isEmpty {
            return oldItems.indices.map(Change.delete)
        }

        // -------------------------------------------------------

        var table = [IdType: Entry]()

        var newRecords = newItems.map { item -> Record in
            let id = getId(item)

            let entry = table[id] ?? Entry()
            entry.newCount += 1
            table[id] = entry

            return Record(entry: entry, reference: nil)
        }

        var oldRecords = oldItems.enumerated().map { (index, item) -> Record in
            let id = getId(item)

            let entry = table[id] ?? Entry()
            entry.oldIndices.append(index)
            table[id] = entry

            return Record(entry: entry, reference: nil)
        }

        table.removeAll()

        // -------------------------------------------------------

        newRecords.enumerated().forEach { (newIndex, newRecord) in
            let entry = newRecord.entry

            guard entry.newCount > 0, let oldIndex = entry.oldIndices.popFirst() else {
                return
            }

            newRecords[newIndex].reference = oldIndex
            oldRecords[oldIndex].reference = newIndex
        }

        // -------------------------------------------------------

        var changes: [Change] = []

        var offset = 0

        let deleteOffsets = oldRecords.enumerated().map { (oldIndex, oldRecord) -> Int in
            let deleteOffset = offset

            if oldRecord.reference == nil {
                changes.append(.delete(oldIndex))

                offset += 1
            }

            return deleteOffset
        }

        // -------------------------------------------------------

        offset = 0

        newRecords.enumerated().forEach { (newIndex, newRecord) in
            guard let oldIndex = newRecord.reference else {
                changes.append(.insert(newIndex))

                offset += 1

                return
            }

            let deleteOffset = deleteOffsets[oldIndex]
            let insertOffset = offset

            let moved = (oldIndex - deleteOffset + insertOffset) != newIndex
            let updated = !isEqual(newItems[newIndex], oldItems[oldIndex])

            if updated {
                changes.append(.update(oldIndex, oldIndex))
            } else if moved {
                changes.append(.move(oldIndex, newIndex))
            }
        }

        // -------------------------------------------------------

        return changes
    }
}
