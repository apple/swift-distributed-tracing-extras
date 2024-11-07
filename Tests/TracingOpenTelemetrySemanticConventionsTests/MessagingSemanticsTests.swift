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
import XCTest

final class MessagingSemanticsTests: XCTestCase {
    private var attributes = SpanAttributes()

    override func setUp() {
        self.attributes = [:]
    }

    func test_messaging() {
        self.attributes.messaging.system = "kafka"
        self.attributes.messaging.destination = "t1"
        self.attributes.messaging.isTemporaryDestination = true
        self.attributes.messaging.protocol = "AMQP"
        self.attributes.messaging.protocolVersion = "0.9.1"
        self.attributes.messaging.url = "https://queue.amazonaws.com/80398EXAMPLE/MyQueue"
        self.attributes.messaging.messageID = "452a7c7c7c7048c2f887f61572b18fc2"
        self.attributes.messaging.conversationID = "MyConversationId"
        self.attributes.messaging.messagePayloadSizeInBytes = 2738
        self.attributes.messaging.compressedMessagePayloadSizeInBytes = 2048
        self.attributes.messaging.consumerID = "g1-c1"

        XCTAssertSpanAttributesEqual(self.attributes, [
            "messaging.system": "kafka",
            "messaging.destination": "t1",
            "messaging.temp_destination": true,
            "messaging.protocol": "AMQP",
            "messaging.protocol_version": "0.9.1",
            "messaging.url": "https://queue.amazonaws.com/80398EXAMPLE/MyQueue",
            "messaging.message_id": "452a7c7c7c7048c2f887f61572b18fc2",
            "messaging.conversation_id": "MyConversationId",
            "messaging.message_payload_size_bytes": 2738,
            "messaging.message_payload_compressed_size_bytes": 2048,
            "messaging.consumer_id": "g1-c1",
        ])
    }

    func test_destinationKind() {
        self.attributes.messaging.destinationKind = .queue
        XCTAssertSpanAttributesEqual(self.attributes, ["messaging.destination_kind": "queue"])

        self.attributes.messaging.destinationKind = .topic
        XCTAssertSpanAttributesEqual(self.attributes, ["messaging.destination_kind": "topic"])

        self.attributes.messaging.destinationKind = .init(rawValue: "future")
        XCTAssertSpanAttributesEqual(self.attributes, ["messaging.destination_kind": "future"])
    }

    func test_operation() {
        self.attributes.messaging.operation = .receive
        XCTAssertSpanAttributesEqual(self.attributes, ["messaging.operation": "receive"])

        self.attributes.messaging.operation = .process
        XCTAssertSpanAttributesEqual(self.attributes, ["messaging.operation": "process"])

        self.attributes.messaging.operation = .init(rawValue: "future")
        XCTAssertSpanAttributesEqual(self.attributes, ["messaging.operation": "future"])
    }

    func test_rabbitMQ() {
        self.attributes.messaging.rabbitMQ.routingKey = "myKey"

        XCTAssertSpanAttributesEqual(self.attributes, ["messaging.rabbitmq.routing_key": "myKey"])
    }

    func test_Kafka() {
        self.attributes.messaging.kafka.messageKey = "myKey"
        self.attributes.messaging.kafka.consumerGroup = "my-group"
        self.attributes.messaging.kafka.clientID = "client-5"
        self.attributes.messaging.kafka.partition = 2
        self.attributes.messaging.kafka.isTombstone = true

        XCTAssertSpanAttributesEqual(self.attributes, [
            "messaging.kafka.message_key": "myKey",
            "messaging.kafka.consumer_group": "my-group",
            "messaging.kafka.client_id": "client-5",
            "messaging.kafka.partition": 2,
            "messaging.kafka.tombstone": true,
        ])
    }

    func test_rocketMQ() {
        self.attributes.messaging.rocketMQ.namespace = "myNamespace"
        self.attributes.messaging.rocketMQ.clientGroup = "myConsumerGroup"
        self.attributes.messaging.rocketMQ.clientID = "myhost@8742@s8083jm"
        self.attributes.messaging.rocketMQ.messageTag = "tagA"
        self.attributes.messaging.rocketMQ.messageKeys = ["keyA", "keyB"]

        XCTAssertSpanAttributesEqual(self.attributes, [
            "messaging.rocketmq.namespace": "myNamespace",
            "messaging.rocketmq.client_group": "myConsumerGroup",
            "messaging.rocketmq.client_id": "myhost@8742@s8083jm",
            "messaging.rocketmq.message_tag": "tagA",
            "messaging.rocketmq.message_keys": .stringArray(["keyA", "keyB"]),
        ])
    }

    func test_rocketMQMessageType() {
        self.attributes.messaging.rocketMQ.messageType = .normal
        XCTAssertSpanAttributesEqual(self.attributes, ["messaging.rocketmq.message_type": "normal"])

        self.attributes.messaging.rocketMQ.messageType = .fifo
        XCTAssertSpanAttributesEqual(self.attributes, ["messaging.rocketmq.message_type": "fifo"])

        self.attributes.messaging.rocketMQ.messageType = .delay
        XCTAssertSpanAttributesEqual(self.attributes, ["messaging.rocketmq.message_type": "delay"])

        self.attributes.messaging.rocketMQ.messageType = .transaction
        XCTAssertSpanAttributesEqual(self.attributes, ["messaging.rocketmq.message_type": "transaction"])
    }

    func test_rocketMQConsumptionModel() {
        self.attributes.messaging.rocketMQ.consumptionModel = .clustering
        XCTAssertSpanAttributesEqual(self.attributes, ["messaging.rocketmq.consumption_model": "clustering"])

        self.attributes.messaging.rocketMQ.consumptionModel = .broadcasting
        XCTAssertSpanAttributesEqual(self.attributes, ["messaging.rocketmq.consumption_model": "broadcasting"])

        self.attributes.messaging.rocketMQ.consumptionModel = .init(rawValue: "future")
        XCTAssertSpanAttributesEqual(self.attributes, ["messaging.rocketmq.consumption_model": "future"])
    }
}
