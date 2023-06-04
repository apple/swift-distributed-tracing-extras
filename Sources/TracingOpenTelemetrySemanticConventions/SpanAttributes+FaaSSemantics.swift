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
    /// Semantic conventions for FaaS spans.
    ///
    /// OpenTelemetry Spec: [Semantic conventions for FaaS spans](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/faas.md#semantic-conventions-for-faas-spans)
    public var faaS: FaaSAttributes {
        get {
            .init(attributes: self)
        }
        set {
            self = newValue.attributes
        }
    }
}

/// Semantic conventions for FaaS spans.
///
/// OpenTelemetry Spec: [Semantic conventions for FaaS spans](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/faas.md#semantic-conventions-for-faas-spans)
@dynamicMemberLookup
public struct FaaSAttributes: SpanAttributeNamespace {
    public var attributes: SpanAttributes

    public init(attributes: SpanAttributes) {
        self.attributes = attributes
    }

    // MARK: - General

    public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
        public init() {}

        /// Type of the trigger which caused this function execution. E.g. ``FaaSAttributes/Trigger/dataSource``.
        ///
        /// Clients invoking FaaS instances usually cannot set `faas.trigger`, since they would typically need to look in the payload
        /// to determine the event type. If clients set it, it should be the same as the trigger that corresponding incoming would have
        /// (i.e., this has nothing to do with the underlying transport used to make the API call to invoke the lambda, which is often HTTP).
        public var trigger: Key<Trigger> { "faas.trigger" }

        /// The execution ID of the current function execution. E.g. "af9d5aa4-a685-4c5f-a22b-444f80b3cc28".
        public var executionID: Key<String> { "faas.execution" }

        /// Whether the serverless function is executed for the first time (aka cold-start).
        public var isColdStart: Key<Bool> { "faas.coldstart" }

        /// The name of the invoked function. E.g. "my-function".
        public var invokedFunction: Key<String> { "faas.invoked_name" }

        /// The cloud provider of the invoked function. E.g. ``FaaSAttributes/Provider/alibabaCloud``.
        public var invokedProvider: Key<Provider> { "faas.invoked_provider" }

        /// The cloud region of the invoked function. E.g. "eu-central-1".
        ///
        /// For some cloud providers, like AWS or GCP, the region in which a function is hosted is essential to uniquely identify the function
        /// and also part of its endpoint. Since it's part of the endpoint being called, the region is always known to clients.
        /// In these cases, faas.invoked\_region MUST be set accordingly.
        ///
        /// If the region is unknown to the client or not required for identifying the invoked function, setting faas.invoked\_region is optional.
        public var invokedRegion: Key<String> { "faas.invoked_region" }
    }

    // MARK: - Document

    /// Span attributes for functions triggered via ``FaaSAttributes/Trigger/dataSource``.
    ///
    /// OpenTelemetry Spec: [Semantic conventions for FaaS Spans - Datasource](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/faas.md#datasource)
    public var document: DocumentAttributes {
        get {
            .init(attributes: self.attributes)
        }
        set {
            self.attributes = newValue.attributes
        }
    }

    /// Span attributes for functions triggered via ``FaaSAttributes/Trigger/dataSource``.
    ///
    /// OpenTelemetry Spec: [Semantic conventions for FaaS Spans - Datasource](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/faas.md#datasource)
    public struct DocumentAttributes: SpanAttributeNamespace {
        public var attributes: SpanAttributes

        public init(attributes: SpanAttributes) {
            self.attributes = attributes
        }

        public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
            public init() {}

            /// The name of the source on which the triggering operation was performed.
            /// For example, in Cloud Storage or S3 corresponds to the bucket name, and in Cosmos DB to the database name.
            public var collection: Key<String> { "faas.document.collection" }

            /// Describes the type of the operation that was performed on the data.
            /// E.g. ``FaaSAttributes/DocumentAttributes/Operation/insert``.
            public var operation: Key<Operation> { "faas.document.operation" }

            /// A string containing the time when the data was accessed
            /// in the [ISO 8601](https://www.iso.org/iso-8601-date-and-time-format.html) format
            /// expressed in [UTC](https://www.w3.org/TR/NOTE-datetime). E.g. "2020-01-23T13:47:06Z".
            public var time: Key<String> { "faas.document.time" }

            /// The document name/table subjected to the operation.
            /// For example, in Cloud Storage or S3 is the name of the file, and in Cosmos DB the table name.
            public var name: Key<String> { "faas.document.name" }
        }

        /// Well-known data operations,
        /// used for the ``FaaSAttributes/DocumentAttributes/NestedSpanAttributes/operation`` span attribute.
        public struct Operation: RawRepresentable, SpanAttributeConvertible, Sendable {
            public let rawValue: String

            public init(rawValue: String) {
                self.rawValue = rawValue
            }

            /// When a new object is created.
            public static let insert = Operation(rawValue: "insert")

            /// When an object is modified.
            public static let edit = Operation(rawValue: "edit")

            /// When an object is deleted.
            public static let delete = Operation(rawValue: "delete")

            public func toSpanAttribute() -> SpanAttribute {
                .string(self.rawValue)
            }
        }
    }

    // MARK: - Timer

    /// Span attributes for functions triggered via ``FaaSAttributes/Trigger/timer``.
    ///
    /// OpenTelemetry Spec: [Semantic conventions for FaaS Spans - Timer](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/faas.md#timer)
    public var timer: TimerAttributes {
        get {
            .init(attributes: self.attributes)
        }
        set {
            self.attributes = newValue.attributes
        }
    }

    /// Span attributes for functions triggered via ``FaaSAttributes/Trigger/timer``.
    ///
    /// OpenTelemetry Spec: [Semantic conventions for FaaS Spans - Timer](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/faas.md#timer)
    public struct TimerAttributes: SpanAttributeNamespace {
        public var attributes: SpanAttributes

        public init(attributes: SpanAttributes) {
            self.attributes = attributes
        }

        public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
            public init() {}

            /// A string containing the function invocation time
            /// in the [ISO 8601](https://www.iso.org/iso-8601-date-and-time-format.html) format
            /// expressed in [UTC](https://www.w3.org/TR/NOTE-datetime). E.g. "2020-01-23T13:47:06Z".
            public var time: Key<String> { "faas.time" }

            /// A string containing the schedule period as
            /// [Cron Expression](https://docs.oracle.com/cd/E12058_01/doc/doc.1014/e12030/cron_expressions.htm).
            /// E.g. "0/5 \* \* \* ? \*".
            public var cron: Key<String> { "faas.cron" }
        }
    }
}

extension FaaSAttributes {
    /// Triggers which caused a function execution, used for the ``FaaSAttributes/NestedSpanAttributes/trigger`` span attribute.
    public struct Trigger: RawRepresentable, SpanAttributeConvertible, Sendable {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        /// A response to some data source operation such as a database or filesystem read/write.
        ///
        /// When using this data source make sure to also set the ``FaaSAttributes/document`` span attributes.
        public static let dataSource = Trigger(rawValue: "datasource")

        /// To provide an answer to an inbound HTTP request.
        public static let http = Trigger(rawValue: "http")

        /// A function is set to be executed when messages are sent to a messaging system.
        public static let pubSub = Trigger(rawValue: "pubsub")

        /// A function is scheduled to be executed regularly.
        ///
        /// When using this data source make sure to also set the ``FaaSAttributes/timer`` span attributes.
        public static let timer = Trigger(rawValue: "timer")

        /// If none of the other well-known triggers apply.
        public static let other = Trigger(rawValue: "other")

        public func toSpanAttribute() -> SpanAttribute {
            .string(self.rawValue)
        }
    }
}

extension FaaSAttributes {
    /// Well-known cloud providers, used for the ``FaaSAttributes/NestedSpanAttributes/invokedProvider`` span attribute.
    public struct Provider: RawRepresentable, SpanAttributeConvertible, Sendable {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        /// Alibaba Cloud
        public static let alibabaCloud = Provider(rawValue: "alibaba_cloud")

        /// Amazon Web Services
        public static let aws = Provider(rawValue: "aws")

        /// Microsoft Azure
        public static let azure = Provider(rawValue: "azure")

        /// Google Cloud Platform
        public static let gpc = Provider(rawValue: "gpc")

        /// Tencent Cloud
        public static let tencentCloud = Provider(rawValue: "tencent_cloud")

        public func toSpanAttribute() -> SpanAttribute {
            .string(self.rawValue)
        }
    }
}
