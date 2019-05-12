import Foundation
import UIKit
import yoga

protocol LayoutCalculator: class {
    func makeLayoutBy(spec: LayoutSpec,
                      sizeConstraints: SizeConstraints,
                      direction: UIUserInterfaceLayoutDirection) -> Layout
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
                data.views.enumerated().forEach { (index, viewData) in
                    let subview = viewData.factory.makeView()
                    subview.tag = index + 1
                    view.addSubview(subview)
                    subview.frame = viewData.frame
                    viewData.factory.config(view: subview, isNew: true)
                }
            } else {
                view.subviews.forEach { subview in
                    let index = subview.tag - 1

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
                      sizeConstraints: SizeConstraints,
                      direction: UIUserInterfaceLayoutDirection) -> Layout {
        let node = spec.makeNodeWith(sizeConstraints: sizeConstraints)

        node.yoga.calculateLayoutWith(
            width: sizeConstraints.width ?? .nan,
            height: sizeConstraints.height ?? .nan,
            parentDirection: direction == .rightToLeft ? .RTL : .LTR
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
