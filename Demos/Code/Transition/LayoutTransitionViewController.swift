import Foundation
import UIKit
import ALLKit

struct UserProfile {
    let avatar: URL?
    let name: String
    let description: String
}

final class LayoutTransitionViewController: UIViewController {
    private let userProfile = UserProfile(
        avatar: URL(string: "https://picsum.photos/100/100?random&q=\(Int.random(in: 1..<1000))"),
        name: "John Smith",
        description: DemoContent.loremIpsum.joined(separator: ". ")
    )

    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()

    private lazy var portraitLayoutSpec = PortraitProfileLayoutSpec(model: userProfile)
    private lazy var landscapeLayoutSpec = LandscapeProfileLayoutSpec(model: userProfile)

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

        let size = view.bounds.size

        let layoutSpec = size.width > size.height ? landscapeLayoutSpec : portraitLayoutSpec

        let layout = layoutSpec.makeLayoutWith(boundingDimensions: CGSize(width: size.width, height: .nan).layoutDimensions)

        scrollView.contentSize = layout.size

        layout.setup(in: contentView)
    }
}
