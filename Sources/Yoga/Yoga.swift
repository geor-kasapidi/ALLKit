import Foundation
import CoreGraphics
import yoga

// https://yogalayout.com/docs

public enum Yoga {
    public typealias MeasureFunc = (CGSize) -> CGSize

    public final class Config {
        fileprivate private(set) var ref: YGConfigRef!

        public init(pointScale: CGFloat) {
            ref = YGConfigNew()
            YGConfigSetPointScaleFactor(ref, Float(pointScale))
        }

        deinit {
            YGConfigFree(ref)
        }
    }

    public final class Node {
        public let measureFunc: MeasureFunc?

        fileprivate private(set) var ref: YGNodeRef!

        public init(config: Config, measureFunc: MeasureFunc? = nil) {
            self.measureFunc = measureFunc

            ref = YGNodeNewWithConfig(config.ref)

            guard self.measureFunc != nil else {
                return
            }

            YGNodeSetContext(ref, Unmanaged.passUnretained(self).toOpaque())

            YGNodeSetMeasureFunc(ref) { (ref, width, widthMode, height, heightMode) -> YGSize in
                let node = Unmanaged<Node>.fromOpaque(YGNodeGetContext(ref)).takeUnretainedValue()
                let size = node.measureFunc?(CGSize(width: CGFloat(width), height: CGFloat(height))) ?? .zero
                return YGSize(width: Float(size.width), height: Float(size.height))
            }
        }

        deinit {
            YGNodeFree(ref)
        }

        // MARK: -

        public func calculateLayout(width: Float, height: Float, parentDirection: YGDirection) {
            YGNodeCalculateLayout(ref, width, height, parentDirection)
        }

        // MARK: -

        public private(set) var children: [Node] = []

        @discardableResult
        public func add(child: Node) -> Self {
            children.append(child)

            YGNodeInsertChild(ref, child.ref, YGNodeGetChildCount(ref))

            return self
        }

        // MARK: -

        public var frame: CGRect {
            CGRect(
                x: CGFloat(YGNodeLayoutGetLeft(ref)),
                y: CGFloat(YGNodeLayoutGetTop(ref)),
                width: CGFloat(YGNodeLayoutGetWidth(ref)),
                height: CGFloat(YGNodeLayoutGetHeight(ref))
            )
        }

        public var flexDirection: YGFlexDirection {
            get { YGNodeStyleGetFlexDirection(ref) }
            set { YGNodeStyleSetFlexDirection(ref, newValue) }
        }

        public var flex: Float {
            get { YGNodeStyleGetFlex(ref) }
            set { YGNodeStyleSetFlex(ref, newValue) }
        }

        public var flexWrap: YGWrap {
            get { YGNodeStyleGetFlexWrap(ref) }
            set { YGNodeStyleSetFlexWrap(ref, newValue) }
        }

        public var flexGrow: Float {
            get { YGNodeStyleGetFlexGrow(ref) }
            set { YGNodeStyleSetFlexGrow(ref, newValue) }
        }

        public var flexShrink: Float {
            get { YGNodeStyleGetFlexShrink(ref) }
            set { YGNodeStyleSetFlexShrink(ref, newValue) }
        }

        public var flexBasis: YGValue {
            get { YGNodeStyleGetFlexBasis(ref) }
            set { set(ref, newValue, YGNodeStyleSetFlexBasis, YGNodeStyleSetFlexBasisPercent) }
        }

        public var display: YGDisplay {
            get { YGNodeStyleGetDisplay(ref) }
            set { YGNodeStyleSetDisplay(ref, newValue) }
        }

        public var aspectRatio: Float {
            get { YGNodeStyleGetAspectRatio(ref) }
            set { YGNodeStyleSetAspectRatio(ref, newValue) }
        }

        public var justifyContent: YGJustify {
            get { YGNodeStyleGetJustifyContent(ref) }
            set { YGNodeStyleSetJustifyContent(ref, newValue) }
        }

        public var alignContent: YGAlign {
            get { YGNodeStyleGetAlignContent(ref) }
            set { YGNodeStyleSetAlignContent(ref, newValue) }
        }

        public var alignItems: YGAlign {
            get { YGNodeStyleGetAlignItems(ref) }
            set { YGNodeStyleSetAlignItems(ref, newValue) }
        }

        public var alignSelf: YGAlign {
            get { YGNodeStyleGetAlignSelf(ref) }
            set { YGNodeStyleSetAlignSelf(ref, newValue) }
        }

        public var positionType: YGPositionType {
            get { YGNodeStyleGetPositionType(ref) }
            set { YGNodeStyleSetPositionType(ref, newValue) }
        }

        public var width: YGValue {
            get { YGNodeStyleGetWidth(ref) }
            set { set(ref, newValue, YGNodeStyleSetWidth, YGNodeStyleSetWidthPercent) }
        }

        public var height: YGValue {
            get { YGNodeStyleGetHeight(ref) }
            set { set(ref, newValue, YGNodeStyleSetHeight, YGNodeStyleSetHeightPercent) }
        }

        public var minWidth: YGValue {
            get { YGNodeStyleGetMinWidth(ref) }
            set { set(ref, newValue, YGNodeStyleSetMinWidth, YGNodeStyleSetMinWidthPercent) }
        }

        public var minHeight: YGValue {
            get { YGNodeStyleGetMinHeight(ref) }
            set { set(ref, newValue, YGNodeStyleSetMinHeight, YGNodeStyleSetMinHeightPercent) }
        }

        public var maxWidth: YGValue {
            get { YGNodeStyleGetMaxWidth(ref) }
            set { set(ref, newValue, YGNodeStyleSetMaxWidth, YGNodeStyleSetMaxWidthPercent) }
        }

        public var maxHeight: YGValue {
            get { YGNodeStyleGetMaxHeight(ref) }
            set { set(ref, newValue, YGNodeStyleSetMaxHeight, YGNodeStyleSetMaxHeightPercent) }
        }

        public var top: YGValue {
            get { YGNodeStyleGetPosition(ref, .top) }
            set { set(ref, newValue, .top, YGNodeStyleSetPosition, YGNodeStyleSetPositionPercent) }
        }

        public var right: YGValue {
            get { YGNodeStyleGetPosition(ref, .right) }
            set { set(ref, newValue, .right, YGNodeStyleSetPosition, YGNodeStyleSetPositionPercent) }
        }

        public var bottom: YGValue {
            get { YGNodeStyleGetPosition(ref, .bottom) }
            set { set(ref, newValue, .bottom, YGNodeStyleSetPosition, YGNodeStyleSetPositionPercent) }
        }

        public var left: YGValue {
            get { YGNodeStyleGetPosition(ref, .left) }
            set { set(ref, newValue, .left, YGNodeStyleSetPosition, YGNodeStyleSetPositionPercent) }
        }

        public var marginTop: YGValue {
            get { YGNodeStyleGetMargin(ref, .top) }
            set { set(ref, newValue, .top, YGNodeStyleSetMargin, YGNodeStyleSetMarginPercent) }
        }

        public var marginRight: YGValue {
            get { YGNodeStyleGetMargin(ref, .right) }
            set { set(ref, newValue, .right, YGNodeStyleSetMargin, YGNodeStyleSetMarginPercent) }
        }

        public var marginBottom: YGValue {
            get { YGNodeStyleGetMargin(ref, .bottom) }
            set { set(ref, newValue, .bottom, YGNodeStyleSetMargin, YGNodeStyleSetMarginPercent) }
        }

        public var marginLeft: YGValue {
            get { YGNodeStyleGetMargin(ref, .left) }
            set { set(ref, newValue, .left, YGNodeStyleSetMargin, YGNodeStyleSetMarginPercent) }
        }

        public var paddingTop: YGValue {
            get { YGNodeStyleGetPadding(ref, .top) }
            set { set(ref, newValue, .top, YGNodeStyleSetPadding, YGNodeStyleSetPaddingPercent) }
        }

        public var paddingRight: YGValue {
            get { YGNodeStyleGetPadding(ref, .right) }
            set { set(ref, newValue, .right, YGNodeStyleSetPadding, YGNodeStyleSetPaddingPercent) }
        }

        public var paddingBottom: YGValue {
            get { YGNodeStyleGetPadding(ref, .bottom) }
            set { set(ref, newValue, .bottom, YGNodeStyleSetPadding, YGNodeStyleSetPaddingPercent) }
        }

        public var paddingLeft: YGValue {
            get { YGNodeStyleGetPadding(ref, .left) }
            set { set(ref, newValue, .left, YGNodeStyleSetPadding, YGNodeStyleSetPaddingPercent) }
        }

        // MARK: -

        private func set(_ ref: YGNodeRef,
                         _ value: YGValue,
                         _ pointSetter: (YGNodeRef?, Float) -> Void,
                         _ percentSetter: (YGNodeRef?, Float) -> Void) {
            switch value.unit {
            case .point:
                pointSetter(ref, value.value)
            case .percent:
                percentSetter(ref, value.value)
            @unknown default:
                assertionFailure()
            }
        }

        private func set(_ ref: YGNodeRef,
                         _ value: YGValue,
                         _ edge: YGEdge,
                         _ pointSetter: (YGNodeRef?, YGEdge, Float) -> Void,
                         _ percentSetter: (YGNodeRef?, YGEdge, Float) -> Void) {
            switch value.unit {
            case .point:
                pointSetter(ref, edge, value.value)
            case .percent:
                percentSetter(ref, edge, value.value)
            @unknown default:
                assertionFailure()
            }
        }
    }
}
