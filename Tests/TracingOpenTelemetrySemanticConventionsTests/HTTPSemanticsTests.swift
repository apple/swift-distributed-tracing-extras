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
    func test_httpNamespace() {
        var attributes = SpanAttributes()

        attributes.http.method = "GET"
        XCTAssertEqual(attributes["http.method"]?.toSpanAttribute(), "GET")

        attributes.http.url = "https://www.swift.org/download"
        XCTAssertEqual(attributes["http.url"]?.toSpanAttribute(), "https://www.swift.org/download")

        attributes.http.target = "/download"
        XCTAssertEqual(attributes["http.target"]?.toSpanAttribute(), "/download")

        attributes.http.host = "www.swift.org"
        XCTAssertEqual(attributes["http.host"]?.toSpanAttribute(), "www.swift.org")

        attributes.http.scheme = "https"
        XCTAssertEqual(attributes["http.scheme"]?.toSpanAttribute(), "https")

        attributes.http.statusCode = 418
        XCTAssertEqual(attributes["http.status_code"]?.toSpanAttribute(), 418)

        attributes.http.flavor = "1.1"
        XCTAssertEqual(attributes["http.flavor"]?.toSpanAttribute(), "1.1")

        attributes.http.userAgent = "test"
        XCTAssertEqual(attributes["http.user_agent"]?.toSpanAttribute(), "test")

        attributes.http.retryCount = 42
        XCTAssertEqual(attributes.http.retryCount?.toSpanAttribute(), 42)
    }

    func test_httpRequestNamespace() {
        var attributes = SpanAttributes()

        attributes.http.request.contentLength = 42
        XCTAssertEqual(attributes["http.request_content_length"]?.toSpanAttribute(), 42)

        attributes.http.request.uncompressedContentLength = 84
        XCTAssertEqual(attributes["http.request_content_length_uncompressed"]?.toSpanAttribute(), 84)

        attributes.http.request.headers.contentType = ["application/json"]
        XCTAssertEqual(attributes.http.request.headers.contentType, ["application/json"])
        XCTAssertEqual(
            attributes["http.request.header.content_type"]?.toSpanAttribute(),
            .stringArray(["application/json"])
        )
    }

    func test_httpResponseNamespace() {
        var attributes = SpanAttributes()

        attributes.http.response.contentLength = 42
        XCTAssertEqual(attributes["http.response_content_length"]?.toSpanAttribute(), 42)

        attributes.http.response.uncompressedContentLength = 84
        XCTAssertEqual(attributes["http.response_content_length_uncompressed"]?.toSpanAttribute(), 84)

        attributes.http.response.headers.connection = ["keep-alive"]
        XCTAssertEqual(attributes.http.request.headers.connection, ["keep-alive"])
        XCTAssertEqual(
            attributes["http.request.header.connection"]?.toSpanAttribute(),
            .stringArray(["keep-alive"])
        )
    }

    func test_httpServerNamespace() {
        var attributes = SpanAttributes()

        attributes.http.server.name = "Swift"
        XCTAssertEqual(attributes["http.server_name"]?.toSpanAttribute(), "Swift")

        attributes.http.server.route = "/blog/:slug"
        XCTAssertEqual(attributes["http.route"]?.toSpanAttribute(), "/blog/:slug")

        attributes.http.server.clientIP = "127.0.0.1"
        XCTAssertEqual(attributes["http.client_ip"]?.toSpanAttribute(), "127.0.0.1")
    }

    func test_httpHeaderAttributes_returnsNilIfHeaderNotFound() {
        let headers = HTTPAttributes.HeaderAttributes(attributes: [:], group: "test")

        XCTAssertNil(headers.test)
    }

    func test_httpHeaderAttributes_canStoreMultipleValuesPerHeader() {
        let headers = HTTPAttributes.HeaderAttributes(
            attributes: ["http.test.header.test": .stringArray(["a", "b", "c"])],
            group: "test"
        )

        XCTAssertEqual(headers.test, ["a", "b", "c"])
    }

    func test_httpHeaderAttributes_transformsCamelCaseIntoSnakeCase() {
        var headers = HTTPAttributes.HeaderAttributes(attributes: [:], group: "test")

        headers.testHeader = ["test"]
        XCTAssertEqual(
            headers.attributes["http.test.header.test_header"]?.toSpanAttribute(),
            .stringArray(["test"])
        )
    }

    func test_httpHeaderAttributes_normalizedKeyRespectsAllCapsWords() {
        var header = HTTPAttributes.HeaderAttributes(attributes: [:], group: "test")

        header.xTraceID = ["42"]
        XCTAssertEqual(
            header.attributes["http.test.header.x_trace_id"]?.toSpanAttribute(),
            .stringArray(["42"])
        )
    }

    func test_httpHeaderAttributes_normalizedKeyReplacesHyphonsWithUnderscores() {
        var headers = HTTPAttributes.HeaderAttributes(attributes: [:], group: "test")

        headers.setValues(["test"], forHeader: "X-Trace-Id")
        XCTAssertEqual(
            headers.attributes["http.test.header.x_trace_id"]?.toSpanAttribute(),
            .stringArray(["test"])
        )
    }
}
