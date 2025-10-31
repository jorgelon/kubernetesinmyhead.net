# Sources

## Kubernetes native metrics

- Metrics For Kubernetes System Components

<https://kubernetes.io/docs/concepts/cluster-administration/system-metrics/>

- Kubernetes Metrics Reference

<https://kubernetes.io/docs/reference/instrumentation/metrics/>

- Kubernetes Component SLI Metrics

<https://kubernetes.io/docs/reference/instrumentation/slis/>

### Kubelet

Kubelet listens https requests by default in the 10250 port, including the metrics.
The http insecure port is disabled by default and it can be enabled with the readOnlyPort setting

The cadvisor port is 4194

Prometheus operator creates a service called kubelet with the following argument

```txt
--kubelet-service=kube-system/kubelet
```

These are the metrics exposed

- /metrics
- /metrics/cadvisor
- /metrics/resource
- /metrics/probes
- /metrics/slis

Cadvisor (kubelet)
<https://github.com/google/cadvisor>

cAdvisor – a Docker daemon metrics – containers monitoring

Provides resource usage and performance characteristics of running containers. It is integrated into the Kubelet in Kubernetes and is responsible for collecting, aggregating, processing, and exporting information about running containers.

Note that kubelet also exposes metrics in /metrics/cadvisor, /metrics/resource and /metrics/probes endpoints. Those metrics do not have the same lifecycle.

<https://github.com/google/cadvisor>

## Kube state metrics

<https://github.com/kubernetes/kube-state-metrics>
kube-state-metrics – deployments, pods, nodes

Provides metrics about the state of Kubernetes objects (e.g., deployments, nodes, pods), but not resource usage metrics.

Some considerations:

- They by default they are deployed in an insecured way. It is a common workaround to add endpoint protection with kube-rbac-proxy

- The helm chart is located here <https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-state-metrics>

- All thee metrics start with "kube_" prefix. We can explore the metrics here
<https://github.com/kubernetes/kube-state-metrics/blob/main/docs/README.md#exposed-metrics>

- By default kube-state-metrics creates the "namespace" label with the value of the namespace where it is deployed and the "exported_namespace" label with the namespace of the observed cotnainer. With "honorLabels: true" the value of "namespace" will be the namespace of the observed container.

Kubestate metrics

## Metrics server

<https://github.com/kubernetes-sigs/metrics-server>

Provides resource usage metrics (e.g., CPU, memory) for Kubernetes objects

## Prometheus adapter

<https://github.com/kubernetes-sigs/prometheus-adapter>

Allows custom metrics to be exposed to the Kubernetes API, but it relies on Prometheus to collect the metrics.

## Node exporter

node-exporter: EC2 instances metrics – CPU, memory, network
