import Foundation
import UIKit

public protocol LayoutNodeConvertible {
    var layoutNode: LayoutNode { get }
}

extension LayoutNode: LayoutNodeConvertible {
    public var layoutNode: LayoutNode {
        self
    }
}

public final class LayoutNode {
    let children: [LayoutNode]
    let viewFactory: ViewFactory?
    let yoga: Yoga.Node

    public init<ViewType: UIView>(children: [LayoutNodeConvertible?] = [],
                                  _ layout: FlexBox.Setup? = nil,
                                  _ LayoutNodeConvertible: ((ViewType, Bool) -> Void)? = nil) {
        self.children = children.compactMap({ $0?.layoutNode })
        viewFactory = LayoutNodeConvertible.flatMap(GenericViewFactory.init)
        yoga = FlexBox(sizeProvider: nil, setup: layout, config: .main).yoga
        self.children.forEach { yoga.add(child: $0.yoga) }
    }

    public init<ViewType: UIView>(sizeProvider: SizeProvider,
                                  _ layout: FlexBox.Setup? = nil,
                                  _ LayoutNodeConvertible: ((ViewType, Bool) -> Void)? = nil) {
        children = []
        viewFactory = LayoutNodeConvertible.flatMap(GenericViewFactory.init)
        yoga = FlexBox(sizeProvider: sizeProvider, setup: layout, config: .main).yoga
    }
}

// *******************************************************

@_functionBuilder
public struct LayoutBuilder {
    public static func buildBlock<T: LayoutNodeConvertible>(_ content: T) -> T {
        content
    }

    public static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> [LayoutNodeConvertible] where C0 : LayoutNodeConvertible, C1 : LayoutNodeConvertible {
        [c0, c1]
    }

    public static func buildBlock<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2) -> [LayoutNodeConvertible] where C0 : LayoutNodeConvertible, C1 : LayoutNodeConvertible, C2 : LayoutNodeConvertible {
        [c0, c1, c2]
    }

    public static func buildBlock<C0, C1, C2, C3>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) -> [LayoutNodeConvertible] where C0 : LayoutNodeConvertible, C1 : LayoutNodeConvertible, C2 : LayoutNodeConvertible, C3 : LayoutNodeConvertible {
        [c0, c1, c2, c3]
    }

    public static func buildBlock<C0, C1, C2, C3, C4>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) -> [LayoutNodeConvertible] where C0 : LayoutNodeConvertible, C1 : LayoutNodeConvertible, C2 : LayoutNodeConvertible, C3 : LayoutNodeConvertible, C4 : LayoutNodeConvertible {
        [c0, c1, c2, c3, c4]
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5) -> [LayoutNodeConvertible] where C0 : LayoutNodeConvertible, C1 : LayoutNodeConvertible, C2 : LayoutNodeConvertible, C3 : LayoutNodeConvertible, C4 : LayoutNodeConvertible, C5 : LayoutNodeConvertible {
        [c0, c1, c2, c3, c4, c5]
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6) -> [LayoutNodeConvertible] where C0 : LayoutNodeConvertible, C1 : LayoutNodeConvertible, C2 : LayoutNodeConvertible, C3 : LayoutNodeConvertible, C4 : LayoutNodeConvertible, C5 : LayoutNodeConvertible, C6 : LayoutNodeConvertible {
        [c0, c1, c2, c3, c4, c5, c6]
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7) -> [LayoutNodeConvertible] where C0 : LayoutNodeConvertible, C1 : LayoutNodeConvertible, C2 : LayoutNodeConvertible, C3 : LayoutNodeConvertible, C4 : LayoutNodeConvertible, C5 : LayoutNodeConvertible, C6 : LayoutNodeConvertible, C7 : LayoutNodeConvertible {
        [c0, c1, c2, c3, c4, c5, c6, c7]
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8) -> [LayoutNodeConvertible] where C0 : LayoutNodeConvertible, C1 : LayoutNodeConvertible, C2 : LayoutNodeConvertible, C3 : LayoutNodeConvertible, C4 : LayoutNodeConvertible, C5 : LayoutNodeConvertible, C6 : LayoutNodeConvertible, C7 : LayoutNodeConvertible, C8 : LayoutNodeConvertible {
        [c0, c1, c2, c3, c4, c5, c6, c7, c8]
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9) -> [LayoutNodeConvertible] where C0 : LayoutNodeConvertible, C1 : LayoutNodeConvertible, C2 : LayoutNodeConvertible, C3 : LayoutNodeConvertible, C4 : LayoutNodeConvertible, C5 : LayoutNodeConvertible, C6 : LayoutNodeConvertible, C7 : LayoutNodeConvertible, C8 : LayoutNodeConvertible, C9 : LayoutNodeConvertible {
        [c0, c1, c2, c3, c4, c5, c6, c7, c8, c9]
    }
}

// *******************************************************

public struct LayoutNodeBuilder {
    public struct SizeProviderFlexBoxStep {
        let sizeProvider: SizeProvider
        let layout: FlexBox.Setup?

        public func view<ViewType: UIView>(_ config: @escaping (ViewType, Bool) -> Void) -> SizeProviderFlexBoxViewStep<ViewType> {
            SizeProviderFlexBoxViewStep(sizeProvider: sizeProvider, layout: layout, view: config)
        }
    }

    public struct SizeProviderFlexBoxViewStep<ViewType: UIView> {
        let sizeProvider: SizeProvider
        let layout: FlexBox.Setup?
        let view: (ViewType, Bool) -> Void
    }

    public struct FlexBoxStep {
        let layout: FlexBox.Setup?

        public func view<ViewType: UIView>(_ config: @escaping (ViewType, Bool) -> Void) -> FlexBoxViewStep<ViewType> {
            FlexBoxViewStep(layout: layout, view: config)
        }

        public func body(@LayoutBuilder block: () -> LayoutNodeConvertible) -> FlexBoxViewBodyStep<UIView> {
            FlexBoxViewBodyStep(layout: layout, view: nil, children: [block()])
        }

        public func body(@LayoutBuilder block: () -> [LayoutNodeConvertible]) -> FlexBoxViewBodyStep<UIView> {
            FlexBoxViewBodyStep(layout: layout, view: nil, children: block())
        }
    }

    public struct FlexBoxViewStep<ViewType: UIView> {
        let layout: FlexBox.Setup?
        let view: (ViewType, Bool) -> Void

        public func body(@LayoutBuilder block: () -> LayoutNodeConvertible) -> FlexBoxViewBodyStep<ViewType> {
            FlexBoxViewBodyStep(layout: layout, view: view, children: [block()])
        }

        public func body(@LayoutBuilder block: () -> [LayoutNodeConvertible]) -> FlexBoxViewBodyStep<ViewType> {
            FlexBoxViewBodyStep(layout: layout, view: view, children: block())
        }
    }

    public struct FlexBoxViewBodyStep<ViewType: UIView> {
        let layout: FlexBox.Setup?
        let view: ((ViewType, Bool) -> Void)?
        let children: [LayoutNodeConvertible]
    }

    // MARK: -

    public init() {}

    public func layout(_ setup: FlexBox.Setup? = nil) -> FlexBoxStep {
        FlexBoxStep(layout: setup)
    }

    public func layout(sizeProvider: SizeProvider, _ setup: FlexBox.Setup? = nil) -> SizeProviderFlexBoxStep {
        SizeProviderFlexBoxStep(sizeProvider: sizeProvider, layout: setup)
    }
}

// *******************************************************

extension LayoutNodeBuilder.SizeProviderFlexBoxStep: LayoutNodeConvertible {
    public var layoutNode: LayoutNode {
        LayoutNode(sizeProvider: sizeProvider, layout)
    }
}

extension LayoutNodeBuilder.SizeProviderFlexBoxViewStep: LayoutNodeConvertible {
    public var layoutNode: LayoutNode {
        LayoutNode(sizeProvider: sizeProvider, layout, view)
    }
}

extension LayoutNodeBuilder.FlexBoxStep: LayoutNodeConvertible {
    public var layoutNode: LayoutNode {
        LayoutNode(children: [], layout, nil)
    }
}

extension LayoutNodeBuilder.FlexBoxViewStep: LayoutNodeConvertible {
    public var layoutNode: LayoutNode {
        LayoutNode(children: [], layout, view)
    }
}

extension LayoutNodeBuilder.FlexBoxViewBodyStep: LayoutNodeConvertible {
    public var layoutNode: LayoutNode {
        LayoutNode(children: children, layout, view)
    }
}
