// Provided. You may add members in an extension in another file, but do not
// change the ones here: the tests use them.

/// One square of the world.
public enum Tile: Character, Codable, Sendable, CaseIterable {
    case nothing = " "
    case floor = "."
    case wall = "#"

    /// A name for the HUD.
    public var name: String {
        switch self {
        case .nothing: "nothing"
        case .floor: "floor"
        case .wall: "wall"
        }
    }
}

/// A place in the world. Row 0 is the top row; column 0 is the left column.
public struct Position: Hashable, Codable, Sendable, CustomStringConvertible {
    public var row: Int
    public var column: Int

    public init(row: Int, column: Int) {
        self.row = row
        self.column = column
    }

    public var description: String { "(\(row), \(column))" }
}

/// A rectangular grid of tiles. A plain value: it knows nothing about how it
/// was generated or how it is drawn.
public struct World: Codable, Equatable, Sendable, CustomStringConvertible {
    public let width: Int
    public let height: Int
    /// `tiles[row][column]`, with `height` rows of `width` tiles each.
    public private(set) var tiles: [[Tile]]

    /// A world of the given size, filled with `.nothing`.
    public init(width: Int, height: Int) {
        precondition(width > 0 && height > 0, "a world needs at least one tile")
        self.width = width
        self.height = height
        tiles = Array(repeating: Array(repeating: .nothing, count: width), count: height)
    }

    /// A world drawn as text, one string per row, using the tiles’ characters.
    /// Handy in tests: `World(rows: ["###", "#.#", "###"])`.
    public init(rows: [String]) {
        let tiles = rows.map { $0.map { Tile(rawValue: $0) ?? .nothing } }
        precondition(!tiles.isEmpty && !tiles[0].isEmpty, "a world needs at least one tile")
        precondition(tiles.allSatisfy { $0.count == tiles[0].count }, "rows must have the same length")
        self.width = tiles[0].count
        self.height = tiles.count
        self.tiles = tiles
    }

    public func contains(_ p: Position) -> Bool {
        (0..<height).contains(p.row) && (0..<width).contains(p.column)
    }

    public subscript(p: Position) -> Tile {
        get {
            precondition(contains(p), "\(p) is outside the world")
            return tiles[p.row][p.column]
        }
        set {
            precondition(contains(p), "\(p) is outside the world")
            tiles[p.row][p.column] = newValue
        }
    }

    public subscript(row: Int, column: Int) -> Tile {
        get { self[Position(row: row, column: column)] }
        set { self[Position(row: row, column: column)] = newValue }
    }

    /// Every floor position, in reading order: top row first, left to right.
    public var floorPositions: [Position] {
        (0..<height).flatMap { r in
            (0..<width).filter { tiles[r][$0] == .floor }.map { Position(row: r, column: $0) }
        }
    }

    /// The world as text, one line per row.
    public var description: String {
        tiles.map { String($0.map(\.rawValue)) }.joined(separator: "\n")
    }
}
