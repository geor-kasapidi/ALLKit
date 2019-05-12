# Async text rendering

Text SDK provided by iOS is highly optimized, but sometimes text rendering can take a lot of time.
If you have an attributed string with a large number of emoji or image attachments (ex. chat app), rendering can takes tens of milliseconds.
This is unacceptable because text views draw text in the main thread.

For drawing text in the background, ALLKit provides a special API:

1. [AttributedStringDrawing](../Sources/Support/AttributedStringDrawing.swift) - object that knows how to calculate text size and create a bitmap from text.

2. [AsyncLabel](../Sources/Support/AsyncLabel.swift) - subclass of UIView that can draw text asynchronously.

### Example of usage

```swift
final class SomeLayoutSpec: ModelLayoutSpec<String> {
    override func makeNodeFrom(model: String, sizeConstraints: SizeConstraints) -> LayoutNode {
        // make attributed string
        let string = model.attributed()
            .font(UIFont.systemFont(ofSize: 15))
            .foregroundColor(UIColor.black)
            .make()

        // make string drawing object with options and context
        let stringDrawing = string.drawing(options: .usesLineFragmentOrigin, context: nil)

        // use drawing object as size provider
        let textNode = LayoutNode(sizeProvider: stringDrawing, config: { node in
            node.margin(all: 16)
        }) { (label: AsyncLabel, _) in
            // pass drawing instance to async label
            label.stringDrawing = stringDrawing
        }

        return LayoutNode(children: [textNode])
    }
}
```

*Note*. AsyncLabel requires the right frame before drawing the text.

**RULE**. You should always draw text with the same API that calculates its size. NSAttributedString -> NSAttributedString, NSLayoutManager -> NSLayoutManager, etc.
