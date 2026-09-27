import Testing
@testable import PercolationCore

// Task 5: write your own tests here. Ideas: compare isFull with a simple
// breadth-first search from the top row on random grids; check that opening
// every site in a grid always percolates; and time opening every site of a
// 500 × 500 grid in a release build (`swift test -c release`).

@Test func myFirstTest() {
    var grid = Percolation(size: 2)
    grid.open(row: 0, column: 0)
    #expect(grid.isOpen(row: 0, column: 0))
}
