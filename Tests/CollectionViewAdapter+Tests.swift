import XCTest
import Foundation
import UIKit

@testable
import ALLKit

private class TestLayoutSpec: LayoutSpec {
    override func makeNodeWith(boundingDimensions: LayoutDimensions<CGFloat>) -> LayoutNodeConvertible {
        return LayoutNode({
            $0.height(100)
        })
    }
}

private class CustomCollectionView: UICollectionView {}
private class CustomCell: UICollectionViewCell {}

class CollectionViewAdapterTests: XCTestCase {
    func testStability() {
        let adapter = CollectionViewAdapter<UICollectionView, UICollectionViewCell, Void>(layout: UICollectionViewFlowLayout())

        let n = 500

        let exp = XCTestExpectation()

        (0..<n-1).forEach { i in
            if i % 3 == 0 {
                let bd = CGSize(width: CGFloat(drand48() * 1000), height: CGFloat(drand48() * 1000)).layoutDimensions

                adapter.set(boundingDimensions: bd, async: i % 2 == 0)
            } else {
                let count = Int.random(in: 0..<20)
                let items = (0..<count).map({ _ -> ListItem<Void> in
                    ListItem(
                        id: UUID().uuidString,
                        layoutSpec: TestLayoutSpec()
                    )
                })

                adapter.set(items: items, animated: i % 2 == 0)
            }
        }

        adapter.set(boundingDimensions: CGSize(width: 500, height: 500).layoutDimensions) { _ in
            exp.fulfill()
        }

        wait(for: [exp], timeout: 100)
    }

    func testCustomCellsAndCollectionView() {
        let adapter = CollectionViewAdapter<CustomCollectionView, CustomCell, Void>(layout: UICollectionViewFlowLayout())
        adapter.collectionView.frame = CGRect(x: 0, y: 0, width: 300, height: 500)

        var items: [ListItem<Void>] = []

        do {
            let id = UUID().uuidString
            let li = ListItem<Void>(id: id, layoutSpec: TestLayoutSpec())

            items.append(li)
        }

        adapter.set(items: items)

        let exp = XCTestExpectation()

        adapter.set(boundingDimensions: CGSize(width: 300, height: CGFloat.nan).layoutDimensions) { _ in
            exp.fulfill()
        }

        wait(for: [exp], timeout: 10)

        XCTAssert(adapter.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) is CustomCell)
    }
}
