# Replacing target-actions with closures

ObjC target-action API has a big limitation - an object with a method marked with the @objc attribute is required.

Sometimes there is no such object. For example, when you create a view on the fly in a layout node:

```swift
final class SomeLayoutSpec: LayoutSpec {
    override func makeNodeWith(boundingDimensions: LayoutDimensions<CGFloat>) -> LayoutNode {
        return LayoutNode(...) { (view: UIView, _) in
            // add tap gesture recognizer
        }
    }
}
```

It would be nice to have an API with closures in this place. And ALLKit provides closure support for gestures and controls (available by Extended subspec):

* **Gestures**

```swift
view.all_addGestureRecognizer { (_: UITapGestureRecognizer) in

}
```

Method `all_addGestureRecognizer` is generic - you can specify any UIGestureRecognizer subclass.

* **Controls**

```swift
let button = UIButton(type: .system)

button.all_setEventHandler(for: .touchUpInside) {

}
```

Now you have all power of closures when using gestures or control events.

```swift
final class SomeLayoutSpec: LayoutSpec {
    override func makeNodeWith(boundingDimensions: LayoutDimensions<CGFloat>) -> LayoutNodeConvertible {
        return LayoutNode(...) { (view: UIView, _) in
            view.all_addGestureRecognizer({ (_: UITapGestureRecognizer) in
                // wow! swift closure!
            })
        }
    }
}
```
