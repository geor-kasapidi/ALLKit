//
//  Extensions.swift
//  ALLKit
//
//  Created by Georgy Kasapidi on 2/15/20.
//

import Foundation
import UIKit
import ALLKit

struct DemoContext {
    var onSelect: (() -> Void)?
    var willDisplay: ((UIView) -> Void)?
    var didEndDisplaying: ((UIView) -> Void)?
}

class ListViewController<T0: UICollectionView, T1: UICollectionViewCell>: UIViewController, UICollectionViewDelegateFlowLayout {
    let adapter: CollectionViewAdapter<T0, T1, DemoContext>

    init(adapter: CollectionViewAdapter<T0, T1, DemoContext> = CollectionViewAdapter()) {
        self.adapter = adapter

        super.init(nibName: nil, bundle: nil)

        adapter.collectionView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        view.addSubview(adapter.collectionView)
        adapter.collectionView.backgroundColor = UIColor.white
        adapter.collectionView.alwaysBounceVertical = true
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        adapter.collectionView.frame = view.bounds
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        adapter.sizeForItem(at: indexPath.item) ?? .zero
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {}

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {}
}

extension CollectionViewAdapter {
    public convenience init(scrollDirection: UICollectionView.ScrollDirection = .vertical,
                            sectionInset: UIEdgeInsets = .zero,
                            minimumLineSpacing: CGFloat = 0,
                            minimumInteritemSpacing: CGFloat = 0) {
        let flowLayout = UICollectionViewFlowLayout()

        do {
            flowLayout.scrollDirection = scrollDirection
            flowLayout.sectionInset = sectionInset
            flowLayout.minimumLineSpacing = minimumLineSpacing
            flowLayout.minimumInteritemSpacing = minimumInteritemSpacing
            flowLayout.headerReferenceSize = .zero
            flowLayout.footerReferenceSize = .zero
        }

        self.init(layout: flowLayout)
    }
}
