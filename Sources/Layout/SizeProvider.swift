import Foundation
import CoreGraphics

public protocol SizeProvider {
    func calculateSize(with constraints: SizeConstraints) -> CGSize
}

extension Optional: SizeProvider where Wrapped: SizeProvider {
    public func calculateSize(with constraints: SizeConstraints) -> CGSize {
        switch self {
        case .none:
            return .zero
        case .some(let provider):
            return provider.calculateSize(with: constraints)
        }
    }
}
