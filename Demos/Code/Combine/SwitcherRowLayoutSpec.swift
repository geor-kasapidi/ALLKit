import Foundation
import UIKit
import ALLKit

final class SwitcherRowLayoutSpec: ModelLayoutSpec<String> {
    override func makeNodeWith(boundingDimensions: LayoutDimensions<CGFloat>) -> LayoutNodeConvertible {
        let attributedTitle = model.attributed()
            .font(.systemFont(ofSize: 14))
            .foregroundColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            .make()

        return LayoutNodeBuilder().layout().body {
            LayoutNodeBuilder().layout {
                $0
                    .flexDirection(.row)
                    .alignItems(.center)
                    .justifyContent(.spaceBetween)
                    .margin(.vertical(12), .horizontal(16))
            }.body {
                LayoutNode(sizeProvider: attributedTitle) { (label: UILabel, isNew) in
                    if isNew {
                        label.numberOfLines = 0
                        label.attributedText = attributedTitle
                    }
                }
                LayoutNodeBuilder().layout {
                    $0.width(51).height(32).margin(.left(8))
                }.view { (switcher: UISwitch, isNew) in
                    if isNew {
                        switcher.onTintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
                        switcher.setOn(true, animated: false)
                        switcher.all_setEventHandler(for: .valueChanged, { [weak switcher] in
                            switcher.flatMap { $0.superview?.viewWithTag($0.tag - 1)?.alpha = $0.isOn ? 1 : 0.3 }
                        })
                    }
                }
            }
        }
    }
}
