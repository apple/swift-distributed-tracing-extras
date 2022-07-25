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
    func test_networkNamespace() {
        var attributes = SpanAttributes()

        attributes.network.transport = .ipTCP
        XCTAssertEqual(attributes["net.transport"]?.toSpanAttribute(), "ip_tcp")

        attributes.network.transport = .ipUDP
        XCTAssertEqual(attributes["net.transport"]?.toSpanAttribute(), "ip_udp")

        attributes.network.transport = .ip
        XCTAssertEqual(attributes["net.transport"]?.toSpanAttribute(), "ip")

        attributes.network.transport = .unix
        XCTAssertEqual(attributes["net.transport"]?.toSpanAttribute(), "unix")

        attributes.network.transport = .pipe
        XCTAssertEqual(attributes["net.transport"]?.toSpanAttribute(), "pipe")

        attributes.network.transport = .inProcess
        XCTAssertEqual(attributes["net.transport"]?.toSpanAttribute(), "inproc")

        attributes.network.transport = .other
        XCTAssertEqual(attributes["net.transport"]?.toSpanAttribute(), "other")

        attributes.network.peer.ip = "127.0.0.1"
        XCTAssertEqual(attributes["net.peer.ip"]?.toSpanAttribute(), "127.0.0.1")

        attributes.network.peer.port = 80
        XCTAssertEqual(attributes["net.peer.port"]?.toSpanAttribute(), 80)

        attributes.network.peer.name = "swift.org"
        XCTAssertEqual(attributes["net.peer.name"]?.toSpanAttribute(), "swift.org")

        attributes.network.host.ip = "127.0.0.1"
        XCTAssertEqual(attributes["net.host.ip"]?.toSpanAttribute(), "127.0.0.1")

        attributes.network.host.port = 35555
        XCTAssertEqual(attributes["net.host.port"]?.toSpanAttribute(), 35555)

        attributes.network.host.name = "localhost"
        XCTAssertEqual(attributes["net.host.name"]?.toSpanAttribute(), "localhost")

        attributes.network.host.connection.type = "wifi"
        XCTAssertEqual(attributes["net.host.connection.type"]?.toSpanAttribute(), "wifi")

        attributes.network.host.connection.subtype = "LTE"
        XCTAssertEqual(attributes["net.host.connection.subtype"]?.toSpanAttribute(), "LTE")

        attributes.network.host.carrier.name = "42"
        XCTAssertEqual(attributes["net.host.carrier.name"]?.toSpanAttribute(), "42")

        attributes.network.host.carrier.mcc = "42"
        XCTAssertEqual(attributes["net.host.carrier.mcc"]?.toSpanAttribute(), "42")

        attributes.network.host.carrier.mnc = "42"
        XCTAssertEqual(attributes["net.host.carrier.mnc"]?.toSpanAttribute(), "42")

        attributes.network.host.carrier.icc = "DE"
        XCTAssertEqual(attributes["net.host.carrier.icc"]?.toSpanAttribute(), "DE")
    }
}
