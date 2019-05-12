# AutoDiff

Diffing is a very popular technique in modern mobile apps development.
It's easy to convert changes between two lists (inserts, deletes, moves, updates) into a UICollectionView batch update.

To find changes between arrays, their elements must be:

1. [Diffable](../Sources/Diff/Diffable.swift) (heterogeneous data):

```swift
let old: [ListItem] = ...
let new: [ListItem] = ...

let changes = Diff.between(old, and: new)
```

ListItem is Diffable out of the box.

or

2. Hashable (homogeneous data):

```swift
let old = Array("abc")
let new = Array("abcd")

let changes = Diff.between(old, and: new)
```

[Provided implementation](../Sources/Diff/Diff.swift) is based on the Paul Heckel algorithm.

[CollectionViewAdapter](list_view.md) uses diffing to animate UICollectionView updates.
