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

final class EndUserSemanticsTests: XCTestCase {
    func test_endUser() {
        var attributes = SpanAttributes()

        attributes.endUser.id = "swift"
        attributes.endUser.role = "admin"
        attributes.endUser.scope = "write:code"

        XCTAssertSpanAttributesEqual(attributes, [
            "enduser.id": "swift",
            "enduser.role": "admin",
            "enduser.scope": "write:code",
        ])
    }
}
