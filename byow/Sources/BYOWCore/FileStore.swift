import Foundation

/// Saves a game as JSON in a file.
public struct FileStore: SaveStore, Sendable {
    public let url: URL

    public init(url: URL) {
        self.url = url
    }

    /// Where the app saves: `save.json` in a `BYOW` folder in Application Support.
    public static var standard: FileStore {
        let folder = URL.applicationSupportDirectory.appending(path: "BYOW", directoryHint: .isDirectory)
        return FileStore(url: folder.appending(path: "save.json"))
    }

    /// Writes the game as JSON, creating the folder if needed.
    public func save(_ game: Game) throws {
        // Task 4
    }

    /// The saved game, or nil if the file does not exist.
    public func load() throws -> Game? {
        // Task 4
        nil // Replace this line.
    }
}
