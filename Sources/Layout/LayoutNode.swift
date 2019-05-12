import Foundation
import UIKit

public final class LayoutNode {
    let children: [LayoutNode]
    let viewFactory: ViewFactory?
    let yoga: YogaNode

    public init<ViewType: UIView>(children: [LayoutNode?] = [],
                                  config: ((YogaNode) -> Void)? = nil,
                                  view: ((ViewType, Bool) -> Void)? = nil) {
        self.children = children.compactMap({ $0 })
        viewFactory = view.flatMap { GenericViewFactory($0) }
        yoga = YogaNode()
        self.children.forEach { yoga.add(child: $0.yoga) }
        yoga.pointScale = UIScreen.main.scale
        config?(yoga)
    }

    public init<ViewType: UIView>(sizeProvider: SizeProvider,
                                  config: ((YogaNode) -> Void)? = nil,
                                  view: ((ViewType, Bool) -> Void)? = nil) {
        children = []
        viewFactory = view.flatMap { GenericViewFactory($0) }
        yoga = YogaNode(measureFunc: { (width, height) -> CGSize in
            sizeProvider.calculateSize(with: SizeConstraints(width: width, height: height))
        })
        yoga.pointScale = UIScreen.main.scale
        config?(yoga)
    }
}
