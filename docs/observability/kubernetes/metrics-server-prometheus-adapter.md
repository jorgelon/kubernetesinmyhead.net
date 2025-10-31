# Metrics server and prometheus adapter

kubectl get --raw "/apis/metrics.k8s.io/v1beta1/nodes"

## Metrics Server

A lightweight, short-term, in-memory store for resource usage metrics. It is specifically designed to provide metrics for the kubectl top commands and Kubernetes autoscaling.

Purpose: Metrics Server is a cluster-wide aggregator of resource usage data. It collects metrics like CPU and memory usage from the kubelets and exposes them via the Kubernetes Metrics API.
Use Cases: It is primarily used for Horizontal Pod Autoscaling (HPA), Vertical Pod Autoscaling (VPA), and the kubectl top command.
Limitations: Metrics Server provides only the most recent metrics and does not store historical data.

<https://github.com/kubernetes-sigs/metrics-server>

"Metrics Server is meant only for autoscaling purposes. For example, don't use it to forward metrics to monitoring solutions, or as a source of monitoring solution metrics. In such cases please collect metrics from Kubelet /metrics/resource endpoint directly."

Metrics Server is a scalable, efficient source of container resource metrics for Kubernetes built-in autoscaling pipelines.

Metrics Server collects resource metrics from Kubelets and exposes them in Kubernetes apiserver through Metrics API for use by Horizontal Pod Autoscaler and Vertical Pod Autoscaler. Metrics API can also be accessed by kubectl top, making it easier to debug autoscaling pipelines.

## Prometheus Adapter

Used to expose custom metrics from Prometheus to Kubernetes. It allows you to use Prometheus metrics for Kubernetes autoscaling (HPA) and other purposes.

<https://github.com/kubernetes-sigs/prometheus-adapter>

Purpose: Prometheus Adapter is used to expose custom metrics and resource metrics from Prometheus to the Kubernetes Metrics API. It allows you to use Prometheus as a source for metrics used by Kubernetes components like HPA.
Use Cases: It is used to enable HPA based on custom metrics collected by Prometheus, as well as to expose resource metrics collected by Prometheus.
Advantages: Prometheus Adapter can provide historical data and more complex metrics than Metrics Server.

## Metrics server vs prometheus adapter

Metrics server and prometheus adapter are mutually exclusive because they both provide

<https://github.com/kubernetes-sigs/prometheus-adapter/issues/561>

## Kube State Metrics

<https://github.com/kubernetes/kube-state-metrics>

## CAdvisor

## Node exporter

<https://github.com/prometheus/node_exporter>
