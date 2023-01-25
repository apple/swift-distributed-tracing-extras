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

final class HTTPSemanticsTests: XCTestCase {
    private var attributes = SpanAttributes()

    override func setUp() {
        attributes = [:]
    }

    func test_HTTP() {
        attributes.http.method = "GET"
        attributes.http.url = "https://www.swift.org/download"
        attributes.http.target = "/download"
        attributes.http.host = "www.swift.org"
        attributes.http.scheme = "https"
        attributes.http.statusCode = 418
        attributes.http.flavor = "1.1"
        attributes.http.userAgent = "test"
        attributes.http.retryCount = 42

        XCTAssertSpanAttributesEqual(attributes, [
            "http.method": "GET",
            "http.url": "https://www.swift.org/download",
            "http.target": "/download",
            "http.host": "www.swift.org",
            "http.scheme": "https",
            "http.status_code": 418,
            "http.flavor": "1.1",
            "http.user_agent": "test",
            "http.retry_count": 42,
        ])
    }

    func test_HTTPRequest() {
        attributes.http.request.contentLength = 42
        attributes.http.request.uncompressedContentLength = 84
        attributes.http.request.headers.setValues(["application/json"], forHeader: "Content-Type")
        attributes.http.request.headers.setValues(["text/plain", "application/json"], forHeader: "accept")

        XCTAssertSpanAttributesEqual(attributes, [
            "http.request_content_length": 42,
            "http.request_content_length_uncompressed": 84,
            "http.request.header.content_type": "application/json",
            "http.request.header.accept": .stringArray(["text/plain", "application/json"]),
        ])
    }

    func test_HTTPResponse() {
        attributes.http.response.contentLength = 42
        attributes.http.response.uncompressedContentLength = 84
        attributes.http.response.headers.setValues(["keep-alive"], forHeader: "connection")
        attributes.http.response.headers.setValues(
            ["max-age=0", "private", "must-revalidate"],
            forHeader: "cache-control"
        )

        XCTAssertSpanAttributesEqual(attributes, [
            "http.response_content_length": 42,
            "http.response_content_length_uncompressed": 84,
            "http.response.header.connection": "keep-alive",
            "http.response.header.cache_control": .stringArray(["max-age=0", "private", "must-revalidate"]),
        ])
    }

    func test_server() {
        attributes.http.server.name = "Swift"
        attributes.http.server.route = "/blog/:slug"
        attributes.http.server.clientIP = "127.0.0.1"

        XCTAssertSpanAttributesEqual(attributes, [
            "http.server_name": "Swift",
            "http.route": "/blog/:slug",
            "http.client_ip": "127.0.0.1",
        ])
    }
}
