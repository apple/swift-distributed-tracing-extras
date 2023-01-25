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
    /// General thread attributes.
    ///
    /// OpenTelemetry Spec: [General thread attributes](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/span-general.md#general-thread-attributes)
    public var thread: ThreadAttributes {
        get {
            .init(attributes: self)
        }
        set {
            self = newValue.attributes
        }
    }
}

/// General thread attributes.
///
/// OpenTelemetry Spec: [General thread attributes](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/span-general.md#general-thread-attributes)
@dynamicMemberLookup
public struct ThreadAttributes: SpanAttributeNamespace {
    public var attributes: SpanAttributes

    public init(attributes: SpanAttributes) {
        self.attributes = attributes
    }

    public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
        public init() {}

        /// Current "managed" thread ID (as opposed to OS thread ID). E.g. 42.
        public var id: Key<Int> { "thread.id" }

        /// Current thread name. E.g. "main".
        public var name: Key<String> { "thread.name" }
    }
}
