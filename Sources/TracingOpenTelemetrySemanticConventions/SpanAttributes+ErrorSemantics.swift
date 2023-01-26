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
    /// Error attributes.
    ///
    /// OpenTelemetry Spec: [Semantic Conventions for Exceptions](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/exceptions.md)
    public var error: ErrorAttributes {
        get {
            .init(attributes: self)
        }
        set {
            self = newValue.attributes
        }
    }
}

/// Error attributes.
///
/// OpenTelemetry Spec: [Semantic Conventions for Exceptions](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/exceptions.md)
@dynamicMemberLookup
public struct ErrorAttributes: SpanAttributeNamespace {
    public var attributes: SpanAttributes

    public init(attributes: SpanAttributes) {
        self.attributes = attributes
    }

    public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
        public init() {}

        /// The type of the error. E.g. `AuthenticationError`.
        public var type: Key<String> { "exception.type" }

        /// The error message. E.g. `Token expired`.
        public var message: Key<String> { "exception.message" }

        /// The stacktrace up to the error.
        public var stacktrace: Key<String> { "exception.stacktrace" }

        /// Whether the error "escaped" the span.
        ///
        /// E.g., if the operation inside a span throws an error to the outside it's considered escaped.
        /// If, on the other hand, the error is being handled inside the span it didn't escape.
        public var escaped: Key<Bool> { "exception.escaped" }
    }
}
