/// Turns a seed into a world of rooms and hallways.
///
/// Requirements (the tests check all of them, for many seeds and sizes):
/// - The world has the requested size.
/// - The same seed and size always give the same world; different seeds give
///   different worlds.
/// - Every floor tile can reach every other one through floor tiles, moving up,
///   down, left, or right.
/// - No floor tile is on the edge of the world, and every tile next to a floor
///   tile, diagonals included, is a floor or a wall.
/// - Every wall is next to a floor tile, diagonals included.
/// - At least a fifth of the tiles are floor.
public enum WorldGenerator {
    public static let minimumWidth = 20
    public static let minimumHeight = 15

    // Task 1. Plan first: write down the steps and the helper functions you
    // need, then write them below. Use one SplitMix64, created from the seed,
    // for every random choice.
    public static func generate(seed: UInt64, width: Int = 60, height: Int = 30) -> World {
        precondition(width >= minimumWidth && height >= minimumHeight, "the world is too small")
        return World(width: width, height: height) // Replace this line.
    }
}
