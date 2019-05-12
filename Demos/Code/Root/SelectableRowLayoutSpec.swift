import Foundation
import UIKit
import ALLKit
import yoga

final class SelectableRowLayoutSpec: ModelLayoutSpec<String> {
    override func makeNodeFrom(model: String, sizeConstraints: SizeConstraints) -> LayoutNode {
        let attributedText = model.attributed()
            .font(.systemFont(ofSize: 14))
            .foregroundColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            .make()
            .drawing()

        let textNode = LayoutNode(sizeProvider: attributedText, config: { node in
            node.flex = 1
        }) { (label: AsyncLabel, _) in
            label.stringDrawing = attributedText
        }

        let arrowNode = LayoutNode(config: { node in
            node.width = 24
            node.height = 24
            node.marginLeft = 6
        }) { (imageView: UIImageView, _) in
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            imageView.image = UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate)
        }

        let contentStackNode = LayoutNode(children: [textNode, arrowNode], config: { node in
            node.padding(top: 12, left: 16, bottom: 12, right: 8)
            node.flexDirection = .row
            node.alignItems = .center
            node.justifyContent = .spaceBetween
        })

        let separatorNode = LayoutNode(config: { node in
            node.height = YGValue(1.0/UIScreen.main.scale)
            node.marginLeft = 16
        }) { (view: UIView, _) in
            view.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }

        let mainStackNode = LayoutNode(children: [contentStackNode, separatorNode], config: { node in
            node.flexDirection = .column
        })

        return mainStackNode
    }
}
