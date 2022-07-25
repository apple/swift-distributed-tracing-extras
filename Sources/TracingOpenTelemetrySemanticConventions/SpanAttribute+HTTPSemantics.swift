//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Distributed Tracing open source project
//
// Copyright (c) 2022 Apple Inc. and the Swift Distributed Tracing project
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
    /// Semantic conventions for HTTP spans.
    ///
    /// OpenTelemetry Spec: [Semantic conventions for HTTP spans](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/http.md#semantic-conventions-for-http-spans)
    public var http: HTTPAttributes {
        get {
            .init(attributes: self)
        }
        set {
            self = newValue.attributes
        }
    }
}

/// Semantic conventions for HTTP spans.
///
/// OpenTelemetry Spec: [Semantic conventions for HTTP spans](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/http.md#semantic-conventions-for-http-spans)
@dynamicMemberLookup
public struct HTTPAttributes: SpanAttributeNamespace {
    public var attributes: SpanAttributes

    public init(attributes: SpanAttributes) {
        self.attributes = attributes
    }

    // MARK: - General

    public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
        public init() {}

        /// HTTP request method. E.g. "GET".
        public var method: Key<String> { "http.method" }

        /// Full HTTP request URL. E.g. "https://www.foo.bar/search?q=OpenTelemetry#SemConv".
        ///
        /// - Warning: The URL MUST NOT contain credentials passed via URL in form of `https://username:password@www.example.com/`.
        /// In such case the attribute's value should be `https://www.example.com/`.
        public var url: Key<String> { "http.url" }

        /// Full request target as passed in an HTTP request line or equivalent. E.g. "/path/12314/?q=ddds#123".
        public var target: Key<String> { "http.target" }

        /// Value of the HTTP host header. E.g. "www.swift.org".
        ///
        /// - Note: When the header is present but empty the attribute SHOULD be set to the empty string.
        /// When the header is not set the attribute MUST NOT be set.
        public var host: Key<String> { "http.host" }

        /// URI scheme identifying the used protocol. E.g. "https".
        public var scheme: Key<String> { "http.scheme" }

        /// HTTP response status code. E.g. 418.
        public var statusCode: Key<Int> { "http.status_code" }

        /// Kind of HTTP protocol used. E.g. "1.0".
        public var flavor: Key<String> { "http.flavor" }

        /// Value of the HTTP User-Agent header sent by the client.
        public var userAgent: Key<String> { "http.user_agent" }

        /// Ordinal number of request re-sending attempts.
        public var retryCount: Key<Int> { "http.retry_count" }
    }

    // MARK: - Request

    /// Semantic conventions for HTTP requests.
    public var request: RequestAttributes {
        get {
            .init(attributes: self.attributes)
        }
        set {
            self.attributes = newValue.attributes
        }
    }

    /// Semantic conventions for HTTP requests.
    public struct RequestAttributes: SpanAttributeNamespace {
        public var attributes: SpanAttributes

        public init(attributes: SpanAttributes) {
            self.attributes = attributes
        }

        /// Semantic conventions for HTTP request headers.
        ///
        /// OpenTelemetry Spec: [HTTP request and response headers](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/http.md#http-request-and-response-headers)
        public var headers: HeaderAttributes {
            get {
                .init(attributes: self.attributes, group: "request")
            }
            set {
                self.attributes = newValue.attributes
            }
        }

        public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
            public init() {}

            /// Size of the request payload body in bytes. E.g. 1234.
            ///
            /// This is the number of bytes transferred excluding headers and is often, but not always, present as the `Content-Length` header.
            /// For requests using transport encoding, this should be the compressed size.
            public var contentLength: Key<Int> { "http.request_content_length" }

            /// Size of the uncompressed request payload body after transport decoding. E.g. 5678.
            ///
            /// Not set if transport encoding is not used.
            public var uncompressedContentLength: Key<Int> { "http.request_content_length_uncompressed" }
        }
    }

    // MARK: - Response

    /// Semantic conventions for HTTP responses.
    public var response: ResponseAttributes {
        get {
            .init(attributes: self.attributes)
        }
        set {
            self.attributes = newValue.attributes
        }
    }

    /// Semantic conventions for HTTP responses.
    public struct ResponseAttributes: SpanAttributeNamespace {
        public var attributes: SpanAttributes

        public init(attributes: SpanAttributes) {
            self.attributes = attributes
        }

        /// Semantic conventions for HTTP response headers.
        ///
        /// OpenTelemetry Spec: [HTTP request and response headers](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/http.md#http-request-and-response-headers)
        public var headers: HeaderAttributes {
            get {
                .init(attributes: self.attributes, group: "request")
            }
            set {
                self.attributes = newValue.attributes
            }
        }

        public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
            public init() {}

            /// Size of the response payload body in bytes. E.g. 1234.
            ///
            /// This is the number of bytes transferred excluding headers and is often, but not always, present as the `Content-Length` header.
            /// For requests using transport encoding, this should be the compressed size.
            public var contentLength: Key<Int> { "http.response_content_length" }

            /// Size of the uncompressed response payload body after transport decoding. E.g. 5678.
            ///
            /// Not set if transport encoding is not used.
            public var uncompressedContentLength: Key<Int> { "http.response_content_length_uncompressed" }
        }
    }

    // MARK: - Server

    /// Semantic conventions for HTTP servers.
    ///
    /// OpenTelemetry Spec: [HTTP Server semantic conventions](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/http.md#http-server-semantic-conventions)
    public var server: ServerAttributes {
        get {
            .init(attributes: self.attributes)
        }
        set {
            self.attributes = newValue.attributes
        }
    }

    /// Semantic conventions for HTTP servers.
    public struct ServerAttributes: SpanAttributeNamespace {
        public var attributes: SpanAttributes

        public init(attributes: SpanAttributes) {
            self.attributes = attributes
        }

        public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
            public init() {}

            /// The primary server name of the matched virtual host, e.g. `swift.org`. This should be obtained via configuration.
            ///
            /// - Warning: If no host configuration can be obtained, this attribute MUST NOT be set.
            public var name: Key<String> { "http.server_name" }

            /// The matched route. E.g. `/blog/:slug`.
            public var route: Key<String> { "http.route" }

            /// The IP address of the original client behind all proxies, if known (e.g. from `X-Forwarded-For`).
            public var clientIP: Key<String> { "http.client_ip" }
        }
    }
}

// MARK: - HTTP Headers

extension HTTPAttributes {
    /// Semantic conventions for HTTP headers.
    ///
    /// OpenTelemetry Spec: [HTTP request and response headers](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/http.md#http-request-and-response-headers)
    @dynamicMemberLookup
    public struct HeaderAttributes {
        var attributes: SpanAttributes
        private let group: String

        init(attributes: SpanAttributes, group: String) {
            self.attributes = attributes
            self.group = group
        }

        public subscript(dynamicMember header: String) -> [String]? {
            get {
                let key = self.attributeKey(forHeader: header)
                guard case .stringArray(let values) = self.attributes[key]?.toSpanAttribute() else { return nil }
                return values
            }
            set {
                let key = self.attributeKey(forHeader: header)
                self.attributes[key] = newValue
            }
        }

        /// Set the given values for the given HTTP header.
        ///
        /// - Note: The supplied header will be normalized into its lowercased snake-case form. E.g. `X-Trace-Id` will become `x_trace_id`.
        /// - Parameters:
        ///   - values: All values set for the given header.
        ///   - header: The name of the HTTP header.
        public mutating func setValues(_ values: [String], forHeader header: String) {
            let key = self.attributeKey(forHeader: header)
            self.attributes[key] = values
        }

        private func attributeKey(forHeader header: String) -> String {
            var key = "http.\(group).header."

            for index in header.indices {
                let character = header[index]

                if character.isUppercase {
                    if index > header.startIndex {
                        let previousCharacter = header[header.index(before: index)]
                        if previousCharacter.isUppercase || previousCharacter == "-" {
                            key.append(character.lowercased())
                        } else {
                            key.append("_\(character.lowercased())")
                        }
                    } else {
                        key.append(character.lowercased())
                    }
                } else if character == "-" {
                    key.append("_")
                } else {
                    key.append(character)
                }
            }

            return key
        }
    }
}
