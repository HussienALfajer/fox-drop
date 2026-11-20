// swift-tools-version: 5.9
// core_alerts' iOS layer (architecture §14.2, CA §4.4–4.5; slice 2.46).

import PackageDescription

let package = Package(
    name: "core_alerts",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .library(name: "core-alerts", targets: ["core_alerts"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "core_alerts",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ]
        )
    ]
)
