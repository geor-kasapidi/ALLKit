import Foundation
import CoreGraphics

public struct SizeConstraints: Equatable {
    public let width: CGFloat?
    public let height: CGFloat?

    public init(width: CGFloat = .nan, height: CGFloat = .nan) {
        self.width = width.isNormal && width > 0 ? width : nil
        self.height = height.isNormal && height > 0 ? height : nil
    }

    public var isEmpty: Bool {
        return width == nil && height == nil
    }

    // MARK: -

    public static func == (lhs: SizeConstraints, rhs: SizeConstraints) -> Bool {
        return isEqual(lhs.width, to: rhs.width) && isEqual(lhs.height, to: rhs.height)
    }

    private static func isEqual(_ x: CGFloat?, to y: CGFloat?) -> Bool {
        return (x == nil && y == nil) || x == y
    }
}
