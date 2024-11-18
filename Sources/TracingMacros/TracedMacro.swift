//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Distributed Tracing open source project
//
// Copyright (c) 2020-2024 Apple Inc. and the Swift Distributed Tracing project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of Swift Distributed Tracing project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//
@_exported import ServiceContextModule
import Tracing

#if compiler(>=6.0)
/// Instrument a function to place the entire body inside a span.
///
/// This macro is equivalent to calling ``withSpan`` in the body, but saves an
/// indentation level and duplication.
@attached(body)
public macro Traced() = #externalMacro(module: "TracingMacrosImplementation", type: "TracedMacro")
#endif
