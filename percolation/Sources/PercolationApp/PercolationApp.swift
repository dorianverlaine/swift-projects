// Provided. Run it once your Percolation passes the tests:
//     swift run -c release PercolationApp

import AppKit
import PercolationCore
import SwiftUI

@main
struct PercolationApp: App {
    init() {
        NSApplication.shared.setActivationPolicy(.regular)
        NSApplication.shared.activate()
    }

    var body: some Scene {
        WindowGroup("Percolation") {
            PercolationView()
        }
    }
}

struct PercolationView: View {
    @State private var size = 30.0
    @State private var grid = Percolation(size: 30)
    @State private var running = false
    @State private var estimate: ThresholdEstimate?
    @State private var estimating = false

    var body: some View {
        VStack(spacing: 12) {
            GeometryReader { geometry in
                let n = grid.size
                let side = min(geometry.size.width, geometry.size.height) / CGFloat(n)
                Canvas { context, _ in
                    for row in 0..<n {
                        for column in 0..<n {
                            let cell = CGRect(x: CGFloat(column) * side, y: CGFloat(row) * side,
                                              width: side, height: side).insetBy(dx: 0.5, dy: 0.5)
                            let color: Color = grid.isFull(row: row, column: column) ? .blue
                                : grid.isOpen(row: row, column: column) ? .white : Color(white: 0.15)
                            context.fill(Path(cell), with: .color(color))
                        }
                    }
                }
                .gesture(SpatialTapGesture().onEnded { tap in
                    let row = Int(tap.location.y / side)
                    let column = Int(tap.location.x / side)
                    if (0..<n).contains(row) && (0..<n).contains(column) {
                        grid.open(row: row, column: column)
                    }
                })
            }
            .aspectRatio(1, contentMode: .fit)

            Text(status)
                .font(.callout.monospacedDigit())
                .foregroundStyle(.secondary)

            GlassEffectContainer(spacing: 10) {
                HStack(spacing: 10) {
                    Button(running ? "Pause" : "Fill", systemImage: running ? "pause.fill" : "drop.fill") {
                        running.toggle()
                    }
                    .buttonStyle(.glassProminent)
                    .disabled(grid.percolates())
                    Button("Reset", systemImage: "arrow.counterclockwise") {
                        reset()
                    }
                    .buttonStyle(.glass)
                    Slider(value: $size, in: 5...80, step: 5) { Text("Size") }
                        .frame(width: 120)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .glassEffect(.regular.interactive(), in: .capsule)
                        .onChange(of: size) { reset() }
                    Button("Estimate", systemImage: "chart.bar.xaxis") {
                        estimating = true
                        Task {
                            estimate = await PercolationStats.estimate(size: Int(size), trials: 200)
                            estimating = false
                        }
                    }
                    .buttonStyle(.glass)
                    .disabled(estimating)
                }
            }
        }
        .padding()
        .frame(minWidth: 560, minHeight: 640)
        .task(id: running) {
            var generator = SystemRandomNumberGenerator()
            while running && !grid.percolates() {
                openRandomSite(using: &generator)
                try? await Task.sleep(for: .milliseconds(8))
            }
            running = false
        }
    }

    private var status: String {
        let total = grid.size * grid.size
        let percent = Int((Double(grid.openSites) / Double(total) * 100).rounded())
        var text = "\(grid.openSites) of \(total) sites open (\(percent)%)"
        text += grid.percolates() ? " · percolates" : " · does not percolate"
        if estimating {
            text += " · estimating…"
        } else if let estimate {
            let low = Int((estimate.confidenceInterval.lowerBound * 1000).rounded())
            let high = Int((estimate.confidenceInterval.upperBound * 1000).rounded())
            text += " · threshold ≈ 0.\(low)–0.\(high)"
        }
        return text
    }

    private func reset() {
        running = false
        grid = Percolation(size: Int(size))
    }

    private func openRandomSite(using generator: inout some RandomNumberGenerator) {
        let n = grid.size
        guard grid.openSites < n * n else { return }
        while true {
            let (row, column) = (Int.random(in: 0..<n, using: &generator), Int.random(in: 0..<n, using: &generator))
            if !grid.isOpen(row: row, column: column) {
                grid.open(row: row, column: column)
                return
            }
        }
    }
}
