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

final class URLSemanticsTests: XCTestCase {
    func test_peer() {
        var attributes = SpanAttributes()

        attributes.url.domain = "www.foo.bar"
        attributes.url.`extension` = "png"
        attributes.url.fragment = "SemConv"
        attributes.url.full = "https://www.foo.bar/search?q=OpenTelemetry#SemConv"
        attributes.url.original = "https://www.foo.bar/search?q=OpenTelemetry#SemConv"
        attributes.url.path = "/search"
        attributes.url.port = 443
        attributes.url.query = "q=OpenTelemetry"
        attributes.url.registeredDomain = "example.com"
        attributes.url.scheme = "https"
        attributes.url.subdomain = "east"
        attributes.url.template = "/users/{id}"
        attributes.url.topLevelDomain = "co.uk"

        XCTAssertSpanAttributesEqual(attributes, [
            "url.domain": "www.foo.bar",
            "url.extension": "png",
            "url.fragment": "SemConv",
            "url.full": "https://www.foo.bar/search?q=OpenTelemetry#SemConv",
            "url.original": "https://www.foo.bar/search?q=OpenTelemetry#SemConv",
            "url.path": "/search",
            "url.port": 443,
            "url.query": "q=OpenTelemetry",
            "url.registered_domain": "example.com",
            "url.scheme": "https",
            "url.subdomain": "east",
            "url.template": "/users/{id}",
            "url.top_level_domain": "co.uk",
        ])
    }
}
