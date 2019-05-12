import Foundation
import UIKit
import ALLKit

final class NumberLayoutSpec: ModelLayoutSpec<Int> {
    override func makeNodeFrom(model: Int, sizeConstraints: SizeConstraints) -> LayoutNode {
        let attributedText = String(model).attributed()
            .font(.boldSystemFont(ofSize: 36))
            .foregroundColor(UIColor.white)
            .make()

        let numberNode = LayoutNode(sizeProvider: attributedText, config: nil) { (label: UILabel, _) in
            label.attributedText = attributedText
        }

        return LayoutNode(children: [numberNode], config: { node in
            node.alignItems = .center
            node.justifyContent = .center
        }) { (view: UIView, _) in
            view.layer.cornerRadius = 4
            view.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        }
    }
}
