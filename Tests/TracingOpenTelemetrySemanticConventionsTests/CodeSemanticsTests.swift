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

final class CodeSemanticsTests: XCTestCase {
    func test_code() {
        var attributes = SpanAttributes()

        let line: Int64 = #line

        attributes.code.function = #function
        attributes.code.namespace = "Tracing"
        attributes.code.filePath = #filePath
        attributes.code.lineNumber = line

        XCTAssertSpanAttributesEqual(attributes, [
            "code.function": #function,
            "code.namespace": "Tracing",
            "code.filepath": #filePath,
            "code.lineno": .int64(Int64(line)),
        ])
    }
}
