import CoreGraphics

public struct LayoutDimension<T: FloatingPoint>: Equatable {
    public let value: T?

    public static func == (lhs: LayoutDimension<T>, rhs: LayoutDimension<T>) -> Bool {
        return lhs.value == nil && rhs.value == nil || lhs.value == rhs.value
    }
}

extension FloatingPoint {
    public var layoutDimension: LayoutDimension<Self> {
        LayoutDimension(value: (Self.ulpOfOne...Self.greatestFiniteMagnitude).contains(self) ? self : nil)
    }
}

public struct LayoutDimensions<T: FloatingPoint>: Equatable {
    public let width: LayoutDimension<T>
    public let height: LayoutDimension<T>

    public init(width: LayoutDimension<T>, height: LayoutDimension<T>) {
        self.width = width
        self.height = height
    }
}

extension LayoutDimensions {
    public typealias Modifier = (T, T) -> (T, T)

    public func modify(_ fn: Modifier) -> LayoutDimensions<T> {
        let (w, h) = fn(width.value ?? .nan, height.value ?? .nan)

        return LayoutDimensions(
            width: w.layoutDimension,
            height: h.layoutDimension
        )
    }
}

extension LayoutDimensions where T == CGFloat {
    var size: CGSize {
        return CGSize(
            width: width.value ?? .greatestFiniteMagnitude,
            height: height.value ?? .greatestFiniteMagnitude
        )
    }
}

extension CGSize {
    public var layoutDimensions: LayoutDimensions<CGFloat> {
        LayoutDimensions(
            width: width.layoutDimension,
            height: height.layoutDimension
        )
    }
}
