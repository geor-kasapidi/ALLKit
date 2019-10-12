public enum Diff {
    public enum Change: Hashable {
        public typealias Index = Int

        case delete(Index)
        case insert(Index)
        case update(Index, Index)
        case move(Index, Index)
    }

    public typealias Changes = [Change]

    private final class Entry {
        var newCount: Int = 0
        var oldIndices: ArraySlice<Int> = []
    }

    private struct Record {
        let entry: Entry
        var reference: Int?
    }

    public static func between<T: Hashable>(_ oldItems: [T], and newItems: [T]) -> Changes {
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

        var table = [T: Entry]()

        var newRecords = newItems.map { item -> Record in
            let entry = table[item] ?? Entry()
            entry.newCount += 1
            table[item] = entry

            return Record(entry: entry, reference: nil)
        }

        var oldRecords = oldItems.enumerated().map { (index, item) -> Record in
            let entry = table[item] ?? Entry()
            entry.oldIndices.append(index)
            table[item] = entry

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
            let updated = newItems[newIndex] != oldItems[oldIndex]

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
