import Foundation
import UIKit
import ALLKit
import Nuke

final class PortraitProfileLayoutSpec: ModelLayoutSpec<UserProfile> {
    override func makeNodeFrom(model: UserProfile, sizeConstraints: SizeConstraints) -> LayoutNode {
        let attributedName = model.name.attributed()
            .font(.boldSystemFont(ofSize: 24))
            .foregroundColor(UIColor.black)
            .alignment(.center)
            .make()

        let attributedDescription = model.description.attributed()
            .font(.systemFont(ofSize: 14))
            .foregroundColor(UIColor.black)
            .alignment(.justified)
            .make()

        let avatarNode = LayoutNode(config: { node in
            node.height = 100
            node.width = 100
            node.marginBottom = 24
        }) { (imageView: UIImageView, isNew) in
            if isNew {
                imageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                imageView.layer.cornerRadius = 50
                imageView.layer.masksToBounds = true
                imageView.contentMode = .scaleAspectFill

                model.avatar.flatMap {
                    _ = Nuke.loadImage(
                        with: $0,
                        options: ImageLoadingOptions(transition: .fadeIn(duration: 0.33)),
                        into: imageView
                    )
                }
            }
        }

        let nameNode = LayoutNode(sizeProvider: attributedName, config: { node in
            node.marginBottom = 24
        }) { (label: UILabel, isNew) in
            if isNew {
                label.numberOfLines = 0
                label.attributedText = attributedName
            }
        }

        let descriptionNode = LayoutNode(sizeProvider: attributedDescription, config: nil) { (label: UILabel, isNew) in
            if isNew {
                label.numberOfLines = 0
                label.attributedText = attributedDescription
            }
        }

        return LayoutNode(children: [avatarNode, nameNode, descriptionNode], config: { node in
            node.flexDirection = .column
            node.padding(all: 24)
            node.alignItems = .center
        })
    }
}

final class LandscapeProfileLayoutSpec: ModelLayoutSpec<UserProfile> {
    override func makeNodeFrom(model: UserProfile, sizeConstraints: SizeConstraints) -> LayoutNode {
        let attributedName = model.name.attributed()
            .font(.boldSystemFont(ofSize: 24))
            .foregroundColor(UIColor.black)
            .alignment(.center)
            .make()

        let attributedDescription = model.description.attributed()
            .font(.systemFont(ofSize: 14))
            .foregroundColor(UIColor.black)
            .alignment(.justified)
            .make()

        let avatarNode = LayoutNode(config: { node in
            node.height = 100
            node.width = 100
            node.marginBottom = 24
        }) { (imageView: UIImageView, isNew) in
            if isNew {
                imageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                imageView.layer.cornerRadius = 50
                imageView.layer.masksToBounds = true
                imageView.contentMode = .scaleAspectFill

                model.avatar.flatMap {
                    _ = Nuke.loadImage(
                        with: $0,
                        options: ImageLoadingOptions(transition: .fadeIn(duration: 0.33)),
                        into: imageView
                    )
                }
            }
        }

        let nameNode = LayoutNode(sizeProvider: attributedName, config: nil) { (label: UILabel, isNew) in
            if isNew {
                label.numberOfLines = 0
                label.attributedText = attributedName
            }
        }

        let descriptionNode = LayoutNode(sizeProvider: attributedDescription, config: { node in
            node.flex = 1
        }) { (label: UILabel, isNew) in
            if isNew {
                label.numberOfLines = 0
                label.attributedText = attributedDescription
            }
        }

        let leftNode = LayoutNode(children: [avatarNode, nameNode], config: { node in
            node.flexDirection = .column
            node.alignItems = .center
            node.marginRight = 24
        })

        return LayoutNode(children: [leftNode, descriptionNode], config: { node in
            node.flexDirection = .row
            node.padding(all: 24)
        })
    }
}
