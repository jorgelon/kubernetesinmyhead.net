# Metrics

{{ if .Values.rules.resource }}
  kubectl get --raw /apis/metrics.k8s.io/v1beta1
{{- end }}
  kubectl get --raw /apis/custom.metrics.k8s.io/v1beta1
{{ if .Values.rules.external }}
  kubectl get --raw /apis/external.metrics.k8s.io/v1beta1

There are 3 ways to get kubernetes metrics:

- The resource metrics api
- The custom metrics api
- The external metrics api

## Resource Metrics API (metrics api)

The resource metrics api provides basic resource usage metrics (cpu/memory) for pods and nodes.

The API is implemented by metrics-server and prometheus-adapter and it has been created for the following purposes:

- Make kubectl top command work
- Horizontal pod autoescaler using cpu/memory
- Vertical pod autoescaler

The metrics are collected from kubelet and published under /apis/metrics.k8s.io/v1beta1.
For example we can get those metrics this way

```shell
kubectl get NodeMetrics # /apis/metrics.k8s.io/v1beta1/nodes?limit=500
kubectl get --raw /apis/metrics.k8s.io/v1beta1/nodes | jq -r
```

```shell
kubectl get PodMetrics -A # /apis/metrics.k8s.io/v1beta1/pods?limit=500
kubectl get --raw /apis/metrics.k8s.io/v1beta1/pods | jq -r
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

## Custom metrics API

The Custom Metrics API allows you to define and use custom metrics for autoscaling and monitoring purposes. These metrics can be collected from various sources, such as Prometheus, and are used for more advanced autoscaling scenarios.

<https://kubernetes.io/docs/reference/external-api/custom-metrics.v1beta2/>

## External metrics API

The External Metrics API allows you to use metrics from sources external to the Kubernetes cluster for autoscaling purposes. These metrics can be anything that is relevant to your application, such as metrics from a cloud provider or an external monitoring system.

<https://kubernetes.io/docs/reference/external-api/external-metrics.v1beta1/>

## Other tools

### Prometheus adapter

The Prometheus Adapter is a component that registers itself using the Kubernetes API aggregation layer so it can serve metrics apis querying a prometheus instance. This allows you to query custom metrics using the Kubernetes API, similar to how you query built-in metrics.

For example it can serve resource metrics, replacing metrics server, using prometheus metrics as source of truth.
Because we can configure the metrics we want to create querying prometheus, we can use horizontal pod autoescaling features with prometheus queries.

- Prometheus adapter in github

<https://github.com/kubernetes-sigs/prometheus-adapter>

- Prometheus adapter helm chart readme

<https://github.com/prometheus-community/helm-charts/blob/main/charts/prometheus-adapter/README.md>

### Kube state metrics

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

### Node exporter

pending
<https://github.com/prometheus/node_exporter>
<https://prometheus.io/docs/guides/node-exporter/>

## Other links

- Kubernetes metrics API type definitions and clients

<https://github.com/kubernetes/metrics>

- Kubernetes api aggregation layer

<https://github.com/kubernetes-sigs/apiserver-builder-alpha/blob/master/docs/concepts/aggregation.md>

- Instrumentation

<https://kubernetes.io/docs/reference/instrumentation/>

- Tools for Monitoring Resources

<https://kubernetes.io/docs/tasks/debug/debug-cluster/resource-usage-monitoring/>

- Metrics For Kubernetes System Components

<https://kubernetes.io/docs/concepts/cluster-administration/system-metrics/>

- Prometheus Community Kubernetes Helm Charts

<https://github.com/prometheus-community/helm-charts>
