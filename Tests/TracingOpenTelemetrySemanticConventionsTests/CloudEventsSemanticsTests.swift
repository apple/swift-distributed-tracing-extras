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

final class CloudEventsSemanticsTests: XCTestCase {
    func test_cloudEvents() {
        var attributes = SpanAttributes()

        attributes.cloudEvents.eventID = "42"
        attributes.cloudEvents.eventSource = "test"
        attributes.cloudEvents.eventSpecVersion = "1.0"
        attributes.cloudEvents.eventType = "favorite_language_selected"
        attributes.cloudEvents.eventSubject = "swift"

        XCTAssertSpanAttributesEqual(attributes, [
            "cloudevents.event_id": "42",
            "cloudevents.event_source": "test",
            "cloudevents.event_spec_version": "1.0",
            "cloudevents.event_type": "favorite_language_selected",
            "cloudevents.event_subject": "swift",
        ])
    }
}
