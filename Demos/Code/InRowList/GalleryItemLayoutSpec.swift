import Foundation
import UIKit
import ALLKit

final class GalleryItemLayoutSpec: ModelLayoutSpec<GalleryItem> {
    override func makeNodeFrom(model: GalleryItem, sizeConstraints: SizeConstraints) -> LayoutNode {
        let title = model.name.attributed()
            .font(UIFont.boldSystemFont(ofSize: 20))
            .foregroundColor(UIColor.black)
            .make()

        let titleNode = LayoutNode(sizeProvider: title, config: { node in
            node.margin(all: 16)
        }) { (label: UILabel, _) in
            label.numberOfLines = 0
            label.attributedText = title
        }

        let galleryNode = LayoutNode(config: { node in
            node.height = 128
        }) { (view: GalleryView, _) in
            view.images = model.images
        }

        return LayoutNode(children: [titleNode, galleryNode], config: { node in
            node.flexDirection = .column
        })
    }
}
