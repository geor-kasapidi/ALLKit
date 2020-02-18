import Foundation
import UIKit
import ALLKit
import Nuke

final class PortraitProfileLayoutSpec: ModelLayoutSpec<UserProfile> {
    override func makeNodeWith(boundingDimensions: LayoutDimensions<CGFloat>) -> LayoutNodeConvertible {
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

        return LayoutNodeBuilder().layout {
            $0.flexDirection(.column).padding(.all(24)).alignItems(.center)
        }.body {
            LayoutNodeBuilder().layout {
                $0.height(100).width(100).margin(.bottom(24))
            }.view { (imageView: UIImageView, isNew) in
                if isNew {
                    imageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                    imageView.layer.cornerRadius = 50
                    imageView.layer.masksToBounds = true
                    imageView.contentMode = .scaleAspectFill

                    self.model.avatar.flatMap {
                        _ = Nuke.loadImage(
                            with: $0,
                            options: ImageLoadingOptions(transition: .fadeIn(duration: 0.33)),
                            into: imageView
                        )
                    }
                }
            }

            LayoutNodeBuilder().layout(sizeProvider: attributedName) {
                $0.margin(.bottom(24))
            }.view { (label: UILabel, isNew) in
                if isNew {
                    label.numberOfLines = 0
                    label.attributedText = attributedName
                }
            }

            LayoutNodeBuilder().layout(sizeProvider: attributedDescription).view { (label: UILabel, isNew) in
                if isNew {
                    label.numberOfLines = 0
                    label.attributedText = attributedDescription
                }
            }
        }
    }
}

final class LandscapeProfileLayoutSpec: ModelLayoutSpec<UserProfile> {
    override func makeNodeWith(boundingDimensions: LayoutDimensions<CGFloat>) -> LayoutNodeConvertible {
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

        return LayoutNodeBuilder().layout {
            $0.flexDirection(.row).padding(.all(24))
        }.body {
            LayoutNodeBuilder().layout {
                $0.flexDirection(.column).alignItems(.center).margin(.right(24))
            }.body {
                LayoutNodeBuilder().layout {
                    $0.height(100).width(100).margin(.bottom(24))
                }.view { (imageView: UIImageView, isNew) in
                    if isNew {
                        imageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                        imageView.layer.cornerRadius = 50
                        imageView.layer.masksToBounds = true
                        imageView.contentMode = .scaleAspectFill

                        self.model.avatar.flatMap {
                            _ = Nuke.loadImage(
                                with: $0,
                                options: ImageLoadingOptions(transition: .fadeIn(duration: 0.33)),
                                into: imageView
                            )
                        }
                    }
                }
                LayoutNode(sizeProvider: attributedName) { (label: UILabel, isNew) in
                    if isNew {
                        label.numberOfLines = 0
                        label.attributedText = attributedName
                    }
                }
            }
            LayoutNodeBuilder().layout(sizeProvider: attributedDescription) {
                $0.flex(1)
            }.view { (label: UILabel, isNew) in
                if isNew {
                    label.numberOfLines = 0
                    label.attributedText = attributedDescription
                }
            }
        }
    }
}
