import Foundation
import UIKit

open class LayoutSpec {
    public let layoutDirection: UIUserInterfaceLayoutDirection

    public init(layoutDirection: UIUserInterfaceLayoutDirection = .leftToRight) {
        self.layoutDirection = layoutDirection
    }

    public final func makeLayoutWith(boundingDimensions: LayoutDimensions<CGFloat>) -> Layout {
        FlatLayoutCalculator().makeLayoutBy(
            spec: self,
            boundingDimensions: boundingDimensions,
            layoutDirection: layoutDirection
        )
    }

    open func makeNodeWith(boundingDimensions: LayoutDimensions<CGFloat>) -> LayoutNodeConvertible {
        fatalError()
    }
}

open class ModelLayoutSpec<ModelType>: LayoutSpec {
    public let model: ModelType

    public init(model: ModelType, layoutDirection: UIUserInterfaceLayoutDirection = .leftToRight) {
        self.model = model

        super.init(layoutDirection: layoutDirection)
    }
}
