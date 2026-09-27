/// A move, from a key.
public enum Move: Character, CaseIterable, Sendable {
    case up = "w", left = "a", down = "s", right = "d"
}

/// A game in progress: a world and an avatar in it. A value, with no idea of
/// keys, screens, or files.
public struct Game: Codable, Equatable, Sendable {
    public let seed: UInt64
    public private(set) var world: World
    public private(set) var avatar: Position
    /// The number of moves that actually moved the avatar.
    public private(set) var steps = 0

    /// A game in the given world, with the avatar on the first floor tile in
    /// reading order (top row first, left to right). The world must have a floor.
    public init(world: World, seed: UInt64 = 0) {
        // Task 2
        self.seed = seed
        self.world = world
        self.avatar = Position(row: 0, column: 0) // Replace this line.
    }

    /// A game in a newly generated world.
    public init(seed: UInt64, width: Int = 60, height: Int = 30) {
        self.init(world: WorldGenerator.generate(seed: seed, width: width, height: height), seed: seed)
    }

    /// Moves the avatar one tile, unless that tile is not a floor.
    public mutating func apply(_ move: Move) {
        // Task 2
    }
}
