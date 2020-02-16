import Foundation
import UIKit
import yoga

public enum FlexDirection {
    case column
    case columnReverse
    case row
    case rowReverse
}

public enum FlexWrap {
    case noWrap
    case wrap
    case wrapReverse
}

public enum FlexAlign {
    case flexStart
    case center
    case flexEnd
    case stretch
    case spaceBetween
    case spaceAround
}

public enum FlexJustify {
    case flexStart
    case center
    case flexEnd
    case spaceBetween
    case spaceAround
    case spaceEvenly
}

public enum FlexValue: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = .point(CGFloat(value))
    }

    case point(CGFloat)
    case percent(Int)
}

public enum FlexDimension {
    case size(FlexValue)
    case width(FlexValue)
    case height(FlexValue)
}

public enum FlexEdge {
    case all(FlexValue)
    case vertical(FlexValue)
    case horizontal(FlexValue)
    case top(FlexValue)
    case left(FlexValue)
    case bottom(FlexValue)
    case right(FlexValue)
}

extension Array where Element == FlexDimension {
    func apply(width: (FlexValue) -> Void,
               height: (FlexValue) -> Void) {
        forEach {
            switch $0 {
            case let .size(value):
                width(value)
                height(value)
            case let .width(value):
                width(value)
            case let .height(value):
                height(value)
            }
        }
    }
}

extension Array where Element == FlexEdge {
    func apply(top: (FlexValue) -> Void,
               left: (FlexValue) -> Void,
               bottom: (FlexValue) -> Void,
               right: (FlexValue) -> Void) {
        forEach {
            switch $0 {
            case let .all(value):
                top(value)
                left(value)
                bottom(value)
                right(value)
            case let .vertical(value):
                top(value)
                bottom(value)
            case let .horizontal(value):
                left(value)
                right(value)
            case let .top(value):
                top(value)
            case let .left(value):
                left(value)
            case let .bottom(value):
                bottom(value)
            case let .right(value):
                right(value)
            }
        }
    }
}

extension FlexValue {
    var ygValue: YGValue {
        switch self {
        case let .point(value):
            return YGValue(value: Float(value), unit: .point)
        case let .percent(value):
            return YGValue(value: Float(value), unit: .percent)
        }
    }
}

extension FlexDirection {
    var ygValue: YGFlexDirection {
        switch self {
        case .column:
            return .column
        case .columnReverse:
            return .columnReverse
        case .row:
            return .row
        case .rowReverse:
            return .rowReverse
        }
    }
}

extension FlexWrap {
    var ygValue: YGWrap {
        switch self {
        case .noWrap:
            return .noWrap
        case .wrap:
            return .wrap
        case .wrapReverse:
            return .wrapReverse
        }
    }
}

extension FlexJustify {
    var ygValue: YGJustify {
        switch self {
        case .center:
            return .center
        case .flexEnd:
            return .flexEnd
        case .flexStart:
            return .flexStart
        case .spaceAround:
            return .spaceAround
        case .spaceBetween:
            return .spaceBetween
        case .spaceEvenly:
            return .spaceEvenly
        }
    }
}

extension FlexAlign {
    var ygValue: YGAlign {
        switch self {
        case .center:
            return .center
        case .flexEnd:
            return .flexEnd
        case .flexStart:
            return .flexStart
        case .spaceAround:
            return .spaceAround
        case .spaceBetween:
            return .spaceBetween
        case .stretch:
            return .stretch
        }
    }
}

extension Yoga.Config {
    static let main = Yoga.Config(pointScale: UIScreen.main.scale)
}

public final class FlexBox {
    public typealias Setup = (FlexBox) -> FlexBox

    let yoga: Yoga.Node

    init(sizeProvider: SizeProvider?, setup: Setup?, config: Yoga.Config) {
        if let sizeProvider = sizeProvider {
            yoga = Yoga.Node(config: config, measureFunc: {
                sizeProvider.calculateSize(boundedBy: $0.layoutDimensions)
            })
        } else {
            yoga = Yoga.Node(config: config, measureFunc: nil)
        }
        setup?(self)
    }

    public func isHidden(_ value: Bool) -> Self {
        yoga.display = value ? .flex : .none
        
        return self
    }

    public func isOverlay(_ value: Bool) -> Self {
        yoga.positionType = value ? .absolute : .relative

        return self
    }

    public func flex(_ value: CGFloat) -> Self {
        yoga.flex = Float(value)

        return self
    }

    public func flexGrow(_ value: CGFloat) -> Self {
        yoga.flexGrow = Float(value)

        return self
    }

    public func flexShrink(_ value: CGFloat) -> Self {
        yoga.flexShrink = Float(value)

        return self
    }

    public func aspectRatio(_ value: CGFloat) -> Self {
        yoga.aspectRatio = Float(value)

        return self
    }

    public func flexDirection(_ value: FlexDirection) -> Self {
        yoga.flexDirection = value.ygValue

        return self
    }

    public func flexWrap(_ value: FlexWrap) -> Self {
        yoga.flexWrap = value.ygValue

        return self
    }

    public func flexBasis(_ value: FlexValue) -> Self {
        yoga.flexBasis = value.ygValue

        return self
    }

    public func justifyContent(_ value: FlexJustify) -> Self {
        yoga.justifyContent = value.ygValue

        return self
    }

    public func alignContent(_ value: FlexAlign) -> Self {
        yoga.alignContent = value.ygValue

        return self
    }

    public func alignItems(_ value: FlexAlign) -> Self {
        yoga.alignItems = value.ygValue

        return self
    }

    public func alignSelf(_ value: FlexAlign) -> Self {
        yoga.alignSelf = value.ygValue

        return self
    }

    public func width(_ value: FlexValue) -> Self {
        yoga.width = value.ygValue

        return self
    }

    public func height(_ value: FlexValue) -> Self {
        yoga.height = value.ygValue

        return self
    }

    public func min(_ value: FlexDimension...) -> Self {
        value.apply(
            width: { yoga.minWidth = $0.ygValue },
            height: { yoga.minHeight = $0.ygValue }
        )

        return self
    }

    public func max(_ value: FlexDimension...) -> Self {
        value.apply(
            width: { yoga.maxWidth = $0.ygValue },
            height: { yoga.maxHeight = $0.ygValue }
        )

        return self
    }

    public func position(_ value: FlexEdge...) -> Self {
        value.apply(
            top: { yoga.top = $0.ygValue },
            left: { yoga.left = $0.ygValue },
            bottom: { yoga.bottom = $0.ygValue },
            right: { yoga.right = $0.ygValue }
        )

        return self
    }

    public func margin(_ value: FlexEdge...) -> Self {
        value.apply(
            top: { yoga.marginTop = $0.ygValue },
            left: { yoga.marginLeft = $0.ygValue },
            bottom: { yoga.marginBottom = $0.ygValue },
            right: { yoga.marginRight = $0.ygValue }
        )

        return self
    }

    public func padding(_ value: FlexEdge...) -> Self {
        value.apply(
            top: { yoga.paddingTop = $0.ygValue },
            left: { yoga.paddingLeft = $0.ygValue },
            bottom: { yoga.paddingBottom = $0.ygValue },
            right: { yoga.paddingRight = $0.ygValue }
        )

        return self
    }
}
