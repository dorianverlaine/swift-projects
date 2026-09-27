import Testing
@testable import NGordNetCore

// Provided tests, on small inline data. Write your own in MyTests.swift.

let wordCounts = """
    cat\t2000\t10\t1
    cat\t2001\t20\t1
    cat\t2002\t30\t1
    dog\t2001\t5\t1
    dog\t2003\t40\t1
    """
let totalCounts = """
    2000,100,1,1
    2001,200,1,1
    2002,300,1,1
    2003,400,1,1
    """

// 0: animal ← 1: pet ← 2: cat, 3: dog;  4: jump leap ← 5: hop;  6: jump (a sudden change)
let synsets = """
    0,animal,a living thing
    1,pet,an animal kept at home, often fed by hand
    2,cat,a small furry pet
    3,dog,a loyal pet
    4,jump leap,the act of springing
    5,hop,a small jump
    6,jump,a sudden change
    """
let hyponyms = """
    0,1
    1,2,3
    4,5
    """

@Suite("Task 1: TimeSeries")
struct TimeSeriesTests {
    func series(_ pairs: [(Int, Double)]) -> TimeSeries {
        var s = TimeSeries()
        for (year, value) in pairs { s[year] = value }
        return s
    }

    @Test func copying() {
        let s = series([(1990, 1), (2000, 2), (2010, 3)])
        let copy = TimeSeries(copying: s, from: 1995, through: 2010)
        #expect(copy.years == [2000, 2010] && copy.values == [2, 3])
        #expect(TimeSeries(copying: s, from: 2020, through: 1990).years.isEmpty)
    }

    @Test func plus() {
        let sum = series([(2000, 1), (2001, 2)]).plus(series([(2001, 10), (2002, 20)]))
        #expect(sum.years == [2000, 2001, 2002] && sum.values == [1, 12, 20])
    }

    @Test func dividedBy() {
        let ratio = series([(2000, 1), (2001, 6)]).dividedBy(series([(2000, 4), (2001, 3), (2002, 9)]))
        #expect(ratio.years == [2000, 2001] && ratio.values == [0.25, 2])
    }
}

@Suite("Task 2: NGramMap")
struct NGramMapTests {
    let map = NGramMap(wordCounts: wordCounts, totalCounts: totalCounts)

    @Test func counts() {
        #expect(map.countHistory("cat").values == [10, 20, 30])
        #expect(map.countHistory("cat", from: 2001, through: 2001).values == [20])
        #expect(map.countHistory("zebra").years.isEmpty)
        #expect(map.totalCountHistory(from: 2002, through: 2003).values == [300, 400])
    }

    @Test func weights() {
        #expect(map.weightHistory("dog").values == [5.0 / 200, 40.0 / 400])
        let summed = map.summedWeightHistory(["cat", "dog"], from: 2001, through: 2002)
        #expect(summed.years == [2001, 2002] && summed[2001] == 20.0 / 200 + 5.0 / 200)
    }
}

@Suite("Task 3: WordNet")
struct WordNetTests {
    let wordNet = WordNet(synsets: synsets, hyponyms: hyponyms)

    @Test func singleWords() {
        #expect(wordNet.hyponyms(of: "pet") == ["cat", "dog", "pet"])
        #expect(wordNet.hyponyms(of: "animal") == ["animal", "cat", "dog", "pet"])
        #expect(wordNet.hyponyms(of: "cat") == ["cat"])
        #expect(wordNet.hyponyms(of: "unicorn").isEmpty)
    }

    @Test func synonymsAndSeveralMeanings() {
        #expect(wordNet.hyponyms(of: "leap") == ["hop", "jump", "leap"])
        #expect(wordNet.hyponyms(of: "jump") == ["hop", "jump", "leap"])   // both meanings of jump
    }
}

@Suite("Task 4: several words")
struct SeveralWordsTests {
    let wordNet = WordNet(synsets: synsets, hyponyms: hyponyms)

    @Test func intersection() {
        #expect(wordNet.hyponyms(of: ["animal", "pet"]) == ["cat", "dog", "pet"])
        #expect(wordNet.hyponyms(of: ["pet", "jump"]).isEmpty)
    }
}

@Suite("Task 5: popular hyponyms")
struct PopularTests {
    let net = NGordNet(ngrams: NGramMap(wordCounts: wordCounts, totalCounts: totalCounts),
                       wordNet: WordNet(synsets: synsets, hyponyms: hyponyms))

    @Test func kZeroMeansAll() {
        #expect(net.hyponyms(["pet"], from: 2000, through: 2003, k: 0) == ["cat", "dog", "pet"])
    }

    @Test func mostUsed() {
        // Uses from 2000 to 2003: cat 60, dog 45, pet 0.
        #expect(net.hyponyms(["pet"], from: 2000, through: 2003, k: 1) == ["cat"])
        #expect(net.hyponyms(["pet"], from: 2000, through: 2003, k: 5) == ["cat", "dog"])   // pet is never used
        #expect(net.hyponyms(["pet"], from: 2003, through: 2003, k: 5) == ["dog"])         // only dog in 2003
    }
}
