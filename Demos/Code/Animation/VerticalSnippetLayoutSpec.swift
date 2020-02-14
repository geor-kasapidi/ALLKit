import Foundation
import UIKit
import ALLKit
import Nuke

final class VerticalSnippetLayoutSpec: ModelLayoutSpec<AnimationDemoModel> {
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
            $0.margin(.all(16))
        }) { (label: UILabel, isNew) in
            if isNew {
                label.numberOfLines = 0
                label.attributedText = titleText
            }
        }

        let subtitleNode = LayoutNode(sizeProvider: subtitleText, {
            $0.margin(.all(16))
        }) { (label: UILabel, isNew) in
            if isNew {
                label.numberOfLines = 0
                label.attributedText = subtitleText
            }
        }

        let imageNode = LayoutNode({
            $0.width(.percent(100)).height(200).margin(.bottom(16))
        }) { (imageView: UIImageView, isNew) in
            imageView.layer.cornerRadius = 0

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

        let mainStackNode = LayoutNode(children: [imageNode, titleNode, subtitleNode], {
            $0.flexDirection(.column).alignItems(.center)
        })

        return mainStackNode
    }
}
