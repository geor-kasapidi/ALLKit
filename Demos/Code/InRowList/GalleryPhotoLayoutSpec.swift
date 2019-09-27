import Foundation
import UIKit
import ALLKit
import Nuke

final class GalleryPhotoLayoutSpec: ModelLayoutSpec<URL> {
    override func makeNodeFrom(model: URL, sizeConstraints: SizeConstraints) -> LayoutNode {
        let imageNode = LayoutNode(config: { node in
            node.aspectRatio = Float(4.0/3.0)
        }) { (imageView: UIImageView, _) in
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill

            _ = Nuke.loadImage(
                with: model,
                options: ImageLoadingOptions(transition: .fadeIn(duration: 0.33)),
                into: imageView
            )
        }

        return LayoutNode(children: [imageNode], config: { node in
            node.flexDirection = .row
            node.alignItems = .stretch
        })
    }
}
