# Managing collection views

[Basic concepts](basic_concepts.md)

Instead of direct UICollectionView usage, ALLKit provides smart abstraction over:

```swift
let adapter = CollectionViewAdapter(layout: /* collectionViewLayout */)
```

Forget about manual setting delegate and datasource, cell subclassing, etc. Just pass size constraints and items array into adapter:

```swift
adapter.collectionView.frame = view.bounds

adapter.set(
    boundingDimensions: CGSize(...).layoutDimensions
)

...

let items: [ListItem] = ...

adapter.set(items: items, animated: true)
```

That's it. And no direct calls of `performBatchUpdates` or `reloadData`.

[ListItem](../Sources/ListKit/ListItem.swift) object represents cell and connects data model with UI:

```swift
let item = ListItem(id: Hashable, layoutSpec: LayoutSpec)

item.setup = { view, index in

}

item.willDisplay = { view, index in

}
```

ID and model are needed to [calculate the changes](auto_diff.md) between the previous and current item lists.

### Swipe actions

UICollectionView does not have built-in swiping support, like UITableView. With ALLKit, you can easily set up swipe actions:

```swift
item.swipeActions = SwipeActions(
    [
        SwipeAction(layoutSpec: LayoutSpec1, setup: { ... }),
        SwipeAction(layoutSpec: LayoutSpec2, setup: { ... })
    ]
)
```

### Different sizes

In complex lists, items can have different sizes — a full-width header, a multi-column grid, etc. For this purpose, ListItem has a special property:

```swift
item.boundingDimensionsModifier = { w, h in
    return (w / 2, .nan)
}
```

### Scroll events

Adapter has an object through which you can receive UIScrollViewDelegate events:

```swift
adapter.scrollEvents.didScroll = { scrollView in

}

adapter.scrollEvents.willEndDragging = { ctx in
    print(ctx.scrollView, ctx.velocity, ctx.targetContentOffset)
}

...
```

### Interactive movement

To enable this feature, you need to configure both the adapter and the elements:

```swift
adapter.settings.allowInteractiveMovement = true
adapter.setupGestureForInteractiveMovement()

...

item.canMove = true
item.didMove = { from, to in

}
```

### Custom collection view and cells

In most cases, this feature is not used. But sometimes, for example, if you want to override cell layout attributes, it can be useful:

```swift
final class CustomCell: UICollectionViewCell {
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        ...
    }
}

...

let adapter = CollectionViewAdapter<UICollectionView, CustomCell>()
```

### ❗️❗️❗️ DO NOT ❗️❗️❗️

* ...modify cell's contentView directly. Adapter creates cell UI based on the spec that you specified in the ListItem object.
* ...call collection view methods that are relevant to updating UI, such as `reloadData`, `performBatchUpdates`, etc. May the [AutoDiff](auto_diff.md) be with you.
* ...setting the collection view delegate and dataSource.
* ...enable prefetching in collection view.
