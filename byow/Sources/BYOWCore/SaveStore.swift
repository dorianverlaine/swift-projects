// Provided.

/// Somewhere a game can be saved and loaded. `FileStore` saves to disk;
/// `MemoryStore` keeps the game in memory, for tests.
public protocol SaveStore {
    /// Saves the game, replacing any saved game.
    func save(_ game: Game) throws
    /// The saved game, or nil if nothing has been saved.
    func load() throws -> Game?
}

/// A save store that keeps the game in memory. A class, so that copies of
/// it share the saved game, like a file would.
public final class MemoryStore: SaveStore {
    public private(set) var saved: Game?

    public init(saved: Game? = nil) {
        self.saved = saved
    }

    public func save(_ game: Game) {
        saved = game
    }

    public func load() -> Game? {
        saved
    }
}
