# Kubernetes Metrics Api

The Kubernetes Metrics API is a standardized way to access some metrics using the kubernetes api.

It has some different components:

## Resource Metrics API

Provides basic resource usage metrics (cpu and memory) for pods and nodes. It is used for:

- Autoescaling purposes via horizontal pod autoescaler
- The kubectl top command

To access those metrics we need to deploy:

- An kubernetes application and service that can serve the queries
- Register an APIService called **v1beta1.metrics.k8s.io** linked to that service

```yaml
apiVersion: apiregistration.k8s.io/v1
kind: APIService
metadata:
  name: v1beta1.metrics.k8s.io
spec:
  group: metrics.k8s.io
  version: v1beta1
  service:
    name: NAME-OF-THE-SERVICE
    namespace: NAMESPACE
    port: PORT
  ...
```

In order to get and check the metrics provided by the resource metrics api, we can

```shell
kubectl get --raw "/apis/metrics.k8s.io/v1beta1/nodes"
kubectl get --raw "/apis/metrics.k8s.io/v1beta1/pods"
```

There are 2 known implementations of the resource metrics api

- Metrics server

Metrics server is the lightest and simplest implementation. Metrics server queries some kubelet  endpoints to get that information.

More info here: [metrics-server](metrics-server.md)

- Prometheus adapter

Prometheus adapter can replace metrics server and it can also serve other Kubernetes Metrics Api components, like custom and external metrics api. It queries a prometheus instance to get that queries.

More info here: [prometheus-adapter](prometheus-adapter.md)

## Custom Metrics API

The Custom Metrics API is a Kubernetes Metrics APi component that permits to access some custom metrics via the kubernetes api.

It permits to define and use that custom metrics for monitoring and autoescaling purposes.

```txt
kubectl get --raw /apis/custom.metrics.k8s.io/v1beta1
```

To access those metrics we need to deploy:

- An kubernetes application and service that can serve the queries
- Register an APIService called **v1beta2.custom.metrics.k8s.io** linked to that service

```yaml
apiVersion: apiregistration.k8s.io/v1
kind: APIService
metadata:
  name: v1beta2.custom.metrics.k8s.io
spec:
  group: custom.metrics.k8s.io
  version: v1beta2
  service:
    name: NAME-OF-THE-SERVICE
    namespace: NAMESPACE
    port: PORT
  ...
```

The most typical implementation of the custom metrics api is the prometheus adapter. For this, the prometheus adapter permits advanced autoescaling based on different metrics other than the cpu and memory.

Again, more info here: [prometheus-adapter](prometheus-adapter.md)

Zalando has another implementation called [kube-metrics-adapter](https://github.com/zalando-incubator/kube-metrics-adapter)

## External Metrics API

The External Metrics API is a Kubernetes Metrics APi component that permits to access some external metrics via the kubernetes api. Those metrics are not necessarily tied to kubernetes objects.

Those metrics also can be used to define and use that external metrics for monitoring and autoescaling purposes, and provides advanced autoescaling features.

To access those metrics we need to deploy:

- An kubernetes application and service that can serve the queries
- Register an APIService called **v1beta1.external.metrics.k8s.io** linked to that service

```yaml
apiVersion: apiregistration.k8s.io/v1
kind: APIService
metadata:
  name: v1beta1.external.metrics.k8s.io
spec:
  group: external.metrics.k8s.io
    version: v1beta1
  service:
    name: NAME-OF-THE-SERVICE
    namespace: NAMESPACE
    port: PORT
```

## Links

More info at <https://github.com/kubernetes/metrics>
