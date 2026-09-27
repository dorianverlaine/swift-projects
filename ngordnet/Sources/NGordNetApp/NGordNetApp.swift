// Provided. Run it once the tests pass:
//     swift run -c release NGordNetApp

import AppKit
import Charts
import NGordNetCore
import SwiftUI

@main
struct NGordNetApp: App {
    init() {
        NSApplication.shared.setActivationPolicy(.regular)
        NSApplication.shared.activate()
    }

    var body: some Scene {
        WindowGroup("NGordNet") {
            ContentView()
        }
    }
}

/// The model: loads the sample data once, and answers queries. It lives on the
/// main actor, like the views that use it; the slow loading runs elsewhere.
@MainActor
@Observable
final class Explorer {
    var net: NGordNet?
    var wordsText = "bird, dog, computer"
    var start = 1900
    var end = 2019
    var k = 5

    var words: [String] {
        wordsText.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces).lowercased() }.filter { !$0.isEmpty }
    }

    func load() async {
        let loaded = await Task.detached {
            NGordNet(ngrams: SampleData.ngramMap(), wordNet: SampleData.wordNet())
        }.value
        net = loaded
    }
}

struct ContentView: View {
    @State private var explorer = Explorer()

    var body: some View {
        Group {
            if explorer.net == nil {
                ProgressView("Loading the sample data…")
            } else {
                TabView {
                    Tab("History", systemImage: "chart.xyaxis.line") { HistoryView() }
                    Tab("Hyponyms", systemImage: "list.bullet.indent") { HyponymsView() }
                }
            }
        }
        .environment(explorer)
        .frame(minWidth: 720, minHeight: 520)
        .task { await explorer.load() }
    }
}

struct QueryBar: View {
    @Environment(Explorer.self) private var explorer
    let showsK: Bool

    var body: some View {
        @Bindable var explorer = explorer
        HStack(spacing: 12) {
            TextField("Words, separated by commas", text: $explorer.wordsText)
                .textFieldStyle(.roundedBorder)
            Stepper("From \(String(explorer.start))", value: $explorer.start, in: 1900...explorer.end)
                .fixedSize()
            Stepper("to \(String(explorer.end))", value: $explorer.end, in: explorer.start...2019)
                .fixedSize()
            if showsK {
                Stepper("k = \(explorer.k)", value: $explorer.k, in: 0...50)
                    .fixedSize()
            }
        }
        .padding(12)
        .glassEffect(.regular, in: .rect(cornerRadius: 16))
        .padding()
    }
}

struct HistoryView: View {
    @Environment(Explorer.self) private var explorer

    var body: some View {
        VStack(spacing: 0) {
            QueryBar(showsK: false)
            if let net = explorer.net {
                Chart {
                    ForEach(explorer.words, id: \.self) { word in
                        let history = net.ngrams.weightHistory(word, from: explorer.start, through: explorer.end)
                        ForEach(history.years, id: \.self) { year in
                            LineMark(x: .value("Year", year), y: .value("Uses per million", history[year]! * 1_000_000))
                                .foregroundStyle(by: .value("Word", word))
                        }
                    }
                }
                .chartXScale(domain: explorer.start...explorer.end)
                .chartYAxisLabel("Uses per million words")
                .padding()
            }
        }
    }
}

struct HyponymsView: View {
    @Environment(Explorer.self) private var explorer

    var body: some View {
        VStack(spacing: 0) {
            QueryBar(showsK: true)
            if let net = explorer.net {
                let results = net.hyponyms(explorer.words, from: explorer.start, through: explorer.end, k: explorer.k)
                if results.isEmpty {
                    ContentUnavailableView("No hyponyms", systemImage: "questionmark.circle",
                                           description: Text("Try a more general word, such as animal or device."))
                } else {
                    List(results, id: \.self) { Text($0) }
                }
            }
        }
    }
}
