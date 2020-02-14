import Foundation
import UIKit
import ALLKit

final class EmojiLayoutSpec: ModelLayoutSpec<String> {
    override func makeNodeWith(boundingDimensions: LayoutDimensions<CGFloat>) -> LayoutNodeConvertible {
        let emojiText = model.attributed().font(UIFont.boldSystemFont(ofSize: 32)).make()

        return LayoutNodeBuilder().layout().body {
            LayoutNodeBuilder().layout {
                $0.alignItems(.center).justifyContent(.center).height(64).margin(.all(2))
            }.view { (view: UIView, _) in
                view.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            }.body {
                LayoutNode(sizeProvider: emojiText) { (label: UILabel, _) in
                    label.attributedText = emojiText
                }
            }
        }
    }
}
