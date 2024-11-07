//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Distributed Tracing open source project
//
// Copyright (c) 2022 Apple Inc. and the Swift Distributed Tracing project authors
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

final class DatabaseSemanticsTests: XCTestCase {
    private var attributes = SpanAttributes()

    override func setUp() {
        self.attributes = [:]
    }

    func test_database() {
        self.attributes.db.system = "postgresql"
        self.attributes.db.connectionString = "test"
        self.attributes.db.user = "swift"
        self.attributes.db.name = "languages"
        self.attributes.db.statement = "SELECT version();"
        self.attributes.db.operation = "findAndModify"

        XCTAssertSpanAttributesEqual(self.attributes, [
            "db.system": "postgresql",
            "db.connection_string": "test",
            "db.user": "swift",
            "db.name": "languages",
            "db.statement": "SELECT version();",
            "db.operation": "findAndModify",
        ])
    }

    func test_MSSQL() {
        self.attributes.db.mssql.instanceName = "test"
        XCTAssertSpanAttributesEqual(self.attributes, ["db.mssql.instance_name": "test"])
    }

    func test_redis() {
        self.attributes.db.redis.databaseIndex = 42
        XCTAssertSpanAttributesEqual(self.attributes, ["db.redis.database_index": 42])
    }

    func test_mongoDB() {
        self.attributes.db.mongoDB.collection = "languages"
        XCTAssertSpanAttributesEqual(self.attributes, ["db.mongodb.collection": "languages"])
    }

    func test_SQL() {
        self.attributes.db.sql.table = "languages"
        XCTAssertSpanAttributesEqual(self.attributes, ["db.sql.table": "languages"])
    }

    func test_cassandra() {
        self.attributes.db.cassandra.pageSize = 42
        self.attributes.db.cassandra.consistencyLevel = "all"
        self.attributes.db.cassandra.table = "languages"
        self.attributes.db.cassandra.idempotence = true
        self.attributes.db.cassandra.speculativeExecutionCount = 42
        self.attributes.db.cassandra.coordinatorID = "test"
        self.attributes.db.cassandra.coordinatorDataCenter = "test"

        XCTAssertSpanAttributesEqual(self.attributes, [
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
