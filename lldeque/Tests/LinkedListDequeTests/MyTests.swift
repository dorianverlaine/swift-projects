import Testing
@testable import LinkedListDeque

// Task 7: write your own tests here. At minimum, a randomized test that
// performs many random operations on a LinkedListDeque and on a [Int], and
// checks after every operation that they agree.

@Test func myFirstTest() {
    let deque = LinkedListDeque<Int>()
    deque.addLast(1)
    #expect(deque.get(0) == 1)
}
