import Foundation
import UIKit
import ALLKit
import yoga

final class SwitcherRowSeparatorLayoutSpec: LayoutSpec {
    override func makeNodeWith(boundingDimensions: LayoutDimensions<CGFloat>) -> LayoutNodeConvertible {
        let viewNode = LayoutNode({
            $0.height(.point(1.0/UIScreen.main.scale))
        }) { (view: UIView, isNew) in
            if isNew {
                view.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            }
        }

        return LayoutNode(children: [viewNode], {
            $0.padding(.left(16))
        })
    }
}
