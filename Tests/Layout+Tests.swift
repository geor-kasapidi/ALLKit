import UIKit
import XCTest

@testable
import ALLKit

private class LayoutSpec1: ModelLayoutSpec<String> {
    override func makeNodeWith(boundingDimensions: LayoutDimensions<CGFloat>) -> LayoutNodeConvertible {
        let text = model.attributed()
            .font(UIFont.systemFont(ofSize: 14))
            .foregroundColor(UIColor.black)
            .make()

        return LayoutNode(sizeProvider: text) { (label: UILabel, _) in
            label.numberOfLines = 0
            label.attributedText = text
        }
    }
}

private class LayoutSpec2: LayoutSpec {
    override func makeNodeWith(boundingDimensions: LayoutDimensions<CGFloat>) -> LayoutNodeConvertible {
        let node1 = LayoutNode({
            $0.width(100).height(100)
        }) { (view: UIView, _) in }

        let node2 = LayoutNode({
            $0.width(110).height(110).margin(.left(10))
        }) { (view: UIView, _) in }

        return LayoutNode(children: [node1, node2], {
            $0.padding(.all(10)).flexDirection(.row).alignItems(.center)
        })
    }
}

private class LayoutSpec3: LayoutSpec {
    override func makeNodeWith(boundingDimensions: LayoutDimensions<CGFloat>) -> LayoutNodeConvertible {
        let viewNodes = (0..<100).map { _ in
            LayoutNode({
                $0.width(100).height(100).margin(.all(5))
            }) { (view: UIView, _) in }
        }

        let contentNode = LayoutNode(children: viewNodes, {
            $0.flexDirection(.row).padding(.all(5))
        })

        return LayoutNode(children: [contentNode])
    }
}

private class LayoutSpec5: ModelLayoutSpec<NSAttributedString?> {
    override func makeNodeWith(boundingDimensions: LayoutDimensions<CGFloat>) -> LayoutNodeConvertible {
        return LayoutNode(sizeProvider: model) { (label: UILabel, _) in
            label.numberOfLines = 0
            label.attributedText = self.model
        }
    }
}

private class LayoutSpec6: ModelLayoutSpec<(() -> Void, () -> Void)> {
    override func makeNodeWith(boundingDimensions: LayoutDimensions<CGFloat>) -> LayoutNodeConvertible {
        return LayoutNode(children: [], {
            $0.width(40).height(40)
        }) { (view: UIView, isNew) in
            if isNew {
                self.model.0()
            } else {
                self.model.1()
            }
        }
    }
}

class LayoutTests: XCTestCase {
    func testConfigView() {
        let view = UIView()

        let ls1 = LayoutSpec1(model: "abc")
        let ls2 = LayoutSpec1(model: "xyz")

        ls1.makeLayoutWith(boundingDimensions: CGSize(width: 100, height: CGFloat.nan).layoutDimensions).setup(in: view)

        let lbl1 = view.subviews.first as! UILabel

        XCTAssert(lbl1.attributedText?.string == "abc")

        ls2.makeLayoutWith(boundingDimensions: CGSize(width: 100, height: CGFloat.nan).layoutDimensions).setup(in: view)

        let lbl2 = view.subviews.first as! UILabel

        XCTAssert(lbl1 === lbl2)

        XCTAssert(lbl2.attributedText?.string == "xyz")
    }

    func testFramesAndOrigins() {
        let view = UIView()

        LayoutSpec2().makeLayoutWith(boundingDimensions: CGSize(width: .nan, height: CGFloat.nan).layoutDimensions).setup(in: view)

        XCTAssert(view.frame.size == CGSize(width: 240, height: 130))
        XCTAssert(view.subviews[0].frame == CGRect(x: 10, y: 15, width: 100, height: 100))
        XCTAssert(view.subviews[1].frame == CGRect(x: 120, y: 10, width: 110, height: 110))
    }

    func testNilText() {
        do {
            let view = UIView()

            LayoutSpec5(model: nil).makeLayoutWith(boundingDimensions: CGSize(width: .nan, height: CGFloat.nan).layoutDimensions).setup(in: view)

            let firstChild = view.subviews[0]

            XCTAssert(firstChild.frame.width == 0 && firstChild.frame.height == 0)
        }

        do {
            let view = UIView()

            let text = "qwe".attributed().font(UIFont.boldSystemFont(ofSize: 40)).make()

            LayoutSpec5(model: text).makeLayoutWith(boundingDimensions: CGSize(width: .nan, height: CGFloat.nan).layoutDimensions).setup(in: view)

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

        let layout = layoutSpec.makeLayoutWith(boundingDimensions: CGSize(width: .nan, height: CGFloat.nan).layoutDimensions)

        let view = layout.makeView()

        layout.makeContentIn(view: view)

        XCTAssert(newCount == 1)
        XCTAssert(reuseCount == 1)
    }
}
