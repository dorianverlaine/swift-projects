/// A graph of meanings. Each synset (set of synonyms) is a vertex, and an edge
/// goes from each synset to its hyponyms: the more specific meanings.
public struct WordNet: Sendable {
    // Declare your stored properties here, with their invariants.

    // Task 3
    /// `synsets` has lines "id,words separated by spaces,definition"; the
    /// definition may contain commas. `hyponyms` has lines "id,hyponym ids…".
    public init(synsets synsetText: String, hyponyms hyponymText: String) {
    }

    // Task 3
    /// Every word in every synset containing `word` or reachable from one by
    /// hyponym edges, including `word` itself: sorted, without duplicates.
    /// Empty if the word is unknown.
    public func hyponyms(of word: String) -> [String] {
        [] // Replace this line.
    }

    // Task 4
    /// The words that are hyponyms of every one of `words`: sorted.
    public func hyponyms(of words: [String]) -> [String] {
        [] // Replace this line.
    }
}
