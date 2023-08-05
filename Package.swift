// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "ProHUD",
    platforms: [.iOS(.v10)],
    products: [
        .library(name: "ProHUD", targets: ["ProHUD"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit.git", "5.0.0" ..< "6.0.0"),
    ],
    targets: [
        .target(
            name: "ProHUD",
            dependencies: ["SnapKit"],
            resources: [.process("Resources/ProHUD.xcassets")]
        )
    ]
)
