import Foundation
import UIKit
import ALLKit
import yoga

final class SelectableRowLayoutSpec: ModelLayoutSpec<String> {
    override func makeNodeWith(boundingDimensions: LayoutDimensions<CGFloat>) -> LayoutNodeConvertible {
        let attributedText = model.attributed()
            .font(.systemFont(ofSize: 14))
            .foregroundColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            .make()
            .drawing()

        return LayoutNodeBuilder().layout {
            $0.flexDirection(.column)
        }.body {
            LayoutNodeBuilder().layout {
                $0.flexDirection(.row)
                    .alignItems(.center)
                    .justifyContent(.spaceBetween)
                    .padding(.vertical(12), .left(16), .right(8))
            }.body {
                LayoutNodeBuilder().layout(sizeProvider: attributedText) {
                    $0.flex(1)
                }.view { (label: AsyncLabel, _) in
                    label.stringDrawing = attributedText
                }
                LayoutNodeBuilder().layout {
                    $0.width(24).height(24).margin(.left(6))
                }.view { (imageView: UIImageView, _) in
                    imageView.contentMode = .scaleAspectFit
                    imageView.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                    imageView.image = UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate)
                }
            }
            LayoutNodeBuilder().layout {
                $0.height(.point(1.0/UIScreen.main.scale)).margin(.left(16))
            }.view { (view: UIView, _) in
                view.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            }
        }
    }
}
