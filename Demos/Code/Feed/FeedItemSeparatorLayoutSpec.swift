import Foundation
import UIKit
import ALLKit
import yoga

final class FeedItemSeparatorLayoutSpec: LayoutSpec {
    override func makeNodeWith(sizeConstraints: SizeConstraints) -> LayoutNode {
        let topLineNode = LayoutNode(config: { node in
            node.height = YGValue(1.0/UIScreen.main.scale)
        }) { (view: UIView, _) in
            view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }

        let bottomLineCode = LayoutNode(config: { node in
            node.height = YGValue(1.0/UIScreen.main.scale)
        }) { (view: UIView, _) in
            view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }

        let backgroundNode = LayoutNode(children: [topLineNode, bottomLineCode], config: { node in
            node.flexDirection = .column
            node.justifyContent = .spaceBetween
            node.height = 8
        }) { (view: UIView, _) in
            view.backgroundColor = #colorLiteral(red: 0.9398509844, green: 0.9398509844, blue: 0.9398509844, alpha: 1)
        }

        return LayoutNode(children: [backgroundNode])
    }
}
