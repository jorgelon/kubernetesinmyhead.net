# Intro and configuration

Prometheus adapter is a kubernetes addon that permits to expose custom metrics to the kubernetes metrics API. For that, prometheus adapter asks to a prometheus intance in order to build the desired metrics.

It can be used to serve the resource metrics api, this is cpu and memory from pods and nodes. It can be used, for example, for autoescaling purposes using Horizontal Pod Autoescaler, replacing metrics-server.

- Resource metrics api

For example, to access the resource metrics api we can

```shell
kubectl get --raw "/apis/metrics.k8s.io/v1beta1/nodes"
kubectl get --raw "/apis/metrics.k8s.io/v1beta1/pods"
```

- Custom metrics api
- External metrics

## The parameters

The prometheus instance is passed with the parameter --prometheus-url. For example:

```txt
--prometheus-url=
```

```txt
--prometheus-url=https://prometheus.monitoring.svc:9090/
```

The configuration file of the prometeus adapter is passed with the parameter --config. For example:

```txt
--config=/etc/adapter/config.yaml
```

## The configuration file

The config.yaml file has some section:

```yaml
resourceRules:  for resource metrics
rules:    for custom metrics
externalRules:   for external metrics
```

Every rule has 4 parts.

- Discovery
- Association
- Naming
- Querying

## Links

- Prometheus adapter github

<https://github.com/kubernetes-sigs/prometheus-adapter/>

- Prometheus adapter helm chart

<https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-adapter>

<https://github.com/kubernetes-sigs/prometheus-adapter/blob/master/docs/config.md>
<https://github.com/kubernetes-sigs/prometheus-adapter/blob/master/docs/config-walkthrough.md>
<https://github.com/kubernetes-sigs/prometheus-adapter/blob/master/docs/walkthrough.md>
<https://github.com/kubernetes-sigs/prometheus-adapter/blob/master/docs/sample-config.yaml>
<https://github.com/kubernetes-sigs/prometheus-adapter/blob/master/docs/externalmetrics.md>
