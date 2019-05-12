public final class Diff {
    private init() {}

    private final class Entry {
        var newCount: Int = 0
        var oldIndices = ArraySlice<Int>()
    }

    private struct Record {
        let entry: Entry
        var reference: Int?
    }

    private static func calculate<ModelType, KeyType: Hashable>(_ oldArray: [ModelType],
                                                                _ newArray: [ModelType],
                                                                hash: (ModelType) -> KeyType,
                                                                isEqual: (ModelType, ModelType) -> Bool) -> DiffResult {
        if oldArray.isEmpty && newArray.isEmpty {
            return DiffResult(
                oldCount: 0,
                newCount: 0,
                deletes: [],
                inserts: [],
                updates: [],
                moves: []
            )
        }

        if oldArray.isEmpty {
            return DiffResult(
                oldCount: 0,
                newCount: newArray.count,
                deletes: [],
                inserts: Array(newArray.indices),
                updates: [],
                moves: []
            )
        }

        if newArray.isEmpty {
            return DiffResult(
                oldCount: oldArray.count,
                newCount: 0,
                deletes: Array(oldArray.indices),
                inserts: [],
                updates: [],
                moves: []
            )
        }

        // -------------------------------------------------------

        var table = [KeyType: Entry]()

        var newRecords = newArray.map { object -> Record in
            let key = hash(object)

            let entry = table[key] ?? Entry()
            entry.newCount += 1
            table[key] = entry

            return Record(entry: entry, reference: nil)
        }

        var oldRecords = oldArray.enumerated().map { (index, object) -> Record in
            let key = hash(object)

            let entry = table[key] ?? Entry()
            entry.oldIndices.append(index)
            table[key] = entry

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

        var deletes: [DiffResult.Index] = []

        var offset = 0

        let deleteOffsets = oldRecords.enumerated().map { (oldIndex, oldRecord) -> Int in
            let deleteOffset = offset

            if oldRecord.reference == nil {
                deletes.append(oldIndex)

                offset += 1
            }

            return deleteOffset
        }

        // -------------------------------------------------------

        var inserts: [DiffResult.Index] = []
        var updates: [DiffResult.Update] = []
        var moves: [DiffResult.Move] = []

        offset = 0

        newRecords.enumerated().forEach { (newIndex, newRecord) in
            guard let oldIndex = newRecord.reference else {
                inserts.append(newIndex)

                offset += 1

                return
            }

            let deleteOffset = deleteOffsets[oldIndex]
            let insertOffset = offset

            let moved = (oldIndex - deleteOffset + insertOffset) != newIndex
            let updated = !isEqual(newArray[newIndex], oldArray[oldIndex])

            if updated {
                updates.append((oldIndex, newIndex))
            }

            if moved {
                moves.append((oldIndex, newIndex))
            }
        }

        // -------------------------------------------------------

        return DiffResult(
            oldCount: oldArray.count,
            newCount: newArray.count,
            deletes: deletes,
            inserts: inserts,
            updates: updates,
            moves: moves
        )
    }

    // MARK: -

    public static func between(_ oldArray: [Diffable], and newArray: [Diffable]) -> DiffResult {
        return calculate(oldArray,
                         newArray,
                         hash: { $0.diffId },
                         isEqual: { $0.isEqual(to: $1) })
    }

    public static func between<ModelType: Hashable>(_ oldArray: [ModelType], and newArray: [ModelType]) -> DiffResult {
        return calculate(oldArray,
                         newArray,
                         hash: { $0 },
                         isEqual: { $0 == $1 })
    }
}
