import PackageDescription

let package = Package(
    name: "JSON",
    dependencies: [
        // Core protocols, extensions, and functionality
        .Package(url: "https://github.com/vapor/core.git", Version(2,0,0, prereleaseIdentifiers: ["alpha"])),

        // Data structure for converting between multiple representations
        .Package(url: "https://github.com/vapor/node.git", Version(0,0,0)),//Version(2,0,0, prereleaseIdentifiers: ["alpha"])),

        // The actual JSON parser
        .Package(url: "https://github.com/DanToml/Jay.git", majorVersion: 1)
    ]
)
