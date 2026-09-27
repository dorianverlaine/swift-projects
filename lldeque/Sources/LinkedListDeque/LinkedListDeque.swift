/// A deque stored in a circular doubly linked list with one sentinel node.
///
/// Requirements (see the project page for details):
/// - `addFirst`, `addLast`, `removeFirst`, `removeLast`, and `count` take
///   constant time, whatever the number of items.
/// - `get` may walk the list, but never more than half of it.
/// - No loops over the whole list except in `get`, `getRecursive`, and `toArray`.
/// - The deque never leaks: when it is freed, every node and item is freed.
public final class LinkedListDeque<Element>: Deque {
    // Declare your node class and properties here.

    public init() {
        // Task 1
    }

    // Task 1
    public var count: Int {
        0 // Replace this line.
    }

    // Task 1
    public func addFirst(_ item: Element) {
    }

    // Task 1
    public func addLast(_ item: Element) {
    }

    // Task 2
    public func toArray() -> [Element] {
        [] // Replace this line.
    }

    // Task 3
    public func get(_ index: Int) -> Element? {
        nil // Replace this line.
    }

    // Task 4
    public func getRecursive(_ index: Int) -> Element? {
        nil // Replace this line.
    }

    // Task 5
    public func removeFirst() -> Element? {
        nil // Replace this line.
    }

    // Task 5
    public func removeLast() -> Element? {
        nil // Replace this line.
    }
}
