# Metrics

There are 3 ways to get kubernetes metrics:

- The resource metrics api
- The custom metrics api
- The external metrics api

Kube state metrics and node exporter can provide more kubernetes metrics. Also, every application can provide its own metrics.

## Resource Metrics API (metrics api)

The resource metrics api provides basic resource usage metrics (cpu/memory) for pods and nodes.

The API is implemented by metrics-server and prometheus-adapter and it has been created for the following purposes:

- Make kubectl top command work
- Horizontal pod autoescaler using cpu/memory
- Vertical pod autoescaler

The metrics are collected from kubelet and published under /apis/metrics.k8s.io/v1beta1.
For example we can get those metrics this way

```shell
# pending using raw
kubectl get NodeMetrics # /apis/metrics.k8s.io/v1beta1/nodes?limit=500
kubectl get PodMetrics -A # /apis/metrics.k8s.io/v1beta1/pods?limit=500
```

We can get who is providing that metrics with

```shell
kubectl get apiservice v1beta1.metrics.k8s.io
```

- Kubernetes Metrics (v1beta1)

<https://kubernetes.io/docs/reference/external-api/metrics.v1beta1/>

- Resource metrics pipeline

<https://kubernetes.io/docs/tasks/debug/debug-cluster/resource-metrics-pipeline/>

### Metrics server

It is a lightweight addon that collects "Resource metrics" from kubelet and exposes them in the metrics api.

It is designed for auotoescaling, not for monitoring purposes, the usage metrics are not accurated. Also it must not be used for horizontal autoscaling based on other resources than CPU/Memory.

- Metrics server in github

<https://github.com/kubernetes-sigs/metrics-server>

### Prometheus adapter

The prometheus adapter can replace the metrics-server and it is has more featured addon because contains an implementation of the Kubernetes Custom, Resource and External Metric APIs

- Prometheus adapter in github

<https://github.com/kubernetes-sigs/prometheus-adapter>

## Custom metrics API

pending

<https://kubernetes.io/docs/reference/external-api/custom-metrics.v1beta2/>

## External metrics API

pending

<https://kubernetes.io/docs/reference/external-api/external-metrics.v1beta1/>

## Kube state metrics

Kube state metrics is a kubernetes addon that talks with the kubernetes api and exposes information about the state of the some objects in the cluster. Kube state metrics holds an entire snapshot of Kubernetes state in memory and continuously generates new metrics based off of it. It shows information like:

- labels
- annotations
- startup times
- termination times
- status
- phase
- namespace
- name of the pod

There is default list of the objects that kube-state-metrics manages but it can be modified.

That exposed metrics can be sent to a prometheus instance. Some distributions like kube-prometheus and kube-prometheus-stack install kube-state-metrics so, if you are using them , you dont need to deploy kube-state-metrics again. The official helm chart is maintained in the promethus-community repo.

- Metrics for Kubernetes Object States

<https://kubernetes.io/docs/concepts/cluster-administration/kube-state-metrics/>

- Kube state metrics in github

<https://github.com/kubernetes/kube-state-metrics>

## Node exporter

pending
<https://github.com/prometheus/node_exporter>
<https://prometheus.io/docs/guides/node-exporter/>

## Other links

- Kubernetes metrics API type definitions and clients

<https://github.com/kubernetes/metrics>

- Instrumentation

<https://kubernetes.io/docs/reference/instrumentation/>

- Tools for Monitoring Resources

<https://kubernetes.io/docs/tasks/debug/debug-cluster/resource-usage-monitoring/>

- Metrics For Kubernetes System Components

<https://kubernetes.io/docs/concepts/cluster-administration/system-metrics/>

- Prometheus Community Kubernetes Helm Charts

<https://github.com/prometheus-community/helm-charts>
