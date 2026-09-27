/// How often each word was used in each year, and how many words were
/// written in total.
public struct NGramMap: Sendable {
    // Declare your stored properties here.

    // Task 2
    /// `wordCounts` has one line per word and year: word, year, count, and
    /// number of books, separated by tabs. `totalCounts` has one line per
    /// year: year, total word count, pages, and books, separated by commas.
    public init(wordCounts: String, totalCounts: String) {
    }

    // Task 2
    /// The word’s counts, for the years from `start` through `end`. Empty for
    /// an unknown word. The result is a copy: changing it changes nothing here.
    public func countHistory(_ word: String, from start: Int = TimeSeries.minYear,
                             through end: Int = TimeSeries.maxYear) -> TimeSeries {
        TimeSeries() // Replace this line.
    }

    // Task 2
    /// The total number of words written each year, from `start` through `end`.
    public func totalCountHistory(from start: Int = TimeSeries.minYear,
                                  through end: Int = TimeSeries.maxYear) -> TimeSeries {
        TimeSeries() // Replace this line.
    }

    // Task 2
    /// The word’s relative frequency: its count divided by the total count,
    /// for each year in which the word appears.
    public func weightHistory(_ word: String, from start: Int = TimeSeries.minYear,
                              through end: Int = TimeSeries.maxYear) -> TimeSeries {
        TimeSeries() // Replace this line.
    }

    // Task 2
    /// The sum of the words’ relative frequencies, year by year.
    public func summedWeightHistory(_ words: [String], from start: Int = TimeSeries.minYear,
                                    through end: Int = TimeSeries.maxYear) -> TimeSeries {
        TimeSeries() // Replace this line.
    }
}
