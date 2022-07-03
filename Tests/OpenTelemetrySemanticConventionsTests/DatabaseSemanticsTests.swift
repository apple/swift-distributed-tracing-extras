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

@testable import OpenTelemetrySemanticConventions
import Tracing
import XCTest

final class DatabaseSemanticsTests: XCTestCase {
    func test_databaseNamespace() {
        var attributes = SpanAttributes()

        attributes.db.system = "postgresql"
        XCTAssertEqual(attributes["db.system"]?.toSpanAttribute(), "postgresql")

        attributes.db.connectionString = "test"
        XCTAssertEqual(attributes["db.connection_string"]?.toSpanAttribute(), "test")

        attributes.db.user = "swift"
        XCTAssertEqual(attributes["db.user"]?.toSpanAttribute(), "swift")

        attributes.db.name = "languages"
        XCTAssertEqual(attributes["db.name"]?.toSpanAttribute(), "languages")

        attributes.db.statement = "SELECT version();"
        XCTAssertEqual(attributes["db.statement"]?.toSpanAttribute(), "SELECT version();")

        attributes.db.operation = "findAndModify";
        XCTAssertEqual(attributes["db.operation"]?.toSpanAttribute(), "findAndModify")
    }

    func test_MSSQLNamespace() {
        var attributes = SpanAttributes()

        attributes.db.mssql.instanceName = "test"
        XCTAssertEqual(attributes["db.mssql.instance_name"]?.toSpanAttribute(), "test")
    }

    func test_redisNamespace() {
        var attributes = SpanAttributes()

        attributes.db.redis.databaseIndex = 42
        XCTAssertEqual(attributes["db.redis.database_index"]?.toSpanAttribute(), 42)
    }

    func test_mongoDBNamespace() {
        var attributes = SpanAttributes()

        attributes.db.mongoDB.collection = "languages"
        XCTAssertEqual(attributes["db.mongodb.collection"]?.toSpanAttribute(), "languages")
    }

    func test_sqlNamespace() {
        var attributes = SpanAttributes()

        attributes.db.sql.table = "languages"
        XCTAssertEqual(attributes["db.sql.table"]?.toSpanAttribute(), "languages")
    }

    func test_cassandraNamespace() {
        var attributes = SpanAttributes()

        attributes.db.cassandra.pageSize = 42
        XCTAssertEqual(attributes["db.cassandra.page_size"]?.toSpanAttribute(), 42)

        attributes.db.cassandra.consistencyLevel = "all"
        XCTAssertEqual(attributes["db.cassandra.consistency_level"]?.toSpanAttribute(), "all")

        attributes.db.cassandra.table = "languages"
        XCTAssertEqual(attributes["db.cassandra.table"]?.toSpanAttribute(), "languages")

        attributes.db.cassandra.idempotence = true
        XCTAssertEqual(attributes["db.cassandra.idempotence"]?.toSpanAttribute(), true)

        attributes.db.cassandra.speculativeExecutionCount = 42
        XCTAssertEqual(attributes["db.cassandra.speculative_execution_count"]?.toSpanAttribute(), 42)

        attributes.db.cassandra.coordinatorID = "test"
        XCTAssertEqual(attributes["db.cassandra.coordinator.id"]?.toSpanAttribute(), "test")

        attributes.db.cassandra.coordinatorDataCenter = "test"
        XCTAssertEqual(attributes["db.cassandra.coordinator.dc"]?.toSpanAttribute(), "test")
    }
}
