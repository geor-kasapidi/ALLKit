import XCTest
import ALLKit

class UIHelpersTests: XCTestCase {
    func testSimpleEvent() {
        var result = false

        let btn = UIButton()

        btn.all_setEventHandler(for: .touchUpInside) { result = true }
        btn.sendActions(for: .touchUpInside)

        XCTAssert(result)
    }

    func testOverrideEvent() {
        var result = ""

        let btn = UIButton()

        btn.all_setEventHandler(for: .touchUpInside) { result.append("a") }
        btn.sendActions(for: .touchUpInside)

        btn.all_setEventHandler(for: .touchUpInside) { result.append("b") }
        btn.sendActions(for: .touchUpInside)

        XCTAssert(result == "ab")
    }

    func testCombinedEvents() {
        var result = ""

        let btn = UIButton()

        btn.all_setEventHandler(for: .touchUpInside) { result.append("a") }
        btn.all_setEventHandler(for: .touchUpOutside) { result.append("b") }
        btn.all_setEventHandler(for: [.touchUpInside, .touchUpOutside]) { result.append("c") }

        btn.sendActions(for: .touchUpInside)
        btn.sendActions(for: .touchUpOutside)

        XCTAssert(result == "acbc")
    }
}
