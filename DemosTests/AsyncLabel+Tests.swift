import XCTest
import Foundation
import UIKit
import ALLKit

class AsyncLabelTests: XCTestCase {
    func testStability() {
        let label = AsyncLabel(frame: CGRect(x: 0, y: 0, width: 400, height: 300))

        // 20 ~ mean number of labels on screen

        (0..<20).forEach { i in
            label.stringDrawing = i % 2 == 0 ? nil : UUID().uuidString.attributed()
                .font(UIFont.boldSystemFont(ofSize: 40))
                .foregroundColor(UIColor.black)
                .make()
                .drawing()
        }

        let exp = XCTestExpectation()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1)

        XCTAssert(label.layer.contents != nil)
    }
}
