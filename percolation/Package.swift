// swift-tools-version: 6.4
import PackageDescription

// The simulation (PercolationCore) and its tests build anywhere Swift runs. The
// app that draws it (PercolationApp) uses SwiftUI, so it exists only on macOS.
var targets: [Target] = [
    .target(name: "PercolationCore"),
    .testTarget(name: "PercolationCoreTests", dependencies: ["PercolationCore"]),
]
#if os(macOS)
targets.append(.executableTarget(name: "PercolationApp", dependencies: ["PercolationCore"]))
#endif

let package = Package(
    name: "Percolation",
    platforms: [.macOS(.v27)],
    targets: targets
)
