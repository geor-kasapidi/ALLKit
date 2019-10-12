import UIKit
import XCTest

@testable
import ALLKit

private class LayoutSpec1: ModelLayoutSpec<String> {
    override func makeNodeFrom(model: String, sizeConstraints: SizeConstraints) -> LayoutNode {
        let text = model.attributed()
            .font(UIFont.systemFont(ofSize: 14))
            .foregroundColor(UIColor.black)
            .make()

        return LayoutNode(sizeProvider: text, config: nil) { (label: UILabel, _) in
            label.numberOfLines = 0
            label.attributedText = text
        }
    }
}

private class LayoutSpec2: LayoutSpec {
    override func makeNodeWith(sizeConstraints: SizeConstraints) -> LayoutNode {
        let node1 = LayoutNode(config: { node in
            node.width = 100
            node.height = 100
        }) { (view: UIView, _) in }

        let node2 = LayoutNode(config: { node in
            node.width = 110
            node.height = 110
            node.marginLeft = 10
        }) { (view: UIView, _) in }

        return LayoutNode(children: [node1, node2], config: { node in
            node.padding(all: 10)
            node.flexDirection = .row
            node.alignItems = .center
        })
    }
}

private class LayoutSpec3: LayoutSpec {
    override func makeNodeWith(sizeConstraints: SizeConstraints) -> LayoutNode {
        let viewNodes = (0..<100).map { _ in
            LayoutNode(config: { node in
                node.width = 100
                node.height = 100
                node.margin(all: 5)
            }) { (view: UIView, _) in }
        }

        let contentNode = LayoutNode(children: viewNodes, config: { node in
            node.flexDirection = .row
            node.padding(all: 5)
        })

        return LayoutNode(children: [contentNode])
    }
}

private class LayoutSpec5: ModelLayoutSpec<NSAttributedString?> {
    override func makeNodeFrom(model: NSAttributedString?, sizeConstraints: SizeConstraints) -> LayoutNode {
        return LayoutNode(sizeProvider: model, config: nil) { (label: UILabel, _) in
            label.numberOfLines = 0
            label.attributedText = model
        }
    }
}

private class LayoutSpec6: ModelLayoutSpec<(() -> Void, () -> Void)> {
    override func makeNodeFrom(model: (() -> Void, () -> Void), sizeConstraints: SizeConstraints) -> LayoutNode {
        return LayoutNode(children: [], config: { node in
            node.width = 40
            node.height = 40
        }) { (view: UIView, isNew) in
            if isNew {
                model.0()
            } else {
                model.1()
            }
        }
    }
}

class LayoutTests: XCTestCase {
    func testConfigView() {
        let view = UIView()

        let ls1 = LayoutSpec1(model: "abc")
        let ls2 = LayoutSpec1(model: "xyz")

        ls1.makeLayoutWith(sizeConstraints: SizeConstraints(width: 100)).setup(in: view)

        let lbl1 = view.subviews.first as! UILabel

        XCTAssert(lbl1.attributedText?.string == "abc")

        ls2.makeLayoutWith(sizeConstraints: SizeConstraints(width: 100)).setup(in: view)

        let lbl2 = view.subviews.first as! UILabel

        XCTAssert(lbl1 === lbl2)

        XCTAssert(lbl2.attributedText?.string == "xyz")
    }

    func testFramesAndOrigins() {
        let view = UIView()

        LayoutSpec2().makeLayoutWith(sizeConstraints: SizeConstraints()).setup(in: view)

        XCTAssert(view.frame.size == CGSize(width: 240, height: 130))
        XCTAssert(view.subviews[0].frame == CGRect(x: 10, y: 15, width: 100, height: 100))
        XCTAssert(view.subviews[1].frame == CGRect(x: 120, y: 10, width: 110, height: 110))
    }

    func testViewTags() {
        let view = UIView()

        LayoutSpec3().makeLayoutWith(sizeConstraints: SizeConstraints()).setup(in: view)

        view.subviews.enumerated().forEach { (index, subview) in
            XCTAssert(subview.tag == index + 1)
        }
    }

    func testNilText() {
        do {
            let view = UIView()

            LayoutSpec5(model: nil).makeLayoutWith(sizeConstraints: SizeConstraints()).setup(in: view)

            let firstChild = view.subviews[0]

            XCTAssert(firstChild.frame.width == 0 && firstChild.frame.height == 0)
        }

        do {
            let view = UIView()

            let text = "qwe".attributed().font(UIFont.boldSystemFont(ofSize: 40)).make()

            LayoutSpec5(model: text).makeLayoutWith(sizeConstraints: SizeConstraints()).setup(in: view)

            let firstChild = view.subviews[0]

            XCTAssert(firstChild.frame.width > 0 && firstChild.frame.height > 0)
        }
    }

    func testReuseView() {
        var newCount = 0
        var reuseCount = 0

        let layoutSpec = LayoutSpec6(model: ({
            newCount += 1
        }, {
            reuseCount += 1
        }))

        let layout = layoutSpec.makeLayoutWith(sizeConstraints: SizeConstraints())

        let view = layout.makeView()

        layout.makeContentIn(view: view)

        XCTAssert(newCount == 1)
        XCTAssert(reuseCount == 1)
    }
}
