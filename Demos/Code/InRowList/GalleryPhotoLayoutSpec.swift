import Foundation
import UIKit
import ALLKit
import YYWebImage

final class GalleryPhotoLayoutSpec: ModelLayoutSpec<URL> {
    override func makeNodeFrom(model: URL, sizeConstraints: SizeConstraints) -> LayoutNode {
        let imageNode = LayoutNode(config: { node in
            node.aspectRatio = Float(4.0/3.0)
        }) { (imageView: UIImageView, _) in
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.yy_setImage(with: model, options: .setImageWithFadeAnimation)
        }

        return LayoutNode(children: [imageNode], config: { node in
            node.flexDirection = .row
            node.alignItems = .stretch
        })
    }
}
