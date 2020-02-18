import Foundation
import UIKit
import yoga

protocol LayoutCalculator: class {
    func makeLayoutBy(spec: LayoutSpec,
                      boundingDimensions: LayoutDimensions<CGFloat>,
                      layoutDirection: UIUserInterfaceLayoutDirection) -> Layout
}

final class FlatLayoutCalculator: LayoutCalculator {
    private struct ViewData {
        let frame: CGRect
        let factory: ViewFactory
    }

    private struct LayoutData {
        let size: CGSize
        let views: [ViewData]
    }

    private final class FlatLayout: Layout {
        let data: LayoutData

        init(_ data: LayoutData) {
            self.data = data
        }

        // MARK: - Layout

        var size: CGSize {
            return data.size
        }

        func makeContentIn(view: UIView) {
            if view.subviews.isEmpty {
                data.views.forEach { viewData in
                    let subview = viewData.factory.makeView()
                    view.addSubview(subview)
                    subview.frame = viewData.frame
                    viewData.factory.config(view: subview, isNew: true)
                }
            } else {
                view.subviews.enumerated().forEach { (index, subview) in
                    guard data.views.indices.contains(index) else {
                        return
                    }

                    let viewData = data.views[index]

                    subview.frame = viewData.frame
                    viewData.factory.config(view: subview, isNew: false)
                }
            }
        }
    }

    // MARK: -

    func makeLayoutBy(spec: LayoutSpec,
                      boundingDimensions: LayoutDimensions<CGFloat>,
                      layoutDirection: UIUserInterfaceLayoutDirection) -> Layout {
        let node = spec.makeNodeWith(boundingDimensions: boundingDimensions).layoutNode

        node.yoga.calculateLayout(
            width: Float(boundingDimensions.width.value ?? .nan),
            height: Float(boundingDimensions.height.value ?? .nan),
            parentDirection: layoutDirection == .rightToLeft ? .RTL : .LTR
        )

        let frame = node.yoga.frame
        var views: [ViewData] = []

        traverse(node: node, offset: frame.origin, views: &views)

        return FlatLayout(LayoutData(size: frame.size, views: views))
    }

    // MARK: -

    private func traverse(node: LayoutNode, offset: CGPoint, views: inout [ViewData]) {
        let frame = node.yoga.frame.offsetBy(dx: offset.x, dy: offset.y)

        if let viewFactory = node.viewFactory {
            views.append(ViewData(
                frame: frame,
                factory: viewFactory
            ))
        }

        node.children.forEach {
            traverse(node: $0, offset: frame.origin, views: &views)
        }
    }
}
