import XCTest
import Foundation
import UIKit
import ALLKit

class TextBuilderTests: XCTestCase {
    func testStability() {
        let loremIpsum = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
"""

        let text = loremIpsum.attributed()
            .alignment(.center)
            .allowsDefaultTighteningForTruncation(true)
            .backgroundColor(UIColor.black)
            .baselineOffset(1)
            .baseWritingDirection(.leftToRight)
            .defaultTabInterval(10)
            .expansion(1)
            .firstLineHeadIndent(1)
            .font(UIFont.boldSystemFont(ofSize: 40))
            .foregroundColor(UIColor.white)
            .headIndent(10)
            .hyphenationFactor(1)
            .kern(3)
            .ligature(1)
            .lineBreakMode(.byWordWrapping)
            .lineHeightMultiple(2)
            .lineSpacing(10)
            .maximumLineHeight(10000)
            .minimumLineHeight(30)
            .obliqueness(3)
            .paragraphSpacing(100)
            .paragraphSpacingBefore(100)
            .shadow(offsetX: 5, offsetY: 5, blurRadius: 50, color: UIColor.white)
            .strikethroughColor(UIColor.black)
            .strikethroughStyle(1)
            .strokeColor(UIColor.red)
            .strokeWidth(1)
            .tailIndent(100)
            .underlineColor(UIColor.green)
            .underlineStyle(.patternDashDotDot)

        let mutableString = text.makeMutable()

        mutableString.append(text.make())

        let label = UILabel()
        label.attributedText = mutableString
    }
}
