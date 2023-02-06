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
@testable import TracingOpenTelemetrySemanticConventions
import XCTest

final class RPCSemanticsTests: XCTestCase {
    private var attributes = SpanAttributes()

    override func setUp() {
        self.attributes = [:]
    }

    func test_RPC() {
        self.attributes.rpc.service = "myservice.EchoService"
        self.attributes.rpc.method = "exampleMethod"

        XCTAssertSpanAttributesEqual(self.attributes, [
            "rpc.service": "myservice.EchoService",
            "rpc.method": "exampleMethod",
        ])
    }

    func test_RPCSystem() {
        self.attributes.rpc.system = .gRPC
        XCTAssertSpanAttributesEqual(self.attributes, ["rpc.system": "grpc"])

        self.attributes.rpc.system = .jsonRPC
        XCTAssertSpanAttributesEqual(self.attributes, ["rpc.system": "jsonrpc"])

        self.attributes.rpc.system = .javaRMI
        XCTAssertSpanAttributesEqual(self.attributes, ["rpc.system": "java_rmi"])

        self.attributes.rpc.system = .dotnetWCF
        XCTAssertSpanAttributesEqual(self.attributes, ["rpc.system": "dotnet_wcf"])

        self.attributes.rpc.system = .apacheDubbo
        XCTAssertSpanAttributesEqual(self.attributes, ["rpc.system": "apache_dubbo"])
    }

    func test_RPCMessage() {
        self.attributes.rpc.message.id = 42
        self.attributes.rpc.message.compressedSizeInBytes = 21
        self.attributes.rpc.message.uncompressedSizeInBytes = 42

        XCTAssertSpanAttributesEqual(self.attributes, [
            "message.id": 42,
            "message.compressed_size": 21,
            "message.uncompressed_size": 42,
        ])
    }

    func test_RPCMessageType() {
        self.attributes.rpc.message.type = .sent
        XCTAssertSpanAttributesEqual(self.attributes, ["message.type": "SENT"])

        self.attributes.rpc.message.type = .received
        XCTAssertSpanAttributesEqual(self.attributes, ["message.type": "RECEIVED"])
    }

    func test_gRPC() {
        self.attributes.rpc.gRPC.statusCode = .ok
        XCTAssertSpanAttributesEqual(self.attributes, ["rpc.grpc.status_code": 0])

        self.attributes.rpc.gRPC.statusCode = .cancelled
        XCTAssertSpanAttributesEqual(self.attributes, ["rpc.grpc.status_code": 1])

        self.attributes.rpc.gRPC.statusCode = .unknown
        XCTAssertSpanAttributesEqual(self.attributes, ["rpc.grpc.status_code": 2])

        self.attributes.rpc.gRPC.statusCode = .invalidArgument
        XCTAssertSpanAttributesEqual(self.attributes, ["rpc.grpc.status_code": 3])

        self.attributes.rpc.gRPC.statusCode = .deadlineExceeded
        XCTAssertSpanAttributesEqual(self.attributes, ["rpc.grpc.status_code": 4])

        self.attributes.rpc.gRPC.statusCode = .notFound
        XCTAssertSpanAttributesEqual(self.attributes, ["rpc.grpc.status_code": 5])

        self.attributes.rpc.gRPC.statusCode = .alreadyExists
        XCTAssertSpanAttributesEqual(self.attributes, ["rpc.grpc.status_code": 6])

        self.attributes.rpc.gRPC.statusCode = .permissionDenied
        XCTAssertSpanAttributesEqual(self.attributes, ["rpc.grpc.status_code": 7])

        self.attributes.rpc.gRPC.statusCode = .resourceExhausted
        XCTAssertSpanAttributesEqual(self.attributes, ["rpc.grpc.status_code": 8])

        self.attributes.rpc.gRPC.statusCode = .failedPrecondition
        XCTAssertSpanAttributesEqual(self.attributes, ["rpc.grpc.status_code": 9])

        self.attributes.rpc.gRPC.statusCode = .aborted
        XCTAssertSpanAttributesEqual(self.attributes, ["rpc.grpc.status_code": 10])

        self.attributes.rpc.gRPC.statusCode = .outOfRange
        XCTAssertSpanAttributesEqual(self.attributes, ["rpc.grpc.status_code": 11])

        self.attributes.rpc.gRPC.statusCode = .unimplemented
        XCTAssertSpanAttributesEqual(self.attributes, ["rpc.grpc.status_code": 12])

        self.attributes.rpc.gRPC.statusCode = .internal
        XCTAssertSpanAttributesEqual(self.attributes, ["rpc.grpc.status_code": 13])

        self.attributes.rpc.gRPC.statusCode = .unavailable
        XCTAssertSpanAttributesEqual(self.attributes, ["rpc.grpc.status_code": 14])

        self.attributes.rpc.gRPC.statusCode = .dataLoss
        XCTAssertSpanAttributesEqual(self.attributes, ["rpc.grpc.status_code": 15])

        self.attributes.rpc.gRPC.statusCode = .unauthenticated
        XCTAssertSpanAttributesEqual(self.attributes, ["rpc.grpc.status_code": 16])
    }

    func test_JSONRPC() {
        self.attributes.rpc.jsonRPC.version = "2.0"
        self.attributes.rpc.jsonRPC.requestID = "42"
        self.attributes.rpc.jsonRPC.errorCode = 42
        self.attributes.rpc.jsonRPC.errorMessage = "Parse error"

        XCTAssertSpanAttributesEqual(self.attributes, [
            "rpc.jsonrpc.version": "2.0",
            "rpc.jsonrpc.request_id": "42",
            "rpc.jsonrpc.error_code": 42,
            "rpc.jsonrpc.error_message": "Parse error",
        ])
    }
}
