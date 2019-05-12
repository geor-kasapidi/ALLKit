import XCTest
import ALLKit

private struct Model: Hashable {
    let id: String
    let value: String
}

class DiffTests: XCTestCase {
    func testAllInserts() {
        let result = Diff.between(Array(""), and: Array("abc"))

        XCTAssert(result.deletes.isEmpty)
        XCTAssert(result.moves.isEmpty)
        XCTAssert(result.updates.isEmpty)
        XCTAssert(result.inserts == [0,1,2])
    }

    func testAllDeletes() {
        let result = Diff.between(Array("abc"), and: Array(""))

        XCTAssert(result.deletes == [0,1,2])
        XCTAssert(result.moves.isEmpty)
        XCTAssert(result.updates.isEmpty)
        XCTAssert(result.inserts.isEmpty)
    }

    func testNoChanges1() {
        let result = Diff.between(Array(""), and: Array(""))

        XCTAssert(result.changesCount == 0)
    }

    func testNoChanges2() {
        let result = Diff.between(Array("abc"), and: Array("abc"))

        XCTAssert(result.changesCount == 0)
    }

    func testSimpleMove() {
        let result = Diff.between(Array("abc"), and: Array("acb"))

        let m = result.moves

        XCTAssert(result.deletes.isEmpty)
        XCTAssert(m.count == 2 && m[0].from == 2 && m[0].to == 1 && m[1].from == 1 && m[1].to == 2)
        XCTAssert(result.updates.isEmpty)
        XCTAssert(result.inserts.isEmpty)
    }

    func testNew() {
        let result = Diff.between(Array("abc"), and: Array("xyz"))

        XCTAssert(result.deletes.count == 3)
        XCTAssert(result.moves.isEmpty)
        XCTAssert(result.updates.isEmpty)
        XCTAssert(result.inserts.count == 3)
    }

    func testPerfomance() {
        let a1 = (0..<1000).map { _ in Int.random(in: 1..<1000) }
        let a2 = (0..<1000).map { _ in Int.random(in: 1..<1000) }

        measure {
            _ = Diff.between(a1, and: a2)
        }
    }
}
