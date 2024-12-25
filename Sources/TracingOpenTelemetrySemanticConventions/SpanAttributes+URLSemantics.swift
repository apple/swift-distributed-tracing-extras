//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Distributed Tracing open source project
//
// Copyright (c) 2023 Apple Inc. and the Swift Distributed Tracing project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of Swift Distributed Tracing project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import Tracing

extension SpanAttributes {
    /// URL attributes.
    ///
    /// OpenTelemetry Spec: [URL attributes](https://opentelemetry.io/docs/specs/semconv/attributes-registry/url/)
    public var url: URLAttributes {
        get {
            .init(attributes: self)
        }
        set {
            self = newValue.attributes
        }
    }
}

/// URL attributes.
///
/// OpenTelemetry Spec: [URL attributes](https://opentelemetry.io/docs/specs/semconv/attributes-registry/url/)
@dynamicMemberLookup
public struct URLAttributes: SpanAttributeNamespace {
    public var attributes: SpanAttributes

    public init(attributes: SpanAttributes) {
        self.attributes = attributes
    }

    public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
        public init() {}

        /// Domain extracted from the url.full, such as “opentelemetry.io”.
        public var domain: Key<String> { "url.domain" }

        /// The file extension extracted from the url.full, excluding the leading dot.
        public var `extension`: Key<String> { "url.extension" }
        
        /// The URI fragment component
        public var fragment: Key<String> { "url.fragment" }
        
        /// Absolute URL describing a network resource according to [RFC3986](https://www.rfc-editor.org/rfc/rfc3986)
        public var full: Key<String> { "url.full" }
        
        /// Unmodified original URL as seen in the event source
        public var original: Key<String> { "url.original" }
        
        /// The URI path component
        public var path: Key<String> { "url.path" }
        
        /// Port extracted from the url.full
        public var port: Key<Int> { "url.port" }
        
        /// The URI query component
        public var query: Key<String> { "url.query" }
        
        /// The highest registered url domain, stripped of the subdomain
        public var registeredDomain: Key<String> { "url.registered_domain" }
        
        /// The URI scheme component identifying the used protocol
        public var scheme: Key<String> { "url.scheme" }
        
        /// The subdomain portion of a fully qualified domain name includes all of the names except the
        /// host name under the registered\_domain. In a partially qualified domain, or if the qualification
        /// level of the full name cannot be determined, subdomain contains all of the names below the
        /// registered domain
        public var subdomain: Key<String> { "url.subdomain" }
        
        /// The low-cardinality template of an absolute path reference
        public var template: Key<String> { "url.template" }
        
        /// The effective top level domain (eTLD), also known as the domain suffix, is the last part of the
        /// domain name. For example, the top level domain for example.com is com
        public var topLevelDomain: Key<String> { "url.top_level_domain" }
    }
}
