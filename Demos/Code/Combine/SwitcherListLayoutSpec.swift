import Foundation
import UIKit
import ALLKit

final class SwitcherListLayoutSpec: ModelLayoutSpec<[String]> {
    override func makeNodeWith(boundingDimensions: LayoutDimensions<CGFloat>) -> LayoutNodeConvertible {
        let children = model.flatMap({ title -> [LayoutNodeConvertible] in
            let switcherNode = SwitcherRowLayoutSpec(model: title).makeNodeWith(boundingDimensions: boundingDimensions)

            let separatorNode = SwitcherRowSeparatorLayoutSpec().makeNodeWith(boundingDimensions: boundingDimensions)

            return [switcherNode, separatorNode]
        })

        return LayoutNodeBuilder().layout {
            $0.flexDirection(.column)
        }.body {
            children
        }
    }
}
