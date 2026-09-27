/// An N-by-N grid of sites, each blocked or open. An open site is full if it
/// is connected to the top row through a chain of open neighbors (up, down,
/// left, right). The system percolates if some site in the bottom row is full.
///
/// Rows and columns count from 0, and row 0 is the top. Every method must
/// check its arguments with a precondition. `open`, `isOpen`, `isFull`, and
/// `percolates` must each use a constant number of union-find operations.
public struct Percolation: Sendable {
    public let size: Int

    // Declare your stored properties here, and write their invariants in a
    // comment above them.

    public init(size: Int) {
        precondition(size > 0, "the grid must have at least one site")
        self.size = size
        // Task 1
    }

    // Task 1
    public var openSites: Int {
        0 // Replace this line.
    }

    // Task 1 and 2
    public mutating func open(row: Int, column: Int) {
    }

    // Task 1
    public func isOpen(row: Int, column: Int) -> Bool {
        false // Replace this line.
    }

    // Task 2 and 3
    public func isFull(row: Int, column: Int) -> Bool {
        false // Replace this line.
    }

    // Task 2
    public func percolates() -> Bool {
        false // Replace this line.
    }
}
