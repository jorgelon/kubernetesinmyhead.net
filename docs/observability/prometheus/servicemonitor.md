# Service monitor

These are the more basic settings to create a servicemonitor

## jobLabel

jobLabel selects the label from the associated Kubernetes Service object which will be used as the job label for all metrics.

For example if jobLabel is set to foo and the Kubernetes Service object is labeled with foo: bar, then Prometheus adds the job="bar" label to all ingested metrics.

If the value of this field is empty or if the label doesn’t exist for the given Service, the job label of the metrics defaults to the name of the associated Kubernetes Service.

## selector

## endpoints

### honorLabels

When true, honorLabels preserves the metric’s labels when they collide with the target’s labels.

for example, the following metric "kube_pod_container_resource_requests"

without honorlabels:

```txt
namespace: where my kubestate metrics instance is deployed
pod: name of the kube-state-metrics pod
container: kube-state-metrics
exported_namespace: where the pod that generates metrics is located
exported_pod: name of the pod that generates metrics
exported_container: name of the container that generates metrics
```

with honorlabels:

```txt
namespace: where the pod that generates metrics is located
pod: name of the pod that generates metrics
container: name of the container that generates metrics
```
