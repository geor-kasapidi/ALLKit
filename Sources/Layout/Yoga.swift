import Foundation
import CoreGraphics
import yoga

// https://yogalayout.com/docs

final class YogaNode {
    typealias MeasureFunc = (CGSize) -> CGSize

    let measureFunc: MeasureFunc?

    private var configRef: YGConfigRef!
    private var nodeRef: YGNodeRef!

    init(measureFunc: MeasureFunc? = nil) {
        self.measureFunc = measureFunc

        configRef = YGConfigNew()
        nodeRef = YGNodeNewWithConfig(configRef)

        guard self.measureFunc != nil else {
            return
        }

        YGNodeSetContext(nodeRef, Unmanaged.passUnretained(self).toOpaque())

        YGNodeSetMeasureFunc(nodeRef) { (nodeRef, width, widthMode, height, heightMode) -> YGSize in
            let node = Unmanaged<YogaNode>.fromOpaque(YGNodeGetContext(nodeRef)).takeUnretainedValue()
            let size = node.measureFunc?(CGSize(width: CGFloat(width), height: CGFloat(height))) ?? .zero
            return YGSize(width: Float(size.width), height: Float(size.height))
        }
    }

    deinit {
        YGNodeFree(nodeRef)
        YGConfigFree(configRef)
    }

    // MARK: -

    func calculateLayout(width: CGFloat?, height: CGFloat?, parentDirection: YGDirection) {
        YGNodeCalculateLayout(
            nodeRef,
            Float(width ?? .nan),
            Float(height ?? .nan),
            parentDirection
        )
    }

    // MARK: -

    private(set) var children: [YogaNode] = []

    @discardableResult
    func add(child: YogaNode) -> Self {
        children.append(child)

        YGNodeInsertChild(nodeRef, child.nodeRef, YGNodeGetChildCount(nodeRef))

        return self
    }

    // MARK: -

    func pointScale(_ value: CGFloat) {
        YGConfigSetPointScaleFactor(configRef, Float(value))
    }

    // MARK: -

    var frame: CGRect {
        CGRect(
            x: CGFloat(YGNodeLayoutGetLeft(nodeRef)),
            y: CGFloat(YGNodeLayoutGetTop(nodeRef)),
            width: CGFloat(YGNodeLayoutGetWidth(nodeRef)),
            height: CGFloat(YGNodeLayoutGetHeight(nodeRef))
        )
    }

    var flexDirection: YGFlexDirection {
        get { YGNodeStyleGetFlexDirection(nodeRef) }
        set { YGNodeStyleSetFlexDirection(nodeRef, newValue) }
    }

    var flex: Float {
        get { YGNodeStyleGetFlex(nodeRef) }
        set { YGNodeStyleSetFlex(nodeRef, newValue) }
    }

    var flexWrap: YGWrap {
        get { YGNodeStyleGetFlexWrap(nodeRef) }
        set { YGNodeStyleSetFlexWrap(nodeRef, newValue) }
    }

    var flexGrow: Float {
        get { YGNodeStyleGetFlexGrow(nodeRef) }
        set { YGNodeStyleSetFlexGrow(nodeRef, newValue) }
    }

    var flexShrink: Float {
        get { YGNodeStyleGetFlexShrink(nodeRef) }
        set { YGNodeStyleSetFlexShrink(nodeRef, newValue) }
    }

    var flexBasis: YGValue {
        get { YGNodeStyleGetFlexBasis(nodeRef) }
        set { set(nodeRef, newValue, YGNodeStyleSetFlexBasis, YGNodeStyleSetFlexBasisPercent) }
    }

    var display: YGDisplay {
        get { YGNodeStyleGetDisplay(nodeRef) }
        set { YGNodeStyleSetDisplay(nodeRef, newValue) }
    }

    var aspectRatio: Float {
        get { YGNodeStyleGetAspectRatio(nodeRef) }
        set { YGNodeStyleSetAspectRatio(nodeRef, newValue) }
    }

    var justifyContent: YGJustify {
        get { YGNodeStyleGetJustifyContent(nodeRef) }
        set { YGNodeStyleSetJustifyContent(nodeRef, newValue) }
    }

    var alignContent: YGAlign {
        get { YGNodeStyleGetAlignContent(nodeRef) }
        set { YGNodeStyleSetAlignContent(nodeRef, newValue) }
    }

    var alignItems: YGAlign {
        get { YGNodeStyleGetAlignItems(nodeRef) }
        set { YGNodeStyleSetAlignItems(nodeRef, newValue) }
    }

    var alignSelf: YGAlign {
        get { YGNodeStyleGetAlignSelf(nodeRef) }
        set { YGNodeStyleSetAlignSelf(nodeRef, newValue) }
    }

    var positionType: YGPositionType {
        get { YGNodeStyleGetPositionType(nodeRef) }
        set { YGNodeStyleSetPositionType(nodeRef, newValue) }
    }

    var width: YGValue {
        get { YGNodeStyleGetWidth(nodeRef) }
        set { set(nodeRef, newValue, YGNodeStyleSetWidth, YGNodeStyleSetWidthPercent) }
    }

    var height: YGValue {
        get { YGNodeStyleGetHeight(nodeRef) }
        set { set(nodeRef, newValue, YGNodeStyleSetHeight, YGNodeStyleSetHeightPercent) }
    }

    var minWidth: YGValue {
        get { YGNodeStyleGetMinWidth(nodeRef) }
        set { set(nodeRef, newValue, YGNodeStyleSetMinWidth, YGNodeStyleSetMinWidthPercent) }
    }

    var minHeight: YGValue {
        get { YGNodeStyleGetMinHeight(nodeRef) }
        set { set(nodeRef, newValue, YGNodeStyleSetMinHeight, YGNodeStyleSetMinHeightPercent) }
    }

    var maxWidth: YGValue {
        get { YGNodeStyleGetMaxWidth(nodeRef) }
        set { set(nodeRef, newValue, YGNodeStyleSetMaxWidth, YGNodeStyleSetMaxWidthPercent) }
    }

    var maxHeight: YGValue {
        get { YGNodeStyleGetMaxHeight(nodeRef) }
        set { set(nodeRef, newValue, YGNodeStyleSetMaxHeight, YGNodeStyleSetMaxHeightPercent) }
    }

    var top: YGValue {
        get { YGNodeStyleGetPosition(nodeRef, .top) }
        set { set(nodeRef, newValue, .top, YGNodeStyleSetPosition, YGNodeStyleSetPositionPercent) }
    }

    var right: YGValue {
        get { YGNodeStyleGetPosition(nodeRef, .right) }
        set { set(nodeRef, newValue, .right, YGNodeStyleSetPosition, YGNodeStyleSetPositionPercent) }
    }

    var bottom: YGValue {
        get { YGNodeStyleGetPosition(nodeRef, .bottom) }
        set { set(nodeRef, newValue, .bottom, YGNodeStyleSetPosition, YGNodeStyleSetPositionPercent) }
    }

    var left: YGValue {
        get { YGNodeStyleGetPosition(nodeRef, .left) }
        set { set(nodeRef, newValue, .left, YGNodeStyleSetPosition, YGNodeStyleSetPositionPercent) }
    }

    var marginTop: YGValue {
        get { YGNodeStyleGetMargin(nodeRef, .top) }
        set { set(nodeRef, newValue, .top, YGNodeStyleSetMargin, YGNodeStyleSetMarginPercent) }
    }

    var marginRight: YGValue {
        get { YGNodeStyleGetMargin(nodeRef, .right) }
        set { set(nodeRef, newValue, .right, YGNodeStyleSetMargin, YGNodeStyleSetMarginPercent) }
    }

    var marginBottom: YGValue {
        get { YGNodeStyleGetMargin(nodeRef, .bottom) }
        set { set(nodeRef, newValue, .bottom, YGNodeStyleSetMargin, YGNodeStyleSetMarginPercent) }
    }

    var marginLeft: YGValue {
        get { YGNodeStyleGetMargin(nodeRef, .left) }
        set { set(nodeRef, newValue, .left, YGNodeStyleSetMargin, YGNodeStyleSetMarginPercent) }
    }

    var paddingTop: YGValue {
        get { YGNodeStyleGetPadding(nodeRef, .top) }
        set { set(nodeRef, newValue, .top, YGNodeStyleSetPadding, YGNodeStyleSetPaddingPercent) }
    }

    var paddingRight: YGValue {
        get { YGNodeStyleGetPadding(nodeRef, .right) }
        set { set(nodeRef, newValue, .right, YGNodeStyleSetPadding, YGNodeStyleSetPaddingPercent) }
    }

    var paddingBottom: YGValue {
        get { YGNodeStyleGetPadding(nodeRef, .bottom) }
        set { set(nodeRef, newValue, .bottom, YGNodeStyleSetPadding, YGNodeStyleSetPaddingPercent) }
    }

    var paddingLeft: YGValue {
        get { YGNodeStyleGetPadding(nodeRef, .left) }
        set { set(nodeRef, newValue, .left, YGNodeStyleSetPadding, YGNodeStyleSetPaddingPercent) }
    }

    // MARK: -

    private func set(_ nodeRef: YGNodeRef,
                     _ value: YGValue,
                     _ pointSetter: (YGNodeRef?, Float) -> Void,
                     _ percentSetter: (YGNodeRef?, Float) -> Void) {
        switch value.unit {
        case .point:
            pointSetter(nodeRef, value.value)
        case .percent:
            percentSetter(nodeRef, value.value)
        @unknown default:
            assertionFailure()
        }
    }

    private func set(_ nodeRef: YGNodeRef,
                     _ value: YGValue,
                     _ edge: YGEdge,
                     _ pointSetter: (YGNodeRef?, YGEdge, Float) -> Void,
                     _ percentSetter: (YGNodeRef?, YGEdge, Float) -> Void) {
        switch value.unit {
        case .point:
            pointSetter(nodeRef, edge, value.value)
        case .percent:
            percentSetter(nodeRef, edge, value.value)
        @unknown default:
            assertionFailure()
        }
    }
}
