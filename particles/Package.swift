// swift-tools-version: 6.4
import PackageDescription

// The simulation (ParticlesCore) and its tests build anywhere Swift runs. The
// app that draws it (ParticlesApp) uses SwiftUI, so it exists only on macOS.
var targets: [Target] = [
    .target(name: "ParticlesCore"),
    .testTarget(name: "ParticlesCoreTests", dependencies: ["ParticlesCore"]),
]
#if os(macOS)
targets.append(.executableTarget(name: "ParticlesApp", dependencies: ["ParticlesCore"]))
#endif

let package = Package(
    name: "Particles",
    platforms: [.macOS(.v27)],
    targets: targets
)
