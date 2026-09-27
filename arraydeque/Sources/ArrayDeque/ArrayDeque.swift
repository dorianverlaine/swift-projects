/// A deque stored in a circular array that grows and shrinks as needed.
///
/// Requirements (see the project page for details):
/// - Store the items in a `[Element?]` used as fixed-size storage: create it
///   with a given number of slots, and afterwards only read and write slots.
///   No `append`, `insert`, or `remove` on it.
/// - Start with 8 slots. Double when full. Halve when fewer than a quarter of
///   the slots are used, but never below 8.
/// - `addFirst`, `addLast`, `removeFirst`, `removeLast`, `get`, and the
///   subscript take constant time, except for the occasional resize.
/// - Slots that do not hold an item are nil.
public struct ArrayDeque<Element>: Deque {
    // Declare your stored properties here.

    public init() {}

    // Task 1
    public var count: Int {
        0 // Replace this line.
    }

    /// The number of slots in the storage. (Task 1)
    public var capacity: Int {
        0 // Replace this line.
    }

    // Task 1
    public mutating func addFirst(_ item: Element) {
    }

    // Task 1
    public mutating func addLast(_ item: Element) {
    }

    // Task 2
    public func get(_ index: Int) -> Element? {
        nil // Replace this line.
    }

    // Task 2
    public func toArray() -> [Element] {
        [] // Replace this line.
    }

    // Task 3
    public mutating func removeFirst() -> Element? {
        nil // Replace this line.
    }

    // Task 3
    public mutating func removeLast() -> Element? {
        nil // Replace this line.
    }
}

// Task 5
extension ArrayDeque: RandomAccessCollection, MutableCollection {
    public var startIndex: Int { 0 }
    public var endIndex: Int { count }

    /// Provided. Deque and Collection both supply an `isEmpty`; this one
    /// settles which the deque uses.
    public var isEmpty: Bool { count == 0 }

    public subscript(position: Int) -> Element {
        get {
            fatalError("Task 5 is not done yet") // Replace this line.
        }
        set {
            // Your code here.
        }
    }
}

// Task 6
extension ArrayDeque: CustomStringConvertible {
    public var description: String {
        "" // Replace this line.
    }
}

// Task 6
extension ArrayDeque: Equatable where Element: Equatable {
    public static func == (lhs: ArrayDeque, rhs: ArrayDeque) -> Bool {
        false // Replace this line.
    }
}

// Task 6
extension Deque where Element: Equatable {
    /// Whether two deques of any kinds hold the same items in the same order.
    public func hasSameItems(as other: some Deque<Element>) -> Bool {
        false // Replace this line.
    }
}
