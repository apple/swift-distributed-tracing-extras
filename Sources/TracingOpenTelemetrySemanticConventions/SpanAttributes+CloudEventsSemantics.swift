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
    /// Semantic conventions for [CloudEvents](https://cloudevents.io).
    ///
    /// OpenTelemetry Spec: [Semantic conventions for CloudEvents](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/cloudevents.md)
    public var cloudEvents: CloudEventsAttributes {
        get {
            .init(attributes: self)
        }
        set {
            self = newValue.attributes
        }
    }
}

/// Semantic conventions for [CloudEvents](https://cloudevents.io).
///
/// OpenTelemetry Spec: [Semantic conventions for CloudEvents](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/cloudevents.md)
@dynamicMemberLookup
public struct CloudEventsAttributes: SpanAttributeNamespace {
    public var attributes: SpanAttributes

    public init(attributes: SpanAttributes) {
        self.attributes = attributes
    }

    public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
        public init() {}

        /// The [event_id](https://github.com/cloudevents/spec/blob/v1.0.2/cloudevents/spec.md#id) uniquely identifies the event.
        /// E.g. "123e4567-e89b-12d3-a456-426614174000".
        public var eventID: Key<String> { "cloudevents.event_id" }

        /// The [source](https://github.com/cloudevents/spec/blob/v1.0.2/cloudevents/spec.md#source-1) identifies the context in
        /// which an event happened. E.g. "my-service".
        public var eventSource: Key<String> { "cloudevents.event_source" }

        /// The [version of the CloudEvents specification](https://github.com/cloudevents/spec/blob/v1.0.2/cloudevents/spec.md#specversion)
        /// which the event uses. E.g. "1.0".
        public var eventSpecVersion: Key<String> { "cloudevents.event_spec_version" }

        /// The [event_type](https://github.com/cloudevents/spec/blob/v1.0.2/cloudevents/spec.md#type)
        /// contains a value describing the type of event related to the originating occurrence. E.g. "com.example.object.deleted.v2".
        public var eventType: Key<String> { "cloudevents.event_type" }

        /// The ]subject](https://github.com/cloudevents/spec/blob/v1.0.2/cloudevents/spec.md#subject3)
        /// of the event in the context of the event producer (identified by source). E.g. "mynewfile.jpg".
        public var eventSubject: Key<String> { "cloudevents.event_subject" }
    }
}
