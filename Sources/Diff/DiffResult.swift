public struct DiffResult {
    public typealias Index = Int
    public typealias Update = (old: Index, new: Index)
    public typealias Move = (from: Index, to: Index)

    public let oldCount: Int
    public let newCount: Int

    public let deletes: [Index]
    public let inserts: [Index]
    public let updates: [Update]
    public let moves: [Move]

    public var changesCount: Int {
        return deletes.count + inserts.count + updates.count + moves.count
    }
}
