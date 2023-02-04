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
import TracingOpenTelemetrySemanticConventions
import XCTest

final class FaaSSemanticsTests: XCTestCase {
    private var attributes = SpanAttributes()

    override func setUp() {
        self.attributes = [:]
    }

    func test_FaaS() {
        self.attributes.faaS.executionID = "42"
        self.attributes.faaS.isColdStart = true
        self.attributes.faaS.invokedFunction = "my-function"
        self.attributes.faaS.invokedRegion = "eu-central-1"

        XCTAssertSpanAttributesEqual(self.attributes, [
            "faas.execution": "42",
            "faas.coldstart": true,
            "faas.invoked_name": "my-function",
            "faas.invoked_region": "eu-central-1",
        ])
    }

    func test_FaaSTrigger() {
        self.attributes.faaS.trigger = .dataSource
        XCTAssertSpanAttributesEqual(self.attributes, ["faas.trigger": "datasource"])

        self.attributes.faaS.trigger = .http
        XCTAssertSpanAttributesEqual(self.attributes, ["faas.trigger": "http"])

        self.attributes.faaS.trigger = .pubSub
        XCTAssertSpanAttributesEqual(self.attributes, ["faas.trigger": "pubsub"])

        self.attributes.faaS.trigger = .timer
        XCTAssertSpanAttributesEqual(self.attributes, ["faas.trigger": "timer"])

        self.attributes.faaS.trigger = .other
        XCTAssertSpanAttributesEqual(self.attributes, ["faas.trigger": "other"])

        self.attributes.faaS.trigger = .init(rawValue: "future")
        XCTAssertSpanAttributesEqual(self.attributes, ["faas.trigger": "future"])
    }

    func test_FaaSInvokedProvider() {
        self.attributes.faaS.invokedProvider = .alibabaCloud
        XCTAssertSpanAttributesEqual(self.attributes, ["faas.invoked_provider": "alibaba_cloud"])

        self.attributes.faaS.invokedProvider = .aws
        XCTAssertSpanAttributesEqual(self.attributes, ["faas.invoked_provider": "aws"])

        self.attributes.faaS.invokedProvider = .azure
        XCTAssertSpanAttributesEqual(self.attributes, ["faas.invoked_provider": "azure"])

        self.attributes.faaS.invokedProvider = .gpc
        XCTAssertSpanAttributesEqual(self.attributes, ["faas.invoked_provider": "gpc"])

        self.attributes.faaS.invokedProvider = .tencentCloud
        XCTAssertSpanAttributesEqual(self.attributes, ["faas.invoked_provider": "tencent_cloud"])

        self.attributes.faaS.invokedProvider = .init(rawValue: "future")
        XCTAssertSpanAttributesEqual(self.attributes, ["faas.invoked_provider": "future"])
    }

    func test_FaaSDocument() {
        self.attributes.faaS.document.collection = "my-bucket"
        self.attributes.faaS.document.time = "2020-01-23T13:47:06Z"
        self.attributes.faaS.document.name = "42.txt"

        XCTAssertSpanAttributesEqual(self.attributes, [
            "faas.document.collection": "my-bucket",
            "faas.document.time": "2020-01-23T13:47:06Z",
            "faas.document.name": "42.txt",
        ])
    }

    func test_FaaSDocumentOperation() {
        self.attributes.faaS.document.operation = .insert
        XCTAssertSpanAttributesEqual(self.attributes, ["faas.document.operation": "insert"])

        self.attributes.faaS.document.operation = .edit
        XCTAssertSpanAttributesEqual(self.attributes, ["faas.document.operation": "edit"])

        self.attributes.faaS.document.operation = .delete
        XCTAssertSpanAttributesEqual(self.attributes, ["faas.document.operation": "delete"])

        self.attributes.faaS.document.operation = .init(rawValue: "future")
        XCTAssertSpanAttributesEqual(self.attributes, ["faas.document.operation": "future"])
    }

    func test_FaaSTimer() {
        self.attributes.faaS.timer.time = "2020-01-23T13:47:06Z"
        self.attributes.faaS.timer.cron = "0/5 * * * ? *"

        XCTAssertSpanAttributesEqual(self.attributes, [
            "faas.time": "2020-01-23T13:47:06Z",
            "faas.cron": "0/5 * * * ? *",
        ])
    }
}
