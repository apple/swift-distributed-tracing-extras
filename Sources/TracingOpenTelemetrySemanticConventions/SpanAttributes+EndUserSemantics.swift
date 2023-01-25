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
    /// General identity attributes.
    ///
    /// OpenTelemetry Spec: [General identity attributes](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/span-general.md#general-identity-attributes)
    ///
    /// These attributes describe the authenticated user driving the user agent making requests to the instrumented system.
    /// It is expected this information would be propagated unchanged from node-to-node within the system using the Baggage mechanism.
    ///
    /// - Warning: These attributes should not be used to record system-to-system authentication attributes.
    public var endUser: EndUserAttributes {
        get {
            .init(attributes: self)
        }
        set {
            self = newValue.attributes
        }
    }
}

/// General identity attributes.
///
/// OpenTelemetry Spec: [General identity attributes](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/span-general.md#general-identity-attributes)
///
/// These attributes describe the authenticated user driving the user agent making requests to the instrumented system.
/// It is expected this information would be propagated unchanged from node-to-node within the system using the Baggage mechanism.
///
/// - Warning: These attributes should not be used to record system-to-system authentication attributes.
@dynamicMemberLookup
public struct EndUserAttributes: SpanAttributeNamespace {
    public var attributes: SpanAttributes

    public init(attributes: SpanAttributes) {
        self.attributes = attributes
    }

    public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
        public init() {}

        /// Username or `client_id` extracted from the access token or
        /// [Authorization header](https://www.rfc-editor.org/rfc/rfc7235#section-4.2)
        /// in the inbound request from outside the system. E.g. "username".
        public var id: Key<String> { "enduser.id" }

        /// Actual/assumed role the client is making the request under extracted from token or application security context. E.g. "admin".
        public var role: Key<String> { "enduser.role" }

        /// Scopes or granted authorities the client currently possesses extracted from token or application security context.
        /// E.g. "read:message, write:files".
        ///
        /// The value would come from the scope associated with an
        /// [OAuth 2.0 Access Token](https://tools.ietf.org/html/rfc6749#section-3.3)
        /// or an attribute value in a
        /// [SAML 2.0 Assertion](https://docs.oasis-open.org/security/saml/Post2.0/sstc-saml-tech-overview-2.0.html).
        public var scope: Key<String> { "enduser.scope" }
    }
}
