import Foundation
import UIKit

public final class AsyncLabel: UIView {
    private let renderQueue = DispatchQueue(label: "ALLKit.AsyncLabel.renderQueue")

    public var stringDrawing: AttributedStringDrawing? {
        willSet {
            assert(Thread.isMainThread)
        }
        didSet {
            render(stringDrawing, bounds.size)
        }
    }

    private func render(_ stringDrawing: AttributedStringDrawing?, _ size: CGSize) {
        renderQueue.async { [weak self] in
            let image = stringDrawing?.draw(with: size)

            DispatchQueue.main.async {
                self?.layer.contents = image?.cgImage
            }
        }
    }
}
