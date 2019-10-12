import XCTest
import ALLKit

class SizeConstraintsTests: XCTestCase {
    func test1() {
        let x = SizeConstraints(width: 100)
        let y = SizeConstraints(width: 100)

        XCTAssert(x == y)
    }

    func test2() {
        let x = SizeConstraints(height: 100)
        let y = SizeConstraints(height: 100)

        XCTAssert(x == y)
    }

    func test3() {
        let x = SizeConstraints(width: 100, height: 100)
        let y = SizeConstraints(width: 100, height: 100)

        XCTAssert(x == y)
    }
}
