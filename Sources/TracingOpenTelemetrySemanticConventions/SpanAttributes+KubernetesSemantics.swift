//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Distributed Tracing open source project
//
// Copyright (c) 2023 Apple Inc. and the Swift Distributed Tracing project authors
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
    /// Kubernetes attributes.
    ///
    /// OpenTelemetry Spec: [Kubernetes attributes](https://opentelemetry.io/docs/specs/semconv/resource/k8s/)
    public var k8s: KubernetesAttributes {
        get {
            .init(attributes: self)
        }
        set {
            self = newValue.attributes
        }
    }
}

/// Kubernetes attributes.
///
/// OpenTelemetry Spec: [Kubernetes attributes](https://opentelemetry.io/docs/specs/semconv/resource/k8s/)
@dynamicMemberLookup
public struct KubernetesAttributes: SpanAttributeNamespace {
    public var attributes: SpanAttributes

    public init(attributes: SpanAttributes) {
        self.attributes = attributes
    }

    // Mark - General

    public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
        public init() {}
    }

    // Mark: - Cluster

    public var cluster: ClusterAttributes {
        get {
            .init(attributes: self.attributes)
        }
        set {
            self.attributes = newValue.attributes
        }
    }

    public struct ClusterAttributes: SpanAttributeNamespace {
        public var attributes: SpanAttributes
        private let resource: String

        public init(attributes: SpanAttributes) {
            self.attributes = attributes
            self.resource = "cluster"
        }

        /// Semantic conventions for Kubernetes labels.
        public var labels: MetadataAttributes {
            get {
                .init(attributes: self.attributes, resource: self.resource, group: "label")
            }
            set {
                self.attributes = newValue.attributes
            }
        }

        /// Semantic conventions for Kubernetes labels.
        public var annotations: MetadataAttributes {
            get {
                .init(attributes: self.attributes, resource: self.resource, group: "annotation")
            }
            set {
                self.attributes = newValue.attributes
            }
        }

        public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
            public init() {}

            /// Cluster Attributes
            ///
            /// "cluster" name; e.g. "swift-distributed-tracing-cluster".
            public var name: Key<String> { "k8s.cluster.name" }
            /// "cluster" uid; e.g. "218fc5a9-a5f1-4b54-aa05-46717d0ab26d".
            public var uid: Key<String> { "k8s.cluster.uid" }
        }
    }

    // Mark - Container

    public var container: ContainerAttributes {
        get {
            .init(attributes: self.attributes)
        }
        set {
            self.attributes = newValue.attributes
        }
    }

    public struct ContainerAttributes: SpanAttributeNamespace {
        public var attributes: SpanAttributes
        private let resource: String

        public init(attributes: SpanAttributes) {
            self.attributes = attributes
            self.resource = "container"
        }

        /// Semantic conventions for Kubernetes labels.
        public var labels: MetadataAttributes {
            get {
                .init(attributes: self.attributes, resource: self.resource, group: "label")
            }
            set {
                self.attributes = newValue.attributes
            }
        }

        /// Semantic conventions for Kubernetes labels.
        public var annotations: MetadataAttributes {
            get {
                .init(attributes: self.attributes, resource: self.resource, group: "annotation")
            }
            set {
                self.attributes = newValue.attributes
            }
        }

        public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
            public init() {}

            /// Pod Attributes
            ///
            /// "container" name; e.g. "webserver".
            public var name: Key<String> { "k8s.container.name" }
            /// "container" restart count; e.g. 3.
            public var restartCount: Key<Int64> { "k8s.container.restart_count" }
            /// "container" last_terminated_reason; e.g. "Evicted".
            public var lastTerminatedReason: Key<String> { "k8s.container.last_terminated_reason" }
        }
    }

    // Mark - CronJob

    public var cronjob: CronJobAttributes {
        get {
            .init(attributes: self.attributes)
        }
        set {
            self.attributes = newValue.attributes
        }
    }

    public struct CronJobAttributes: SpanAttributeNamespace {
        public var attributes: SpanAttributes
        private let resource: String

        public init(attributes: SpanAttributes) {
            self.attributes = attributes
            self.resource = "cronjob"
        }

        /// Semantic conventions for Kubernetes labels.
        public var labels: MetadataAttributes {
            get {
                .init(attributes: self.attributes, resource: self.resource, group: "label")
            }
            set {
                self.attributes = newValue.attributes
            }
        }

        /// Semantic conventions for Kubernetes labels.
        public var annotations: MetadataAttributes {
            get {
                .init(attributes: self.attributes, resource: self.resource, group: "annotation")
            }
            set {
                self.attributes = newValue.attributes
            }
        }

        public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
            public init() {}

            /// CronJob Attributes
            ///
            /// "cronjob" name; e.g. "swift".
            public var name: Key<String> { "k8s.cronjob.name" }
            /// "cronjob" uid; e.g. "70360e9a-f5ac-43c3-a996-3b949de67288".
            public var uid: Key<String> { "k8s.cronjob.uid" }
        }
    }

    // Mark - DaemonSet

    public var daemonset: DaemonSetAttributes {
        get {
            .init(attributes: self.attributes)
        }
        set {
            self.attributes = newValue.attributes
        }
    }

    public struct DaemonSetAttributes: SpanAttributeNamespace {
        public var attributes: SpanAttributes
        private let resource: String

        public init(attributes: SpanAttributes) {
            self.attributes = attributes
            self.resource = "daemonset"
        }

        /// Semantic conventions for Kubernetes labels.
        public var labels: MetadataAttributes {
            get {
                .init(attributes: self.attributes, resource: self.resource, group: "label")
            }
            set {
                self.attributes = newValue.attributes
            }
        }

        /// Semantic conventions for Kubernetes labels.
        public var annotations: MetadataAttributes {
            get {
                .init(attributes: self.attributes, resource: self.resource, group: "annotation")
            }
            set {
                self.attributes = newValue.attributes
            }
        }

        public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
            public init() {}

            /// DaemonSet Attributes
            ///
            /// "daemonset" name; e.g. "swift".
            public var name: Key<String> { "k8s.daemonset.name" }
            /// "daemonset" uid; e.g. "34330774-22fb-411d-a986-374e813ac952".
            public var uid: Key<String> { "k8s.daemonset.uid" }
        }
    }

    // Mark - Deployment

    public var deployment: DeploymentAttributes {
        get {
            .init(attributes: self.attributes)
        }
        set {
            self.attributes = newValue.attributes
        }
    }

    public struct DeploymentAttributes: SpanAttributeNamespace {
        public var attributes: SpanAttributes
        private let resource: String

        public init(attributes: SpanAttributes) {
            self.attributes = attributes
            self.resource = "deployment"
        }

        /// Semantic conventions for Kubernetes labels.
        public var labels: MetadataAttributes {
            get {
                .init(attributes: self.attributes, resource: self.resource, group: "label")
            }
            set {
                self.attributes = newValue.attributes
            }
        }

        /// Semantic conventions for Kubernetes labels.
        public var annotations: MetadataAttributes {
            get {
                .init(attributes: self.attributes, resource: self.resource, group: "annotation")
            }
            set {
                self.attributes = newValue.attributes
            }
        }

        public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
            public init() {}

            /// Deployment Attributes
            ///
            /// "deployment" name; e.g. "swift".
            public var name: Key<String> { "k8s.deployment.name" }
            /// "deployment" uid; e.g. "b9e5e87b-6d18-4525-bb8e-5efd00cad377".
            public var uid: Key<String> { "k8s.deployment.uid" }
        }
    }

    // Mark - Job

    public var job: JobAttributes {
        get {
            .init(attributes: self.attributes)
        }
        set {
            self.attributes = newValue.attributes
        }
    }

    public struct JobAttributes: SpanAttributeNamespace {
        public var attributes: SpanAttributes
        private let resource: String

        public init(attributes: SpanAttributes) {
            self.attributes = attributes
            self.resource = "job"
        }

        /// Semantic conventions for Kubernetes labels.
        public var labels: MetadataAttributes {
            get {
                .init(attributes: self.attributes, resource: self.resource, group: "label")
            }
            set {
                self.attributes = newValue.attributes
            }
        }

        /// Semantic conventions for Kubernetes labels.
        public var annotations: MetadataAttributes {
            get {
                .init(attributes: self.attributes, resource: self.resource, group: "annotation")
            }
            set {
                self.attributes = newValue.attributes
            }
        }

        public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
            public init() {}

            /// Job Attributes
            ///
            /// "job" name; e.g. "swift".
            public var name: Key<String> { "k8s.job.name" }
            /// "job" uid; e.g. "250c0a82-2ea8-4ed1-99c8-b238b1b86784".
            public var uid: Key<String> { "k8s.job.uid" }
        }
    }

    // Mark - Namespace

    public var namespace: NamespaceAttributes {
        get {
            .init(attributes: self.attributes)
        }
        set {
            self.attributes = newValue.attributes
        }
    }

    public struct NamespaceAttributes: SpanAttributeNamespace {
        public var attributes: SpanAttributes
        private let resource: String

        public init(attributes: SpanAttributes) {
            self.attributes = attributes
            self.resource = "namespace"
        }

        /// Semantic conventions for Kubernetes labels.
        public var labels: MetadataAttributes {
            get {
                .init(attributes: self.attributes, resource: self.resource, group: "label")
            }
            set {
                self.attributes = newValue.attributes
            }
        }

        /// Semantic conventions for Kubernetes labels.
        public var annotations: MetadataAttributes {
            get {
                .init(attributes: self.attributes, resource: self.resource, group: "annotation")
            }
            set {
                self.attributes = newValue.attributes
            }
        }

        public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
            public init() {}

            /// Cluster Attributes
            ///
            /// "cluster" name; e.g. "default".
            public var name: Key<String> { "k8s.namespace.name" }
        }
    }


    // Mark - Node

    /// Kubernetes attributes.
    ///
    /// OpenTelemetry Spec: [Kubernetes attributes](https://opentelemetry.io/docs/specs/semconv/resource/k8s/)
    public var node: NodeAttributes {
        get {
            .init(attributes: self.attributes)
        }
        set {
            self.attributes = newValue.attributes
        }
    }
    public struct NodeAttributes: SpanAttributeNamespace {
        public var attributes: SpanAttributes
        private let resource: String

        public init(attributes: SpanAttributes) {
            self.attributes = attributes
            self.resource = "node"
        }

        /// Semantic conventions for Kubernetes labels.
        public var labels: MetadataAttributes {
            get {
                .init(attributes: self.attributes, resource: self.resource, group: "label")
            }
            set {
                self.attributes = newValue.attributes
            }
        }

        /// Semantic conventions for Kubernetes labels.
        public var annotations: MetadataAttributes {
            get {
                .init(attributes: self.attributes, resource: self.resource, group: "annotation")
            }
            set {
                self.attributes = newValue.attributes
            }
        }

        public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
            public init() {}

            /// Cluster Attributes
            ///
            /// "cluster" name; e.g. "node-1".
            public var name: Key<String> { "k8s.node.name" }
            /// "cluster" uid; e.g. "1eb3a0c6-0477-4080-a9cb-0cb7db65c6a2".
            public var uid: Key<String> { "k8s.node.uid" }
        }
    }

    // Mark - Pod

    public var pod: PodAttributes {
        get {
            .init(attributes: self.attributes)
        }
        set {
            self.attributes = newValue.attributes
        }
    }

    public struct PodAttributes: SpanAttributeNamespace {
        public var attributes: SpanAttributes
        private let resource: String

        public init(attributes: SpanAttributes) {
            self.attributes = attributes
            self.resource = "pod"
        }

        /// Semantic conventions for Kubernetes labels.
        public var labels: MetadataAttributes {
            get {
                .init(attributes: self.attributes, resource: self.resource, group: "label")
            }
            set {
                self.attributes = newValue.attributes
            }
        }

        /// Semantic conventions for Kubernetes labels.
        public var annotations: MetadataAttributes {
            get {
                .init(attributes: self.attributes, resource: self.resource, group: "annotation")
            }
            set {
                self.attributes = newValue.attributes
            }
        }

        public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
            public init() {}

            /// Pod Attributes
            ///
            /// "pod" name; e.g. "swift-2425ff6a-e3149".
            public var name: Key<String> { "k8s.pod.name" }
            /// "pod" uid; e.g. "efb22509-5650-41e8-bf78-5dac6e54fcbf".
            public var uid: Key<String> { "k8s.pod.uid" }
        }
    }

    // Mark - ReplicaSet

    public var replicaset: ReplicaSetAttributes {
        get {
            .init(attributes: self.attributes)
        }
        set {
            self.attributes = newValue.attributes
        }
    }

    public struct ReplicaSetAttributes: SpanAttributeNamespace {
        public var attributes: SpanAttributes
        private let resource: String

        public init(attributes: SpanAttributes) {
            self.attributes = attributes
            self.resource = "replicaset"
        }

        /// Semantic conventions for Kubernetes labels.
        public var labels: MetadataAttributes {
            get {
                .init(attributes: self.attributes, resource: self.resource, group: "label")
            }
            set {
                self.attributes = newValue.attributes
            }
        }

        /// Semantic conventions for Kubernetes labels.
        public var annotations: MetadataAttributes {
            get {
                .init(attributes: self.attributes, resource: self.resource, group: "annotation")
            }
            set {
                self.attributes = newValue.attributes
            }
        }

        public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
            public init() {}

            /// ReplicaSet Attributes
            ///
            /// "replicaset" name; e.g. "swift-2425ff6a".
            public var name: Key<String> { "k8s.replicaset.name" }
            /// "replicaset" uid; e.g. "6eb14149-78db-49ac-a019-edb6fd06de4c".
            public var uid: Key<String> { "k8s.replicaset.uid" }
        }
    }

    // Mark - StatefulSet
    public var statefulset: StatefulSetAttributes {
        get {
            .init(attributes: self.attributes)
        }
        set {
            self.attributes = newValue.attributes
        }
    }

    public struct StatefulSetAttributes: SpanAttributeNamespace {
        public var attributes: SpanAttributes
        private let resource: String

        public init(attributes: SpanAttributes) {
            self.attributes = attributes
            self.resource = "statefulset"
        }

        /// Semantic conventions for Kubernetes labels.
        public var labels: MetadataAttributes {
            get {
                .init(attributes: self.attributes, resource: self.resource, group: "label")
            }
            set {
                self.attributes = newValue.attributes
            }
        }

        /// Semantic conventions for Kubernetes labels.
        public var annotations: MetadataAttributes {
            get {
                .init(attributes: self.attributes, resource: self.resource, group: "annotation")
            }
            set {
                self.attributes = newValue.attributes
            }
        }

        public struct NestedSpanAttributes: NestedSpanAttributesProtocol {
            public init() {}

            /// StatefulSet Attributes
            ///
            /// "statefulset" name; e.g. "swift".
            public var name: Key<String> { "k8s.statefulset.name" }
            /// "statefulset" uid; e.g. "030f007b-179d-4f68-80f4-5e5a1b2ded07".
            public var uid: Key<String> { "k8s.statefulset.uid" }
        }
    }
}

// Mark - Kubernetes Resource Metadata Labels/Annotations
extension KubernetesAttributes {
    /// Semantic conventions for Kubernetes resource metadata.
    ///
    /// Note: OpenTelemetry Spec documents only pod resource, but any resource
    /// may be labeled. In lieu of extensibility, this has been setup to work
    /// with any specified resource.
    ///
    /// OpenTelemetry Spec: [Kubernetes attributes](https://opentelemetry.io/docs/specs/semconv/resource/k8s)
    public struct MetadataAttributes {
        var attributes: SpanAttributes
        private let group: String
        private let resource: String

        init(attributes: SpanAttributes, resource: String, group: String) {
            self.attributes = attributes
            self.group = group
            self.resource = resource
        }

        /// Set the given value for the given Kubernetes pod's metadata.
        ///
        /// e.g. for the k8s resource's label/annotation
        ///   - if the label is: "com.apple.swift/foo.bar=baz"
        ///     then "k8s.<resource>.label.<key>": "k8s.pod.label.com.apple.swift/foo.bar"
        ///   - if the annotation is: "com.apple.swift/foo.bar=baz"
        ///     then "k8s.<resource>.annotation.<key>": "k8s.pod.annotation.com.apple.swift/foo.bar"
        /// - Parameters:
        ///   - value: The value for the given metadata label/annotation.
        ///   - metadata: The key name of the Kubernetes resource's label/annotation.
        public mutating func setValue(_ value: String, forKey key: String) {
            self.attributes["k8s.\(self.resource).\(self.group).\(key)"] = value
        }
    }
}
