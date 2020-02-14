import Foundation
import UIKit
import ALLKit

final class GalleryItemLayoutSpec: ModelLayoutSpec<GalleryItem> {
    override func makeNodeWith(boundingDimensions: LayoutDimensions<CGFloat>) -> LayoutNodeConvertible {
        let title = model.name.attributed()
            .font(UIFont.boldSystemFont(ofSize: 20))
            .foregroundColor(UIColor.black)
            .make()

        let titleNode = LayoutNode(sizeProvider: title, {
            $0.margin(.all(16))
        }) { (label: UILabel, _) in
            label.numberOfLines = 0
            label.attributedText = title
        }

        let galleryNode = LayoutNode({
            $0.height(128)
        }) { (view: GalleryView, _) in
            view.images = self.model.images
        }

        return LayoutNode(children: [titleNode, galleryNode], {
            $0.flexDirection(.column)
        })
    }
}
