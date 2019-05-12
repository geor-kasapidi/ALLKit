import Foundation
import UIKit

public protocol Layout: class {
    var size: CGSize { get }

    func makeContentIn(view: UIView)
}

extension Layout {
    public func setup(in view: UIView, at origin: CGPoint = .zero) {
        view.frame = CGRect(origin: origin, size: size)

        makeContentIn(view: view)
    }

    public func makeView() -> UIView {
        let view = UIView()
        setup(in: view)
        return view
    }
}
