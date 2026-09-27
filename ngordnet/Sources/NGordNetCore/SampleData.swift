// Provided. Do not change this file.

import Foundation

/// The sample data files bundled with the package, in Data/. Their formats
/// follow Google Books Ngram and WordNet, but the contents are synthetic;
/// see Data/README.txt.
public enum SampleData {
    /// The text of a bundled data file, such as "words.tsv".
    public static func contents(of file: String) -> String {
        let parts = file.split(separator: ".", maxSplits: 1).map(String.init)
        guard let url = Bundle.module.url(forResource: parts[0], withExtension: parts.count > 1 ? parts[1] : nil,
                                          subdirectory: "Data"),
              let text = try? String(contentsOf: url, encoding: .utf8) else {
            fatalError("The sample data file \(file) is missing from the package.")
        }
        return text
    }

    public static func ngramMap() -> NGramMap {
        NGramMap(wordCounts: contents(of: "words.tsv"), totalCounts: contents(of: "totals.csv"))
    }

    public static func wordNet() -> WordNet {
        WordNet(synsets: contents(of: "synsets.csv"), hyponyms: contents(of: "hyponyms.csv"))
    }
}
