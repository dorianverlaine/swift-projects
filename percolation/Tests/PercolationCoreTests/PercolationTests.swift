import Testing
@testable import PercolationCore

// Provided tests. Write your own in MyTests.swift.

/// A grid opened from a picture: "#" is open, anything else is blocked.
func grid(_ rows: [String]) -> Percolation {
    var result = Percolation(size: rows.count)
    for (r, row) in rows.enumerated() {
        for (c, cell) in row.enumerated() where cell == "#" {
            result.open(row: r, column: c)
        }
    }
    return result
}

@Suite("Task 1: opening sites")
struct OpeningTests {
    @Test func startsBlocked() {
        let g = Percolation(size: 3)
        #expect(g.openSites == 0 && !g.isOpen(row: 1, column: 1))
    }

    @Test func openingIsCountedOnce() {
        var g = Percolation(size: 3)
        g.open(row: 1, column: 2)
        g.open(row: 1, column: 2)
        g.open(row: 0, column: 0)
        #expect(g.openSites == 2 && g.isOpen(row: 1, column: 2) && !g.isOpen(row: 2, column: 1))
    }
}

@Suite("Task 2: fullness and percolation")
struct PercolationTests {
    @Test func topRowIsFullWhenOpen() {
        var g = Percolation(size: 3)
        g.open(row: 0, column: 1)
        #expect(g.isFull(row: 0, column: 1) && !g.isFull(row: 0, column: 0))
    }

    @Test func fullnessFlowsThroughOpenNeighbors() {
        let g = grid(["#..",
                      "##.",
                      ".#."])
        #expect(g.isFull(row: 2, column: 1) && g.isFull(row: 1, column: 0))
        #expect(g.percolates())
    }

    @Test func diagonalsDoNotConnect() {
        let g = grid(["#..",
                      ".#.",
                      "..#"])
        #expect(!g.isFull(row: 1, column: 1) && !g.percolates())
    }

    @Test func singleSite() {
        var g = Percolation(size: 1)
        #expect(!g.percolates())
        g.open(row: 0, column: 0)
        #expect(g.percolates() && g.isFull(row: 0, column: 0))
    }

    @Test func blockedSitesAreNeverFull() {
        let g = grid(["###", "#.#", "###"])
        #expect(!g.isFull(row: 1, column: 1) && g.percolates())
    }
}

@Suite("Task 3: backwash")
struct BackwashTests {
    @Test func bottomSitesAreNotFullThroughTheBottom() {
        // Column 0 percolates. The site at the bottom right is open, and touches
        // the bottom row, but no path of open sites leads to it from the top.
        let g = grid(["#..",
                      "#..",
                      "#.#"])
        #expect(g.percolates())
        #expect(!g.isFull(row: 2, column: 2))
    }
}
