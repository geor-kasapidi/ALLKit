import Foundation
import UIKit

public final class ListItem: Diffable {
    private struct Model<T: Equatable>: AnyEquatable {
        let data: T

        func isEqual(to object: Any) -> Bool {
            return (object as? Model<T>)?.data == data
        }
    }

    // MARK: -

    let id: String
    let model: AnyEquatable
    let layoutSpec: LayoutSpec

    public init<T: Equatable>(id: String,
                              model: T,
                              layoutSpec: LayoutSpec) {
        self.id = id
        self.model = Model(data: model)
        self.layoutSpec = layoutSpec
    }

    public convenience init(id: String, layoutSpec: LayoutSpec) {
        self.init(id: id, model: id, layoutSpec: layoutSpec)
    }

    // MARK: - Diffable

    public var diffId: String {
        return id
    }

    public func isEqual(to object: Any) -> Bool {
        guard let other = object as? ListItem else {
            return false
        }

        if self === other {
            return true
        }

        return model.isEqual(to: other.model)
    }

    // MARK: -

    public var sizeConstraintsModifier: ((SizeConstraints) -> SizeConstraints)?
    public var swipeActions: SwipeActions?
    public var canMove: Bool = false
    public var didMove: ((Int, Int) -> Void)?
    public var didTap: ((UIView, Int) -> Void)?
    public var willShow: ((UIView, Int) -> Void)?
}
