import Foundation
import UIKit

public final class ListItem: Hashable {
    let id: AnyHashable
    let layoutSpec: LayoutSpec

    public init<T: Hashable>(id: T, layoutSpec: LayoutSpec) {
        self.id = AnyHashable(id)
        self.layoutSpec = layoutSpec
    }

    // MARK: - Public properties

    public var boundingDimensionsModifier: LayoutDimensions<CGFloat>.Modifier?
    public var swipeActions: SwipeActions?
    public var setup: ((UIView, Int) -> Void)?
    public var canMove: Bool = false
    public var didMove: ((Int, Int) -> Void)?
    public var willDisplay: ((UIView?, Int) -> Void)?
    public var didEndDisplaying: ((UIView?, Int) -> Void)?

    // MARK: - Hashable & Equatable

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: ListItem, rhs: ListItem) -> Bool {
        return lhs === rhs ? true : lhs.id == rhs.id
    }
}

extension ListItem {
    func makeLayoutWith(_ dimensions: LayoutDimensions<CGFloat>) -> Layout {
        layoutSpec.makeLayoutWith(boundingDimensions: boundingDimensionsModifier.flatMap(dimensions.modify) ?? dimensions)
    }
}
