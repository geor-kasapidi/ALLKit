import Foundation
import UIKit

public final class ListItem<ContextType>: Hashable {
    let id: AnyHashable
    let layoutSpec: LayoutSpec

    public init<IdType: Hashable>(id: IdType, layoutSpec: LayoutSpec) {
        self.id = AnyHashable(id)
        self.layoutSpec = layoutSpec
    }

    // MARK: - Public properties

    public var context: ContextType?
    public var makeView: ((Layout, Int) -> UIView)?
    public var boundingDimensionsModifier: LayoutDimensions<CGFloat>.Modifier?
    public var canMove: Bool = false
    public var didMove: ((Int, Int) -> Void)?

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
