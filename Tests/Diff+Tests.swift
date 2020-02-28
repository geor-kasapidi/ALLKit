import XCTest
import ALLKit

private struct Model: Hashable {
    let id: String
    let value: String
}

private struct DiffableModel: Diffable {
    var diffId: String
    var value: String
}

class DiffTests: XCTestCase {
    func testAllInserts() {
        let result = Diff.between(Array(""), and: Array("abc"))

        var inserts: [Int] = []

        result.forEach {
            switch $0 {
            case .delete, .move, .update:
                XCTAssert(false)
            case let .insert(index):
                inserts.append(index)
            }
        }

        XCTAssert(inserts == [0,1,2])
    }

    func testAllDeletes() {
        let result = Diff.between(Array("abc"), and: Array(""))

        var deletes: [Int] = []

        result.forEach {
            switch $0 {
            case .insert, .move, .update:
                XCTAssert(false)
            case let .delete(index):
                deletes.append(index)
            }
        }

        XCTAssert(deletes == [0,1,2])
    }

    func testNoChanges1() {
        let result = Diff.between(Array(""), and: Array(""))

        XCTAssert(result.isEmpty)
    }

    func testNoChanges2() {
        let result = Diff.between(Array("abc"), and: Array("abc"))

        XCTAssert(result.isEmpty)
    }

    func testSimpleMove() {
        let result = Diff.between(Array("abc"), and: Array("acb"))

        var moves: [(Int, Int)] = []

        result.forEach {
            switch $0 {
            case .delete, .insert, .update:
                XCTAssert(false)
            case let .move(from, to):
                moves.append((from, to))
            }
        }

        XCTAssert(moves.count == 2)
        XCTAssert(moves[0].0 == 2 && moves[0].1 == 1)
        XCTAssert(moves[1].0 == 1 && moves[1].1 == 2)
    }

    func testNew() {
        let result = Diff.between(Array("abc"), and: Array("xyz"))

        var deletes = 0
        var inserts = 0

        result.forEach {
            switch $0 {
            case .update, .move:
                XCTAssert(false)
            case .delete:
                deletes += 1
            case .insert:
                inserts += 1
            }
        }

        XCTAssert(deletes == 3)
        XCTAssert(inserts == 3)
    }

    func testDiffable() {
        let m1 = DiffableModel(diffId: "1", value: "x")
        var m2 = DiffableModel(diffId: "2", value: "y")

        let x = [m1, m2]

        m2.value = "z"

        let y = [m1, m2]

        let d = Diff.between(x, and: y)

        XCTAssert(d.count == 1)
        XCTAssert(d[0] == .update(1, 1))
    }

    func testPerfomance() {
        let a1 = (0..<1000).map { _ in Int.random(in: 1..<1000) }
        let a2 = (0..<1000).map { _ in Int.random(in: 1..<1000) }

        measure {
            _ = Diff.between(a1, and: a2)
        }
    }
}
