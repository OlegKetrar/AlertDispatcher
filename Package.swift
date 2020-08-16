// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "AlertDispatcher",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(
            name: "AlertDispatcher",
            type: .dynamic,
            targets: ["AlertDispatcher"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "AlertDispatcher", path: "Sources")
    ],
    swiftLanguageVersions: [.v5]
)
