import Foundation
import UIKit
import ALLKit
import Nuke

final class HorizontalSnippetLayoutSpec: ModelLayoutSpec<AnimationDemoModel> {
    override func makeNodeWith(boundingDimensions: LayoutDimensions<CGFloat>) -> LayoutNodeConvertible {
        let titleText = model.title.attributed()
            .font(UIFont.boldSystemFont(ofSize: 18))
            .foregroundColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
            .make()

        let subtitleText = model.subtitle.attributed()
            .font(UIFont.systemFont(ofSize: 14))
            .foregroundColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
            .make()

        let titleNode = LayoutNode(sizeProvider: titleText, {
            $0.alignItems(.center).justifyContent(.center).flex(1)
        }) { (label: UILabel, isNew) in
            if isNew {
                label.numberOfLines = 0
                label.attributedText = titleText
            }
        }

        let subtitleNode = LayoutNode(sizeProvider: subtitleText) { (label: UILabel, isNew) in
            if isNew {
                label.numberOfLines = 0
                label.attributedText = subtitleText
            }
        }

        let imageNode = LayoutNode({
            $0.width(80).height(80).margin(.right(16))
        }) { (imageView: UIImageView, isNew) in
            imageView.layer.cornerRadius = 40

            if isNew {
                imageView.contentMode = .scaleAspectFill
                imageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                imageView.layer.masksToBounds = true

                self.model.url.flatMap {
                    _ = Nuke.loadImage(
                        with: $0,
                        options: ImageLoadingOptions(transition: .fadeIn(duration: 0.33)),
                        into: imageView
                    )
                }
            }
        }

        let topStackNode = LayoutNode(children: [imageNode, titleNode], {
            $0.flexDirection(.row).alignItems(.center).margin(.bottom(16))
        })

        let mainStackNode = LayoutNode(children: [topStackNode, subtitleNode], {
            $0.padding(.all(16)).flexDirection(.column)
        })

        return mainStackNode
    }
}
