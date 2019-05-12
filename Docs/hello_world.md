# Spec example

![Hello, world](hello_world.png)

### Model

```swift
struct DemoLayoutModel {
    let image: UIImage
    let title: String
}
```

### Spec

```swift
final class DemoLayoutSpec: ModelLayoutSpec<DemoLayoutModel> {
    override func makeNodeFrom(model: DemoLayoutModel, sizeConstraints: SizeConstraints) -> LayoutNode {
        // Leaf node with view

        let imageNode = LayoutNode(children: [], config: { node in
            node.width = 48
            node.height = 48
        }) { (imageView: UIImageView, isNew) in
            if isNew /* if view is only created */ {
                imageView.contentMode = .scaleAspectFill
                imageView.layer.cornerRadius = 24
                imageView.layer.masksToBounds = true
                imageView.layer.borderWidth = 1
                imageView.layer.borderColor = UIColor.lightGray.cgColor
                imageView.backgroundColor = UIColor.lightGray
            }

            imageView.image = model.image
        }

        // Leaf node with size provider and view

        let titleString = NSAttributedString(
            string: model.title,
            attributes: [
                .font: UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor.black
            ]
        )

        let titleNode = LayoutNode(sizeProvider: titleString, config: { node in
            node.marginLeft = 16
        }) { (label: UILabel, _) in
            label.numberOfLines = 0
            label.attributedText = titleString
        }

        // Node with children and no view

        let contentNode = LayoutNode(children: [imageNode, titleNode], config: { node in
            node.flexDirection = .row
            node.alignItems = .center
            node.padding(all: 16)
        })

        return contentNode
    }
}
```

### Layout and view

```swift
let layoutSpec = DemoLayoutSpec(
    model: DemoLayoutModel(
        image: UIImage(named: "ive")!,
        title: "Jonathan Ive is Apple’s chief design officer, reporting to CEO Tim Cook."
    )
)

let layout = layoutSpec.makeLayoutWith(
    sizeConstraints: SizeConstraints(
        width: UIScreen.main.bounds.width,
        height: .nan
    )
)

let view = layout.makeView()
```
