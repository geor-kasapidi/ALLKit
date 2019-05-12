import Foundation
import UIKit
import ALLKit
import yoga

final class SwitcherRowSeparatorLayoutSpec: LayoutSpec {
    override func makeNodeWith(sizeConstraints: SizeConstraints) -> LayoutNode {
        let viewNode = LayoutNode(config: { node in
            node.height = YGValue(1.0/UIScreen.main.scale)
        }) { (view: UIView, isNew) in
            if isNew {
                view.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            }
        }

        return LayoutNode(children: [viewNode], config: { node in
            node.paddingLeft = 16
        })
    }
}
