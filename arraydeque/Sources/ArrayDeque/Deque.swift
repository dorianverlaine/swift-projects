// Provided. Do not change this file.

/// A double-ended queue: a list that can add and remove items at both ends.
///
/// Project 6 implements it with a circular doubly linked list, and Project 7
/// with a circular array. Both must pass the same tests.
public protocol Deque<Element> {
    associatedtype Element

    /// The number of items in the deque.
    var count: Int { get }

    /// Adds an item to the front.
    mutating func addFirst(_ item: Element)

    /// Adds an item to the back.
    mutating func addLast(_ item: Element)

    /// Removes and returns the front item, or returns nil if the deque is empty.
    mutating func removeFirst() -> Element?

    /// Removes and returns the back item, or returns nil if the deque is empty.
    mutating func removeLast() -> Element?

    /// The item at `index`, where 0 is the front, or nil if there is no such item.
    func get(_ index: Int) -> Element?

    /// All the items, from front to back.
    func toArray() -> [Element]
}

extension Deque {
    /// Whether the deque has no items.
    public var isEmpty: Bool { count == 0 }
}
