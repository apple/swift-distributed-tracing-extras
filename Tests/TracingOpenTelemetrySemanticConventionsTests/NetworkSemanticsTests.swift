//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Distributed Tracing open source project
//
// Copyright (c) 2022 Apple Inc. and the Swift Distributed Tracing project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of Swift Distributed Tracing project authors
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
        self.attributes = [:]
    }

    func test_networkTransport() {
        self.attributes.network.transport = .ipTCP
        XCTAssertSpanAttributesEqual(self.attributes, ["net.transport": "ip_tcp"])

        self.attributes.network.transport = .ipUDP
        XCTAssertSpanAttributesEqual(self.attributes, ["net.transport": "ip_udp"])

        self.attributes.network.transport = .ip
        XCTAssertSpanAttributesEqual(self.attributes, ["net.transport": "ip"])

        self.attributes.network.transport = .unix
        XCTAssertSpanAttributesEqual(self.attributes, ["net.transport": "unix"])

        self.attributes.network.transport = .pipe
        XCTAssertSpanAttributesEqual(self.attributes, ["net.transport": "pipe"])

        self.attributes.network.transport = .inProcess
        XCTAssertSpanAttributesEqual(self.attributes, ["net.transport": "inproc"])

        self.attributes.network.transport = .other
        XCTAssertSpanAttributesEqual(self.attributes, ["net.transport": "other"])

        self.attributes.network.transport = .init(rawValue: "custom")
        XCTAssertSpanAttributesEqual(self.attributes, ["net.transport": "custom"])
    }

    func test_networkPeer() {
        self.attributes.network.peer.ip = "127.0.0.1"
        self.attributes.network.peer.port = 35555
        self.attributes.network.peer.name = "swift.org"

        XCTAssertSpanAttributesEqual(self.attributes, [
            "net.peer.ip": "127.0.0.1",
            "net.peer.port": 35555,
            "net.peer.name": "swift.org",
        ])
    }

    func test_networkHost() {
        self.attributes.network.host.ip = "127.0.0.1"
        self.attributes.network.host.port = 80
        self.attributes.network.host.name = "localhost"
        self.attributes.network.host.connection.type = "wifi"
        self.attributes.network.host.connection.subtype = "LTE"
        self.attributes.network.host.carrier.name = "42"
        self.attributes.network.host.carrier.mcc = "42"
        self.attributes.network.host.carrier.mnc = "42"
        self.attributes.network.host.carrier.icc = "DE"

        XCTAssertSpanAttributesEqual(self.attributes, [
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
