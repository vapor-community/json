import PackageDescription

let package = Package(
    name: "JSON",
    dependencies: [
        // Core protocols, extensions, and functionality
    	.Package(url: "https://github.com/qutheory/core.git", majorVersion: 0, minor: 2),

        // Data structure for converting between multiple representations
        .Package(url: "https://github.com/qutheory/node.git", majorVersion: 0, minor: 2)
    ]
)
