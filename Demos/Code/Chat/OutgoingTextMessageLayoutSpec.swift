import Foundation
import UIKit
import ALLKit

final class OutgoingTextMessageLayoutSpec: ModelLayoutSpec<ChatMessage> {
    override func makeNodeWith(boundingDimensions: LayoutDimensions<CGFloat>) -> LayoutNodeConvertible {
        let attributedText = model.text.attributed()
            .font(.systemFont(ofSize: 14))
            .foregroundColor(UIColor.white)
            .make()
            .drawing()

        let attributedDateText = DateFormatter.localizedString(from: model.date, dateStyle: .none, timeStyle: DateFormatter.Style.short).attributed()
            .font(.italicSystemFont(ofSize: 10))
            .foregroundColor(UIColor.white)
            .make()

        let tailNode = LayoutNode({
            $0.isOverlay(true).width(20).height(20).position(.bottom(0), .right(-6))
        }) { (imageView: UIImageView, _) in
            imageView.superview?.sendSubviewToBack(imageView)
            imageView.image = UIImage(named: "tail")?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = ChatColors.outgoing
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

        let backgroundNode = LayoutNode(children: [tailNode, textNode, infoNode], {
            $0.flexDirection(.row).alignItems(.center).padding(.top(8), .left(16), .bottom(8), .right(8)).margin(.left(.percent(30)), .bottom(8), .right(16)).min(.height(36))
        }) { (view: UIView, _) in
            view.backgroundColor = ChatColors.outgoing
            view.layer.cornerRadius = 18
        }

        return LayoutNode(children: [backgroundNode], {
            $0.alignItems(.center).flexDirection(.rowReverse)
        })
    }
}
