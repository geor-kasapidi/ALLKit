import Foundation
import UIKit
import ALLKit

final class MailRowSwipeActionLayoutSpec: ModelLayoutSpec<MailRowSwipeItem> {
    override func makeNodeWith(boundingDimensions: LayoutDimensions<CGFloat>) -> LayoutNodeConvertible {
        let text = model.text.attributed()
            .font(UIFont.boldSystemFont(ofSize: 12))
            .foregroundColor(UIColor.white)
            .make()

        return LayoutNodeBuilder().layout {
            $0.flexDirection(.column).alignItems(.center).justifyContent(.center)
        }.body {
            LayoutNodeBuilder().layout {
                $0.height(24).width(24).margin(.bottom(4))
            }.view { (imageView: UIImageView, _) in
                imageView.contentMode = .scaleAspectFit
                imageView.tintColor = UIColor.white
                imageView.image = self.model.image.withRenderingMode(.alwaysTemplate)
            }
            LayoutNode(sizeProvider: text) { (label: UILabel, _) in
                label.numberOfLines = 0
                label.attributedText = text
            }
        }
    }
}
