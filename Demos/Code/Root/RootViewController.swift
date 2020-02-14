import Foundation
import UIKit
import ALLKit

private final class SwipeTextLayoutSpec: ModelLayoutSpec<String> {
    override func makeNodeWith(boundingDimensions: LayoutDimensions<CGFloat>) -> LayoutNodeConvertible {
        let attrText = model.attributed()
            .font(UIFont.boldSystemFont(ofSize: 40))
            .alignment(.center)
            .make()

        return LayoutNode(sizeProvider: attrText) { (label: UILabel, _) in
            label.attributedText = attrText
        }
    }
}

final class RootViewController: UIViewController {
    private let adapter = CollectionViewAdapter()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Select demo"

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        do {
            view.backgroundColor = UIColor.white
            view.addSubview(adapter.collectionView)
            adapter.collectionView.alwaysBounceVertical = true
            adapter.collectionView.backgroundColor = UIColor.white
        }

        do {
            typealias MenuRow = (name: String, onSelect: () -> Void)

            let menuRows: [MenuRow] = [
                ("Feed", { [weak self] in
                    let vc = FeedViewController()

                    self?.navigationController?.pushViewController(vc, animated: true)
                }),
                ("Chat", { [weak self] in
                    let vc = ChatViewController()

                    self?.navigationController?.pushViewController(vc, animated: true)
                }),
                ("Mail (swipe demo)", { [weak self] in
                    let vc = MailViewController()

                    self?.navigationController?.pushViewController(vc, animated: true)
                }),
                ("Combine layouts (plain UIScrollView)", { [weak self] in
                    let vc = CombinedLayoutViewController()

                    self?.navigationController?.pushViewController(vc, animated: true)
                }),
                ("Layout transition (different layouts for portrait and landscape orientations)", { [weak self] in
                    let vc = LayoutTransitionViewController()

                    self?.navigationController?.pushViewController(vc, animated: true)
                }),
                ("Animations", { [weak self] in
                    let vc = LayoutAnimationViewController()

                    self?.navigationController?.pushViewController(vc, animated: true)
                }),
                ("Diff", { [weak self] in
                    let vc = AutoDiffViewController()

                    self?.navigationController?.pushViewController(vc, animated: true)
                }),
                ("Interactive movement", { [weak self] in
                    let vc = MovementViewController()

                    self?.navigationController?.pushViewController(vc, animated: true)
                }),
                ("Size constraints (different cell sizes)", { [weak self] in
                    let vc = SizeConstraintsDemoViewController()

                    self?.navigationController?.pushViewController(vc, animated: true)
                }),
                ("Waterfall (custom collection layout)", { [weak self] in
                    let vc = WaterfallViewController()

                    self?.navigationController?.pushViewController(vc, animated: true)
                }),
                ("Horizontal list in row", { [weak self] in
                    let vc = MultiGalleriesViewController()

                    self?.navigationController?.pushViewController(vc, animated: true)
                })
            ]

            let items = menuRows.enumerated().map { (index, row) -> ListItem in
                let rowItem = ListItem(
                    id: row.name,
                    layoutSpec: SelectableRowLayoutSpec(model: row.name)
                )

                rowItem.setup = { [weak self] view, itemIndex in
                    view.all_addGestureRecognizer { (_: UITapGestureRecognizer) in
                        self?.adapter.collectionView.deselectItem(at: IndexPath(item: itemIndex, section: 0), animated: true)

                        row.onSelect()
                    }
                }

                return rowItem
            }

            adapter.set(items: items)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setToolbarHidden(true, animated: animated)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        adapter.collectionView.frame = view.bounds

        adapter.set(boundingDimensions: CGSize(width: view.bounds.width, height: .nan).layoutDimensions)
    }
}
