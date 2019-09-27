import Foundation
import UIKit
import ALLKit
import Nuke

final class FeedItemLayoutSpec: ModelLayoutSpec<FeedItem> {
    override func makeNodeFrom(model: FeedItem, sizeConstraints: SizeConstraints) -> LayoutNode {
        let topNode: LayoutNode

        do {
            let attributedTitleText = model.title.attributed()
                .font(.boldSystemFont(ofSize: 16))
                .foregroundColor(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1))
                .make()

            let attributedDateText = DateFormatter.localizedString(from: model.date, dateStyle: .medium, timeStyle: .short).attributed()
                .font(.systemFont(ofSize: 12))
                .foregroundColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
                .make()

            let avatarNode = LayoutNode(config: { node in
                node.width = 40
                node.height = 40
                node.marginRight = 16
            }) { (imageView: UIImageView, _) in
                imageView.contentMode = .scaleAspectFill
                imageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                imageView.layer.cornerRadius = 20
                imageView.layer.masksToBounds = true

                model.avatar.flatMap {
                    _ = Nuke.loadImage(
                        with: $0,
                        options: ImageLoadingOptions(transition: .fadeIn(duration: 0.33)),
                        into: imageView
                    )
                }
            }

            let titleNode = LayoutNode(sizeProvider: attributedTitleText, config: { node in
                node.marginBottom = 2
            }) { (label: UILabel, _) in
                label.numberOfLines = 0
                label.attributedText = attributedTitleText
            }

            let dateNode = LayoutNode(sizeProvider: attributedDateText, config: nil) { (label: UILabel, _) in
                label.attributedText = attributedDateText
            }

            let textContainerNode = LayoutNode(children: [titleNode, dateNode], config: { node in
                node.flexDirection = .column
                node.flex = 1
            })

            topNode = LayoutNode(children: [avatarNode, textContainerNode], config: { node in
                node.padding(top: 8, left: 16, bottom: 8, right: 16)
                node.flexDirection = .row
                node.alignItems = .center
            })
        }

        let imageNode = LayoutNode(config: { node in
            node.aspectRatio = 1
        }) { (imageView: UIImageView, _) in
            imageView.contentMode = .scaleAspectFill
            imageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)

            model.image.flatMap {
                _ = Nuke.loadImage(
                    with: $0,
                    options: ImageLoadingOptions(transition: .fadeIn(duration: 0.33)),
                    into: imageView
                )
            }
        }

        let likesNode: LayoutNode

        do {
            let attributedLikesCountText = String(model.likesCount).attributed()
                .font(.systemFont(ofSize: 14))
                .foregroundColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
                .make()

            let imageNode = LayoutNode(config: { node in
                node.width = 24
                node.height = 24
                node.marginRight = 4
            }) { (imageView: UIImageView, _) in
                imageView.contentMode = .scaleAspectFit
                imageView.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                imageView.image = UIImage(named: "heart")?.withRenderingMode(.alwaysTemplate)
            }

            let textNode = LayoutNode(sizeProvider: attributedLikesCountText, config: nil) { (label: UILabel, _) in
                label.attributedText = attributedLikesCountText
            }

            likesNode = LayoutNode(children: [imageNode, textNode], config: { node in
                node.flexDirection = .row
                node.alignItems = .center
            })
        }

        let viewsNode: LayoutNode

        do {
            let attributedViewsCountText = String(model.viewsCount).attributed()
                .font(.systemFont(ofSize: 14))
                .foregroundColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
                .make()

            let imageNode = LayoutNode(config: { node in
                node.width = 24
                node.height = 24
                node.marginRight = 4
            }) { (imageView: UIImageView, _) in
                imageView.contentMode = .scaleAspectFit
                imageView.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                imageView.image = UIImage(named: "watched")?.withRenderingMode(.alwaysTemplate)
            }

            let textNode = LayoutNode(sizeProvider: attributedViewsCountText, config: nil) { (label: UILabel, _) in
                label.attributedText = attributedViewsCountText
            }

            viewsNode = LayoutNode(children: [imageNode, textNode], config: { node in
                node.flexDirection = .row
                node.alignItems = .center
            })
        }

        let bottomNode = LayoutNode(children: [likesNode, viewsNode], config: { node in
            node.padding(top: 8, left: 24, bottom: 8, right: 24)
            node.flexDirection = .row
            node.justifyContent = .spaceBetween
        })

        return LayoutNode(children: [topNode, imageNode, bottomNode], config: { node in
            node.flexDirection = .column
        })
    }
}
