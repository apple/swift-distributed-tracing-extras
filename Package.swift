// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "swift-distributed-tracing-extras",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v14),
        .tvOS(.v14),
        .watchOS(.v7),
    ],
    products: [
        .library(
            name: "TracingOpenTelemetrySemanticConventions",
            targets: [
                "TracingOpenTelemetrySemanticConventions"
            ]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-distributed-tracing.git", from: "0.3.0"),
    ],
    targets: [
        .target(
            name: "TracingOpenTelemetrySemanticConventions",
            dependencies: [
                .product(name: "Tracing", package: "swift-distributed-tracing"),
            ]
        ),
        .testTarget(
            name: "TracingOpenTelemetrySemanticConventionsTests",
            dependencies: [
                .target(name: "TracingOpenTelemetrySemanticConventions"),
                .product(name: "Tracing", package: "swift-distributed-tracing"),
            ]
        ),
    ]
)
