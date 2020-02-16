import XCTest
import Foundation
import UIKit

@testable
import ALLKit

private class TestLayoutSpec: LayoutSpec {
    override func makeNodeWith(boundingDimensions: LayoutDimensions<CGFloat>) -> LayoutNodeConvertible {
        return LayoutNode()
    }
}

private struct TestModel: Equatable {
    let id: String
    let value: Int
}

class ListItemTests: XCTestCase {
    func testEquality() {
        let m1 = TestModel(id: "1", value: 100)
        let m2 = TestModel(id: "2", value: 200)
        let m3 = TestModel(id: "1", value: 100)

        let item1 = ListItem<Void>(id: m1.id, layoutSpec: TestLayoutSpec())
        let item2 = ListItem<Void>(id: m2.id, layoutSpec: TestLayoutSpec())
        let item3 = ListItem<Void>(id: m3.id, layoutSpec: TestLayoutSpec())

        XCTAssert(item1 == item3)
        XCTAssert(item3 == item1)
        XCTAssert(item1 != item2)
        XCTAssert(item3 != item2)
    }
}
