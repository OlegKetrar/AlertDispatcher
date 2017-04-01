// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "AlertDispatcher",
    dependencies: [
        .Package(url: "https://github.com/OlegKetrar/TaskKit", "0.2.3")
    ]
)
