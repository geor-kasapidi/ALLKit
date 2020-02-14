import Foundation
import UIKit

public struct SwipeAction {
    public typealias ViewSetup = (UIView, @escaping (Bool) -> Void) -> Void // view + close(animated)

    public let layoutSpec: LayoutSpec
    public let setup: ViewSetup

    public init(layoutSpec: LayoutSpec, setup: @escaping ViewSetup) {
        self.layoutSpec = layoutSpec
        self.setup = setup
    }
}

public struct SwipeActions {
    public let list: [SwipeAction]
    public let size: CGFloat

    public init?(_ list: [SwipeAction], size: CGFloat = 96) {
        assert(size > 0)

        guard size.isNormal, !list.isEmpty else { return nil }

        self.list = list
        self.size = size
    }
}

public protocol SwipeViewPublicInterface {
    func open(animated: Bool)
    func close(animated: Bool)
}

final class SwipeView: UIView, UIGestureRecognizerDelegate {
    private let contentView = UIView()
    private let buttonWidth: CGFloat
    private var buttons: [UIView] = []

    init(contentLayout: Layout, actions: SwipeActions) {
        buttonWidth = actions.size

        super.init(frame: CGRect(origin: .zero, size: contentLayout.size))

        clipsToBounds = true

        do {
            let boundingSize = CGSize(width: buttonWidth, height: contentLayout.size.height)

            actions.list.reversed().forEach { action in
                let layout = action.layoutSpec.makeLayoutWith(boundingDimensions: boundingSize.layoutDimensions)

                let view = UIView(frame: CGRect(
                    x: 0,
                    y: 0,
                    width: buttonWidth,
                    height: contentLayout.size.height
                ))
                view.clipsToBounds = true
                view.addSubview(layout.makeView())
                action.setup(view, { [weak self] animated in
                    self?.update(offset: 0, animated: animated)
                })
                addSubview(view)

                buttons.append(view)
            }
        }

        do {
            contentView.addSubview(contentLayout.makeView())

            contentView.isExclusiveTouch = true

            addSubview(contentView)

            contentView.all_addGestureRecognizer({ [weak self] (pan: UIPanGestureRecognizer) in
                self?.didUpdateGestureState(pan)
            }).delegate = self

            contentView.all_addGestureRecognizer({ [weak self] (_: UITapGestureRecognizer) in
                self?.update(offset: 0, animated: true)
            }).delegate = self
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: -

    private var location: CGFloat = 0

    private func didUpdateGestureState(_ pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .began:
            location = contentView.frame.minX
        case .changed:
            let translation = pan.translation(in: contentView).x

            let w = CGFloat(buttons.count) * buttonWidth

            let x = max(0, -(translation + location))

            if x < w {
                update(offset: x/w, animated: false)
            } else {
                update(offset: pow(CGFloat(M_E), 1-w/x), animated: false)
            }
        default:
            let translation = pan.translation(in: contentView).x

            update(offset: offset > 1 ? 1 : (translation > 0 ? 0 : 1), animated: true)
        }
    }

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let tap = gestureRecognizer as? UITapGestureRecognizer, tap.view === contentView {
            return offset > 0
        }

        if let pan = gestureRecognizer as? UIPanGestureRecognizer, pan.view === contentView {
            let translation = pan.translation(in: contentView)

            return pan.numberOfTouches == 1 && abs(translation.y) < abs(translation.x)
        }

        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }

    // MARK: -

    private func update(offset value: CGFloat, animated: Bool) {
        guard (value.isZero || value.isNormal), value >= 0, value != offset else { return }

        offset = value

        setNeedsLayout()

        if animated {
            UIView.animate(
                withDuration: 0.2,
                delay: 0,
                options: [.allowUserInteraction, .beginFromCurrentState],
                animations: layoutIfNeeded,
                completion: nil
            )
        } else {
            UIView.performWithoutAnimation(layoutIfNeeded)
        }
    }

    private var offset: CGFloat = 0

    // MARK: -

    override func layoutSubviews() {
        super.layoutSubviews()

        let bounds = self.bounds

        guard !bounds.isEmpty else { return }

        let viewWidth = buttonWidth * offset

        contentView.frame = bounds.offsetBy(
            dx: -CGFloat(buttons.count) * viewWidth,
            dy: 0
        )

        buttons.enumerated().forEach { (index, view) in
            view.frame = CGRect(
                x: bounds.width - CGFloat(index + 1) * viewWidth,
                y: 0,
                width: viewWidth,
                height: bounds.height
            )
        }
    }
}

extension SwipeView: SwipeViewPublicInterface {
    func open(animated: Bool) {
        update(offset: 1, animated: animated)
    }

    func close(animated: Bool) {
        update(offset: 0, animated: animated)
    }
}
