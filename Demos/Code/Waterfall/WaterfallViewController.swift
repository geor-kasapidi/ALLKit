import Foundation
import UIKit
import ALLKit

private final class WaterfallColorLayoutSpec: ModelLayoutSpec<String> {
    override func makeNodeWith(boundingDimensions: LayoutDimensions<CGFloat>) -> LayoutNodeConvertible {
        let textString = model.attributed()
            .font(UIFont.systemFont(ofSize: 12))
            .foregroundColor(UIColor.gray)
            .make()

        return LayoutNodeBuilder().layout {
            $0.padding(.all(8))
        }.view { (view: UIView, _) in
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.black.cgColor
            view.layer.cornerRadius = 4
            view.layer.masksToBounds = true
        }.body {
            LayoutNode(sizeProvider: textString) { (label: UILabel, _) in
                label.numberOfLines = 0
                label.attributedText = textString
            }
        }
    }
}

final class WaterfallViewController: ListViewController<UICollectionView, UICollectionViewCell>, WaterfallLayoutDelegate {
    private let waterfallLayout = WaterfallLayout(numberOfColumns: 2, spacing: 4)

    init() {
        super.init(adapter: CollectionViewAdapter(layout: waterfallLayout))

        waterfallLayout.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.global().async { [weak self] in
            let content = DemoContent.loremIpsum.joined(separator: " ")

            let items: [ListItem<DemoContext>] = (0..<Int.random(in: 100..<200)).map { index in
                let randomIndex = content.indices.randomElement()!

                let item = ListItem<DemoContext>(
                    id: String(index),
                    layoutSpec: WaterfallColorLayoutSpec(model: String(content[randomIndex...]))
                )

                return item
            }

            DispatchQueue.main.async {
                self?.adapter.set(items: items)
            }
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        adapter.set(
            boundingDimensions: CGSize(
                width: waterfallLayout.columnWidthFor(viewWidth: view.bounds.width),
                height: .nan
            ).layoutDimensions
        )
    }

    func heightForItemAt(indexPath: IndexPath) -> CGFloat {
        return adapter.sizeForItem(at: indexPath.item)?.height ?? 0
    }
}
