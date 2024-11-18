// swift-tools-version:5.9
import CompilerPluginSupport
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
        .library(
            name: "TracingMacros",
            targets: [
                "TracingMacros",
            ]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-distributed-tracing.git", from: "1.0.0"),
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0-latest"),
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

        // ==== --------------------------------------------------------------------------------------------------------
        // MARK: TracingMacros

        .target(
            name: "TracingMacros",
            dependencies: [
                .target(name: "TracingMacrosImplementation"),
                .product(name: "Tracing", package: "swift-distributed-tracing"),
            ]
        ),
        .macro(
            name: "TracingMacrosImplementation",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),
        .testTarget(
            name: "TracingMacrosTests",
            dependencies: [
                .target(name: "TracingMacros"),
                .target(name: "TracingMacrosImplementation"),
                .product(name: "Tracing", package: "swift-distributed-tracing"),
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
