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
@testable import TracingOpenTelemetrySemanticConventions
import XCTest

final class ErrorSemanticsTests: XCTestCase {
    func test_error() {
        var attributes = SpanAttributes()

        attributes.error.type = "AuthenticationError"
        attributes.error.message = "The provided token already expired."
        attributes.error.stacktrace = "test"
        attributes.error.escaped = true

        XCTAssertSpanAttributesEqual(attributes, [
            "exception.type": "AuthenticationError",
            "exception.message": "The provided token already expired.",
            "exception.stacktrace": "test",
            "exception.escaped": true,
        ])
    }
}
