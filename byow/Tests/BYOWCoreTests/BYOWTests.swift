import Testing
@testable import BYOWCore

// Provided tests. Write your own in MyTests.swift.

/// Checks the properties every generated world must have, and returns a
/// description of the first one that fails, or nil.
func problem(in world: World) -> String? {
    let floors = world.floorPositions
    guard let start = floors.first else { return "no floor" }
    if Double(floors.count) < Double(world.width * world.height) / 5 {
        return "only \(floors.count) floor tiles"
    }
    for p in floors {
        if p.row == 0 || p.column == 0 || p.row == world.height - 1 || p.column == world.width - 1 {
            return "floor on the edge at \(p)"
        }
        for dr in -1...1 {
            for dc in -1...1 where world[p.row + dr, p.column + dc] == .nothing {
                return "floor at \(p) next to nothing"
            }
        }
    }
    for r in 0..<world.height {
        for c in 0..<world.width where world[r, c] == .wall {
            let nearFloor = (-1...1).contains { dr in
                (-1...1).contains { dc in
                    let q = Position(row: r + dr, column: c + dc)
                    return world.contains(q) && world[q] == .floor
                }
            }
            if !nearFloor { return "wall at \(Position(row: r, column: c)) far from any floor" }
        }
    }
    var seen: Set<Position> = [start]
    var queue = [start]
    var head = 0
    while head < queue.count {
        let p = queue[head]
        head += 1
        for (dr, dc) in [(-1, 0), (1, 0), (0, -1), (0, 1)] {
            let q = Position(row: p.row + dr, column: p.column + dc)
            if world.contains(q), world[q] == .floor, seen.insert(q).inserted {
                queue.append(q)
            }
        }
    }
    if seen.count != floors.count { return "\(floors.count - seen.count) floor tiles unreachable" }
    return nil
}

@Suite("Task 1: generating worlds")
struct GenerationTests {
    @Test func hasTheRequestedSize() {
        let world = WorldGenerator.generate(seed: 1, width: 45, height: 25)
        #expect(world.width == 45 && world.height == 25)
    }

    @Test func sameSeedSameWorld() {
        #expect(WorldGenerator.generate(seed: 61) == WorldGenerator.generate(seed: 61))
    }

    @Test func differentSeedsDifferentWorlds() {
        #expect(WorldGenerator.generate(seed: 61) != WorldGenerator.generate(seed: 62))
    }

    @Test(arguments: 0..<50 as Range<UInt64>)
    func worldsAreGood(seed: UInt64) {
        let world = WorldGenerator.generate(seed: seed)
        #expect(problem(in: world) == nil, "seed \(seed):\n\(world)")
    }
}

let smallWorld = World(rows: [
    "#######",
    "#..#..#",
    "#.....#",
    "#######",
])

@Suite("Task 2: moving")
struct GameTests {
    @Test func startsOnTheFirstFloorTile() {
        #expect(Game(world: smallWorld).avatar == Position(row: 1, column: 1))
        let game = Game(seed: 5)
        #expect(game.world == WorldGenerator.generate(seed: 5) && game.world[game.avatar] == .floor)
    }

    @Test func movesOnFloor() {
        var game = Game(world: smallWorld)
        for move in [Move.right, .down, .right, .right, .up] { game.apply(move) }
        #expect(game.avatar == Position(row: 1, column: 4) && game.steps == 5)
    }

    @Test func wallsBlock() {
        var game = Game(world: smallWorld)
        game.apply(.up)
        game.apply(.left)
        game.apply(.right)
        game.apply(.right)
        #expect(game.avatar == Position(row: 1, column: 2) && game.steps == 1)
    }
}

@Suite("Task 3: input strings")
struct InteractionTests {
    @Test func newGameAndMoves() {
        let game = interact(withInput: "n42sdddd", store: MemoryStore())
        var expected = Game(seed: 42)
        for _ in 0..<4 { expected.apply(.right) }
        #expect(game == expected)
    }

    @Test func caseDoesNotMatter() {
        #expect(interact(withInput: "N42SDDwA", store: MemoryStore()) ==
                interact(withInput: "n42sddwa", store: MemoryStore()))
    }

    @Test func noGameWithoutStart() {
        #expect(interact(withInput: "wasd", store: MemoryStore()) == nil)
        #expect(interact(withInput: "n42", store: MemoryStore()) == nil)
    }

    @Test func saveAndLoad() {
        let store = MemoryStore()
        let saved = interact(withInput: "n7sddss:q", store: store)
        #expect(store.saved == saved)
        let continued = interact(withInput: "lwa", store: store)
        #expect(continued == interact(withInput: "n7sddsswa", store: MemoryStore()))
    }

    @Test func quitIgnoresTheRest() {
        #expect(interact(withInput: "n7sdd:qss", store: MemoryStore()) ==
                interact(withInput: "n7sdd", store: MemoryStore()))
    }
}
