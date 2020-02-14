# Reusable views

Let's start with an example:

```swift
struct SomeModel {
    let foo: Bool
}

final class SomeLayoutSpec: ModelLayoutSpec<SomeModel> {
    override func makeNodeWith(boundingDimensions: LayoutDimensions<CGFloat>) -> LayoutNodeConvertible {
        if model.foo {
            return LayoutNode { (imageView: UIImageView, _) in

            }
        } else {
            return LayoutNode { (label: UILabel, _) in

            }
        }
    }
}

...

let boundingDimensions = CGSize(width: UIScreen.main.bounds.width, height: .nan).layoutDimensions

let layout1 = SomeLayoutSpec(model: SomeModel(foo: true)).makeLayoutWith(boundingDimensions: boundingDimensions)
let layout2 = SomeLayoutSpec(model: SomeModel(foo: false)).makeLayoutWith(boundingDimensions: boundingDimensions)

let view = UIView()

layout1.setup(in: view)

layout2.setup(in: view)
```

The component produces a different set of views depending on the data model. When layout2 is applied to a view, nothing happens because the view has a UIImageView as a subview, and the layout requires a UILabel.

Hence the rule:

**If you want to reuse views, the output of the layouts must be the same**. Views created by different layouts should have the same order, count and types.

Or just create a view from scratch without reuse. But in this case, you will not be able to [animate](animations.md) the changes.

Reuse is a good optimization because you can divide view configuration into one-time and multiple actions:

```swift
let imageNode = LayoutNode(...) { (imageView: UIImageView, isNew) in
    if isNew /* if view is only created */ {
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.lightGray
    }

    imageView.image = model.image
}
```

Since the above process is not automatic, manual layout should be done carefully.

Fortunately, when using the CollectionViewAdapter you should not think about how the layout is applied. And you can create specs in any convenient way.
