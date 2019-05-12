import Foundation
import UIKit

protocol ViewFactory {
    func makeView() -> UIView

    func config(view: UIView, isNew: Bool)
}

final class GenericViewFactory<ViewType: UIView>: ViewFactory {
    private let config: (ViewType, Bool) -> Void

    init(_ config: @escaping (ViewType, Bool) -> Void) {
        self.config = config
    }

    func makeView() -> UIView {
        return ViewType(frame: .zero)
    }

    func config(view: UIView, isNew: Bool) {
        (view as? ViewType).flatMap { config($0, isNew) }
    }
}
