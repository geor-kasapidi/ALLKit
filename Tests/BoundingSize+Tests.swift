import XCTest
@testable import ALLKit

class LayoutDimensionsTests: XCTestCase {
    func test1() {
        let x = CGSize(width: 100, height: CGFloat.nan).layoutDimensions
        let y = CGSize(width: 100, height: CGFloat.nan).layoutDimensions

        XCTAssert(x == y)
    }

    func test2() {
        let x = CGSize(width: CGFloat.nan, height: 100).layoutDimensions
        let y = CGSize(width: CGFloat.nan, height: 100).layoutDimensions

        XCTAssert(x == y)
    }

    func test3() {
        let x = CGSize(width: 100, height: 100).layoutDimensions
        let y = CGSize(width: 100, height: 100).layoutDimensions

        XCTAssert(x == y)
    }

    func test4() {
        let x = LayoutDimension<CGFloat>(value: nil)
        let y = LayoutDimension<CGFloat>(value: nil)

        XCTAssert(x == y)
    }

    func test5() {
        let x = LayoutDimension<CGFloat>(value: 100)
        let y = LayoutDimension<CGFloat>(value: 100)

        XCTAssert(x == y)
    }
}
