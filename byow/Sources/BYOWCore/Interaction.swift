/// Plays a game from a string of keys, as if they were typed, and returns the
/// game at the end, or nil if no game was started. Keys are case-insensitive.
///
/// Before a game starts:
/// - `n` starts a new game: the digits that follow form the seed, and `s`
///   ends it. Characters other than digits between `n` and `s` are ignored.
///   The seed wraps around if it is too large for a `UInt64`, and is 0 if there
///   are no digits.
/// - `l` loads the saved game from the store, if there is one.
/// - Every other key is ignored.
///
/// During a game:
/// - `w`, `a`, `s`, `d` move the avatar.
/// - `:` followed immediately by `q` saves the game to the store and ends the
///   input: the rest of the string is ignored.
/// - Every other key is ignored.
///
/// A new world always has the default size, 60 by 30. For example,
/// `interact(withInput: "n123sddss:q", store: store)` generates the world for
/// seed 123, moves right twice and down twice, and saves; after that,
/// `interact(withInput: "lwa", store: store)` loads it and continues.
public func interact(withInput input: String, store: some SaveStore) -> Game? {
    // Task 3
    nil // Replace this line.
}
