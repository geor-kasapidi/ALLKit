import Foundation
import UIKit
import ALLKit
import Nuke

final class GalleryPhotoLayoutSpec: ModelLayoutSpec<URL> {
    override func makeNodeWith(boundingDimensions: LayoutDimensions<CGFloat>) -> LayoutNodeConvertible {
        LayoutNodeBuilder().layout {
            $0.flexDirection(.row).alignItems(.stretch)
        }.body {
            LayoutNodeBuilder().layout {
                $0.aspectRatio(4.0/3.0)
            }.view { (imageView: UIImageView, _) in
                imageView.clipsToBounds = true
                imageView.contentMode = .scaleAspectFill

                _ = Nuke.loadImage(
                    with: self.model,
                    options: ImageLoadingOptions(transition: .fadeIn(duration: 0.33)),
                    into: imageView
                )
            }
        }
    }
}
