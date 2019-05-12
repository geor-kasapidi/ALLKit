# FlexBox

[YogaNode](../Sources/FlexBox/Yoga.swift) is a swift wrapper around [Yoga](https://yogalayout.com) with automatic memory management.

[LayoutNode](basic_concepts.md) is based on YogaNode.

### Supported properties

* flexDirection, flex, flexWrap, flexGrow, flexShrink, flexBasis
* display, aspectRatio, position
* justifyContent, alignContent, alignItems, alignSelf
* width, height, minWidth, minHeight, maxWidth, maxHeight
* top, right, bottom, left
* marginTop, marginRight, marginBottom, marginLeft
* paddingTop, paddingRight, paddingBottom, paddingLeft

### Example of usage

```swift
// declare stack node

let parentNode = YogaNode()
parentNode.pointScale = UIScreen.main.scale // pixels per point for proper rounding
parentNode.flexDirection = .column
parentNode.alignItems = .center

// declare node with custom measure func

let customNode = YogaNode { (width, height) -> CGSize in
    return CGSize(width: width, height: width * 0.4)
}

customNode.pointScale = UIScreen.main.scale
customNode.marginTop = 7
customNode.maxWidth = 70%

// make nodes hierarchy

parentNode.add(child: customNode)

// calculate layout with size constraints and interface direction

parentNode.calculateLayoutWith(width: 100, height: .nan, parentDirection: .LTR)

// get node frames

print(parentNode.frame, customNode.frame)
```
