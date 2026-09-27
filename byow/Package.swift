// swift-tools-version: 6.4
import PackageDescription

// The world generator and the game (BYOWCore) and their tests build anywhere
// Swift runs. The app that plays it (BYOWApp) uses SwiftUI, so it exists only
// on macOS.
var targets: [Target] = [
    .target(name: "BYOWCore"),
    .testTarget(name: "BYOWCoreTests", dependencies: ["BYOWCore"]),
]
#if os(macOS)
targets.append(.executableTarget(name: "BYOWApp", dependencies: ["BYOWCore"]))
#endif

let package = Package(
    name: "BYOW",
    platforms: [.macOS(.v27)],
    targets: targets
)
