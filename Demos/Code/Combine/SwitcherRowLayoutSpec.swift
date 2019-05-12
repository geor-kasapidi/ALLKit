import Foundation
import UIKit
import ALLKit

final class SwitcherRowLayoutSpec: ModelLayoutSpec<String> {
    override func makeNodeFrom(model: String, sizeConstraints: SizeConstraints) -> LayoutNode {
        let attributedTitle = model.attributed()
            .font(.systemFont(ofSize: 14))
            .foregroundColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            .make()

        let titleNode = LayoutNode(sizeProvider: attributedTitle, config: nil) { (label: UILabel, isNew) in
            if isNew {
                label.numberOfLines = 0
                label.attributedText = attributedTitle
            }
        }

        let switcherNode = LayoutNode(config: { node in
            node.width = 51
            node.height = 32
            node.marginLeft = 8
        }) { (switcher: UISwitch, isNew) in
            if isNew {
                switcher.onTintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
                switcher.setOn(true, animated: false)
                switcher.all_setEventHandler(for: .valueChanged, { [weak switcher] in
                    switcher.flatMap { $0.superview?.viewWithTag($0.tag - 1)?.alpha = $0.isOn ? 1 : 0.3 }
                })
            }
        }

        let contentNode = LayoutNode(children: [titleNode, switcherNode], config: { node in
            node.flexDirection = .row
            node.margin(top: 12, left: 16, bottom: 12, right: 16)
            node.alignItems = .center
            node.justifyContent = .spaceBetween
        })

        return LayoutNode(children: [contentNode])
    }
}
