import Foundation
import UIKit
import ALLKit

struct GalleryItem {
    let name: String
    let images: [URL]
}

final class MultiGalleriesViewController: UIViewController {
    private let adapter = CollectionViewAdapter()

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            view.backgroundColor = UIColor.white

            view.addSubview(adapter.collectionView)

            adapter.collectionView.backgroundColor = UIColor.white
        }

        do {
            let listItems = DemoContent.NATO.map { name -> ListItem in
                let images = (0..<100).map { _ in URL(string: "https://picsum.photos/200/150?random&q=\(Int.random(in: 1..<1000))")! }

                let listItem = ListItem(
                    id: name,
                    layoutSpec: GalleryItemLayoutSpec(model: GalleryItem(name: name, images: images))
                )

                return listItem
            }

            adapter.set(items: listItems)
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        adapter.collectionView.frame = view.bounds

        adapter.set(boundingDimensions: CGSize(width: view.bounds.width, height: .nan).layoutDimensions)
    }
}
