// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "swift-distributed-tracing-extras",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v11),
    ],
    products: [
        .library(name: "OpenTelemetrySemanticConventions", targets: ["OpenTelemetrySemanticConventions"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-distributed-tracing.git", from: "0.3.0"),
    ],
    targets: [
        .target(
            name: "OpenTelemetrySemanticConventions",
            dependencies: [
                .product(name: "Tracing", package: "swift-distributed-tracing"),
            ]
        ),
        .testTarget(
            name: "OpenTelemetrySemanticConventionsTests",
            dependencies: [
                .target(name: "OpenTelemetrySemanticConventions"),
                .product(name: "Tracing", package: "swift-distributed-tracing"),
            ]
        ),
    ]
)
