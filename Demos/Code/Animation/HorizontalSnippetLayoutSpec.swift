import Foundation
import UIKit
import ALLKit
import Nuke

final class HorizontalSnippetLayoutSpec: ModelLayoutSpec<AnimationDemoModel> {
    override func makeNodeFrom(model: AnimationDemoModel, sizeConstraints: SizeConstraints) -> LayoutNode {
        let titleText = model.title.attributed()
            .font(UIFont.boldSystemFont(ofSize: 18))
            .foregroundColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
            .make()

        let subtitleText = model.subtitle.attributed()
            .font(UIFont.systemFont(ofSize: 14))
            .foregroundColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
            .make()

        let titleNode = LayoutNode(sizeProvider: titleText, config: { node in
            node.alignItems = .center
            node.justifyContent = .center
            node.flex = 1
        }) { (label: UILabel, isNew) in
            if isNew {
                label.numberOfLines = 0
                label.attributedText = titleText
            }
        }

        let subtitleNode = LayoutNode(sizeProvider: subtitleText, config: nil) { (label: UILabel, isNew) in
            if isNew {
                label.numberOfLines = 0
                label.attributedText = subtitleText
            }
        }

        let imageNode = LayoutNode(config: { node in
            node.width = 80
            node.height = 80
            node.marginRight = 16
        }) { (imageView: UIImageView, isNew) in
            imageView.layer.cornerRadius = 40

            if isNew {
                imageView.contentMode = .scaleAspectFill
                imageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                imageView.layer.masksToBounds = true

                model.url.flatMap {
                    _ = Nuke.loadImage(
                        with: $0,
                        options: ImageLoadingOptions(transition: .fadeIn(duration: 0.33)),
                        into: imageView
                    )
                }
            }
        }

        let topStackNode = LayoutNode(children: [imageNode, titleNode], config: { node in
            node.flexDirection = .row
            node.marginBottom = 16
            node.alignItems = .center
        })

        let mainStackNode = LayoutNode(children: [topStackNode, subtitleNode], config: { node in
            node.padding(all: 16)
            node.flexDirection = .column
        })

        return mainStackNode
    }
}
