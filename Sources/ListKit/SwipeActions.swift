import Foundation
import UIKit

public struct SwipeAction {
    public let layoutSpec: LayoutSpec
    public let color: UIColor
    public let perform: () -> Void

    public init(layoutSpec: LayoutSpec,
                color: UIColor,
                perform: @escaping () -> Void) {

        self.layoutSpec = layoutSpec
        self.color = color
        self.perform = perform
    }
}

public struct SwipeActions {
    public let list: [SwipeAction]
    public let size: CGFloat

    public init?(_ list: [SwipeAction], size: CGFloat = 96) {
        assert(size > 0)

        guard size.isNormal, !list.isEmpty else { return nil }

        self.list = list
        self.size = size
    }
}
