import Foundation
import UIKit
import ALLKit

final class GalleryView: UIView, UICollectionViewDelegateFlowLayout {
    private lazy var adapter: CollectionViewAdapter<UICollectionView, UICollectionViewCell, DemoContext> = {
        let adapter = CollectionViewAdapter<UICollectionView, UICollectionViewCell, DemoContext>(scrollDirection: .horizontal)
        adapter.collectionView.delegate = self
        adapter.collectionView.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        addSubview(adapter.collectionView)
        return adapter
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        adapter.collectionView.frame = bounds

        adapter.set(boundingDimensions: CGSize(width: .nan, height: bounds.height).layoutDimensions)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        adapter.sizeForItem(at: indexPath.item) ?? .zero
    }

    var images: [URL] = [] {
        didSet {
            DispatchQueue.global().async { [weak self] in
                let listItems = (self?.images ?? []).map { url -> ListItem<DemoContext> in
                    ListItem(
                        id: url,
                        layoutSpec: GalleryPhotoLayoutSpec(model: url)
                    )
                }

                DispatchQueue.main.async {
                    self?.adapter.set(items: listItems)
                }
            }
        }
    }
}
