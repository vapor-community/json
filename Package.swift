import PackageDescription

let package = Package(
    name: "JSON",
    dependencies: [
        // Core protocols, extensions, and functionality
        .Package(url: "https://github.com/vapor/core.git", majorVersion: 0, minor: 5),

        // Data structure for converting between multiple representations
        .Package(url: "https://github.com/vapor/node.git", majorVersion: 0, minor: 6),

        // The actual JSON parser
        .Package(url: "https://github.com/DanToml/Jay.git", majorVersion: 0, minor: 21)
    ]
)
