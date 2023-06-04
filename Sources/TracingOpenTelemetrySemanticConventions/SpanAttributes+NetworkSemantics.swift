//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Distributed Tracing open source project
//
// Copyright (c) 2022-2023 Apple Inc. and the Swift Distributed Tracing project
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
    /// General network connection attributes.
    ///
    /// OpenTelemetry Spec: [General network connection attributes](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/span-general.md#general-network-connection-attributes)
    public var network: NetworkAttributes {
        get {
            .init(attributes: self)
        }
        set {
            self = newValue.attributes
        }
    }
}

/// General network connection attributes.
///
/// OpenTelemetry Spec: [General network connection attributes](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/span-general.md#general-network-connection-attributes)
@dynamicMemberLookup
public struct NetworkAttributes: SpanAttributeNamespace {
    public var attributes: SpanAttributes

    public init(attributes: SpanAttributes) {
        self.attributes = attributes
    }

    public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
        public init() {}

        /// Transport protocol used.
        public var transport: Key<Transport> { "net.transport" }
    }

    /// Possible values for the `network.transport` span attribute.
    ///
    /// OpenTelemetry Spec: [Network transport attributes](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/span-general.md#network-transport-attributes)
    public struct Transport: RawRepresentable, SpanAttributeConvertible, Sendable {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        /// `ip_tcp`.
        public static let ipTCP = Transport(rawValue: "ip_tcp")

        /// `ip_udp`.
        public static let ipUDP = Transport(rawValue: "ip_udp")

        /// Another IP-based protocol.
        public static let ip = Transport(rawValue: "ip")

        /// Unix Domain socket.
        public static let unix = Transport(rawValue: "unix")

        /// Named or anonymous pipe.
        public static let pipe = Transport(rawValue: "pipe")

        /// In-process communication.
        ///
        /// Signals that there is only in-process communication not using a "real" network protocol in cases where network
        /// attributes would normally be expected. Usually all other network attributes can be left out in that case.
        public static let inProcess = Transport(rawValue: "inproc")

        /// Something else (non IP-based).
        public static let other = Transport(rawValue: "other")

        public func toSpanAttribute() -> SpanAttribute {
            .string(self.rawValue)
        }
    }

    // MARK: - Network Peer Attributes

    /// Network peer attributes.
    ///
    /// OpenTelemetry Spec: [General network connection attributes](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/span-general.md#network-transport-attributes)
    public var peer: NetworkPeerAttributes {
        get {
            .init(attributes: self.attributes)
        }
        set {
            self.attributes = newValue.attributes
        }
    }

    /// Network peer attributes.
    ///
    /// OpenTelemetry Spec: [General network connection attributes](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/span-general.md#network-transport-attributes)
    public struct NetworkPeerAttributes: SpanAttributeNamespace {
        public var attributes: SpanAttributes

        public init(attributes: SpanAttributes) {
            self.attributes = attributes
        }

        public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
            public init() {}

            /// Remote address of the peer (dotted decimal for IPv4 or [RFC 5952](https://tools.ietf.org/html/rfc5952) for IPv6),
            /// e.g. `127.0.0.1`.
            public var ip: Key<String> { "net.peer.ip" }

            /// Remote port number, e.g. `443`.
            public var port: Key<Int> { "net.peer.port" }

            /// Remote hostname or similar. E.g. `example.com`.
            ///
            /// - Warning: The peer name SHOULD NOT be set if capturing it would require an extra DNS lookup.
            public var name: Key<String> { "net.peer.name" }
        }
    }

    // MARK: - Network Host Attributes

    /// Network host attributes.
    ///
    /// OpenTelemetry Spec: [General network connection attributes](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/span-general.md#network-transport-attributes)
    public var host: NetworkHostAttributes {
        get {
            .init(attributes: self.attributes)
        }
        set {
            self.attributes = newValue.attributes
        }
    }

    /// Network host attributes.
    ///
    /// OpenTelemetry Spec: [General network connection attributes](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/span-general.md#network-transport-attributes)
    public struct NetworkHostAttributes: SpanAttributeNamespace {
        public var attributes: SpanAttributes

        public init(attributes: SpanAttributes) {
            self.attributes = attributes
        }

        public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
            public init() {}

            /// Remote address of the host (dotted decimal for IPv4 or [RFC 5952](https://tools.ietf.org/html/rfc5952) for IPv6),
            /// useful in case of a multi-IP host. E.g. `192.168.0.1`.
            public var ip: Key<String> { "net.host.ip" }

            /// Host port number, e.g. `35555`.
            public var port: Key<Int> { "net.host.port" }

            /// Local hostname or similar. E.g. `localhost`.
            ///
            /// - Warning: The peer name SHOULD NOT be set if capturing it would require an extra DNS lookup.
            public var name: Key<String> { "net.host.name" }
        }

        /// Network host connection attributes.
        ///
        /// OpenTelemetry Spec: [General network connection attributes](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/span-general.md#network-transport-attributes)
        public var connection: ConnectionAttributes {
            get {
                .init(attributes: self.attributes)
            }
            set {
                self.attributes = newValue.attributes
            }
        }

        /// Network host connection attributes.
        ///
        /// OpenTelemetry Spec: [General network connection attributes](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/span-general.md#network-transport-attributes)
        public struct ConnectionAttributes: SpanAttributeNamespace {
            public var attributes: SpanAttributes

            public init(attributes: SpanAttributes) {
                self.attributes = attributes
            }

            public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
                public init() {}

                /// The internet connection type currently being used by the host. E.g. `wifi`.
                public var type: Key<String> { "net.host.connection.type" }

                /// This describes more details regarding the ``type``.
                /// It may be the type of cell technology connection, but it could be used for describing details about a wifi connection. E.g. `LTE`.
                public var subtype: Key<String> { "net.host.connection.subtype" }
            }
        }

        /// Network host carrier attributes.
        ///
        /// OpenTelemetry Spec: [General network connection attributes](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/span-general.md#network-transport-attributes)
        public var carrier: CarrierAttributes {
            get {
                .init(attributes: self.attributes)
            }
            set {
                self.attributes = newValue.attributes
            }
        }

        /// Network host carrier attributes.
        ///
        /// OpenTelemetry Spec: [General network connection attributes](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/span-general.md#network-transport-attributes)
        public struct CarrierAttributes: SpanAttributeNamespace {
            public var attributes: SpanAttributes

            public init(attributes: SpanAttributes) {
                self.attributes = attributes
            }

            public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
                public init() {}

                /// The name of the mobile carrier.
                public var name: Key<String> { "net.host.carrier.name" }

                /// The mobile carrier country code. E.g. `310`.
                public var mcc: Key<String> { "net.host.carrier.mcc" }

                /// The mobile carrier network code. E.g. `001`.
                public var mnc: Key<String> { "net.host.carrier.mnc" }

                /// The `ISO 3166-1 alpha-2` 2-character country code associated with the mobile carrier network. E.g. `DE`.
                public var icc: Key<String> { "net.host.carrier.icc" }
            }
        }
    }
}
