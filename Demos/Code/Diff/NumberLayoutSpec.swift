import Foundation
import UIKit
import ALLKit

final class NumberLayoutSpec: ModelLayoutSpec<Int> {
    override func makeNodeWith(boundingDimensions: LayoutDimensions<CGFloat>) -> LayoutNodeConvertible {
        let attributedText = String(model).attributed()
            .font(.boldSystemFont(ofSize: 36))
            .foregroundColor(UIColor.white)
            .make()

        return LayoutNodeBuilder().layout {
            $0.alignItems(.center).justifyContent(.center)
        }.view { (view: UIView, _) in
            view.layer.cornerRadius = 4
            view.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        }.body {
            LayoutNode(sizeProvider: attributedText) { (label: UILabel, _) in
                label.attributedText = attributedText
            }
        }
    }
}
