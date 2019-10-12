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

    public var sizeConstraintsModifier: ((SizeConstraints) -> SizeConstraints)?
    public var swipeActions: SwipeActions?
    public var canMove: Bool = false
    public var didMove: ((Int, Int) -> Void)?
    public var didTap: ((UIView, Int) -> Void)?
    public var willShow: ((UIView, Int) -> Void)?

    // MARK: - Hashable & Equatable

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: ListItem, rhs: ListItem) -> Bool {
        if lhs === rhs {
            return true
        }

        return lhs.id == rhs.id
    }
}
