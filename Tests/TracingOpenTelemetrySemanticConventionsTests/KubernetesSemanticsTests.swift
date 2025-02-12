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
@testable import TracingOpenTelemetrySemanticConventions
import XCTest

final class KubernetesSemanticsTests: XCTestCase {
    private var attributes = SpanAttributes()

    override func setUp() {
        self.attributes = [:]
    }

    func test_Kubernetes() {
        self.attributes.k8s.cluster.name = "swift-distributed-tracing-cluster"
        self.attributes.k8s.cluster.uid = "218fc5a9-a5f1-4b54-aa05-46717d0ab26d"
        self.attributes.k8s.node.name = "node-1"
        self.attributes.k8s.node.uid = "1eb3a0c6-0477-4080-a9cb-0cb7db65c6a2"
        self.attributes.k8s.namespace.name = "default"
        self.attributes.k8s.pod.name = "swift-2425ff6a-e3149"
        self.attributes.k8s.pod.uid = "efb22509-5650-41e8-bf78-5dac6e54fcbf"
        self.attributes.k8s.container.name = "webserver"
        self.attributes.k8s.container.restartCount = 3
        self.attributes.k8s.container.lastTerminatedReason = "Evicted"
        self.attributes.k8s.replicaset.name = "swift-2425ff6a"
        self.attributes.k8s.replicaset.uid = "6eb14149-78db-49ac-a019-edb6fd06de4c"
        self.attributes.k8s.deployment.name = "swift"
        self.attributes.k8s.deployment.uid = "b9e5e87b-6d18-4525-bb8e-5efd00cad377"
        self.attributes.k8s.statefulset.name = "swift"
        self.attributes.k8s.statefulset.uid = "030f007b-179d-4f68-80f4-5e5a1b2ded07"
        self.attributes.k8s.daemonset.name = "swift"
        self.attributes.k8s.daemonset.uid = "34330774-22fb-411d-a986-374e813ac952"
        self.attributes.k8s.job.name = "swift"
        self.attributes.k8s.job.uid = "250c0a82-2ea8-4ed1-99c8-b238b1b86784"
        self.attributes.k8s.cronjob.name = "swift"
        self.attributes.k8s.cronjob.uid = "70360e9a-f5ac-43c3-a996-3b949de67288"

        XCTAssertSpanAttributesEqual(self.attributes, [
            "k8s.cluster.name": "swift-distributed-tracing-cluster",
            "k8s.cluster.uid": "218fc5a9-a5f1-4b54-aa05-46717d0ab26d",
            "k8s.node.name": "node-1",
            "k8s.node.uid": "1eb3a0c6-0477-4080-a9cb-0cb7db65c6a2",
            "k8s.namespace.name": "default",
            "k8s.pod.name": "swift-2425ff6a-e3149",
            "k8s.pod.uid": "efb22509-5650-41e8-bf78-5dac6e54fcbf",
            "k8s.container.name": "webserver",
            "k8s.container.restart_count": 3,
            "k8s.container.last_terminated_reason": "Evicted",
            "k8s.replicaset.name": "swift-2425ff6a",
            "k8s.replicaset.uid": "6eb14149-78db-49ac-a019-edb6fd06de4c",
            "k8s.deployment.name": "swift",
            "k8s.deployment.uid": "b9e5e87b-6d18-4525-bb8e-5efd00cad377",
            "k8s.statefulset.name": "swift",
            "k8s.statefulset.uid": "030f007b-179d-4f68-80f4-5e5a1b2ded07",
            "k8s.daemonset.name": "swift",
            "k8s.daemonset.uid": "34330774-22fb-411d-a986-374e813ac952",
            "k8s.job.name": "swift",
            "k8s.job.uid": "250c0a82-2ea8-4ed1-99c8-b238b1b86784",
            "k8s.cronjob.name": "swift",
            "k8s.cronjob.uid": "70360e9a-f5ac-43c3-a996-3b949de67288",
        ])
    }

    func test_KubernetesLabel() {
        self.attributes.k8s.cluster.labels.setValue("baz-cluster", forKey: "com.apple.swift/foo.bar")
        self.attributes.k8s.container.labels.setValue("baz-container", forKey: "com.apple.swift/foo.bar")
        self.attributes.k8s.cronjob.labels.setValue("baz-cronjob", forKey: "com.apple.swift/foo.bar")
        self.attributes.k8s.daemonset.labels.setValue("baz-daemonset", forKey: "com.apple.swift/foo.bar")
        self.attributes.k8s.deployment.labels.setValue("baz-deployment", forKey: "com.apple.swift/foo.bar")
        self.attributes.k8s.job.labels.setValue("baz-job", forKey: "com.apple.swift/foo.bar")
        self.attributes.k8s.namespace.labels.setValue("baz-namespace", forKey: "com.apple.swift/foo.bar")
        self.attributes.k8s.node.labels.setValue("baz-node", forKey: "com.apple.swift/foo.bar")
        self.attributes.k8s.pod.labels.setValue("baz-pod", forKey: "com.apple.swift/foo.bar")
        self.attributes.k8s.replicaset.labels.setValue("baz-rs", forKey: "com.apple.swift/foo.bar")
        self.attributes.k8s.statefulset.labels.setValue("baz-statefulset", forKey: "com.apple.swift/foo.bar")


        XCTAssertSpanAttributesEqual(self.attributes, [
            "k8s.cluster.label.com.apple.swift/foo.bar": "baz-cluster",
            "k8s.container.label.com.apple.swift/foo.bar": "baz-container",
            "k8s.cronjob.label.com.apple.swift/foo.bar": "baz-cronjob",
            "k8s.daemonset.label.com.apple.swift/foo.bar": "baz-daemonset",
            "k8s.deployment.label.com.apple.swift/foo.bar": "baz-deployment",
            "k8s.job.label.com.apple.swift/foo.bar": "baz-job",
            "k8s.namespace.label.com.apple.swift/foo.bar": "baz-namespace",
            "k8s.node.label.com.apple.swift/foo.bar": "baz-node",
            "k8s.pod.label.com.apple.swift/foo.bar": "baz-pod",
            "k8s.replicaset.label.com.apple.swift/foo.bar": "baz-rs",
            "k8s.statefulset.label.com.apple.swift/foo.bar": "baz-statefulset",
        ])
    }

    func test_KubernetesAnnotation() {
        self.attributes.k8s.cluster.annotations.setValue("baz-cluster", forKey: "com.apple.swift/foo.bar")
        self.attributes.k8s.container.annotations.setValue("baz-container", forKey: "com.apple.swift/foo.bar")
        self.attributes.k8s.cronjob.annotations.setValue("baz-cronjob", forKey: "com.apple.swift/foo.bar")
        self.attributes.k8s.daemonset.annotations.setValue("baz-daemonset", forKey: "com.apple.swift/foo.bar")
        self.attributes.k8s.deployment.annotations.setValue("baz-deployment", forKey: "com.apple.swift/foo.bar")
        self.attributes.k8s.job.annotations.setValue("baz-job", forKey: "com.apple.swift/foo.bar")
        self.attributes.k8s.namespace.annotations.setValue("baz-namespace", forKey: "com.apple.swift/foo.bar")
        self.attributes.k8s.node.annotations.setValue("baz-node", forKey: "com.apple.swift/foo.bar")
        self.attributes.k8s.pod.annotations.setValue("baz-pod", forKey: "com.apple.swift/foo.bar")
        self.attributes.k8s.replicaset.annotations.setValue("baz-rs", forKey: "com.apple.swift/foo.bar")
        self.attributes.k8s.statefulset.annotations.setValue("baz-statefulset", forKey: "com.apple.swift/foo.bar")


        XCTAssertSpanAttributesEqual(self.attributes, [
            "k8s.cluster.annotation.com.apple.swift/foo.bar": "baz-cluster",
            "k8s.container.annotation.com.apple.swift/foo.bar": "baz-container",
            "k8s.cronjob.annotation.com.apple.swift/foo.bar": "baz-cronjob",
            "k8s.daemonset.annotation.com.apple.swift/foo.bar": "baz-daemonset",
            "k8s.deployment.annotation.com.apple.swift/foo.bar": "baz-deployment",
            "k8s.job.annotation.com.apple.swift/foo.bar": "baz-job",
            "k8s.namespace.annotation.com.apple.swift/foo.bar": "baz-namespace",
            "k8s.node.annotation.com.apple.swift/foo.bar": "baz-node",
            "k8s.pod.annotation.com.apple.swift/foo.bar": "baz-pod",
            "k8s.replicaset.annotation.com.apple.swift/foo.bar": "baz-rs",
            "k8s.statefulset.annotation.com.apple.swift/foo.bar": "baz-statefulset",
        ])
    }
}
