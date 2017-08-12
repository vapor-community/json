// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "JSON",
    products: [
        .library(name: "JSON", targets: ["JSON"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/core.git", .branch("polymorphic-decoder")),
    ],
    targets: [
        .target(name: "JSON", dependencies: ["Core"]),
        .testTarget(name: "JSONTests", dependencies: ["JSON"]),
    ]
)
