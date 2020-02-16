# Managing collection views

[Basic concepts](basic_concepts.md)

Instead of direct UICollectionView usage, ALLKit provides smart abstraction over:

```swift
let adapter = CollectionViewAdapter<...>(layout: /* collectionViewLayout */)
```

Adapter is a collection view data source (delegate is up to you) and manages cells using yoga layout.

All you need is just pass bouding dimensions:

```swift
adapter.collectionView.frame = view.bounds

adapter.set(
    boundingDimensions: CGSize(...).layoutDimensions
)
```

and data items:

```swift
let items: [ListItem<...>] = ...

adapter.set(items: items, animated: true)
```

That's it. And no direct calls of `performBatchUpdates` or `reloadData`.

[ListItem](../Sources/ListKit/ListItem.swift) object represents cell and connects data model with UI:

```swift
let item = ListItem<...>(id: Hashable, layoutSpec: LayoutSpec)
```

ID is needed to [calculate the changes](auto_diff.md) between the previous and current item lists.

### Swipe actions

UICollectionView does not have built-in swiping support, like UITableView. With ALLKit, you can easily set up swipe actions (available by Extended subspec):

```swift
let actions = SwipeActions(...)

item.makeView = { layout, index -> UIView in
    actions.makeView(contentLayout: layout)
}
```

### Different sizes

In complex lists, items can have different sizes — a full-width header, a multi-column grid, etc. For this purpose, ListItem has a special property:

```swift
item.boundingDimensionsModifier = { w, h in
    return (w / 2, .nan)
}
```

### Interactive movement

To enable this feature, you need to configure both the adapter and the elements:

```swift
adapter.settings.allowInteractiveMovement = true

adapter.collectionView.all_addGestureRecognizer { [weak self] (g: UILongPressGestureRecognizer) in
    self?.adapter.handleMoveGesture(g)
}
...

item.canMove = true
item.didMove = { from, to in }
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

let adapter = CollectionViewAdapter<UICollectionView, CustomCell, Any>()
```

### ❗️❗️❗️ DO NOT ❗️❗️❗️

* ...modify cell's contentView directly. Adapter creates cell UI based on the spec that you specified in the ListItem object.
* ...call collection view methods that are relevant to updating UI, such as `reloadData`, `performBatchUpdates`, etc. May the [AutoDiff](auto_diff.md) be with you.
* ...setting the collection view dataSource.
* ...enable prefetching in collection view.
