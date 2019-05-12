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

final class MailViewController: UIViewController {
    let adapter = CollectionViewAdapter()

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            view.backgroundColor = UIColor.white

            view.addSubview(adapter.collectionView)

            adapter.collectionView.backgroundColor = UIColor.white
        }

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

        adapter.collectionView.frame = view.bounds

        adapter.set(sizeConstraints: SizeConstraints(width: view.bounds.width))
    }

    private var rows: [MailRow] = [] {
        didSet {
            let items = rows.map { row -> ListItem in
                let item = ListItem(
                    id: row.id,
                    model: row,
                    layoutSpec: MailRowLayoutSpec(model: row)
                )

                let deleteAction = SwipeAction(
                    layoutSpec: MailRowSwipeActionLayoutSpec(model: MailRowSwipeItem(image: UIImage(named: "trash")!, text: "Delete")),
                    color: #colorLiteral(red: 0.7450980544, green: 0.1884698107, blue: 0.1212462212, alpha: 1),
                    perform: { [weak self] in
                        guard let strongSelf = self else { return }

                        _ = strongSelf.rows.firstIndex(of: row).flatMap { strongSelf.rows.remove(at: $0) }
                })

                let customAction = SwipeAction(
                    layoutSpec: MailRowSwipeActionLayoutSpec(model: MailRowSwipeItem(image: UIImage(named: "setting")!, text: "Other")),
                    color: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1),
                    perform: { [weak self] in
                        guard let strongSelf = self else { return }

                        let alert = UIAlertController(title: "WOW", message: "This is alert", preferredStyle: .alert)

                        alert.addAction(UIAlertAction(title: "Close me", style: .cancel, handler: nil))

                        strongSelf.present(alert, animated: true, completion: nil)
                })

                item.swipeActions = SwipeActions([customAction, deleteAction])

                item.didTap = { _, _ in
                    print(row.text)
                }

                return item
            }

            adapter.set(items: items)
        }
    }
}
