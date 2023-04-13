//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Distributed Tracing open source project
//
// Copyright (c) 2023 Apple Inc. and the Swift Distributed Tracing project
// authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import Tracing

extension SpanAttributes {
    /// Semantic conventions for RPC spans.
    ///
    /// OpenTelemetry Spec: [Semantic conventions for RPC spans](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/rpc.md)
    public var rpc: RPCAttributes {
        get {
            .init(attributes: self)
        }
        set {
            self = newValue.attributes
        }
    }
}

/// Semantic conventions for RPC spans.
///
/// OpenTelemetry Spec: [Semantic conventions for RPC spans](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/rpc.md)
@dynamicMemberLookup
public struct RPCAttributes: SpanAttributeNamespace {
    public var attributes: SpanAttributes

    public init(attributes: SpanAttributes) {
        self.attributes = attributes
    }

    // MARK: - General

    public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
        public init() {}

        /// The remoting system. E.g. ``RPCAttributes/System/gRPC``.
        public var system: Key<System> { "rpc.system" }

        /// The full (logical) name of the service being called, including its package name, if applicable. E.g. "myservice.EchoService".
        ///
        /// This is the logical name of the service from the RPC interface perspective, which can be different from the name of any implementing class.
        /// The ``CodeAttributes/NestedSpanAttributes/namespace`` attribute may be used to store the latter (despite the attribute name,
        /// it may include a class name; e.g., class with method actually executing the call on the server side, RPC client stub class on the client side).
        public var service: Key<String> { "rpc.service" }

        /// The name of the (logical) method being called, must be equal to the
        /// [$method part in the span name](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/rpc.md#span-name).
        /// E.g. "exampleMethod".
        ///
        /// This is the logical name of the method from the RPC interface perspective, which can be different from the name of
        /// any implementing method/function.
        /// The ``CodeAttributes/NestedSpanAttributes/function`` attribute may be used to store the latter
        /// (e.g., method actually executing the call on the server side, RPC client stub method on the client side).
        public var method: Key<String> { "rpc.method" }
    }

    // MARK: - Message

    public var message: MessageAttributes {
        get {
            .init(attributes: self.attributes)
        }
        set {
            self.attributes = newValue.attributes
        }
    }

    /// Span attributes describing RPC messages.
    ///
    /// OpenTelemetry Spec: [Semantic Conventions for RPC spans - Events](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/rpc.md#events)
    public struct MessageAttributes: SpanAttributeNamespace {
        public var attributes: SpanAttributes

        public init(attributes: SpanAttributes) {
            self.attributes = attributes
        }

        public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
            public init() {}

            /// Whether this is a ``RPCAttributes/MessageAttributes/MessageType/received``
            /// or ``RPCAttributes/MessageAttributes/MessageType/sent`` message.
            public var type: Key<MessageType> { "message.type" }

            /// Unique message ID. MUST be calculated as two different counters starting from 1, one for sent messages and one for received message.
            ///
            /// This way we guarantee that the values will be consistent between different implementations.
            public var id: Key<Int> { "message.id" }

            /// Compressed size of the message in bytes.
            public var compressedSizeInBytes: Key<Int> { "message.compressed_size" }

            /// Uncompressed size of the message in bytes.
            public var uncompressedSizeInBytes: Key<Int> { "message.uncompressed_size" }
        }

        public enum MessageType: String, SpanAttributeConvertible {
            /// The message was sent.
            case sent = "SENT"

            /// The message was received.
            case received = "RECEIVED"

            public func toSpanAttribute() -> SpanAttribute {
                .string(self.rawValue)
            }
        }
    }

    // MARK: - gRPC

    /// Semantic conventions for [gRPC](https://grpc.io/) spans.
    ///
    /// OpenTelemetry Spec: [Semantic Conventions for RPC spans - gRPC](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/rpc.md#grpc)
    public var gRPC: GRPCAttributes {
        get {
            .init(attributes: self.attributes)
        }
        set {
            self.attributes = newValue.attributes
        }
    }

    /// Semantic conventions for [gRPC](https://grpc.io/) spans.
    ///
    /// OpenTelemetry Spec: [Semantic Conventions for RPC spans - gRPC](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/rpc.md#grpc)
    public struct GRPCAttributes: SpanAttributeNamespace {
        public var attributes: SpanAttributes

        public init(attributes: SpanAttributes) {
            self.attributes = attributes
        }

        public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
            public init() {}

            /// The [numeric status code](https://github.com/grpc/grpc/blob/v1.33.2/doc/statuscodes.md) of the gRPC request.
            /// E.g. ``RPCAttributes/GRPCAttributes/StatusCode/ok``.
            public var statusCode: Key<StatusCode> { "rpc.grpc.status_code" }
        }

        public struct StatusCode: RawRepresentable, SpanAttributeConvertible {
            public let rawValue: Int64

            public init(rawValue: Int64) {
                self.rawValue = rawValue
            }

            public init(_ rawValue: Int) {
                self.rawValue = Int64(exactly: rawValue)!
            }

            /// OK
            public static let ok = StatusCode(rawValue: 0)

            /// CANCELLED
            public static let cancelled = StatusCode(rawValue: 1)

            /// UNKNOWN
            public static let unknown = StatusCode(rawValue: 2)

            /// INVALID\_ARGUMENT
            public static let invalidArgument = StatusCode(rawValue: 3)

            /// DEADLINE\_EXCEEDED
            public static let deadlineExceeded = StatusCode(rawValue: 4)

            /// NOT\_FOUND
            public static let notFound = StatusCode(rawValue: 5)

            /// ALREADY\_EXISTS
            public static let alreadyExists = StatusCode(rawValue: 6)

            /// PERMISSION\_DENIED
            public static let permissionDenied = StatusCode(rawValue: 7)

            /// RESOURCE\_EXHAUSTED
            public static let resourceExhausted = StatusCode(rawValue: 8)

            /// FAILED\_PRECONDITION
            public static let failedPrecondition = StatusCode(rawValue: 9)

            /// ABORTED
            public static let aborted = StatusCode(rawValue: 10)

            /// OUT\_OF\_RANGE
            public static let outOfRange = StatusCode(rawValue: 11)

            /// UNIMPLEMENTED
            public static let unimplemented = StatusCode(rawValue: 12)

            /// INTERNAL
            public static let `internal` = StatusCode(rawValue: 13)

            /// UNAVAILABLE
            public static let unavailable = StatusCode(rawValue: 14)

            /// DATA\_LOSS
            public static let dataLoss = StatusCode(rawValue: 15)

            /// UNAUTHENTICATED
            public static let unauthenticated = StatusCode(rawValue: 16)

            public func toSpanAttribute() -> SpanAttribute {
                SpanAttribute.int64(self.rawValue)
            }
        }
    }

    // MARK: - JSON RPC

    /// Semantic conventions for [JSON RPC](https://www.jsonrpc.org/) spans.
    ///
    /// OpenTelemetry Spec: [Semantic Conventions for RPC spans - JSON RPC](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/rpc.md#json-rpc)
    public var jsonRPC: JSONRPCAttributes {
        get {
            .init(attributes: self.attributes)
        }
        set {
            self.attributes = newValue.attributes
        }
    }

    /// Semantic conventions for [JSON RPC](https://www.jsonrpc.org/) spans.
    ///
    /// OpenTelemetry Spec: [Semantic Conventions for RPC spans - JSON RPC](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/rpc.md#json-rpc)
    public struct JSONRPCAttributes: SpanAttributeNamespace {
        public var attributes: SpanAttributes

        public init(attributes: SpanAttributes) {
            self.attributes = attributes
        }

        public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
            public init() {}

            /// Protocol version as in `jsonrpc` property of request/response. E.g. "2.0".
            ///
            /// Since JSON-RPC 1.0 does not specify this, the value can be omitted.
            public var version: Key<String> { "rpc.jsonrpc.version" }

            /// `id` property of request or response. E.g. "10" or "request-7".
            ///
            /// Since protocol allows id to be int, string, null or missing (for notifications), value is expected to be cast to string for simplicity.
            /// Use empty string in case of null value. Omit entirely if this is a notification.
            public var requestID: Key<String> { "rpc.jsonrpc.request_id" }

            /// `error.code` property of response if it is an error response. E.g. -32700 or 100.
            ///
            /// If missing, response is assumed to be successful.
            public var errorCode: Key<Int> { "rpc.jsonrpc.error_code" }

            /// `error.message` property of response if it is an error response. E.g. "Parse error".
            public var errorMessage: Key<String> { "rpc.jsonrpc.error_message" }
        }
    }
}

// MARK: - System

extension RPCAttributes {
    /// Well-known RPC systems, used for the ``RPCAttributes/NestedSpanAttributes/system`` span attribute.
    public struct System: RawRepresentable, SpanAttributeConvertible {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        /// gRPC
        public static let gRPC = System(rawValue: "grpc")

        /// JSON RPC
        public static let jsonRPC = System(rawValue: "jsonrpc")

        /// Java RMI
        public static let javaRMI = System(rawValue: "java_rmi")

        /// .NET WCF
        public static let dotnetWCF = System(rawValue: "dotnet_wcf")

        /// Apache Dubbo
        public static let apacheDubbo = System(rawValue: "apache_dubbo")

        public func toSpanAttribute() -> SpanAttribute {
            .string(self.rawValue)
        }
    }
}
