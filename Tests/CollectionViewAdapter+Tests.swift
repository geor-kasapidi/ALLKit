import XCTest
import Foundation
import UIKit

@testable
import ALLKit

private class TestLayoutSpec: LayoutSpec {
    override func makeNodeWith(sizeConstraints: SizeConstraints) -> LayoutNode {
        return LayoutNode(config: { node in
            node.height = 100
        })
    }
}

private class CustomCollectionView: UICollectionView {}
private class CustomCell: UICollectionViewCell {}

class CollectionViewAdapterTests: XCTestCase {
    func testStability() {
        let adapter = CollectionViewAdapter()

        let n = 500

        let exp = XCTestExpectation()

        (0..<n-1).forEach { i in
            if i % 3 == 0 {
                let sc = SizeConstraints(width: CGFloat(drand48() * 1000), height: CGFloat(drand48() * 1000))

                adapter.set(sizeConstraints: sc, async: i % 2 == 0)
            } else {
                let count = Int.random(in: 0..<20)
                let items = (0..<count).map({ _ -> ListItem in
                    ListItem(
                        id: UUID().uuidString,
                        layoutSpec: TestLayoutSpec()
                    )
                })

                adapter.set(items: items, animated: i % 2 == 0)
            }
        }

        adapter.set(sizeConstraints: SizeConstraints(width: 500, height: 500)) { _ in
            exp.fulfill()
        }

        wait(for: [exp], timeout: 100)
    }

    func testCustomCellsAndCollectionView() {
        let adapter = CollectionViewAdapter<CustomCollectionView, CustomCell>(layout: UICollectionViewFlowLayout())
        adapter.collectionView.frame = CGRect(x: 0, y: 0, width: 300, height: 500)

        var items: [ListItem] = []

        do {
            let id = UUID().uuidString
            let li = ListItem(id: id, layoutSpec: TestLayoutSpec())

            items.append(li)
        }

        adapter.set(items: items)

        let exp = XCTestExpectation()

        adapter.set(sizeConstraints: SizeConstraints(width: 300, height: .nan)) { _ in
            exp.fulfill()
        }

        wait(for: [exp], timeout: 10)

        XCTAssert(adapter.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) is CustomCell)
    }

    func testEvents() {
        let adapter = CollectionViewAdapter(layout: UICollectionViewFlowLayout())

        adapter.collectionView.frame = CGRect(x: 0, y: 0, width: 300, height: 4000)

        var events: Set<String> = []

        adapter.scrollEvents.didChangeAdjustedContentInset = { _ in events.insert("didChangeAdjustedContentInset") }
        adapter.scrollEvents.didEndDecelerating = { _ in events.insert("didEndDecelerating") }
        adapter.scrollEvents.didEndDragging = { _ in events.insert("didEndDragging") }
        adapter.scrollEvents.didEndScrollingAnimation = { _ in events.insert("didEndScrollingAnimation") }
        adapter.scrollEvents.didScroll = { _ in events.insert("didScroll") }
        adapter.scrollEvents.didScrollToTop = { _ in events.insert("didScrollToTop") }
        adapter.scrollEvents.willBeginDecelerating = { _ in events.insert("willBeginDecelerating") }
        adapter.scrollEvents.willBeginDragging = { _ in events.insert("willBeginDragging") }
        adapter.scrollEvents.willEndDragging = { _ in events.insert("willEndDragging") }

        let items: [ListItem] = (0..<1000).map { _ in
            let id = UUID().uuidString

            let item = ListItem(id: id, layoutSpec: TestLayoutSpec())
            item.willShow = { _, _ in
                events.insert("willDisplay")
            }

            return item
        }

        let exp = XCTestExpectation()

        adapter.set(items: items) { _ in
            adapter.set(sizeConstraints: SizeConstraints(width: 300), async: true, completion: { _ in
                adapter.dataSource.moveItem(from: 100, to: 200)

                exp.fulfill()
            })
        }

        wait(for: [exp], timeout: 10)

        adapter.collectionView.setContentOffset(CGPoint(x: 0, y: 1000), animated: true)

        print(events)

        XCTAssert(events.contains("willDisplay"))
        XCTAssert(events.contains("didScroll"))
    }
}
