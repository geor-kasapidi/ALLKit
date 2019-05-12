import Foundation
import UIKit
import ALLKit

final class SwitcherListLayoutSpec: ModelLayoutSpec<[String]> {
    override func makeNodeFrom(model: [String], sizeConstraints: SizeConstraints) -> LayoutNode {
        let children = model.flatMap({ title -> [LayoutNode] in
            let switcherNode = SwitcherRowLayoutSpec(model: title).makeNodeWith(sizeConstraints: sizeConstraints)

            let separatorNode = SwitcherRowSeparatorLayoutSpec().makeNodeWith(sizeConstraints: sizeConstraints)

            return [switcherNode, separatorNode]
        })

        return LayoutNode(children: children, config: { node in
            node.flexDirection = .column
        })
    }
}
