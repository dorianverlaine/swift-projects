import Testing
@testable import NGordNetCore

// Task 6: write your own tests here, including some on the bundled sample
// data (SampleData.ngramMap() and SampleData.wordNet()). For example: every
// hyponym of "animal" is also a hyponym of "entity"; "swift" has hyponyms in
// two unrelated parts of the graph; the summed weight of a word alone equals
// its weight history.

@Test func myFirstTest() {
    #expect(TimeSeries().years.isEmpty)
}
