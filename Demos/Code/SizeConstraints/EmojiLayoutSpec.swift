import Foundation
import UIKit
import ALLKit

final class EmojiLayoutSpec: ModelLayoutSpec<String> {
    override func makeNodeFrom(model: String, sizeConstraints: SizeConstraints) -> LayoutNode {
        let emojiText = model.attributed().font(UIFont.boldSystemFont(ofSize: 32)).make()

        let emojiNode = LayoutNode(sizeProvider: emojiText, config: nil) { (label: UILabel, _) in
            label.attributedText = emojiText
        }

        let backgroundNode = LayoutNode(children: [emojiNode], config: { node in
            node.alignItems = .center
            node.justifyContent = .center
            node.height = 64
            node.margin(all: 2)
        }) { (view: UIView, _) in
            view.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        }

        return LayoutNode(children: [backgroundNode])
    }
}
