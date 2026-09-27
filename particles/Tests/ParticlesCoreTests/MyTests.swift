import Testing
@testable import ParticlesCore

// Task 6: write your own tests here. Ideas: sand and water in a closed box are
// never created or destroyed, however many ticks run; a fountain surrounded by
// barriers does nothing; fire next to a long row of plants eventually burns
// all of them.

@Test func myFirstTest() {
    #expect(Particle(.sand).flavor == .sand)
}
