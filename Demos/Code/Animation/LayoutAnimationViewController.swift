import Foundation
import UIKit
import ALLKit

struct AnimationDemoModel {
    let url: URL?
    let title: String
    let subtitle: String
}

final class LayoutAnimationViewController: UIViewController {
    private let model = AnimationDemoModel(
        url: URL(string: "https://picsum.photos/640/480?random&q=\(Int.random(in: 1..<1000))"),
        title: "Lorem Ipsum",
        subtitle: DemoContent.loremIpsum.joined(separator: " ")
    )

    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()

    private lazy var horizontalLayoutSpec = HorizontalSnippetLayoutSpec(model: model)
    private lazy var verticalLayoutSpec = VerticalSnippetLayoutSpec(model: model)

    private var currentLayoutSpec: LayoutSpec? = nil {
        didSet {
            view.setNeedsLayout()
        }
    }

    private var isHorizontal: Bool = false {
        didSet {
            guard isHorizontal != oldValue else { return }

            currentLayoutSpec = isHorizontal ? horizontalLayoutSpec : verticalLayoutSpec
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            view.backgroundColor = UIColor.white

            view.addSubview(scrollView)

            scrollView.addSubview(contentView)
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Change layout",
            style: .plain,
            target: self,
            action: #selector(changeLayout)
        )

        isHorizontal = true
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        scrollView.frame = view.bounds

        guard let layoutSpec = currentLayoutSpec else {
            return
        }

        let size = view.bounds.size

        let layout = layoutSpec.makeLayoutWith(sizeConstraints: SizeConstraints(width: size.width))

        scrollView.contentSize = layout.size

        layout.setup(in: contentView)
    }

    @objc
    private func changeLayout() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.toggleLayout()
        }
    }

    private func toggleLayout() {
        isHorizontal = !isHorizontal

        view.layoutIfNeeded()
    }
}
