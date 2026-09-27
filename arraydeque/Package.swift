// swift-tools-version: 6.4
import PackageDescription

let package = Package(
    name: "ArrayDeque",
    targets: [
        .target(name: "ArrayDeque"),
        .testTarget(name: "ArrayDequeTests", dependencies: ["ArrayDeque"]),
    ]
)
