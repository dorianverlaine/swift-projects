import Testing
@testable import ParticlesCore

// Provided tests. Write your own in MyTests.swift.

/// A Dice whose answers are fixed in advance, used in order. When a list runs
/// out, its last answer repeats.
struct ScriptedDice: Dice {
    var chances: [Bool] = [false]
    var picks: [Int] = [0]

    mutating func chance(_ probability: Double) -> Bool {
        chances.count > 1 ? chances.removeFirst() : chances[0]
    }

    mutating func pick(_ count: Int) -> Int {
        picks.count > 1 ? picks.removeFirst() : picks[0]
    }
}

/// A grid from rows of text: . empty, s sand, # barrier, w water, f fountain,
/// p plant, * fire, o flower.
func grid(_ rows: [String]) -> Grid {
    let codes: [Character: Flavor] = [".": .empty, "s": .sand, "#": .barrier, "w": .water,
                                      "f": .fountain, "p": .plant, "*": .fire, "o": .flower]
    var result = Grid(width: rows[0].count, height: rows.count)
    for (y, row) in rows.enumerated() {
        for (x, code) in row.enumerated() {
            result.place(codes[code]!, x: x, y: y)
        }
    }
    return result
}

func picture(_ grid: Grid) -> [String] {
    let codes: [Flavor: Character] = [.empty: ".", .sand: "s", .barrier: "#", .water: "w",
                                      .fountain: "f", .plant: "p", .fire: "*", .flower: "o"]
    return (0..<grid.height).map { y in
        String((0..<grid.width).map { x in codes[grid[x, y].flavor]! })
    }
}

func ticked(_ rows: [String], times: Int = 1, dice: ScriptedDice = ScriptedDice()) -> [String] {
    var world = grid(rows)
    var dice = dice
    for _ in 0..<times {
        world.tick(dice: &dice)
    }
    return picture(world)
}

@Suite("Task 1: particles")
struct ParticleTests {
    @Test func colors() {
        #expect(Flavor.empty.color == RGB(0, 0, 0))
        #expect(Flavor.sand.color == RGB(220, 190, 110))
        #expect(Flavor.water.color == RGB(40, 110, 255))
        #expect(Flavor.flower.color == RGB(255, 140, 180))
    }

    @Test func lifespans() {
        #expect(Particle(.fire).lifespan == 10)
        #expect(Particle(.sand).lifespan == -1 && Particle(.plant).lifespan == -1)
    }

    @Test func fireFades() {
        var fire = Particle(.fire)
        #expect(fire.color == RGB(255, 60, 0))
        fire.lifespan = 5
        #expect(fire.color == RGB(127, 30, 0))
    }
}

@Suite("Task 2: the grid")
struct GridTests {
    @Test func readAndWrite() {
        var world = Grid(width: 3, height: 2)
        world[2, 1] = Particle(.sand)
        #expect(world[2, 1].flavor == .sand && world[0, 0].flavor == .empty)
        #expect(world.contains(x: 2, y: 1) && !world.contains(x: 3, y: 0) && !world.contains(x: 0, y: -1))
    }

    @Test func outsideIsAWall() {
        var world = Grid(width: 2, height: 2)
        #expect(world[-1, 0].flavor == .barrier && world[0, 2].flavor == .barrier)
        world[5, 5] = Particle(.sand)    // ignored
        #expect(picture(world) == ["..", ".."])
    }
}

@Suite("Task 3: sand and water")
struct SandWaterTests {
    @Test func sandFallsOneCellPerTick() {
        #expect(ticked([".s.", "...", "...", "..."]) == ["...", ".s.", "...", "..."])
        #expect(ticked([".s.", "...", "...", "..."], times: 3) == ["...", "...", "...", ".s."])
    }

    @Test func sandSlidesDiagonally() {
        #expect(ticked([".s.", ".#."], dice: ScriptedDice(picks: [0])) == ["...", "s#."])
        #expect(ticked([".s.", ".#."], dice: ScriptedDice(picks: [1])) == ["...", ".#s"])
        #expect(ticked([".s.", "##."], dice: ScriptedDice(picks: [0])) == ["...", "##s"])
        #expect(ticked(["#s#", "#s#"]) == ["#s#", "#s#"])
    }

    @Test func sandSinksInWater() {
        #expect(ticked(["s", "w"]) == ["w", "s"])
    }

    @Test func waterFallsThenFlows() {
        #expect(ticked([".w.", "..."]) == ["...", ".w."])
        #expect(ticked(["w..", "#.."]) == [".w.", "#.."])   // the left side is outside: a wall
        #expect(ticked([".w.", "###"], dice: ScriptedDice(picks: [0])) == ["w..", "###"])
        #expect(ticked([".w.", "###"], dice: ScriptedDice(picks: [1])) == ["..w", "###"])
        #expect(ticked(["#w#", "###"]) == ["#w#", "###"])
    }
}

@Suite("Task 4: fountains and plants")
struct FountainPlantTests {
    @Test func fountainsMakeWater() {
        #expect(ticked(["f", ".", "."]) == ["f", "w", "."])
        #expect(ticked(["f", ".", "."], times: 2) == ["f", "w", "w"])
    }

    @Test func plantsGrow() {
        #expect(ticked([".", "p"], dice: ScriptedDice(chances: [false])) == [".", "p"])
        #expect(ticked([".", "p"], dice: ScriptedDice(chances: [true, false])) == ["p", "p"])
        #expect(ticked([".", "p"], dice: ScriptedDice(chances: [true, true])) == ["o", "p"])
        #expect(ticked([".", ".", "p"], dice: ScriptedDice(chances: [true, false])) == [".", "p", "p"])
    }
}

@Suite("Task 5: fire")
struct FireTests {
    @Test func fireSpreads() {
        #expect(ticked([".p.", "o*p", ".s."], dice: ScriptedDice(chances: [true])) == [".*.", "***", ".s."])
        #expect(ticked(["p*p"], dice: ScriptedDice(chances: [false])) == ["p*p"])
    }

    @Test func fireBurnsOut() {
        #expect(ticked(["*"], times: 9) == ["*"])
        #expect(ticked(["*"], times: 10) == ["."])
    }

    @Test func newFireWaitsForTheNextTick() {
        var world = grid(["p", "*"])
        var dice = ScriptedDice(chances: [true])
        world.tick(dice: &dice)
        #expect(world[0, 0].lifespan == 10 && world[0, 1].lifespan == 9)
    }
}
