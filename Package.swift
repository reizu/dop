// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Dop",
    dependencies: [
        .package(url: "https://github.com/apple/swift-package-manager.git", from: "0.1.0"),
        .package(url: "https://github.com/reizu/swift-common.git", .branch("master")),
    ],
    targets: [
        .target(
            name: "Devops",
            dependencies: [
                "Utility",
                "Common",
            ]
        ),
        .target(
            name: "dop",
            dependencies: [
                "Utility",
                "Devops",
            ]
        ),
    ]
)
