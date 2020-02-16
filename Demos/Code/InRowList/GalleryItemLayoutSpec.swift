import Foundation
import UIKit
import ALLKit

final class GalleryItemLayoutSpec: ModelLayoutSpec<GalleryItem> {
    override func makeNodeWith(boundingDimensions: LayoutDimensions<CGFloat>) -> LayoutNodeConvertible {
        let title = model.name.attributed()
            .font(UIFont.boldSystemFont(ofSize: 20))
            .foregroundColor(UIColor.black)
            .make()

        return LayoutNodeBuilder().layout {
            $0.flexDirection(.column)
        }.body {
            LayoutNodeBuilder().layout(sizeProvider: title) {
                $0.margin(.all(16))
            }.view { (label: UILabel, _) in
                label.numberOfLines = 0
                label.attributedText = title
            }
            LayoutNodeBuilder().layout {
                $0.height(128)
            }.view { (view: GalleryView, _) in
                view.images = self.model.images
            }
        }
    }
}
