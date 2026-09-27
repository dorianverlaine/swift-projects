// swift-tools-version: 6.4
import PackageDescription

// The data structures (NGordNetCore) and their tests build anywhere Swift runs.
// The app that charts and queries them (NGordNetApp) uses SwiftUI, so it exists
// only on macOS.
var targets: [Target] = [
    .target(name: "NGordNetCore", resources: [.copy("Data")]),
    .testTarget(name: "NGordNetCoreTests", dependencies: ["NGordNetCore"]),
]
#if os(macOS)
targets.append(.executableTarget(name: "NGordNetApp", dependencies: ["NGordNetCore"]))
#endif

let package = Package(
    name: "NGordNet",
    platforms: [.macOS(.v27)],
    targets: targets
)
