# Swift Distributed Tracing Extras

> [!Important]
> Swift Distributed Tracing Extras is now **deprecated and read-only**. OpenTelemetry semantic conventions moved to
> [swift-otel/swift-otel-semantic-conventions](https://github.com/swift-otel/swift-otel-semantic-conventions).

## Modules

Swift Distributed Tracing Extras ships the following extra modules:

- [OpenTelemetrySemanticConventions](Sources/TracingOpenTelemetrySemanticConventions)

### OpenTelemetry Semantic Conventions

#### Getting Started

This module is complementary to [swift-distributed-tracing](https://github.com/apple/swift-distributed-tracing) so you will want to depend on it (the API package).


Then, you can depend on the extras package:

```swift
.package(url: "https://github.com/apple/swift-distributed-tracing.git", from: "..."),
.package(url: "https://github.com/apple/swift-distributed-tracing-extras.git", from: "..."),
```

> If you are writing an application, rather than a library, you'll also want to depend on a specific tracer implementation. For available implementations refer to the [swift-distributed-tracing README.md](https://github.com/apple/swift-distributed-tracing).

#### Usage

The OpenTelemetry Semantic Conventions package provides span attributes to work with [OpenTelemetry's
semantic conventions](https://github.com/open-telemetry/opentelemetry-specification/tree/v1.11.0/specification/trace/semantic_conventions).

Semantic attributes enable users of [swift-distributed-tracing](https://github.com/apple/swift-distributed-tracing) to
set attributes on spans using a type-safe pre-defined and well known attributes, like this:

```swift
import Tracing
import TracingOpenTelemetrySemanticConventions

// Example framework code, which handles an incoming request and starts a span for handling a request:
func wrapHandleRequest(exampleRequest: ExampleHTTPRequest) async throws -> ExampleHTTPResponse {
    try await InstrumentationSystem.tracer.withSpan(named: "test") { span in

        // Set semantic HTTP attributes before
        span.attributes.http.method = exampleRequest.method
        span.attributes.http.url = exampleRequest.url
        // ...

        // Hand off to user code to handle the request;
        // The current span already has all important semantic attributes set.
        let response = try await actualHandleRequest(exampleRequest: exampleRequest)

        // ... set any response attributes ... 
        
        return response
    }
}
```

You can also read attributes that are set on a span using the same property syntax:

```swift
assert(span.attributes.http.method == "GET")
// etc.
```

Without the semantic attributes package, one would be able to set the attributes using a type-unsafe approach, like this:

```swift
span.attributes["http.method"] = "\(exampleRequest.method)"
span.attributes["http.url"] = "\(exampleRequest.url)"
```

however this approach is error-prone as one can accidentally record not quite the right type of value,
or accidentally use a wrong, unexpected, key that would then not be understood by Otel tracing backends.

## Supported versions

This module supports: **Swift 5.4+**, on all platforms Swift is available.
