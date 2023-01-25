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
import TracingOpenTelemetrySemanticConventions
import XCTest

final class NetworkSemanticsTests: XCTestCase {
    private var attributes = SpanAttributes()

    override func setUp() {
        attributes = [:]
    }

    func test_networkTransport() {
        attributes.network.transport = .ipTCP
        XCTAssertSpanAttributesEqual(attributes, ["net.transport": "ip_tcp"])

        attributes.network.transport = .ipUDP
        XCTAssertSpanAttributesEqual(attributes, ["net.transport": "ip_udp"])

        attributes.network.transport = .ip
        XCTAssertSpanAttributesEqual(attributes, ["net.transport": "ip"])

        attributes.network.transport = .unix
        XCTAssertSpanAttributesEqual(attributes, ["net.transport": "unix"])

        attributes.network.transport = .pipe
        XCTAssertSpanAttributesEqual(attributes, ["net.transport": "pipe"])

        attributes.network.transport = .inProcess
        XCTAssertSpanAttributesEqual(attributes, ["net.transport": "inproc"])

        attributes.network.transport = .other
        XCTAssertSpanAttributesEqual(attributes, ["net.transport": "other"])

        attributes.network.transport = .init(rawValue: "custom")
        XCTAssertSpanAttributesEqual(attributes, ["net.transport": "custom"])
    }

    func test_networkPeer() {
        attributes.network.peer.ip = "127.0.0.1"
        attributes.network.peer.port = 35555
        attributes.network.peer.name = "swift.org"

        XCTAssertSpanAttributesEqual(attributes, [
            "net.peer.ip": "127.0.0.1",
            "net.peer.port": 35555,
            "net.peer.name": "swift.org",
        ])
    }

    func test_networkHost() {
        attributes.network.host.ip = "127.0.0.1"
        attributes.network.host.port = 80
        attributes.network.host.name = "localhost"
        attributes.network.host.connection.type = "wifi"
        attributes.network.host.connection.subtype = "LTE"
        attributes.network.host.carrier.name = "42"
        attributes.network.host.carrier.mcc = "42"
        attributes.network.host.carrier.mnc = "42"
        attributes.network.host.carrier.icc = "DE"

        XCTAssertSpanAttributesEqual(attributes, [
            "net.host.ip": "127.0.0.1",
            "net.host.port": 80,
            "net.host.name": "localhost",
            "net.host.connection.type": "wifi",
            "net.host.connection.subtype": "LTE",
            "net.host.carrier.name": "42",
            "net.host.carrier.mcc": "42",
            "net.host.carrier.mnc": "42",
            "net.host.carrier.icc": "DE",
        ])
    }
}
