import Testing
@testable import LinkedListDeque

// Provided tests. They check a lot, but not everything: write your own in
// MyTests.swift, especially a randomized comparison against [Int].

/// An item that counts how many of its kind are alive, to detect leaks.
final class Tracked {
    nonisolated(unsafe) static var alive = 0
    let value: Int
    init(_ value: Int) {
        self.value = value
        Tracked.alive += 1
    }
    deinit {
        Tracked.alive -= 1
    }
}

@Suite("Task 1: adding")
struct AddingTests {
    @Test func startsEmpty() {
        let deque = LinkedListDeque<Int>()
        #expect(deque.count == 0)
        #expect(deque.isEmpty)
    }

    @Test func addFirstAndLast() {
        let deque = LinkedListDeque<Int>()
        deque.addLast(2)
        deque.addFirst(1)
        deque.addLast(3)
        #expect(deque.count == 3)
        #expect(!deque.isEmpty)
    }
}

@Suite("Task 2: toArray")
struct ToArrayTests {
    @Test func order() {
        let deque = LinkedListDeque<String>()
        deque.addLast("b")
        deque.addFirst("a")
        deque.addLast("c")
        #expect(deque.toArray() == ["a", "b", "c"])
    }

    @Test func empty() {
        #expect(LinkedListDeque<Int>().toArray().isEmpty)
    }
}

@Suite("Task 3 and 4: get")
struct GetTests {
    static let size = 7

    func makeDeque() -> LinkedListDeque<Int> {
        let deque = LinkedListDeque<Int>()
        for n in (0..<Self.size).reversed() {
            deque.addFirst(n)
        }
        return deque
    }

    @Test(arguments: 0..<size)
    func getEachIndex(index: Int) {
        let deque = makeDeque()
        #expect(deque.get(index) == index)
        #expect(deque.getRecursive(index) == index)
    }

    @Test(arguments: [-1, size, 100])
    func outOfRange(index: Int) {
        let deque = makeDeque()
        #expect(deque.get(index) == nil)
        #expect(deque.getRecursive(index) == nil)
    }
}

@Suite("Task 5: removing")
struct RemovingTests {
    @Test func removeFromBothEnds() {
        let deque = LinkedListDeque<Int>()
        for n in 1...4 {
            deque.addLast(n)
        }
        #expect(deque.removeFirst() == 1)
        #expect(deque.removeLast() == 4)
        #expect(deque.toArray() == [2, 3])
        #expect(deque.count == 2)
    }

    @Test func removeFromEmpty() {
        let deque = LinkedListDeque<Int>()
        #expect(deque.removeFirst() == nil)
        #expect(deque.removeLast() == nil)
        #expect(deque.count == 0)
    }

    @Test func emptyAfterRemovingEverything() {
        let deque = LinkedListDeque<Int>()
        deque.addFirst(1)
        _ = deque.removeLast()
        #expect(deque.isEmpty && deque.toArray().isEmpty)
        deque.addLast(2)
        #expect(deque.toArray() == [2])
    }
}

@Suite("Task 6: memory", .serialized)
struct MemoryTests {
    @Test func removedItemsAreFreed() {
        let before = Tracked.alive
        let deque = LinkedListDeque<Tracked>()
        for n in 0..<10 {
            deque.addLast(Tracked(n))
        }
        for _ in 0..<5 {
            _ = deque.removeFirst()
        }
        #expect(Tracked.alive == before + 5)
        _ = deque
    }

    @Test func freeingTheDequeFreesEverything() {
        let before = Tracked.alive
        var deque: LinkedListDeque<Tracked>? = LinkedListDeque()
        for n in 0..<10 {
            deque!.addLast(Tracked(n))
            deque!.addFirst(Tracked(-n))
        }
        deque = nil
        #expect(Tracked.alive == before)
    }
}
