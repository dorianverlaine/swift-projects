import Testing
@testable import ArrayDeque

// Provided tests. Write your own in MyTests.swift, especially a randomized
// comparison against [Int] that makes the deque grow and shrink many times.

/// An item that counts how many of its kind are alive, to detect loitering.
final class Tracked {
    nonisolated(unsafe) static var alive = 0
    init() { Tracked.alive += 1 }
    deinit { Tracked.alive -= 1 }
}

func deque(_ values: [Int]) -> ArrayDeque<Int> {
    var result = ArrayDeque<Int>()
    for value in values {
        result.addLast(value)
    }
    return result
}

@Suite("Tasks 1 and 2: adding and reading")
struct AddingTests {
    @Test func startsEmptyWithEightSlots() {
        let d = ArrayDeque<Int>()
        #expect(d.count == 0 && d.isEmpty && d.capacity == 8)
    }

    @Test func addBothEnds() {
        var d = ArrayDeque<Int>()
        d.addLast(2)
        d.addFirst(1)
        d.addLast(3)
        d.addFirst(0)
        #expect(d.toArray() == [0, 1, 2, 3])
        #expect(d.get(0) == 0 && d.get(3) == 3 && d.get(4) == nil && d.get(-1) == nil)
    }

    @Test func wrapsAroundWithoutResizing() {
        var d = ArrayDeque<Int>()
        for n in 1...4 {
            d.addFirst(-n)
            d.addLast(n)
        }
        #expect(d.capacity == 8)
        #expect(d.toArray() == [-4, -3, -2, -1, 1, 2, 3, 4])
    }
}

@Suite("Task 3: removing")
struct RemovingTests {
    @Test func removeBothEnds() {
        var d = deque([1, 2, 3, 4])
        #expect(d.removeFirst() == 1 && d.removeLast() == 4)
        #expect(d.toArray() == [2, 3] && d.count == 2)
    }

    @Test func removeFromEmpty() {
        var d = ArrayDeque<Int>()
        #expect(d.removeFirst() == nil && d.removeLast() == nil && d.count == 0)
    }

    @Test func removedItemsAreReleased() {
        let before = Tracked.alive
        var d = ArrayDeque<Tracked>()
        for _ in 0..<6 {
            d.addLast(Tracked())
        }
        _ = d.removeFirst()
        _ = d.removeLast()
        #expect(Tracked.alive == before + 4)
    }
}

@Suite("Task 4: resizing")
struct ResizingTests {
    @Test func growsByDoubling() {
        let d = deque(Array(0..<9))
        #expect(d.capacity == 16 && d.toArray() == Array(0..<9))
    }

    @Test func growsAfterWrapping() {
        var d = ArrayDeque<Int>()
        for n in 0..<8 {
            d.addFirst(n)
        }
        d.addLast(100)
        #expect(d.toArray() == [7, 6, 5, 4, 3, 2, 1, 0, 100])
    }

    @Test func shrinksWhenSparse() {
        var d = deque(Array(0..<64))
        #expect(d.capacity == 64)
        while d.count > 10 {
            _ = d.removeFirst()
        }
        #expect(d.capacity <= 32 && d.capacity >= 16)
        while d.count > 0 {
            _ = d.removeLast()
        }
        #expect(d.capacity == 8)
    }
}

@Suite("Task 5: collection")
struct CollectionTests {
    @Test func iterationAndIndexing() throws {
        var d = deque([3, 1, 2])
        try #require(d.count == 3)
        #expect(Array(d) == [3, 1, 2])
        #expect(d[1] == 1 && d.first == 3 && d.last == 2)
        d[1] = 10
        #expect(d.toArray() == [3, 10, 2])
    }

    @Test func algorithmsForFree() throws {
        var d = ArrayDeque<Int>()
        for n in [5, 3, 9, 1] {
            d.addFirst(n)
        }
        try #require(d.count == 4)
        d.sort()
        #expect(d.toArray() == [1, 3, 5, 9])
        #expect(d.reduce(0, +) == 18 && d.firstIndex(of: 5) == 2)
    }
}

@Suite("Task 6: equality and description")
struct EqualityTests {
    @Test func equalRegardlessOfLayout() {
        var a = ArrayDeque<Int>()
        var b = ArrayDeque<Int>()
        for n in 1...3 {
            a.addLast(n)
        }
        for n in (1...3).reversed() {
            b.addFirst(n)
        }
        #expect(a == b)
        #expect(a != deque([1, 2]))
        #expect(a.hasSameItems(as: b))
    }

    @Test func description() {
        #expect(deque([1, 2, 3]).description == "[1, 2, 3]")
        #expect(ArrayDeque<Int>().description == "[]")
    }

    @Test func valueSemantics() {
        var a = deque([1, 2])
        let b = a
        a.addLast(3)
        #expect(b.toArray() == [1, 2] && a.toArray() == [1, 2, 3])
    }
}
