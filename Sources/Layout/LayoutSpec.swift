import Foundation
import UIKit

open class LayoutSpec {
    public let direction: UIUserInterfaceLayoutDirection

    public init(direction: UIUserInterfaceLayoutDirection = .leftToRight) {
        self.direction = direction
    }

    public final func makeLayoutWith(sizeConstraints: SizeConstraints) -> Layout {
        return FlatLayoutCalculator().makeLayoutBy(
            spec: self,
            sizeConstraints: sizeConstraints,
            direction: direction
        )
    }

    open func makeNodeWith(sizeConstraints: SizeConstraints) -> LayoutNode {
        fatalError()
    }
}

open class ModelLayoutSpec<ModelType>: LayoutSpec {
    public let model: ModelType

    public init(model: ModelType, direction: UIUserInterfaceLayoutDirection = .leftToRight) {
        self.model = model

        super.init(direction: direction)
    }

    public final override func makeNodeWith(sizeConstraints: SizeConstraints) -> LayoutNode {
        return makeNodeFrom(model: model, sizeConstraints: sizeConstraints)
    }

    open func makeNodeFrom(model: ModelType, sizeConstraints: SizeConstraints) -> LayoutNode {
        fatalError()
    }
}
