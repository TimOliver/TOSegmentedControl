// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TOSegmentedControl",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(
            name: "TOSegmentedControl",
            targets: ["TOSegmentedControl"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "TOSegmentedControl",
            path: ".",
            sources: [
                "TOSegmentedControl/TOSegmentedControl.m",
                "TOSegmentedControl/Private/TOSegmentedControlSegment.m",
            ],
            publicHeadersPath: "include"
        ),
        .testTarget(
            name: "TOSegmentedControlTests",
            dependencies: ["TOSegmentedControl"],
            path: "TOSegmentedControlTests"),
    ]
)
