import Testing
@testable import BYOWCore

// Task 5: write your own tests here. Ideas: check the world properties for a
// thousand seeds and for small and large worlds; check that `:` not followed
// by `q` does nothing; and save to a FileStore in a temporary folder.

@Test func myFirstTest() {
    let world = WorldGenerator.generate(seed: 2026)
    #expect(problem(in: world) == nil, "\n\(world)")
}
