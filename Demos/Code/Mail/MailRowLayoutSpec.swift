import Foundation
import UIKit
import ALLKit
import yoga

final class MailRowLayoutSpec: ModelLayoutSpec<MailRow> {
    override func makeNodeWith(boundingDimensions: LayoutDimensions<CGFloat>) -> LayoutNodeConvertible {
        let attributedTitle = model.title.attributed()
            .font(.boldSystemFont(ofSize: 16))
            .foregroundColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            .make()

        let attributedText = model.text.attributed()
            .font(.systemFont(ofSize: 12))
            .foregroundColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
            .make()

        return LayoutNodeBuilder().layout {
            $0.flexDirection(.column)
        }.body {
            LayoutNodeBuilder().layout {
                $0.flex(1).margin(.top(12), .left(16), .bottom(12), .right(8))
            }.body {
                LayoutNodeBuilder().layout(sizeProvider: attributedTitle) {
                    $0.max(.height(56)).margin(.bottom(4))
                }.view { (label: UILabel, _) in
                    label.numberOfLines = 0
                    label.attributedText = attributedTitle
                }
                LayoutNodeBuilder().layout(sizeProvider: attributedText) {
                    $0.max(.height(40))
                }.view { (label: UILabel, _) in
                    label.numberOfLines = 0
                    label.attributedText = attributedText
                }
            }
            LayoutNodeBuilder().layout {
                $0.margin(.left(16)).height(.point(1.0/UIScreen.main.scale))
            }.view { (view: UIView, _) in
                view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }
        }
    }
}
