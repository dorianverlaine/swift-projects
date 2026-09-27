import Testing
@testable import ArrayDeque

// Task 7: write your own tests here. At minimum, a randomized comparison
// against [Int] that checks, after every operation, the items, the count, and
// that capacity follows the rules: at least 8, and at most four times count
// whenever capacity is above 8.

@Test func myFirstTest() {
    var deque = ArrayDeque<Int>()
    deque.addLast(1)
    #expect(deque.get(0) == 1)
}
