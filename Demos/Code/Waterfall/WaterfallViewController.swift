import Foundation
import UIKit
import ALLKit

private final class WaterfallColorLayoutSpec: ModelLayoutSpec<String> {
    override func makeNodeFrom(model: String, sizeConstraints: SizeConstraints) -> LayoutNode {
        let textString = model.attributed()
            .font(UIFont.systemFont(ofSize: 12))
            .foregroundColor(UIColor.gray)
            .make()

        let textNode = LayoutNode(sizeProvider: textString, config: { node in

        }) { (label: UILabel, _) in
            label.numberOfLines = 0
            label.attributedText = textString
        }

        let contentNode = LayoutNode(children: [textNode], config: { node in
            node.padding(all: 8)
        }) { (view: UIView, _) in
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.black.cgColor
            view.layer.cornerRadius = 4
            view.layer.masksToBounds = true
        }

        return contentNode
    }
}

final class WaterfallViewController: UIViewController, WaterfallLayoutDelegate {
    private let waterfallLayout = WaterfallLayout(numberOfColumns: 2, spacing: 4)
    private let adapter: CollectionViewAdapter<UICollectionView, UICollectionViewCell>

    init() {
        adapter = CollectionViewAdapter(layout: waterfallLayout)

        super.init(nibName: nil, bundle: nil)

        waterfallLayout.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        adapter.collectionView.backgroundColor = UIColor.white

        view.addSubview(adapter.collectionView)

        DispatchQueue.global().async { [weak self] in
            let content = DemoContent.loremIpsum.joined(separator: " ")

            let items: [ListItem] = (0..<Int.random(in: 100..<200)).map { index in
                let randomIndex = content.indices.randomElement()!

                let item = ListItem(
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

        adapter.collectionView.frame = view.bounds

        adapter.set(sizeConstraints: SizeConstraints(
            width: waterfallLayout.columnWidthFor(viewWidth: view.bounds.width),
            height: .nan
        ))
    }

    func heightForItemAt(indexPath: IndexPath) -> CGFloat {
        return adapter.sizeForItem(at: indexPath.item).height
    }
}
