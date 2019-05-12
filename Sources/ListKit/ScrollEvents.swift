import Foundation
import UIKit

public struct ScrollEvents {
    public struct WillEndDraggingContext {
        public let scrollView: UIScrollView
        public let velocity: CGPoint
        public let targetContentOffset: UnsafeMutablePointer<CGPoint>
    }

    public struct DidEndDraggingContext {
        public let scrollView: UIScrollView
        public let willDecelerate: Bool
    }

    public var didScroll: ((UIScrollView) -> Void)?
    public var willBeginDragging: ((UIScrollView) -> Void)?
    public var willEndDragging: ((WillEndDraggingContext) -> Void)?
    public var didEndDragging: ((DidEndDraggingContext) -> Void)?
    public var willBeginDecelerating: ((UIScrollView) -> Void)?
    public var didEndDecelerating: ((UIScrollView) -> Void)?
    public var didEndScrollingAnimation: ((UIScrollView) -> Void)?
    public var didScrollToTop: ((UIScrollView) -> Void)?
    public var didChangeAdjustedContentInset: ((UIScrollView) -> Void)?
}
