/// Word histories and meanings together: the queries the app asks.
public struct NGordNet: Sendable {
    public let ngrams: NGramMap
    public let wordNet: WordNet

    public init(ngrams: NGramMap, wordNet: WordNet) {
        self.ngrams = ngrams
        self.wordNet = wordNet
    }

    // Task 5
    /// The hyponyms common to all of `words`. When k is 0, all of them. When k
    /// is positive, only the k most used between `start` and `end`, counting
    /// total uses over those years, leaving out words never used then, with ties
    /// broken alphabetically. Always returned in alphabetical order.
    public func hyponyms(_ words: [String], from start: Int, through end: Int, k: Int) -> [String] {
        [] // Replace this line.
    }
}
