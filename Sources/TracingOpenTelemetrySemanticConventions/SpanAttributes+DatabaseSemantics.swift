//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Distributed Tracing open source project
//
// Copyright (c) 2022-2023 Apple Inc. and the Swift Distributed Tracing project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of Swift Distributed Tracing project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import Tracing

extension SpanAttributes {
    /// Semantic conventions for database client calls.
    ///
    /// OpenTelemetry Spec: [Semantic conventions for database client calls](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/database.md)
    public var db: DatabaseAttributes {
        get {
            .init(attributes: self)
        }
        set {
            self = newValue.attributes
        }
    }
}

/// Semantic conventions for database client calls.
///
/// OpenTelemetry Spec: [Semantic conventions for database client calls](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/database.md)
@dynamicMemberLookup
public struct DatabaseAttributes: SpanAttributeNamespace {
    public var attributes: SpanAttributes

    public init(attributes: SpanAttributes) {
        self.attributes = attributes
    }

    // MARK: - General

    public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
        public init() {}

        // MARK: - Connection-level attributes

        /// An identifier for the database management system (DBMS) product being used, e.g. `postgresql`.
        ///
        /// - OpenTelemetry Spec: [Notes and well-known identifiers for db.system](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/database.md#notes-and-well-known-identifiers-for-dbsystem)
        /// - OpenTelemetry Spec: [Connection-level attributes](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/database.md#connection-level-attributes).
        public var system: Key<String> { "db.system" }

        /// The connection string used to connect to the database, e.g. `Server=(localdb)\v11.0;Integrated Security=true;`.
        ///
        /// OpenTelemetry Spec: [Connection-level attributes](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/database.md#connection-level-attributes).
        ///
        /// - Warning: It is recommended to remove embedded credentials.
        public var connectionString: Key<String> { "db.connection_string" }

        /// Username for accessing the database, e.g. `readonly_user`.
        ///
        /// OpenTelemetry Spec: [Connection-level attributes](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/database.md#connection-level-attributes).
        public var user: Key<String> { "db.user" }

        // MARK: - Call-level attributes

        /// The name of the database being accessed. For commands that switch the database,
        /// this should be set to the target database (even if the command fails).
        ///
        /// In some SQL databases, the database name to be used is called "schema name". In case there are multiple layers that could be considered for
        /// database name (e.g. Oracle instance name and schema name), the database name to be used is the more specific layer (e.g. Oracle schema name).
        ///
        /// - In `Cassandra`, the value SHOULD be set to the keyspace name.
        /// - In `HBase`, the value SHOULD be set to the HBase namespace.
        ///
        /// OpenTelemetry Spec: [Call-level attributes](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/database.md#call-level-attributes).
        public var name: Key<String> { "db.name" }

        /// The database statement being executed, e.g. `SELECT * FROM wuser_table`.
        ///
        /// The value may be sanitized to exclude sensitive information.
        /// This attribute is required if applicable and not explicitly disabled via instrumentation configuration.
        ///
        /// For `Redis`, the value provided SHOULD correspond to the syntax of the Redis CLI.
        /// If, for example, the [HMSET command](https://redis.io/commands/hmset) is invoked, "HMSET myhash field1 'Hello' field2 'World'"
        /// would be a suitable value.
        ///
        /// OpenTelemetry Spec: [Call-level attributes](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/database.md#call-level-attributes).
        public var statement: Key<String> { "db.statement" }

        /// The name of the operation being executed, e.g. the
        /// [`MongoDB` command name](https://docs.mongodb.com/manual/reference/command/#database-operations) such as
        /// `findAndModify`, or the SQL keyword.
        ///
        /// When setting this to an SQL keyword, it is not recommended to attempt
        /// any client-side parsing of ``DatabaseAttributes/NestedSpanAttributes/statement`` just to get this property,
        /// but it should be set if the operation name is provided by the library being instrumented. If the SQL statement has an ambiguous operation,
        /// or performs more than one operation, this value may be omitted.
        ///
        /// In `CouchDB`, the value should be set to the HTTP method + the target REST route according to the API reference documentation.
        /// For example, when retrieving a document, db.operation would be set to (literally, i.e., without replacing the placeholders with concrete values):
        /// [`GET /{db}/{docid}`](http://docs.couchdb.org/en/stable/api/document/common.html#get--db-docid).
        ///
        /// OpenTelemetry Spec: [Call-level attributes](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/database.md#call-level-attributes).
        public var operation: Key<String> { "db.operation" }
    }

    // MARK: - MSSQL

    /// Semantic conventions for Microsoft SQL Server clients.
    ///
    /// OpenTelemetry Spec: [Connection-level attributes for specific technologies](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/database.md#connection-level-attributes-for-specific-technologies)
    public var mssql: MSSQLAttributes {
        get {
            .init(attributes: self.attributes)
        }
        set {
            self.attributes = newValue.attributes
        }
    }

    /// Semantic conventions for Microsoft SQL Server clients.
    ///
    /// OpenTelemetry Spec: [Connection-level attributes for specific technologies](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/database.md#connection-level-attributes-for-specific-technologies)
    public struct MSSQLAttributes: SpanAttributeNamespace {
        public var attributes: SpanAttributes

        public init(attributes: SpanAttributes) {
            self.attributes = attributes
        }

        public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
            public init() {}

            /// The Microsoft SQL Server instance name connecting to, e.g. `MSSQLSERVER`.
            ///
            /// This name is used to determine the port of a named instance.
            ///
            /// - OpenTelemetry Spec: [Connection-level attributes for specific technologies](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/database.md#connection-level-attributes-for-specific-technologies)
            /// - Microsoft SQL Server: [Building the connection URL](https://docs.microsoft.com/en-us/sql/connect/jdbc/building-the-connection-url?view=sql-server-ver15)
            public var instanceName: Key<String> { "db.mssql.instance_name" }
        }
    }

    // MARK: - Redis

    /// Semantic conventions for Redis clients.
    ///
    /// OpenTelemetry Spec: [Call-level attributes for specific technologies](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/database.md#call-level-attributes-for-specific-technologies)
    public var redis: RedisAttributes {
        get {
            .init(attributes: self.attributes)
        }
        set {
            self.attributes = newValue.attributes
        }
    }

    /// Semantic conventions for Redis clients.
    ///
    /// OpenTelemetry Spec: [Call-level attributes for specific technologies](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/database.md#call-level-attributes-for-specific-technologies)
    public struct RedisAttributes: SpanAttributeNamespace {
        public var attributes: SpanAttributes

        public init(attributes: SpanAttributes) {
            self.attributes = attributes
        }

        public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
            public init() {}

            /// The index of the database being accessed as used in the `SELECT` command.
            /// To be used instead of the generic ``DatabaseAttributes/NestedSpanAttributes/name`` attribute.
            ///
            /// The index is required if it's anything other than the default database (`0`).
            public var databaseIndex: Key<Int> { "db.redis.database_index" }
        }
    }

    // MARK: - MongoDB

    /// Semantic conventions for MongoDB clients.
    ///
    /// OpenTelemetry Spec: [Call-level attributes for specific technologies](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/database.md#call-level-attributes-for-specific-technologies)
    public var mongoDB: MongoDBAttributes {
        get {
            .init(attributes: self.attributes)
        }
        set {
            self.attributes = newValue.attributes
        }
    }

    /// Semantic conventions for MongoDB clients.
    ///
    /// OpenTelemetry Spec: [Call-level attributes for specific technologies](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/database.md#call-level-attributes-for-specific-technologies)
    public struct MongoDBAttributes: SpanAttributeNamespace {
        public var attributes: SpanAttributes

        public init(attributes: SpanAttributes) {
            self.attributes = attributes
        }

        public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
            public init() {}

            /// The collection being accessed within the database stated in the ``DatabaseAttributes/NestedSpanAttributes/name`` attribute,
            /// e.g. `customers`.
            public var collection: Key<String> { "db.mongodb.collection" }
        }
    }

    // MARK: - SQL

    /// Semantic conventions for SQL clients.
    ///
    /// OpenTelemetry Spec: [Call-level attributes for specific technologies](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/database.md#call-level-attributes-for-specific-technologies)
    public var sql: SQLAttributes {
        get {
            .init(attributes: self.attributes)
        }
        set {
            self.attributes = newValue.attributes
        }
    }

    /// Semantic conventions for SQL clients.
    ///
    /// OpenTelemetry Spec: [Call-level attributes for specific technologies](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/database.md#call-level-attributes-for-specific-technologies)
    public struct SQLAttributes: SpanAttributeNamespace {
        public var attributes: SpanAttributes

        public init(attributes: SpanAttributes) {
            self.attributes = attributes
        }

        public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
            public init() {}

            /// The name of the primary table that the operation is acting upon, including the database name (if applicable), e.g. `public.users`.
            ///
            /// It is not recommended to attempt any client-side parsing of ``DatabaseAttributes/NestedSpanAttributes/statement``
            /// just to get this property, but it should be set if it is provided by the library being instrumented.
            /// If the operation is acting upon an anonymous table, or more than one table, this value MUST NOT be set.
            public var table: Key<String> { "db.sql.table" }
        }
    }

    // MARK: - Cassandra

    /// Semantic conventions for Cassandra clients.
    ///
    /// OpenTelemetry Spec: [Cassandra](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/database.md#cassandra)
    public var cassandra: CassandraAttributes {
        get {
            .init(attributes: self.attributes)
        }
        set {
            self.attributes = newValue.attributes
        }
    }

    /// Semantic conventions for Cassandra clients.
    ///
    /// OpenTelemetry Spec: [Cassandra](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/database.md#cassandra)
    public struct CassandraAttributes: SpanAttributeNamespace {
        public var attributes: SpanAttributes

        public init(attributes: SpanAttributes) {
            self.attributes = attributes
        }

        public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
            public init() {}

            /// The fetch size used for paging, i.e. how many rows will be returned at once, e.g. `5000`.
            public var pageSize: Key<Int> { "db.cassandra.page_size" }

            /// The consistency level of the query. Based on consistency values from [CQL](https://docs.datastax.com/en/cassandra-oss/3.0/cassandra/dml/dmlConfigConsistency.html).
            /// E.g. `all`.
            public var consistencyLevel: Key<String> { "db.cassandra.consistency_level" }

            /// The name of the primary table that the operation is acting upon, including the keyspace name (if applicable).
            /// This mirrors the ``DatabaseAttributes/SQLAttributes/NestedSpanAttributes/table`` attribute but references `cassandra`
            /// rather than `sql`.
            ///
            /// It is not recommended to attempt any client-side parsing of ``DatabaseAttributes/NestedSpanAttributes/statement``
            /// just to get this property, but it should be set if it is provided by the library being instrumented.
            /// If the operation is acting upon an anonymous table, or more than one table, this value MUST NOT be set.
            public var table: Key<String> { "db.cassandra.table" }

            /// Whether or not the query is idempotent.
            public var idempotence: Key<Bool> { "db.cassandra.idempotence" }

            /// The number of times a query was speculatively executed. Not set or 0 if the query was not executed speculatively.
            public var speculativeExecutionCount: Key<Int> { "db.cassandra.speculative_execution_count" }

            /// The ID of the coordinating node for a query.
            public var coordinatorID: Key<String> { "db.cassandra.coordinator.id" }

            /// The data center of the coordinating node for a query. E.g. `us-west-2`.
            public var coordinatorDataCenter: Key<String> { "db.cassandra.coordinator.dc" }
        }
    }
}
