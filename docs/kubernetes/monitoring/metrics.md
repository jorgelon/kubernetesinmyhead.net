# Ways to get kubernetes metrics

## Cadvisor

Provides resource usage and performance characteristics of running containers. It is integrated into the Kubelet in Kubernetes and is responsible for collecting, aggregating, processing, and exporting information about running containers.

<https://github.com/google/cadvisor>

## Kube state metrics

<https://github.com/kubernetes/kube-state-metrics>

Provides metrics about the state of Kubernetes objects (e.g., deployments, nodes, pods), but not resource usage metrics.

## Metrics server

<https://github.com/kubernetes-sigs/metrics-server>

Provides resource usage metrics (e.g., CPU, memory) for Kubernetes objects

## Prometheus adapter

<https://github.com/kubernetes-sigs/prometheus-adapter>

Allows custom metrics to be exposed to the Kubernetes API, but it relies on Prometheus to collect the metrics.
