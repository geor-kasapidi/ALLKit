import Foundation
import UIKit

protocol WaterfallLayoutDelegate: class {
    func heightForItemAt(indexPath: IndexPath) -> CGFloat
}

final class WaterfallLayout: UICollectionViewLayout {
    let numberOfColumns: Int
    let spacing: CGFloat

    init(numberOfColumns: Int, spacing: CGFloat = 0) {
        precondition(numberOfColumns > 1 && spacing >= 0)

        self.numberOfColumns = numberOfColumns
        self.spacing = spacing

        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    weak var delegate: WaterfallLayoutDelegate!

    // MARK: -

    private var contentSize: CGSize = .zero
    private var layoutAttributesCache: [UICollectionViewLayoutAttributes] = []

    // MARK: -

    override func prepare() {
        guard let collectionView = collectionView, layoutAttributesCache.isEmpty else {
            return
        }

        let collectionViewWidth = collectionView.bounds.width
        let columnWidth = columnWidthFor(viewWidth: collectionViewWidth)

        let xOffset: [CGFloat] = (0..<numberOfColumns).map {
            CGFloat($0) * columnWidth
        }

        var yOffset: [CGFloat] = Array(repeating: spacing, count: numberOfColumns)

        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let column = item % numberOfColumns

            let indexPath = IndexPath(item: item, section: 0)

            let itemHeight = delegate.heightForItemAt(indexPath: indexPath)

            let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            layoutAttributes.frame = CGRect(
                x: xOffset[column] + spacing * CGFloat(column + 1),
                y: yOffset[column],
                width: columnWidth,
                height: itemHeight
            )

            layoutAttributesCache.append(layoutAttributes)

            yOffset[column] = yOffset[column] + itemHeight + spacing
        }

        contentSize = CGSize(
            width: collectionViewWidth,
            height: yOffset.max()!
        )
    }

    override func invalidateLayout() {
        super.invalidateLayout()

        layoutAttributesCache = []
    }

    override var collectionViewContentSize: CGSize {
        return contentSize
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributesCache.filter {
            $0.frame.intersects(rect)
        }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributesCache[indexPath.item]
    }

    // MARK: -

    func columnWidthFor(viewWidth: CGFloat) -> CGFloat {
        return (viewWidth - CGFloat(numberOfColumns + 1) * spacing) / CGFloat(numberOfColumns)
    }
}
