// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "scal",
    dependencies: [
        .package(url: "https://github.com/jakeheis/SwiftCLI", from: "5.2.2")
    ],
    targets: [
        .target(
            name: "scal",
            dependencies: ["SwiftCLI"])
    ]
)
