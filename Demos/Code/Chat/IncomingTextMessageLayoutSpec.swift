import Foundation
import UIKit
import ALLKit
import yoga

final class IncomingTextMessageLayoutSpec: ModelLayoutSpec<ChatMessage> {
    override func makeNodeWith(boundingDimensions: LayoutDimensions<CGFloat>) -> LayoutNodeConvertible {
        let attributedText = model.text.attributed()
            .font(.systemFont(ofSize: 14))
            .foregroundColor(UIColor.black)
            .make()
            .drawing()

        let attributedDateText = DateFormatter.localizedString(from: model.date, dateStyle: .none, timeStyle: DateFormatter.Style.short).attributed()
            .font(.italicSystemFont(ofSize: 10))
            .foregroundColor(UIColor.black.withAlphaComponent(0.6))
            .make()

        let tailNode = LayoutNode({
            $0.isOverlay(true).width(20).height(18).position(.bottom(0), .left(-6))
        }) { (imageView: UIImageView, _) in
            imageView.superview?.sendSubviewToBack(imageView)
            imageView.image = UIImage(named: "tail")?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = ChatColors.incoming
            imageView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }

        let textNode = LayoutNode(sizeProvider: attributedText, {
            $0.flexShrink(1).margin(.right(8))
        }) { (label: AsyncLabel, _) in
            label.stringDrawing = attributedText
        }

        let dateNode = LayoutNode(sizeProvider: attributedDateText) { (label: UILabel, _) in
            label.attributedText = attributedDateText
        }

        let infoNode = LayoutNode(children: [dateNode], {
            $0.margin(.bottom(2)).flexDirection(.row).alignItems(.center).alignSelf(.flexEnd)
        })

        let backgroundNode = LayoutNode(children: [textNode, tailNode, infoNode], {
            $0.flexDirection(.row).alignItems(.center).padding(.vertical(8), .horizontal(12)).margin(.left(16), .bottom(8), .right(.percent(30))).min(.height(36))
        }) { (view: UIView, _) in
            view.backgroundColor = ChatColors.incoming
            view.layer.cornerRadius = 18
        }

        return LayoutNode(children: [backgroundNode], {
            $0.alignItems(.center).flexDirection(.row)
        })
    }
}
