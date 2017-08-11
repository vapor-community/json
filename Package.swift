// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "JSONs",
    products: [
        .library(name: "JSONs", targets: ["JSONs"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/core.git", .upToNextMajor(from: "2.1.0")),
        .package(url: "https://github.com/vapor/mapper.git", .branch("beta")),
    ],
    targets: [
        .target(name: "JSONs", dependencies: ["Core", "Mapper"]),
        .testTarget(name: "JSONsTests", dependencies: ["JSONs"]),
    ]
)