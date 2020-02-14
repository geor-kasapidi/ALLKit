import ObjectiveC
import Foundation
import UIKit

private final class AssociatedProxyTable<KeyType: AnyObject, ValueType: AnyObject> {
    private let key: UnsafeRawPointer

    init(key: UnsafeRawPointer) {
        self.key = key
    }

    subscript(holder: KeyType) -> ValueType? {
        get { objc_getAssociatedObject(holder, key) as? ValueType }
        set { objc_setAssociatedObject(holder, key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

extension UIControl {
    private final class Handler: NSObject {
        let action: () -> Void

        init(action: @escaping () -> Void) {
            self.action = action
        }

        @objc
        func invoke() {
            action()
        }
    }

    private struct Storage {
        private static var key = 0

        static let table = AssociatedProxyTable<UIControl, NSMutableDictionary>(key: &key)
    }

    public func all_setEventHandler(for controlEvents: UIControl.Event, _ action: (() -> Void)?) {
        let handlers = Storage.table[self] ?? NSMutableDictionary()
        if let currentHandler = handlers[controlEvents.rawValue] {
            removeTarget(currentHandler, action: #selector(Handler.invoke), for: controlEvents)
            handlers[controlEvents.rawValue] = nil
        }
        if let newAction = action {
            let newHandler = Handler(action: newAction)
            addTarget(newHandler, action: #selector(Handler.invoke), for: controlEvents)
            handlers[controlEvents.rawValue] = newHandler
        }
        Storage.table[self] = handlers
    }
}

extension UIView {
    private final class Handler<GestureType: UIGestureRecognizer>: NSObject {
        private let action: (GestureType) -> Void

        init(action: @escaping (GestureType) -> Void) {
            self.action = action
        }

        @objc
        func invoke(gesture: UIGestureRecognizer) {
            (gesture as? GestureType).flatMap {
                action($0)
            }
        }
    }

    private struct Storage {
        private static var key = 0

        static let table = AssociatedProxyTable<UIGestureRecognizer, NSObject>(key: &key)
    }

    @discardableResult
    public func all_addGestureRecognizer<GestureType: UIGestureRecognizer>(_ action: @escaping (GestureType) -> Void) -> GestureType {
        let handler = Handler<GestureType>(action: action)
        let gesture = GestureType(target: handler, action: #selector(Handler.invoke(gesture:)))
        Storage.table[gesture] = handler
        addGestureRecognizer(gesture)
        return gesture
    }
}
