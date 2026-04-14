// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "help_scout_beacon",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(name: "help-scout-beacon", targets: ["help_scout_beacon"]),
    ],
    dependencies: [
        .package(url: "https://github.com/helpscout/beacon-ios-sdk", from: "4.0.0"),
    ],
    targets: [
        .target(
            name: "help_scout_beacon",
            dependencies: [
                .product(name: "Beacon-iOS", package: "beacon-ios-sdk"),
            ],
            path: "Sources/help_scout_beacon"
        ),
    ]
)
