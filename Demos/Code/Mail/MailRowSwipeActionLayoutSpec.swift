import Foundation
import UIKit
import ALLKit

final class MailRowSwipeActionLayoutSpec: ModelLayoutSpec<MailRowSwipeItem> {
    override func makeNodeFrom(model: MailRowSwipeItem, sizeConstraints: SizeConstraints) -> LayoutNode {
        let imageNode = LayoutNode(config: { node in
            node.height = 24
            node.width = 24
            node.marginBottom = 4
        }) { (imageView: UIImageView, _) in
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = UIColor.white
            imageView.image = model.image.withRenderingMode(.alwaysTemplate)
        }

        let text = model.text.attributed()
            .font(UIFont.boldSystemFont(ofSize: 12))
            .foregroundColor(UIColor.white)
            .make()

        let textNode = LayoutNode(sizeProvider: text, config: nil) { (label: UILabel, _) in
            label.numberOfLines = 0
            label.attributedText = text
        }

        return LayoutNode(children: [imageNode, textNode], config: { node in
            node.flexDirection = .column
            node.alignItems = .center
            node.justifyContent = .center
        })
    }
}
