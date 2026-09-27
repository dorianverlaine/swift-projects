// swift-tools-version: 6.4
import PackageDescription

let package = Package(
    name: "LinkedListDeque",
    targets: [
        .target(name: "LinkedListDeque"),
        .testTarget(name: "LinkedListDequeTests", dependencies: ["LinkedListDeque"]),
    ]
)
