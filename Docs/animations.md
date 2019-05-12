# Animations

When you apply a layout to view with existing subviews, you change their frames and other properties that you specified in the configuration block.

To animate the changes, simply do this in the animation block:

```swift
let layout: Layout = ...
let view: UIView = ...

UIView.animate(withDuration: 0.5) {
    layout.setup(in: view)
}
```
