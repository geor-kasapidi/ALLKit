import Foundation

extension Array {
    mutating func move(from i: Index, to j: Index) {
        insert(remove(at: i), at: j)
    }

    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

func onMainThread(_ closure: @escaping () -> Void) {
    if Thread.isMainThread {
        closure()
    } else {
        DispatchQueue.main.async(execute: closure)
    }
}
