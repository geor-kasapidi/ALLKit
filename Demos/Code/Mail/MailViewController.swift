import Foundation
import UIKit
import ALLKit

struct MailRow: Equatable {
    let id = UUID().uuidString
    let title: String
    let text: String

    static func ==(lhs: MailRow, rhs: MailRow) -> Bool {
        return lhs.id == rhs.id
    }
}

struct MailRowSwipeItem {
    let image: UIImage
    let text: String
}

final class MailViewController: ListViewController<UICollectionView, UICollectionViewCell> {
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.global().async {
            let sentences = DemoContent.loremIpsum

            let rows = (0..<20).map({ _ -> MailRow in
                let text = sentences.randomElement()!

                return MailRow(title: UUID().uuidString, text: text)
            })

            DispatchQueue.main.async {
                self.rows = rows
            }
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        adapter.set(boundingDimensions: CGSize(width: view.bounds.width, height: .nan).layoutDimensions)
    }

    private var rows: [MailRow] = [] {
        didSet {
            let items = rows.map { row -> ListItem<DemoContext> in
                let item = ListItem<DemoContext>(
                    id: row.id,
                    layoutSpec: MailRowLayoutSpec(model: row)
                )

                let deleteAction = SwipeAction(
                    layoutSpec: MailRowSwipeActionLayoutSpec(model: MailRowSwipeItem(image: UIImage(named: "trash")!, text: "Delete")),
                    setup: ({ [weak self] view, close in
                        view.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1884698107, blue: 0.1212462212, alpha: 1)
                        view.all_addGestureRecognizer { (_: UITapGestureRecognizer) in
                            guard let strongSelf = self else { return }

                            close(true)

                            _ = strongSelf.rows.firstIndex(of: row).flatMap { strongSelf.rows.remove(at: $0) }
                        }
                    })
                )

                let customAction = SwipeAction(
                    layoutSpec: MailRowSwipeActionLayoutSpec(model: MailRowSwipeItem(image: UIImage(named: "setting")!, text: "Other")),
                    setup: ({ [weak self] view, close in
                        view.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                        view.all_addGestureRecognizer { (_: UITapGestureRecognizer) in
                            guard let strongSelf = self else { return }

                            close(true)

                            let alert = UIAlertController(title: "WOW", message: "This is alert", preferredStyle: .alert)

                            alert.addAction(UIAlertAction(title: "Close me", style: .cancel, handler: nil))

                            strongSelf.present(alert, animated: true, completion: nil)
                        }
                    })
                )

                if let actions = SwipeActions([customAction, deleteAction]) {
                    item.makeView = { layout, index -> UIView in
                        actions.makeView(contentLayout: layout)
                    }
                }

                return item
            }

            adapter.set(items: items)
        }
    }
}
