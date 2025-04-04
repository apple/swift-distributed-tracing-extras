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
import TracingOpenTelemetrySemanticConventions
import XCTest

final class PeerSemanticsTests: XCTestCase {
    func test_peer() {
        var attributes = SpanAttributes()

        attributes.peer.service = "orders"

        XCTAssertSpanAttributesEqual(attributes, ["peer.service": "orders"])
    }
}
