import Foundation
import UIKit
import ALLKit

struct GalleryItem {
    let name: String
    let images: [URL]
}

final class MultiGalleriesViewController: ListViewController<UICollectionView, UICollectionViewCell> {
    override func viewDidLoad() {
        super.viewDidLoad()

        let listItems = DemoContent.NATO.map { name -> ListItem<DemoContext> in
            let images = (0..<100).map { _ in URL(string: "https://picsum.photos/200/150?random&q=\(Int.random(in: 1..<1000))")! }

            let listItem = ListItem<DemoContext>(
                id: name,
                layoutSpec: GalleryItemLayoutSpec(model: GalleryItem(name: name, images: images))
            )

            return listItem
        }

        adapter.set(items: listItems)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        adapter.set(boundingDimensions: CGSize(width: view.bounds.width, height: .nan).layoutDimensions)
    }
}
