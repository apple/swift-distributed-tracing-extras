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

extension SpanAttributes {
    /// Source code attributes.
    ///
    /// OpenTelemetry Spec: [Source code attributes](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/span-general.md#source-code-attributes)
    public var code: CodeAttributes {
        get {
            .init(attributes: self)
        }
        set {
            self = newValue.attributes
        }
    }
}

/// Source code attributes.
///
/// OpenTelemetry Spec: [Source code attributes](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.11.0/specification/trace/semantic_conventions/span-general.md#source-code-attributes)
@dynamicMemberLookup
public struct CodeAttributes: SpanAttributeNamespace {
    public var attributes: SpanAttributes

    public init(attributes: SpanAttributes) {
        self.attributes = attributes
    }

    public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
        public init() {}

        /// The method or function name, or equivalent (usually rightmost part of the code unit's name). E.g. "serveRequest".
        ///
        /// You may want to set this attribute to `#function`.
        public var function: Key<String> { "code.function" }

        /// The "namespace" within which ``function`` is defined.
        /// Usually the qualified class or module name, such that ``namespace`` + some separator + ``function``
        /// form a unique identifier for the code unit.
        /// E.g. "com.example.MyHttpService".
        public var namespace: Key<String> { "code.namespace" }

        /// The source code file name that identifies the code unit as uniquely as possible (preferably an absolute file path).
        /// E.g. "/usr/local/MyApplication/main.swift".
        ///
        /// You may want to set this attribute to `#filePath`.
        public var filePath: Key<String> { "code.filepath" }

        /// The line number in ``filePath`` best representing the operation.
        /// It SHOULD point within the code unit named in ``function``.
        /// E.g. 42.
        ///
        /// You may want to set this attribute to `#line`.
        public var lineNumber: Key<Int64> { "code.lineno" }
    }
}
