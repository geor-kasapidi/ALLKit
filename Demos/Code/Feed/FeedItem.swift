import Foundation

struct FeedItem: Equatable {
    let id = UUID().uuidString
    let avatar: URL?
    let title: String
    let date: Date
    let image: URL?
    let likesCount: UInt
    let viewsCount: UInt

    static func ==(lhs: FeedItem, rhs: FeedItem) -> Bool {
        return lhs.id == rhs.id
    }
}
