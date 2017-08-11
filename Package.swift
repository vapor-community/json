// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "JSON",
    products: [
        .library(name: "JSON", targets: ["JSON"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/core.git", .upToNextMajor(from: "2.1.0")),
        .package(url: "https://github.com/vapor/mapper.git", .branch("beta")),
    ],
    targets: [
        .target(name: "JSON", dependencies: ["Core", "Mapper"]),
        .testTarget(name: "JSONTests", dependencies: ["JSON"]),
    ]
)