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
    override func makeNodeWith(boundingDimensions: LayoutDimensions<CGFloat>) -> LayoutNodeConvertible {
        let titleString = model.title.attributed()
            .font(UIFont.systemFont(ofSize: 16))
            .foregroundColor(UIColor.black)
            .make()

        // root container node
        return LayoutNodeBuilder().layout {
            $0.flexDirection(.row).alignItems(.center).padding(.all(16))
        }.body {
            // image node
            LayoutNodeBuilder().layout {
                $0.width(48).height(48)
            }.view { (imageView: UIImageView, isNew) in
                if isNew /* if view is only created */ {
                    imageView.contentMode = .scaleAspectFill
                    imageView.layer.cornerRadius = 24
                    imageView.layer.masksToBounds = true
                    imageView.layer.borderWidth = 1
                    imageView.layer.borderColor = UIColor.lightGray.cgColor
                    imageView.backgroundColor = UIColor.lightGray
                }

                imageView.image = self.model.image
            }
            // title node
            LayoutNodeBuilder().layout(sizeProvider: titleString) {
                $0.margin(.left(16))
            }.view { (label: UILabel, _) in
                label.numberOfLines = 0
                label.attributedText = titleString
            }
        }
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
    boundingDimensions: CGSize(...).layoutDimensions
)

let view = layout.makeView()
```
