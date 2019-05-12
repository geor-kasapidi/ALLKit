import Foundation
import UIKit
import ALLKit

final class CombinedLayoutViewController: UIViewController {
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    private lazy var layoutSpec = SwitcherListLayoutSpec(model: DemoContent.NATO)

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            view.backgroundColor = UIColor.white

            view.addSubview(scrollView)

            scrollView.addSubview(contentView)
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        scrollView.frame = view.bounds

        let layout = layoutSpec.makeLayoutWith(sizeConstraints: SizeConstraints(width: view.bounds.width))

        scrollView.contentSize = layout.size
        layout.setup(in: contentView)
    }
}
