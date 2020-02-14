import Foundation
import UIKit
import ALLKit
import Nuke

final class FeedItemLayoutSpec: ModelLayoutSpec<FeedItem> {
    override func makeNodeWith(boundingDimensions: LayoutDimensions<CGFloat>) -> LayoutNodeConvertible {
        let attributedTitleText = model.title.attributed()
            .font(.boldSystemFont(ofSize: 16))
            .foregroundColor(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1))
            .make()

        let attributedDateText = DateFormatter.localizedString(from: model.date, dateStyle: .medium, timeStyle: .short).attributed()
            .font(.systemFont(ofSize: 12))
            .foregroundColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
            .make()

        let attributedLikesCountText = String(model.likesCount).attributed()
            .font(.systemFont(ofSize: 14))
            .foregroundColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
            .make()

        let attributedViewsCountText = String(model.viewsCount).attributed()
            .font(.systemFont(ofSize: 14))
            .foregroundColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
            .make()

        return LayoutNodeBuilder().layout {
            $0.flexDirection(.column)
        }.body {
            // top panel
            LayoutNodeBuilder().layout {
                $0.flexDirection(.row).alignItems(.center).padding(.top(8), .left(16), .bottom(8), .right(16))
            }.body {
                LayoutNodeBuilder().layout {
                    $0.width(40).height(40).margin(.right(16))
                }.view { (imageView: UIImageView, _) in
                    imageView.contentMode = .scaleAspectFill
                    imageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                    imageView.layer.cornerRadius = 20
                    imageView.layer.masksToBounds = true

                    self.model.avatar.flatMap {
                        _ = Nuke.loadImage(
                            with: $0,
                            options: ImageLoadingOptions(transition: .fadeIn(duration: 0.33)),
                            into: imageView
                        )
                    }
                }
                LayoutNodeBuilder().layout {
                    $0.flexDirection(.column).flex(1)
                }.body {
                    LayoutNodeBuilder().layout(sizeProvider: attributedTitleText) {
                        $0.margin(.bottom(2))
                    }.view { (label: UILabel, _) in
                        label.numberOfLines = 0
                        label.attributedText = attributedTitleText
                    }
                    LayoutNode(sizeProvider: attributedDateText) { (label: UILabel, _) in
                        label.attributedText = attributedDateText
                    }
                }
            }
            // main image
            LayoutNodeBuilder().layout {
                $0.aspectRatio(1)
            }.view { (imageView: UIImageView, _) in
                imageView.contentMode = .scaleAspectFill
                imageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)

                self.model.image.flatMap {
                    _ = Nuke.loadImage(
                        with: $0,
                        options: ImageLoadingOptions(transition: .fadeIn(duration: 0.33)),
                        into: imageView
                    )
                }
            }
            // bottom panel
            LayoutNodeBuilder().layout {
                $0.flexDirection(.row).justifyContent(.spaceBetween).padding(.vertical(8), .horizontal(32))
            }.body {
                LayoutNodeBuilder().layout {
                    $0.flexDirection(.row).alignItems(.center)
                }.body {
                    LayoutNodeBuilder().layout {
                        $0.width(24).height(24).margin(.right(4))
                    }.view { (imageView: UIImageView, _) in
                        imageView.contentMode = .scaleAspectFit
                        imageView.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                        imageView.image = UIImage(named: "heart")?.withRenderingMode(.alwaysTemplate)
                    }
                    LayoutNode(sizeProvider: attributedLikesCountText) { (label: UILabel, _) in
                        label.attributedText = attributedLikesCountText
                    }
                }
                LayoutNodeBuilder().layout {
                    $0.flexDirection(.row).alignItems(.center)
                }.body {
                    LayoutNodeBuilder().layout {
                        $0.width(24).height(24).margin(.right(4))
                    }.view { (imageView: UIImageView, _) in
                        imageView.contentMode = .scaleAspectFit
                        imageView.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                        imageView.image = UIImage(named: "watched")?.withRenderingMode(.alwaysTemplate)
                    }
                    LayoutNode(sizeProvider: attributedViewsCountText) { (label: UILabel, _) in
                        label.attributedText = attributedViewsCountText
                    }
                }
            }
        }
    }
}
