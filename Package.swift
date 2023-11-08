// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "AlertDispatcher",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "AlertDispatcher",
            targets: ["AlertDispatcher"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "AlertDispatcher", path: "Sources")
    ],
    swiftLanguageVersions: [.v5]
)
