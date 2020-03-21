// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Gabi",
    products: [
        .library(
            name: "Gabi",
            targets: ["Gabi"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Gabi",
            dependencies: []),
        .testTarget(
            name: "GabiTests",
            dependencies: ["Gabi"]),
    ]
)
