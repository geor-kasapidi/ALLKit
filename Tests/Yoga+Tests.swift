import XCTest
import Foundation
import UIKit
import yoga

@testable
import ALLKit

class YogaTests: XCTestCase {
    func testStability() {
        let yoga = YogaNode()

        yoga.flexDirection = .column
        XCTAssert(yoga.flexDirection == .column)

        yoga.flex = 1
        XCTAssert(yoga.flex == 1)

        yoga.flexWrap = .wrap
        XCTAssert(yoga.flexWrap == .wrap)

        yoga.flexGrow = 1
        XCTAssert(yoga.flexGrow == 1)

        yoga.flexShrink = 1
        XCTAssert(yoga.flexShrink == 1)

        yoga.flexBasis = 50%
        XCTAssert(yoga.flexBasis == 50%)

        yoga.display = .none
        XCTAssert(yoga.display == .none)

        yoga.aspectRatio = Float(4.0/3.0)
        XCTAssert(yoga.aspectRatio == Float(4.0/3.0))

        yoga.justifyContent = .center
        XCTAssert(yoga.justifyContent == .center)

        yoga.alignContent = .center
        XCTAssert(yoga.alignContent == .center)

        yoga.alignItems = .center
        XCTAssert(yoga.alignItems == .center)

        yoga.alignSelf = .stretch
        XCTAssert(yoga.alignSelf == .stretch)

        yoga.position = .absolute
        XCTAssert(yoga.position == .absolute)

        yoga.width = 100%
        XCTAssert(yoga.width == 100%)

        yoga.height = 100%
        XCTAssert(yoga.height == 100%)

        yoga.minWidth = 10
        XCTAssert(yoga.minWidth == 10)

        yoga.minHeight = 10
        XCTAssert(yoga.minHeight == 10)

        yoga.maxWidth = 1000
        XCTAssert(yoga.maxWidth == 1000)

        yoga.maxHeight = 1000
        XCTAssert(yoga.maxHeight == 1000)

        yoga.top = 5
        XCTAssert(yoga.top == 5)

        yoga.right = 5
        XCTAssert(yoga.right == 5)

        yoga.bottom = 5
        XCTAssert(yoga.bottom == 5)

        yoga.left = 5
        XCTAssert(yoga.left == 5)

        yoga.padding(all: 20)
        XCTAssert(yoga.paddingTop == 20)
        XCTAssert(yoga.paddingLeft == 20)
        XCTAssert(yoga.paddingRight == 20)
        XCTAssert(yoga.paddingBottom == 20)

        yoga.margin(all: 20)
        XCTAssert(yoga.marginTop == 20)
        XCTAssert(yoga.marginLeft == 20)
        XCTAssert(yoga.marginRight == 20)
        XCTAssert(yoga.marginBottom == 20)

        yoga.add(child: YogaNode())
            .add(child: YogaNode())

        yoga.calculateLayoutWith(width: 500, height: 500, parentDirection: .LTR)
    }

    func testNodeWithCustomMeasureFunc() {
        let yoga = YogaNode { (w, h) -> CGSize in
            return CGSize(width: w, height: 70)
        }

        yoga.calculateLayoutWith(width: 100, height: .nan, parentDirection: .LTR)

        XCTAssert(yoga.frame.width == 100)
        XCTAssert(yoga.frame.height == 70)
    }
}
