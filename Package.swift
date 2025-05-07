// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "swift-distributed-tracing-extras",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        .library(
            name: "TracingOpenTelemetrySemanticConventions",
            targets: [
                "TracingOpenTelemetrySemanticConventions",
            ]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-distributed-tracing.git", from: "1.0.0"),
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

for target in package.targets {
    var settings = target.swiftSettings ?? []
    settings.append(.enableExperimentalFeature("StrictConcurrency=complete"))
    target.swiftSettings = settings
}
