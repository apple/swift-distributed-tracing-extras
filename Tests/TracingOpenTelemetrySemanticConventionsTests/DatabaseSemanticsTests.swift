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
import TracingOpenTelemetrySemanticConventions
import XCTest

final class DatabaseSemanticsTests: XCTestCase {
    private var attributes = SpanAttributes()

    override func setUp() {
        attributes = [:]
    }

    func test_database() {
        attributes.db.system = "postgresql"
        attributes.db.connectionString = "test"
        attributes.db.user = "swift"
        attributes.db.name = "languages"
        attributes.db.statement = "SELECT version();"
        attributes.db.operation = "findAndModify"

        XCTAssertSpanAttributesEqual(attributes, [
            "db.system": "postgresql",
            "db.connection_string": "test",
            "db.user": "swift",
            "db.name": "languages",
            "db.statement": "SELECT version();",
            "db.operation": "findAndModify",
        ])
    }

    func test_MSSQL() {
        attributes.db.mssql.instanceName = "test"
        XCTAssertSpanAttributesEqual(attributes, ["db.mssql.instance_name": "test"])
    }

    func test_redis() {
        attributes.db.redis.databaseIndex = 42
        XCTAssertSpanAttributesEqual(attributes, ["db.redis.database_index": 42])
    }

    func test_mongoDB() {
        attributes.db.mongoDB.collection = "languages"
        XCTAssertSpanAttributesEqual(attributes, ["db.mongodb.collection": "languages"])
    }

    func test_SQL() {
        attributes.db.sql.table = "languages"
        XCTAssertSpanAttributesEqual(attributes, ["db.sql.table": "languages"])
    }

    func test_cassandra() {
        attributes.db.cassandra.pageSize = 42
        attributes.db.cassandra.consistencyLevel = "all"
        attributes.db.cassandra.table = "languages"
        attributes.db.cassandra.idempotence = true
        attributes.db.cassandra.speculativeExecutionCount = 42
        attributes.db.cassandra.coordinatorID = "test"
        attributes.db.cassandra.coordinatorDataCenter = "test"

        XCTAssertSpanAttributesEqual(attributes, [
            "db.cassandra.page_size": 42,
            "db.cassandra.consistency_level": "all",
            "db.cassandra.table": "languages",
            "db.cassandra.idempotence": true,
            "db.cassandra.speculative_execution_count": 42,
            "db.cassandra.coordinator.id": "test",
            "db.cassandra.coordinator.dc": "test",
        ])
    }
}
