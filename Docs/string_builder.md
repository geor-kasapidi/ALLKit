# Building attributed strings

NSAttributedString = text + display rules.

This is very important entity, but the API provided by iOS SDK is not very convenient.

Typical example:

```swift
let ps = NSMutableParagraphStyle()
ps.alignment = .center
ps.lineSpacing = 4
ps.lineBreakMode = .byTruncatingMiddle

let s = NSAttributedString(
    string: "some text",
    attributes: [
        .font: UIFont.systemFont(ofSize: 15),
        .foregroundColor: UIColor.black,
        .paragraphStyle: ps
    ]
)
```

Separation of properties into attributes and paragraph style complicates the creation of NSAttributedStrings.

[AttributedStringBuilder](../Sources/StringBuilder/AttributedStringBuilder.swift) solves this problem (available by StringBuilder subspec):

```swift
let s = "some text".attributed()
    .font(UIFont.systemFont(ofSize: 15))
    .foregroundColor(UIColor.black)
    .alignment(.center)
    .lineSpacing(4)
    .lineBreakMode(.byTruncatingMiddle)
    .make() // or makeMutable()
```
