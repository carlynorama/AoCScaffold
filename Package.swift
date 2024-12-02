// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AoCScaffold",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(name: "FileWrangler", targets: ["FileWrangler"]),
        .executable(name: "aoc", targets: ["CLI"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.5.0")),
        .package(url: "https://github.com/apple/pkl-swift", from: "0.3.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(name: "FileWrangler"),
        .executableTarget(
            name: "CLI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "PklSwift", package: "pkl-swift"),
                "FileWrangler"
            ]
        )
    ]
)
