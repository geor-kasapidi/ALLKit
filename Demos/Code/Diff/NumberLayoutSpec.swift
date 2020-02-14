import Foundation
import UIKit
import ALLKit

final class NumberLayoutSpec: ModelLayoutSpec<Int> {
    override func makeNodeWith(boundingDimensions: LayoutDimensions<CGFloat>) -> LayoutNodeConvertible {
        let attributedText = String(model).attributed()
            .font(.boldSystemFont(ofSize: 36))
            .foregroundColor(UIColor.white)
            .make()

        let numberNode = LayoutNode(sizeProvider: attributedText) { (label: UILabel, _) in
            label.attributedText = attributedText
        }

        return LayoutNode(children: [numberNode], {
            $0.alignItems(.center).justifyContent(.center)
        }) { (view: UIView, _) in
            view.layer.cornerRadius = 4
            view.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        }
    }
}
