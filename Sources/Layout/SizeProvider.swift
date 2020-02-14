import Foundation
import CoreGraphics

public protocol SizeProvider {
    func calculateSize(boundedBy dimensions: LayoutDimensions<CGFloat>) -> CGSize
}

extension Optional: SizeProvider where Wrapped: SizeProvider {
    public func calculateSize(boundedBy dimensions: LayoutDimensions<CGFloat>) -> CGSize {
        switch self {
        case .none:
            return .zero
        case let .some(provider):
            return provider.calculateSize(boundedBy: dimensions)
        }
    }
}
