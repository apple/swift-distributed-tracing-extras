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
        self.attributes = [:]
    }

    func test_HTTP() {
        self.attributes.http.method = "GET"
        self.attributes.http.url = "https://www.swift.org/download"
        self.attributes.http.target = "/download"
        self.attributes.http.host = "www.swift.org"
        self.attributes.http.scheme = "https"
        self.attributes.http.statusCode = 418
        self.attributes.http.flavor = "1.1"
        self.attributes.http.userAgent = "test"
        self.attributes.http.retryCount = 42

        XCTAssertSpanAttributesEqual(self.attributes, [
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
        self.attributes.http.request.contentLength = 42
        self.attributes.http.request.uncompressedContentLength = 84
        self.attributes.http.request.headers.setValues(["application/json"], forHeader: "Content-Type")
        self.attributes.http.request.headers.setValues(["text/plain", "application/json"], forHeader: "accept")

        XCTAssertSpanAttributesEqual(self.attributes, [
            "http.request_content_length": 42,
            "http.request_content_length_uncompressed": 84,
            "http.request.header.content_type": "application/json",
            "http.request.header.accept": .stringArray(["text/plain", "application/json"]),
        ])
    }

    func test_HTTPResponse() {
        self.attributes.http.response.contentLength = 42
        self.attributes.http.response.uncompressedContentLength = 84
        self.attributes.http.response.headers.setValues(["keep-alive"], forHeader: "connection")
        self.attributes.http.response.headers.setValues(
            ["max-age=0", "private", "must-revalidate"],
            forHeader: "cache-control"
        )

        XCTAssertSpanAttributesEqual(self.attributes, [
            "http.response_content_length": 42,
            "http.response_content_length_uncompressed": 84,
            "http.response.header.connection": "keep-alive",
            "http.response.header.cache_control": .stringArray(["max-age=0", "private", "must-revalidate"]),
        ])
    }

    func test_server() {
        self.attributes.http.server.name = "Swift"
        self.attributes.http.server.route = "/blog/:slug"
        self.attributes.http.server.clientIP = "127.0.0.1"

        XCTAssertSpanAttributesEqual(self.attributes, [
            "http.server_name": "Swift",
            "http.route": "/blog/:slug",
            "http.client_ip": "127.0.0.1",
        ])
    }
}
