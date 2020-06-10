// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "ProHUD",
    platforms: [.iOS(.v10)],
    products: [
        .library(name: "ProHUD", targets: ["ProHUD"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit.git", "5.0.0" ..< "6.0.0"),
        .package(url: "https://github.com/xaoxuu/Inspire.git", "2.0.0" ..< "3.0.0"),
    ],
    targets: [
        .target(
            name: "ProHUD",
            dependencies: ["SnapKit", "Inspire"],
            path: "Source"
        )
    ],
    swiftLanguageVersions: [.v5]
)
