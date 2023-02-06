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
    /// Semantic conventions for messaging systems.
    ///
    /// OpenTelemetry Spec: [Messaging Systems](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/messaging.md)
    public var messaging: MessagingAttributes {
        get {
            .init(attributes: self)
        }
        set {
            self = newValue.attributes
        }
    }
}

/// Semantic conventions for messaging systems.
///
/// OpenTelemetry Spec: [Messaging Systems](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/messaging.md)
@dynamicMemberLookup
public struct MessagingAttributes: SpanAttributeNamespace {
    public var attributes: SpanAttributes

    public init(attributes: SpanAttributes) {
        self.attributes = attributes
    }

    // MARK: - General

    public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
        public init() {}

        /// A string identifying the messaging system. E.g. "kafka".
        public var system: Key<String> { "messaging.system" }

        /// The message destination name. E.g. "MyTopic".
        ///
        /// This might be equal to the span name but is required nevertheless.
        public var destination: Key<String> { "messaging.destination" }

        /// The kind of message destination. E.g. ``MessagingAttributes/DestinationKind/topic``.
        public var destinationKind: Key<DestinationKind> { "messaging.destination_kind" }

        /// Whether the message destination is temporary.
        public var isTemporaryDestination: Key<Bool> { "messaging.temp_destination" }

        /// The name of the transport protocol. E.g. "AMQP".
        public var `protocol`: Key<String> { "messaging.protocol" }

        /// The version of the transport protocol. E.g. "0.9.1".
        public var protocolVersion: Key<String> { "messaging.protocol_version" }

        /// Connection string. E.g. "https://queue.amazonaws.com/80398EXAMPLE/MyQueue".
        public var url: Key<String> { "messaging.url" }

        /// A value used by the messaging system as an identifier for the message, represented as a string. E.g. "452a7c7c7c7048c2f887f61572b18fc2".
        public var messageID: Key<String> { "messaging.message_id" }

        /// The [conversation ID](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/messaging.md#conversations)
        /// identifying the conversation to which the message belongs, represented as a string. Sometimes called "Correlation ID".
        /// E.g. "MyConversationId".
        public var conversationID: Key<String> { "messaging.conversation_id" }

        /// The (uncompressed) size of the message payload in bytes. E.g. 2738.
        ///
        /// Also use this attribute if it is unknown whether the compressed or uncompressed payload size is reported.
        public var messagePayloadSizeInBytes: Key<Int> { "messaging.message_payload_size_bytes" }

        /// The compressed size of the message payload in bytes. E.g. 2048.
        public var compressedMessagePayloadSizeInBytes: Key<Int> { "messaging.message_payload_compressed_size_bytes" }

        /// The kind of message consumption as defined in ``MessagingAttributes/Operation``.
        /// E.g. ``MessagingAttributes/Operation/receive``.
        public var operation: Key<Operation> { "messaging.operation" }

        /// The identifier for the consumer receiving a message.
        ///
        /// ## Kafka
        /// Set it to ``MessagingAttributes/KafkaAttributes/NestedSpanAttributes/consumerGroup`` - ``MessagingAttributes/KafkaAttributes/NestedSpanAttributes/clientID``,
        /// if both are present, or only ``MessagingAttributes/KafkaAttributes/NestedSpanAttributes/consumerGroup``.
        ///
        /// ## Brokers such as RabbitMQ and Artemis
        /// Set it to the `client_id` of the client consuming the message.
        public var consumerID: Key<String> { "messaging.consumer_id" }
    }

    // MARK: - RabbitMQ

    /// Semantic conventions for RabbitMQ spans.
    ///
    /// [OpenTelemetry Spec: RabbitMQ](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/messaging.md#rabbitmq)
    public var rabbitMQ: RabbitMQAttributes {
        get {
            .init(attributes: self.attributes)
        }
        set {
            self.attributes = newValue.attributes
        }
    }

    /// Semantic conventions for RabbitMQ spans.
    ///
    /// [OpenTelemetry Spec: RabbitMQ](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/messaging.md#rabbitmq)
    public struct RabbitMQAttributes: SpanAttributeNamespace {
        public var attributes: SpanAttributes

        public init(attributes: SpanAttributes) {
            self.attributes = attributes
        }

        public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
            public init() {}

            /// RabbitMQ message routing key. E.g. "myKey"
            public var routingKey: Key<String> { "messaging.rabbitmq.routing_key" }
        }
    }

    // MARK: - Kafka

    /// Semantic conventions for Kafka spans.
    ///
    /// [OpenTelemetry Spec: Kafka](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/messaging.md#apache-kafka)
    public var kafka: KafkaAttributes {
        get {
            .init(attributes: self.attributes)
        }
        set {
            self.attributes = newValue.attributes
        }
    }

    /// Semantic conventions for Kafka spans.
    ///
    /// [OpenTelemetry Spec: Kafka](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/messaging.md#apache-kafka)
    public struct KafkaAttributes: SpanAttributeNamespace {
        public var attributes: SpanAttributes

        public init(attributes: SpanAttributes) {
            self.attributes = attributes
        }

        public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
            public init() {}

            /// Message keys in Kafka are used for grouping alike messages to ensure they're processed on the same partition.
            /// They differ from ``MessagingAttributes/NestedSpanAttributes/messageID`` in that they're not unique.
            /// E.g. "myKey".
            ///
            /// - Note: If the key is null, the attribute MUST NOT be set.
            public var messageKey: Key<String> { "messaging.kafka.message_key" }

            /// Name of the Kafka Consumer Group that is handling the message.
            /// Only applies to consumers, not producers. E.g. "my-group".
            public var consumerGroup: Key<String> { "messaging.kafka.consumer_group" }

            /// Client ID for the Consumer or Producer that is handling the message. E.g. "client-5".
            public var clientID: Key<String> { "messaging.kafka.client_id" }

            /// Partition the message is sent to. E.g. 2.
            public var partition: Key<Int> { "messaging.kafka.partition" }

            /// Whether the message is a tombstone. If not set, it is assumed to be false.
            public var isTombstone: Key<Bool> { "messaging.kafka.tombstone" }
        }
    }

    /// Semantic conventions for RocketMQ spans.
    ///
    /// [OpenTelemetry Spec: RocketMQ](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/messaging.md#apache-rocketmq)
    public var rocketMQ: RocketMQAttributes {
        get {
            .init(attributes: self.attributes)
        }
        set {
            self.attributes = newValue.attributes
        }
    }

    /// Semantic conventions for RocketMQ spans.
    ///
    /// [OpenTelemetry Spec: RocketMQ](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/messaging.md#apache-rocketmq)
    public struct RocketMQAttributes: SpanAttributeNamespace {
        public var attributes: SpanAttributes

        public init(attributes: SpanAttributes) {
            self.attributes = attributes
        }

        public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
            public init() {}

            /// Namespace of RocketMQ resources, resources in different namespaces are individual. E.g. "myNamespace".
            public var namespace: Key<String> { "messaging.rocketmq.namespace" }

            /// Name of the RocketMQ producer/consumer group that is handling the message. E.g. "myConsumerGroup".
            ///
            /// The client type is identified by the SpanKind.
            public var clientGroup: Key<String> { "messaging.rocketmq.client_group" }

            /// The unique identifier for each client. E.g. "myhost@8742@s8083jm".
            public var clientID: Key<String> { "messaging.rocketmq.client_id" }

            /// Type of message. E.g. ``MessagingAttributes/RocketMQAttributes/MessageType/normal``.
            public var messageType: Key<MessageType> { "messaging.rocketmq.message_type" }

            /// The secondary classifier of message besides topic. E.g. "tagA".
            public var messageTag: Key<String> { "messaging.rocketmq.message_tag" }

            /// Key(s) of message, another way to mark message besides message id. E.g. ["keyA", "keyB"].
            public var messageKeys: Key<[String]> { "messaging.rocketmq.message_keys" }

            /// Model of message consumption. E.g. ``MessagingAttributes/RocketMQAttributes/ConsumptionModel/clustering``.
            ///
            /// - Note: This only applies to consumer spans.
            public var consumptionModel: Key<ConsumptionModel> { "messaging.rocketmq.consumption_model" }
        }

        /// Possible values for the ``MessagingAttributes/RocketMQAttributes/NestedSpanAttributes/messageType`` span attribute.
        public struct MessageType: RawRepresentable, SpanAttributeConvertible {
            public let rawValue: String

            public init(rawValue: String) {
                self.rawValue = rawValue
            }

            /// Normal message.
            public static let normal = MessageType(rawValue: "normal")

            /// FIFO message.
            public static let fifo = MessageType(rawValue: "fifo")

            /// Delay message.
            public static let delay = MessageType(rawValue: "delay")

            /// Transaction message.
            public static let transaction = MessageType(rawValue: "transaction")

            public func toSpanAttribute() -> SpanAttribute {
                .string(self.rawValue)
            }
        }

        /// Possible values for the ``MessagingAttributes/RocketMQAttributes/NestedSpanAttributes/consumptionModel`` span attribute.
        public struct ConsumptionModel: RawRepresentable, SpanAttributeConvertible {
            public let rawValue: String

            public init(rawValue: String) {
                self.rawValue = rawValue
            }

            /// Clustering consumption model.
            public static let clustering = ConsumptionModel(rawValue: "clustering")

            /// Broadcasting consumption model.
            public static let broadcasting = ConsumptionModel(rawValue: "broadcasting")

            public func toSpanAttribute() -> SpanAttribute {
                .string(self.rawValue)
            }
        }
    }
}

// MARK: - Destination Kind

extension MessagingAttributes {
    /// Possible values for the ``MessagingAttributes/NestedSpanAttributes/destinationKind`` span attribute.
    public struct DestinationKind: RawRepresentable, SpanAttributeConvertible {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        /// A message sent to a queue.
        public static let queue = DestinationKind(rawValue: "queue")

        /// A message sent to a topic.
        public static let topic = DestinationKind(rawValue: "topic")

        public func toSpanAttribute() -> SpanAttribute {
            .string(self.rawValue)
        }
    }
}

// MARK: - Operation

extension MessagingAttributes {
    /// Possible values for the ``MessagingAttributes/NestedSpanAttributes/operation`` span attribute.
    ///
    /// - Note: A "send" operation is purposefully not defined,
    /// because in this case ``MessagingAttributes/NestedSpanAttributes/operation`` should not be set at all
    /// as it can be inferred from the span kind.
    ///
    /// OpenTelemetry Spec: [Messaging Operation Names](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/messaging.md#operation-names)
    public struct Operation: RawRepresentable, SpanAttributeConvertible {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        /// A message is received from a destination by a message consumer/server.
        public static let receive = Operation(rawValue: "receive")

        /// A message that was previously received from a destination is processed by a message consumer/server.
        public static let process = Operation(rawValue: "process")

        public func toSpanAttribute() -> SpanAttribute {
            .string(self.rawValue)
        }
    }
}
