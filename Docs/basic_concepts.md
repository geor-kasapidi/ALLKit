# Basic concepts

ALLKit has 3 core entities: layout node, layout spec and layout.

## Layout node

Layout node is an atomic unit of UI - objective bridge between flexbox and UIKit.

There are 4 types of layout nodes:

|             | standard sized | custom sized |
|-------------|:--------------:|:------------:|
|    has view |        A       |       C      |
| has no view |        B       |       D      |

* **A**

```swift
LayoutNode(children: [/*...*/], {
    /* flexbox properties */
}) { (view: ViewType, isNew) in
    /* view properties */
}
```

* **B**

```swift
LayoutNode(children: [/*...*/], {
    /* flexbox properties */
})
```

* **C**

```swift
let sizeProvider: SizeProvider

LayoutNode(sizeProvider: sizeProvider, {
    /* flexbox properties */
}) { (view: ViewType, isNew) in
    /* view properties */
}
```

* **D**

```swift
let sizeProvider: SizeProvider

LayoutNode(sizeProvider: sizeProvider, {
    /* flexbox properties */
})
```

In common case (**A**, **B**) to calculate layout you need to establish relationship between nodes (make node tree) and set up their flexbox properties. But sometimes (**C**, **D**) layout algorithm needs extra information about node size. There is a special protocol for this purpose - [SizeProvider](../Sources/Layout/SizeProvider.swift). Object that implements this protocol can calculate the size based on the width and height constraints. Typical example is text - in iOS you can calculate `NSAttributedString` size using `boundingRect` method. Nodes with size providers are always leafs.

Nodes with views (**A**, **C**) has trailing closure with generic view type (you can use `UIView` and its subclasses) and special optional to use parameter `isNew`, which is true if view is only created. Views passed to the closure always have correct frame. Note, that no default views are created for nodes without user-defined views (**B**, **D**).

## Layout spec

If layout node is an atom, then layout spec is a molecule - group of atoms. Layout spec is a declarative UI component. Each component is a subclass of `LayoutSpec` or `ModelLayoutSpec`:

```swift
final class YourLayoutSpec: LayoutSpec {
    override func makeNodeWith(boundingDimensions: LayoutDimensions<CGFloat>) -> LayoutNodeConvertible {
        ...
    }
}
```

```swift
final class YourLayoutSpec: ModelLayoutSpec<SomeModel> {
    override func makeNodeWith(boundingDimensions: LayoutDimensions<CGFloat>) -> LayoutNodeConvertible {
        self.model...
    }
}
```

Layout specs have two important features: 

1. **Encapsulation** - UI building is separate from other logic.
2. **Composition** - components can be easily combined:

```swift
struct Model1 {
    ...
}

struct Model2 {
    let submodel: Model1
    ...
}

final class LayoutSpec1: ModelLayoutSpec<Model1> {
    override func makeNodeWith(boundingDimensions: LayoutDimensions<CGFloat>) -> LayoutNodeConvertible {
        ...
    }
}

final class LayoutSpec2: ModelLayoutSpec<Model2> {
    override func makeNodeWith(boundingDimensions: LayoutDimensions<CGFloat>) -> LayoutNodeConvertible {
        let node1 = LayoutSpec1(model: model.submodel).makeNodeWith(boundingDimensions: boundingDimensions)

        let node2 = LayoutNode(children: [node1])

        ...
    }
}
```

## Layout

Layout is a view stencil.

1. Spec makes layout:

```swift
let layout = layoutSpec.makeLayoutWith(
    boundingDimensions: CGSize(...).layoutDimensions
)
```

2. Layout makes view:

```swift
let view = layout.makeView() // convenience method
```

or

```swift
view.frame = CGRect(origin: .zero, size: layout.size)

layout.makeContentIn(view: view)
```

The default implementation of the `Layout` protocol creates subviews in the provided view (if no subviews), otherwise reuses existing subviews.

Methods `makeContentIn` and `makeView` must be used from main thread.

## Example

[Demo component](hello_world.md)
